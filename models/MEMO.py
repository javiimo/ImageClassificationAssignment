import torch
import torch.nn as nn
import numpy as np

class MEMO(nn.Module):

    def __init__(self, model: nn.Module, transformations, device, num_augmentations):
        super().__init__()
        self.model = model
        self.device = device
        self.transformations = transformations
        self.num_augmentations = num_augmentations

    def augment_image(self, image):
        torch.manual_seed(33)
        augmented_images = [ image ]
        for _ in range(self.num_augmentations):
            augmented_images.append(self.transformations(image))
        return torch.vstack(augmented_images)
    
    def marginal_entropy(self, logits):
        z = logits - logits.logsumexp(dim = -1, keepdim=True) 
        marginal_logp = z.logsumexp(dim=0) - np.log(z.shape[0])
        min_real = torch.finfo(marginal_logp.dtype).min
        avg_logits = torch.clamp(marginal_logp, min = min_real)
        return -(avg_logits * torch.exp(avg_logits)).sum(dim=-1)

    def entropy_loss_MEMO(self, batch_features, text_features = None):
        if text_features is None:
            text_features = self.text_features
        logits = self.logits(text_features, batch_features)
        return self.marginal_entropy(logits)
    
    # TODO: move this logic to outside of class
    def grad_descent_step(self, loss):
        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()

    # TODO: integrate into forward() function
    def predict(self, image):
        self.model.eval()
        image = self.preprocess(image).unsqueeze(0).to(self.device)
        with torch.no_grad():
            probs = self.forward(image)

        prediction = torch.argmax(probs).item()
        entropy = float(self.compute_entropy(probs))
        return prediction, probs, entropy
    
    def forward(self, image):
        self.model.train()
        images = self.augment_image(image)
        preds = self.model(images)
        avg_preds = preds.mean(axis=0)
        return avg_preds

        #######################################
        #original_params = {name: param.clone() for name, param in self.model.named_parameters()}

        # Require gradients to update the CLIP parameters
        # TODO: Maybe use require_grad() function
        if not self.requiring_grads:
            for param in self.model.parameters():
                param.requires_grad = True
            self.requiring_grads = True

        #try:
        self.model.train()
        batch = self.augment_image(image)
        batch_features = self.model.encode_image(batch)
        norms = batch_features.norm(dim=-1, p=2, keepdim=True)
        #if (norms == 0).any():
        #    print("Zero norm found in image features")
        batch_features = batch_features / norms.clamp_min(1e-10)
        loss = self.entropy_loss_MEMO(batch_features)
        self.grad_descent_step(loss)

        if any(torch.isnan(param).any() for param in self.model.parameters()):
            print("nan values detected in model parameters after updating")
        # Predict using the updated model
        prediction, probs, entropy = self.predict(image)
        #finally:
            # Restore original parameters
        #    with torch.no_grad():
        #        for name, param in self.model.named_parameters():
        #            param.copy_(original_params[name])
        return prediction, probs, entropy
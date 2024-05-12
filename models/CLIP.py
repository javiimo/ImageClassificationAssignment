import torch
import torch.nn as nn
import clip
from PIL.Image import Image

def default_prompt_fn(class_label):
    return f"a photo of a {class_label}"

class CLIP(nn.Module):

    def __init__(self, model_name, device) -> None:
        super().__init__()
        self.device = device
        if model_name not in clip.available_models():
            raise ValueError(f"Expected one of following model names {clip.available_models()}. Got: '{model_name}'")
        self.model, self.preprocess = clip.load(model_name, self.device)
        self.text_features = None

    def compute_text_features(self, class_labels, prompt_fn=default_prompt_fn):
        text_inputs = torch.cat([clip.tokenize(prompt_fn(c)) for c in class_labels])
        with torch.no_grad():
            text_features = self.model.encode_text(text_inputs)
        self.text_features = text_features / text_features.norm(dim=-1, p=2, keepdim=True)


    def forward(self, image):
        #self.model.eval()
        image_features = self.model.encode_image(image)
        image_features /= image_features.norm(dim=-1, p=2, keepdim=True).clamp_min(1e-10)
        cosine_similarity = image_features @ self.text_features.T
        logits = self.model.logit_scale.exp() * cosine_similarity
        return logits.softmax(dim=-1)
    
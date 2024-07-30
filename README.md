# Image Classification with Test-Time Adaptation Project
The link to the html is: [https://javiimo.github.io/ImageClassificationAssignment/](https://javiimo.github.io/ImageClassificationAssignment/)
### Project Overview

"*Test Time Adaptation*" (TTA) refers to a technique in AI where a model is adapted or fine-tuned at the time of inference, using the data it is currently processing.
The target of TTA techniques is to improve model's performance over new or unseen data. In other words, improving the effectiveness when test samples are sampled from a distribution different from the training set one. This latter phenomenon is called  *domain shift*.

The purpose of this work is to implement known methods to mitigate the domain shift problem via TTA, and to suggest new approaches.

The model used is CLIP ViT-B/32, and the test dataset is ImageNet-A.

The strategies implemented are:

1. Marginal Entropy Minimization with One test point (MEMO)
2. Contrastive Prompt Tuning (CoOp) with Test-time Prompt Tuning (TPT)
3. Candidates Boosting (CB)
4. Descriptive labeling, Generalized similarities, Adaptive temperature (DGA)

Where the first 2 points are based on existing papers, the latter ones are of our own.

Furthermore, we will explore the integration of monocular depth estimation, utilizing the Depth Anything model, into our image classification pipeline to try to enhance performance.

### The Team

This project is conducted under the supervision of Dr. Elisa Ricci and Dr. Francesco Tonini. Our team comprises:

- Pietro Begotti
- Javier Montané Ortuño 

# Repository File Structure

- The main file is the Jupyter Notebook Project.ipynb which contains all the cells with the implementations, some theory, tests, plots of the results and conclusions.

- The .json files contain the results of each method on each image of the dataset and allow to plot the results without having to rerun the tests.

- The rest of the files are needed for some cells to run and are part of the code implementation:
    - model.pth.tar contains the pretrained CoOp weights
    - List_ClassNames_imageneta.txt is used to map the ids of the classes to their string names

# Important Notice

The AWS resources are no longer available, impacting dataset accessibility. Modifications to that part of the code will be necessary to load it, and also apply to plots displaying specific images.

# References

1. Radford, A., Kim, J. W., Hallacy, C., Ramesh, A., Goh, G., Agarwal, S., ... & Sutskever, I. (2021). [Learning Transferable Visual Models From Natural Language Supervision](https://arxiv.org/abs/2103.00020). *arXiv preprint arXiv:2103.00020*.

2. Wang, H., Ge, S., Xing, E. P., & Lipton, Z. C. (2021). [MEMO: Test Time Robustness via Adaptation and Augmentation](https://arxiv.org/pdf/2110.09506). *arXiv preprint arXiv:2110.09506*.

3. Shu, Y., Wang, W., Bai, S., & Wang, H. (2022). [Test-Time Prompt Tuning for Zero-Shot Generalization in Vision-Language Models](https://arxiv.org/pdf/2209.07511). *arXiv preprint arXiv:2209.07511*.

4. Yang, L., Kang, B., Li, X., Zhao, F., Zhang, J., Xiao, B., & Song, L. (2024). [Depth Anything: Unleashing the Power of Large-Scale Unlabeled Data](https://arxiv.org/abs/2401.10891). *arXiv preprint arXiv:2401.10891*.
   
   [GitHub Repository](https://github.com/LiheYoung/Depth-Anything)

5. Zhou, K., Yang, J., Loy, C. C., & Liu, Z. (2021). [Learning to Prompt for Vision-Language Models](https://arxiv.org/abs/2109.01134). *arXiv preprint arXiv:2109.01134*.

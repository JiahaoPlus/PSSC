# Robust Image Feature Matching via Progressive Sparse Spatial Consensus (PSSC)

## Introduction
This is a MATLAB implementation of Progressive Sparse Spatial Consensus (PSSC) for mismatch removal from a set of putative feature correspondences involving large number of outliers. Our goal is to estimate the underlying spatial consensus between the feature correspondences and then remove mismatches accordingly. This is formulated as a maximum likelihood estimation problem, and solved by an iterative expectation-maximization algorithm. To handle large number of outliers, we introduce a progressive framework, which uses matching results on a small putative set with high inlier ratio to guide the matching on a large putative set. The spatial consensus is modeled by a non-parametric thinplate spline kernel; this enables our method to handle image pairs with both rigid and non-rigid motions.Moreover, we also introduce a sparse approximation to accelerate the optimization, which can largely reduce the computational complexity without degenerating the accuracy. The quantitative results on various experimental data demonstrate that our method can achieve better matching accuracy and can generate more good matches compared to several state-of-the-art methods.

## Requirement
Please download VLFeat toolbox (http://www.vlfeat.org/) and add the folder and its subfolder to the current path.

## Citation
If you use our code or models in your research, please cite with:
@article{ma2017robust,
  title={Robust Image Feature Matching via Progressive Sparse Spatial Consensus},
  author={Ma, Yong and Wang, Jiahao and Xu, Huihui and Zhang, Shuaibin and Mei, Xiaoguang and Ma, Jiayi},
  journal={IEEE Access},
  volume={5},
  pages={24568--24579},
  year={2017},
  publisher={IEEE}
}
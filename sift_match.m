function [X, Y] = sift_match(I1, I2, theta)
%   [X, Y] = sift_match(I1, I2, theta) does sift match using VL_Feat. 
%
% Input:
%   I1, I2: Tow input image.
%
%   theta: A descriptor D1 is matched to a descriptor D2 only if the
%       distance d(D1,D2) multiplied by THRESH is not greater than the
%       distance of D1 to all other descriptors. The default value of
%       THRESH used by VL_Feat is 1.5.
%
% Output:
%   X, Y: SIFT matches of interest points.

[f1,d1] = vl_sift(im2single(rgb2gray(I1))) ;
[f2,d2] = vl_sift(im2single(rgb2gray(I2))) ;

% [f1,d1] = vl_sift(im2single(I1)) ;
% [f2,d2] = vl_sift(im2single(I2)) ;

[matches, ~] = vl_ubcmatch(d1,d2, theta) ;

x1 = f1(1, matches(1,:)) ;
%x2 = f2(1,matches(2,:)) + size(I1,2) ;
y1 = f1(2, matches(1,:)) ;
y2 = f2(2, matches(2,:)) ;
X = [x1; y1]';
Y = [f2(1, matches(2,:)); y2]';

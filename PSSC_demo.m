%	This is a demo for PSSC.
%   Robust Image Feature Matching via Progressive Sparse Spatial Consensus
%   https://ieeexplore.ieee.org/document/8089726
%	Authors:	Jiahao
%	Date:       04/02/2017

clear; close all; 
% load VLFEAT toolbox (http://www.vlfeat.org/)
if 1
    oldcd = cd;
    cd vlfeat/toolbox
    vl_setup;
    cd(oldcd);
end
% Initialization
initP = [];
conf = [];
conf = EMTPS_init(conf);
normalize = 1;
visualize = 1;
imgname1 = 'Tshirt1.jpg';
imgname2 = 'Tshirt2.jpg';
I1 = imread(imgname1) ;
I2 = imread(imgname2) ;
I1 = I1(1:size(I2,1), 1:size(I2,2), :);
if size(I1,3) == 1
    I1 = repmat(I1,[1,1,3]);
    I2 = repmat(I2,[1,1,3]);
end

% Use SIFT to extract features and establish initial matches (Putative sets S0)
[X0, Y0] = sift_match(I1, I2, 1.5);
Z0 = [X0, Y0];
Z0 = unique(Z0,'rows');%delete the same matches
X0 = Z0(:,1:2);
Y0 = Z0(:,3:4);

% Perform SSC on S0 and obtain inlier set I0 (indexes are saved in "Transform.Index")
Transform=SSC(I1,I2,conf,normalize,visualize,X0,Y0,initP);
fprintf('Matches: %d\n',length(Transform.Index));

% K = 1 (Get putative sets S1)
[X1, Y1] = sift_match(I1, I2, 1);
Z1 = [X1, Y1];
Z1 = unique(Z1,'rows');%delete the same matches
X1 = Z1(:,1:2);
Y1 = Z1(:,3:4);

% Using I0 to initialize the responsibility (P) on S1 
initP=zeros(size(X1,1),1);
[~, i0, i1] = intersect(Z0,Z1,'rows');
initP(i1)=Transform.P(i0);
idx=find(initP>0.75);
initP((initP<1e-5))=1e-5;

% Plot (new putative matches in S1 are in red color)
if visualize
    interval = 20;
    WhiteInterval = 255*ones(size(I1,1), interval, 3);
    figure;imagesc(cat(2, I1, WhiteInterval, I2)) ;
    hold on ;
    line([X1(:,1)'; Y1(:,1)'+size(I1,2)+interval], [X1(:,2)' ;  Y1(:,2)'],'linewidth', 1, 'color', 'r') ;
    line([X1(idx,1)'; Y1(idx,1)'+size(I1,2)+interval], [X1(idx,2)' ;  Y1(idx,2)'],'linewidth', 1, 'color', 'b') ;
    axis equal;axis off;
    drawnow;
end

% Perform SSC on S1 (inlier indexes are saved in "Transform.Index")
Transform=SSC(I1,I2,conf,normalize,visualize,X1,Y1,initP); 
fprintf('Matches: %d\n',length(Transform.Index));
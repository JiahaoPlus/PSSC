function Transform=SSC(I1,I2,conf,normalize,visualize,X,Y,initP)
%	function SSC
%	Authors:Jiahao Wang
%	Date:	04/02/2017
%   input:  
%       I1(image 1),
%       I2(image 2),
%       conf(parameters),
%       normalize(whether normalize or not),
%       visualize(whether visualize or not),
%       X(feature points in image 1),
%       Y(feature points in image 2),
%       initP(initial responsibility P)
%   output:
%       Transform(transformation: a struct contains X, Y, V, H, W, P, E, Index)

normal.xm=0; normal.ym=0;
normal.xscale=1; normal.yscale=1;
if normalize, [nX, nY, normal]=Norm2(X,Y); end
nX = [nX, ones(size(nX,1), 1)];
nY = [nY, ones(size(nY,1), 1)];

if ~exist('conf')
    conf = []; 
    conf = EMTPS_init(conf);
end

Transform=SparseEMTPS(nX, nY, conf.gamma, conf.lambda, conf.theta, conf.a, conf.MaxIter, conf.ecr, conf.minP, initP);

if normalize, Transform.V=Transform.V*normal.yscale+repmat(normal.ym,size(Y,1),1); end 

[~, ia, ~] = unique(Transform.X(Transform.Index),'rows');%delete the same X that matches different Y
Transform.Index=Transform.Index(ia);

if visualize
    interval = 20;
    WhiteInterval = 255*ones(size(I1,1), interval, 3);
    figure;imagesc(cat(2, I1, WhiteInterval, I2)) ;
    hold on ;
    line([X(Transform.Index,1)'; Y(Transform.Index,1)'+size(I1,2)+interval], [X(Transform.Index,2)' ;  Y(Transform.Index,2)'],'linewidth', 1, 'color', 'b') ;
    axis equal ;axis off  ; 
    drawnow;
end
function Transform = SparseEMTPS(X, Y, gamma, lambda, theta, a, MaxIter, ecr, minP, initP)

%	function SparseEMTPS
%	Authors: Jiahao Wang, Jiayi Ma
%	Date:    04/05/2017


% fprintf('Starting mismatch removal:\n');
[N, D]=size(X); 

% Construct kernel matrix K
M1 = 30;
idx = randperm(size(X,1)); 
idx = idx(1:min(M1,size(X,1)));
ctrl_X = X(idx,:);
KU = tps_gen_K(X,ctrl_X);
KS = tps_gen_K(ctrl_X,ctrl_X);
M1 = size(ctrl_X,1);


% Initialization
V=X; iter=1;  tecr=1; W=zeros(M1,D); H=zeros(D,D); E=1; 
sigma2=sum(sum((Y-X).^2))/(N*D);
%%
newE = [];
flag=0;
while (iter<MaxIter) && (tecr > ecr) && (sigma2 > 1e-8) 
    % E-step. 
    E_old=E;
    D = size(Y, 2);

    if (~isempty(initP)) && flag==0
        P=initP;
    else
        temp1 = exp(-sum((Y-V).^2,2)/(2*sigma2));
        temp2 = (2*pi*sigma2)^(D/2)*(1-gamma)/(gamma*a);
        P=temp1./(temp1+temp2);
    end

    E=P'*sum((Y-V).^2,2)/(2*sigma2)+sum(P)*log(sigma2)*D/2;
    E=E+lambda/2*trace(W'*KS*W);           
    newE = [newE,E];%   
    tecr=abs((E-E_old)/E);
    
    % M-step. Update W, H.
    XX = X.*repmat(sqrt(P), [1, D]);
    YY = Y.*repmat(sqrt(P), [1, D]);

    [q1,q2,R] = tps_gen_qr(XX);
    P = max(P, minP);
    W=(((q2'*(KU.*repmat(sqrt(P), [1,M1]))))'*q2'*(KU.*repmat(sqrt(P), [1,M1]))+lambda*sigma2*(KS+eye(M1)*1e-5))\((q2'*(KU.*repmat(sqrt(P), [1,M1])))'*q2'*YY);

    H = R\(q1'*(YY-KU.*repmat(sqrt(P), [1, M1])*W));
    
    % Update V and sigma^2
    V=X*H + KU*W;
    VD = V(:,D);    VD(abs(VD)<1e-10) = 1e-10;
    V = V./repmat(VD, [1, D]);
    Sp=sum(P);
    sigma2=sum(P'*sum((Y-V).^2, 2))/(Sp*D);

    % Update gamma
    numcorr = length(find(P > theta));
    gamma=numcorr/size(X, 1);
    if gamma > 0.95, gamma = 0.95; end
    if gamma < 0.05, gamma = 0.05; end
    
    iter=iter+1;
    flag=1;
end

%%
Transform.X = X(:,1:D-1);
Transform.Y = Y(:,1:D-1);
Transform.V = V(:,1:D-1);
Transform.H = H;
Transform.W = W;
Transform.P = P;
Transform.E = newE;
Transform.Index = find(P > theta);

%%%%%%%%%%%%%%%%%%%%%%%%
function [K] = tps_gen_K(x,z)

% Format:
[n, M] = size (x); 
[m, M] = size (z);
dim    = M  - 1;

% calc. the K matrix.
% 2D: K = r^2 * log r
% 3D: K = -r
K= zeros (n,m);

for it_dim=1:dim
  tmp = x(:,it_dim) * ones(1,m) - ones(n,1) * z(:,it_dim)';
  tmp = tmp .* tmp;
  K = K + tmp;
end
  
if dim == 2
  mask = K < 1e-10; % to avoid singularity.
  K = 0.5 * K .* log(K + mask) .* (K>1e-10);
else
  K = - sqrt(K);
end

%%%%%%%%%%%%%%%%%%%%%%%%
function [q1,q2,R] = tps_gen_qr(x)

[n,M] = size (x);

[q,r]   = qr(x);
q1      = q(:, 1:M);
q2      = q(:, M+1:n);
R       = r(1:M,1:M);





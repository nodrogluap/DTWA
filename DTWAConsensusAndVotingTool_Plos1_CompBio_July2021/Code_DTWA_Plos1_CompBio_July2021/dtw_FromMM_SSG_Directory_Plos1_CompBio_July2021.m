function [d,p] = dtw_FromMM_SSG_Directory_Plos1_CompBio_July2021(x,y)
%DTW dynamic time warping for multidimensional time series
%
% Input
% x:  [n x d]               d dimensional time series of length n
% y:  [m x d]               d dimensional time series of length m
%
% Output
% d:  [1 x 1]               dtw(x,y) with local Euclidean distance
% p:  [L x 2]   (optional)  warping path of length L
%
%
% Author: David Schultz, DAI-Lab, TU Berlin, Germany, 2016 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[N,d]=size(x);
[M,~]=size(y);


C = zeros(N,M);

if d==1 % runs faster than pdist2 for d==1
    C(1,1) = (x(1)-y(1))^2;
    for n = 2:N
        C(n,1) = C(n-1,1) + (x(n)-y(1))^2;
    end
    for m = 2:M
        C(1,m) = C(1,m-1) + (x(1)-y(m))^2;
    end
    for n = 2:N
        for m=2:M
            C(n,m) = (x(n)-y(m))^2 + min(min(C(n-1,m-1),C(n-1,m)),C(n,m-1));
        end
    end
else
    D = pdist2(x,y).^2;
    C(:,1) = cumsum(D(:,1));
    C(1,:) = cumsum(D(1,:));
    for n = 2:N
        for m = 2:M
            C(n,m) = D(n,m) + min(min(C(n-1,m-1),C(n-1,m)),C(n,m-1));
        end
    end 
end

d = sqrt(C(N,M));


% compute warping path p
if nargout >= 2
    n = N;
    m = M;
    p = zeros(n+m-1,2);
    p(end,:) = [n,m];
    k = 1;
    while n+m ~= 2
        if n == 1
            m = m-1;
        elseif m == 1
            n = n-1;
        else
            C_diag = C(n-1,m-1);
            C_r = C(n,m-1);
            C_d = C(n-1,m);
            if C_diag <= C_r
                if C_diag <= C_d
                    n=n-1;
                    m=m-1;
                else
                    n=n-1;
                end
            elseif C_r <= C_d
                m=m-1;
            else
                n=n-1;
            end
        end
        p(end-k,:)=[n,m]; 
        k=k+1;
    end
    p = p(end-k+1:end,:);
end

end

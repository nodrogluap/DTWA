function [z,f] = SubGradientDescent_Plos1_CompBio_July2021(streamForDTWA, DTWA, eta)
% function [z,f] = SubGradientDescent_Plos1_CompBio_July2021(streamForDTWA, DTWA, eta)
% Modified M. Smith, Electrical and Software Engineering, 
% University of Calgary, Calgary, Canada Feb 2019; June 2021

nEpochs = DTWA.epochs;
initSequence = DTWA.seedStreamNumber;

%SSG Computes an approximate sample mean under dynamic time warping
% 
% SSG aims at finding a sample mean under dynamic time warping of  
% sample X = (x_1,...,x_N) containing time series x_i, each of arbitraty 
% length and uniform dimension d. Similarity between the
% d-dimensional data points x_ij is measured by means of the Euclidean 
% distance. Other local distances are not supported.
%
% Mathematically this can be formulated as an optimization problem.
% A sample mean is a time series z that satisfies 
%
%    F(z) = min F(x),
%            x
%
% where F is the Frechet function, defined by
%
%                  N
%    F(x) = (1/N) sum dtw^2(x,x_i).
%                 i=1
%
% 
% SSG is a stochastic subgradient method that aims at minimizing F.
% For this, the algorithm requires to choose an initial (mean candidate) 
% sequence. Details are discussed in [1].
% 
%
%
% Input
%   X               Cell array of time series x_i of size [n_i,d], where
%                   n_i is the length of time series x_i and d is the 
%                   uniform dimension of all time series.
%                   example:   X{1} = x_1;  % size [n_1,d]
%                              X{2} = x_2;  % size [n_2,d]
%
%   nEpochs         Number of epochs.
%   (o)             default: nEpochs = 1
%                   Hint: One epoch is often sufficient for larger
%                   datasets (approximately N > 300). For smaller datasets
%                   nEpochs should be decreased
%
%   eta         	Vector representiong a learning rate schedule
%   (o)             At update k the learning rate is set to eta(k).
%                   If k > length(eta), then eta(end) is used.
%                   default: eta = linspace(0.1, 0.005, N)
%                            i.e. linear decreasing from 0.1 to 0.005
%                            within the first epoch
%
%   initSequence    (1) default: If initSequence is not defined, then a  
%   (o)                 random sample of X is selected as the initial mean
%                       candidate
%                   (2) If initSequence is the integer i > 0, then x_i is  
%                       choosen as the initial sequence
%                   (3) If initSequence <= 0, then the medoid of
%                       X is selected. 
%                       CAUTION: This may take very long on larger
%                                datasets since O(N^2) dtw distances have 
%                                to be computed, each consisting of 
%                                O(n_i*n_j) distance  computations of
%                                d-dimensional vectors.
%                   (4) If initSequence is a d-dimensional time series of 
%                       length n, then it is used as initial sequence.
%
% Output
%   z               Approximate mean time series of size [n x d], 
%                   where n is the length of the initial sequence.
%
%   f               Vector containing Frechet variations f(k) := F(z^(k)),
%   (o)             where z^(k) is the mean at epoch k.
%                   f(1) is the Frechet variation of the initial sequence
%               !!! CAUTION: Returning f doubles the computation time!
%                            Do not ask for f if not necessary.
%
% (o) = optional
%__________________
%
% Credits
% * The SSG mean algorithm was introduced in [1].
%
% [1] Schultz and Jain - "Nonsmooth Analysis and Subgradient Methods
%     for Averaging in Dynamic Time Warping Spaces"
%
%
% Author: David Schultz, DAI-Lab, TU Berlin, Germany, 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
N = length(streamForDTWA);          % number of samples
d = size(streamForDTWA{1},2);       % dimension of data

if nargin < 2 || isempty(nEpochs)
    numUpdates = 1000;
    nEpochs = ceil(numUpdates/N);
end

if nargin < 3 || isempty(eta)
    eta = linspace(0.1, 0.005, N);
end

if nargin < 4
    initSequence = [];
end

% initialize mean z
if isempty(initSequence)
    z = streamForDTWA{randi(N)};
elseif initSequence > 0
    z = streamForDTWA{initSequence};
elseif initSequence <= 0
    z = medoidSequence(streamForDTWA);
else
    z = initSequence;
end

f = zeros(nEpochs+1,1);
if nargout == 2
    f(1) = Frechet(z,streamForDTWA);
end

% stochastic subgradient optimization
for  k = 1:nEpochs
    perm = randperm(N);
    for i = 1:N
        x_i = streamForDTWA{perm(i)};

        [~,p] = dtw_FromMM_SSG_Directory_Plos1_CompBio_July2021(z,x_i);
        
        [W,V] = getWarpingAndValenceMatrix(p);

        subgradient = 2*(repmat(V,1,d).*z - W*x_i);
        
        % determine learning rate for update no. c
        c = (k-1)*N+i;
        if c <= length(eta)
            lr = eta(c);
        else
            lr = eta(end);
        end
        
        % update rule
        z = z - lr * subgradient;
        
    end
    
    if nargout == 2
        f(k+1) = Frechet(z,streamForDTWA);
    end
end

if nargout == 2
    f = f(1:nEpochs+1);
end

disp(['SSG iterations: ' num2str(nEpochs)])
end



function f = Frechet(x,X)
  N = length(X);
  f = 0;
  for i = 1:N
      dist = dtw_FromMM_SSG_Directory_Sept2018(x,X{i});
      f = f + dist^2;
  end
  f=f/N;
end

function x = medoidSequence(X) 
  %MEDOIDSEQUENCE returns medoid of X
  % A medoid is an element of X that minimizes the Frechet function
  % among all elements in X
  N = length(X);
  f_min = inf;
  i_min = 0;
  for i = 1:N
      f = Frechet(X{i},X);
      if f < f_min
          f_min = f;
          i_min = i;
      end
  end
      x = X{i_min};
end

function [W,V] = getWarpingAndValenceMatrix(p)
  % W is the (sparse) warping matrix of p
  % V is a vector representing the diagonal of the valence matrix 
  L = length(p);
  n = p(L,1);
  m = p(L,2);  
  W = sparse(p(:,1),p(:,2),ones(L,1),n,m);
  V = sum(W,2);
end

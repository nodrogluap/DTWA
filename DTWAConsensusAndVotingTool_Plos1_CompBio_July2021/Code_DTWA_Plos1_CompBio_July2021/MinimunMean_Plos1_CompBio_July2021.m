function [z,f] = MinimunMean_Plos1_CompBio_July2021(streamForDTWA, DTWA) % maxIter, initSequence)
% function [z,f] = MinimunMean_Plos1_CompBio_July2021(streamForDTWA, DTWA)
% Modified M. Smith, Electrical and Software Engineering, 
% University of Calgary, Calgary, Canada -- Feb 2019; June 2021

initSequence = DTWA.seedStreamNumber;
maxIter = DTWA.epochs;

%MM Computes an approximate sample mean under dynamic time warping
% 
% MM is a fast reformulation of the DBA algorithm [2].
%
% MM aims at finding a sample mean under dynamic time warping of  
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
% The algorithm requires to choose an initial (mean candidate) sequence. 
% Then MM iteratively refines it with respect to a majorize-minimize
% optimization principle. Details are discussed in [1].
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
%   maxIter         Maximum number of iterations. MM may terminate earlier
%   (o)             default: maxIter = 15
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
%   (o)             where z^(k) is the mean at iteration k.
%                   f(1) is the Frechet variation of the initial sequence
%
% (o) = optional
%__________________
%
% Credits
% * The original DBA algorithm was invented in [2].
% * The present implementation can be multithreaded and uses the warping  
%   and valence matrices to compute the mean updates. Theory behind was
%   introduced in [1].
%
% [1] Schultz and Jain - "Nonsmooth Analysis and Subgradient Methods
%     for Averaging in Dynamic Time Warping Spaces"
% [2] Petitjean et al. - "A global averaging method for dynamic time
%     warping, with applications to clustering"
%
% Author: David Schultz, DAI-Lab, TU Berlin, Germany, 2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
if nargin < 2 || isempty(maxIter)
    maxIter = 15;
end

if nargin < 3
    initSequence = [];
end

N = length(streamForDTWA);              % number of samples / time series
d = size(streamForDTWA{1},2);           % dimension of data points of time series


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
n = size(z,1);              % length of the mean candidate

tol = 1e-4;
f = zeros(maxIter+1,1);     % init vector of Frechet variations
k = 1;                      % epoch counter
  
% Majorize-Minimize optimization
while ( k <= 2 || f(k-2)-f(k-1) > tol ) && k <= maxIter 
%% (1) MAJORIZE, find v,w describing an F-majorizing function
    v = zeros(n,1);
    w = zeros(n,d); 
    frechetVar = 0;
    
    % The following expensive loop could be parallelized by 
    % changing for -> parfor
    for i = 1:N
        x = streamForDTWA{i};
        [dist,p] = dtw_FromMM_SSG_Directory_Plos1_CompBio_July2021(z,x);
        [W,v_i] = getWarpingAndValenceMatrix(p);
        v = v + v_i;
        w = w + W*x;        % if d >= 2, Matlab computes componentwise 
                            % matrix-vector multiplication:
                            % W*x = [W*x(:,1), ..., W*x(:,d)]                          
        frechetVar = frechetVar + dist^2;
    end  
    
%% (2) MINIMIZE, update the mean
    z = w./repmat(v,1,d);   % compute mean update
    f(k) = frechetVar/N;    % Frechet variation of z after iteration k-1
    k = k+1;
end

if nargout == 2             % Frechet variation after termination
    f(k) = Frechet(z,streamForDTWA);
    f = f(1:k);
end
disp(['MM iterations: ' num2str(k-1)])
end

function f = Frechet(x,streamForDTWA)
  N = length(streamForDTWA);
  f = 0;
  for i = 1:N
      dist = dtw_FromMM_SSG_Directory_10Jan2019(x,streamForDTWA{i});
      f = f + dist^2;
  end
  f=f/N;
end

function x = medoidSequence(streamForDTWA) 
  %MEDOIDSEQUENCE returns medoid of X
  % A medoid is an element of X that minimizes the Frechet function
  % among all elements in X
  N = length(streamForDTWA);
  f_min = inf;
  i_min = 0;
  for i = 1:N
      f = Frechet(streamForDTWA{i},streamForDTWA);
      if f < f_min
          f_min = f;
          i_min = i;
      end
  end
      x = streamForDTWA{i_min};
end

function [W,v] = getWarpingAndValenceMatrix(p)
  % W is the (sparse) warping matrix of p
  % v is a vector representing the diagonal of the valence matrix 
  L = length(p);
  n = p(L,1);
  m = p(L,2);  
  W = sparse(p(:,1),p(:,2),ones(L,1),n,m);
  v = sum(W,2);
end

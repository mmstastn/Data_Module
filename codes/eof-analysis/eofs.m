function [lambda,u,coeff,cumul_approx] = eofs(data,num_modes)
% EOF computes Empirical Orthogonal Functions by MATLAB's built in svds
%
% Data needs to be snapshots in columns, so a matrix with M rows giving spatial 
% locations and N columns giving timesteps, with time increasing left to right.
%
%  [lambda,u,coeff,cumul_approx] = EOFS(data,num_modes) returns the EOFS 
%  information for data, the first num_modes modes.
%
% This call also subtracts the mean, so the mean should be stored if it's needed.
%
% returns:
% -eigenvalues in lambda [num_modes x 1], in descending order, unnormalized.
% -eigenvectors as columns of u [M x num_modes]
% -coefficients in coeff [num_modes x N]
% -cumulative approximations in cumul_approx [num_modes x M x N] = number of modes, space, time


%% Setup
[M,N] = size(data); % find dimensions of data
data = bsxfun(@minus, data, mean(data,2)); % remove mean

        %% Compute EOFs by SVD
        [u,s,v]=svds(data/sqrt(N-1),num_modes); % perform the SVD, v is not used.
        % the columns of u are the eigenvectors.
        % NOTE: data is not transposed as in Kutz's code because this is wrong, even in his notation
        lambda = diag(s).^2; % the singular values need to be squared to match the eigenvalues from pca.
        % but svd ensures they're already in decreasing order.

        %% Find timeseries coefficients
        coeff=u'*data; % project the mean centered data onto the basis, size M x N
        
        %% Calculate Cumulative Approximations
        cumul_approx = zeros(num_modes,M,N); %  number of modes, space, time

        for kk=1:num_modes % number of modes to sum over
            sum_to_kk = zeros(M,N); % set temp to zero
            for ii=1:kk % sum over kk modes
                sum_to_kk=sum_to_kk+bsxfun(@times,u(:,ii),coeff(ii,:));
            end
            cumul_approx(kk,:,:) = sum_to_kk; % store sum of first k EOF in kth slot
        end
end 


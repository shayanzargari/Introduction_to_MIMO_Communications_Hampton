function S_hat = ZF_Decoding(H, R, rho, M)
% The number of antennas (Nt) is the number of columns in the channel matrix
Nt = size(H, 2);

% Generate constellation for M-PSK
constellation = pskmod(0:(M-1), M, pi/M);

%% ZF algorithm
% Step 1: Compute the pseudoinverse of the channel matrix (H+)
H_plus = pinv(H);

% Step 2: Premultiply the receive matrix (R) by H+. Resulting matrix is R_tilde
R_tilde = H_plus * R;

% Step 3: Estimate the symbols for each layer by performing maximum likelihood decoding on each row of R_tilde
% Create an array for estimated symbols
S_hat = zeros(size(R_tilde));

for k = 1:size(R_tilde, 2)
    for n = 1:Nt
        % Calculate Euclidean distances to all constellation points
        distances = abs(R_tilde(n,k) - sqrt(rho) * constellation);

        % Find the constellation point that minimises the Euclidean distance
        [~, min_index] = min(distances);

        % This is our decoded symbol for nth antenna
        S_hat(n,k) = constellation(min_index);
    end
end

end
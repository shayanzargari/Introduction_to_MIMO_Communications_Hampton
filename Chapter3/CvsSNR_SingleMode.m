function [C, Weights] = CvsSNR_SingleMode(SNRvec_dB, H)
% Get number of transmit antennas
Nt = size(H, 2);

% Convert SNR from dB to linear scale
SNRvec = 10.^(SNRvec_dB/10);

% Initialize capacity and Weights vectors
C = zeros(1, length(SNRvec));
Weights = zeros(Nt, length(SNRvec));

% Singular Value Decomposition
[~, D, V] = svd(H);

% Get the maximum singular value and its corresponding right singular vector
[max_singular_value, idx] = max(diag(D));
v_max = V(:, idx);

% Calculate capacity and Weights for each SNR
for i = 1:length(SNRvec)
    SNR = SNRvec(i);

    % Compute capacity
    C(i) = log2(1 + SNR * abs(max_singular_value)^2);

    % Compute Weights
    Weights(:, i) = sqrt(SNR) * v_max;
end
end

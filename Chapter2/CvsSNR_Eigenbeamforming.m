function [C, gain] = CvsSNR_Eigenbeamforming(SNRvec_dB, H)

% Convert SNR from dB to linear scale
SNRvec = 10.^(SNRvec_dB/10);

% Perform singular value decomposition (SVD)
[~, D, ~] = svd(H);

% Extract singular values (squared) and sort them in descending order
singular_values_sq = flipud(sort(diag(D).^2));

% Get rank of H
rankH = rank(H);

% Initialize the output variables
C = zeros(1, length(SNRvec));
gain = zeros(length(SNRvec), rankH);

for i = 1:length(SNRvec)
    % Total transmit power
    rho = SNRvec(i);

    % Compute waterfilling power allocation
    Popt = waterfilling(singular_values_sq, rho);

    % Compute capacity
    C(i) = sum(log2(1 + rho .* singular_values_sq .* Popt'));

    % Assign the gain for each SNR value
    gain(i, :) = Popt;
end
end



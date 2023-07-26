function C = CvsSNR_EqualPowerAllocation(SNRvec_dB, H, calcType)
Nt = size(H, 2);   % number of transmit antennas
Nr = size(H, 1);   % number of receive antennas
SNRvec = 10.^(SNRvec_dB/10);   % SNR in linear scale
C = zeros(1, length(SNRvec));   % Initialize capacity vector

for i = 1:length(SNRvec)
    SNR = SNRvec(i);

    if calcType == 1
        % Calculate capacity without using eigenvalues
        C(i) = log2(det(eye(Nr) + (SNR/Nt) * (H * H')));
    elseif calcType == 2
        % Calculate capacity using eigenvalue decomposition
        [~, D] = eig(H * H');
        lambda = diag(D);
        C(i) = sum(log2(1 + (SNR/Nt) * lambda));
    else
        error('Invalid calculation type. Choose 1 or 2.');
    end
end
end



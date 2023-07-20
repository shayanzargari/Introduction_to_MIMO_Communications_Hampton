function C = ErgodicCapacity(SNRdB, Nt, Nr, Niter)

% Convert SNR from dB to linear scale
rho = 10.^(SNRdB/10);

% Initialize capacity
C = 0;

for iter = 1:Niter
    % Generate the channel matrix H with complex Gaussian entries
    H = (randn(Nr, Nt) + 1j*randn(Nr, Nt)) / sqrt(2);

    % Compute the capacity for this channel realization
    C = C + log2(det(eye(Nr) + rho/Nt * (H * H')));
end

% Compute the ergodic capacity
C = C / Niter;

end
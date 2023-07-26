function C = OutageCapacity(SNRdB, Nt, Nr, Niter, q)

% Convert SNR from dB to linear scale
SNR = 10.^(SNRdB/10);

% Initialize capacity vector
C_vec = zeros(Niter, 1);

for iter = 1:Niter
    % Generate the channel matrix H with complex Gaussian entries
    H = (randn(Nr, Nt) + 1j*randn(Nr, Nt)) / sqrt(2);

    % Compute the capacity for this channel realization
    C_vec(iter) = log2(real(det(eye(Nr) + SNR/Nt * (H * H'))));
end

% Ensure q is a percentage between 0 and 100
q = max(0, min(100, q));

% Compute the outage capacity
C = quantile(C_vec, q/100);

end

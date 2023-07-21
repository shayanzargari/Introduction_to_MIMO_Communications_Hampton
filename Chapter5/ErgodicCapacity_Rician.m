function C = ErgodicCapacity_Rician(SNRdB, Nt, Nr, Kvec, HLOS, Niter)

% Convert SNR from dB to linear scale
SNR = 10^(SNRdB/10);

% Calculate ergodic capacity for each K-factor value
C = zeros(1, length(Kvec));
for i = 1:length(Kvec)
    K = Kvec(i);

    % Initialize capacity for this K-factor value
    C_iter = 0;

    for iter = 1:Niter
        % Generate the Rayleigh fading component of the channel matrix
        H_Rayleigh = sqrt(1/2) * (randn(Nr, Nt) + 1j*randn(Nr, Nt));

        % Combine Rayleigh fading component with LOS component (Rician channel)
        H = sqrt(K/(K+1)) * HLOS + sqrt(1/(K+1)) * H_Rayleigh;

        % Compute the capacity for this channel realization
        C_iter = C_iter + log2(det(eye(Nr) + SNR/Nt * (H * H')));
    end

    % Average over all iterations
    C(i) = C_iter / Niter;
end

end

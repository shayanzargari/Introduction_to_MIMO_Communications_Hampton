function C = ErgodicCapacity_Corr(SNRdBvec, Nt, Nr, Rt, Rr, Niter)

% Convert SNR from dB to linear scale
SNRvec = 10.^(SNRdBvec/10);

% Calculate ergodic capacity for each SNR value
C = zeros(1, length(SNRvec));
for i = 1:length(SNRvec)
    % Total transmit power
    rho = SNRvec(i);

    % Initialize capacity for this SNR value
    C_iter = 0;

    for iter = 1:Niter
        
        H_w = sqrt(1/2) * (randn(Nr, Nt) + 1j*randn(Nr, Nt));

        % Generate the channel matrix H with correlated complex Gaussian entries
        H = (sqrtm(Rr) * H_w * sqrtm(Rt));

        % Compute the capacity for this channel realization
        C_iter = C_iter + log2(det(eye(Nr) + rho/Nt * (H * H')));
    end

    % Average over all iterations
    C(i) = C_iter / Niter;
end

end

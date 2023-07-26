function [BER_est] = Alamouti_w_CE(SNRdB, Nt, Nr, Niter, Sp, p)

SNR = 10^(SNRdB/10);  % Convert SNR from dB to linear scale
bitErrors_est = 0;
totalBits = 0;

for iter = 1:Niter
    %% Step 1: Compute the transmit symbols (BPSK modulation)
    rand_bits = (2*randi([0 1], Nt, 1) - 1);

    % Adjust for E{|s|^2} = 1/Nt
    s = sqrt(1/Nt) * rand_bits;

    % Alamouti STBC
    s_Alamouti = [s(1) -conj(s(2)); s(2) conj(s(1))];

    %% Channel estiamtion
    H = sqrt(1/2) * (randn(Nr, Nt) + 1j*randn(Nr, Nt));  % Rayleigh fading
    Z = sqrt(1/2) * (randn(Nr, p) + 1j*randn(Nr, p));  % Noise matrix for the pilots
    Rp = sqrt(SNR) * H * Sp + Z;  % Received pilot matrix

    % ML channel estimation
    H_hat_ML = sqrt(1/SNR) * Rp * Sp' * inv(Sp * Sp');

    %% Step 2: Compute the received signals
    r = zeros(Nr, 2);
    for i = 1:Nr
        r(i, 1) = sqrt(SNR) * H_hat_ML(i, :) * s_Alamouti(:, 1) + Z(i, 1);
        r(i, 2) = sqrt(SNR) * H_hat_ML(i, :) * s_Alamouti(:, 2) + Z(i, 2);
    end

    %% Step 3: Compute the combiner output
    s_tilde = zeros(Nt, 1);
    for i = 1:Nr
        s_tilde(1) = s_tilde(1) + conj(H_hat_ML(i, 1)) * r(i, 1) + H_hat_ML(i, 2) * conj(r(i, 2));
        s_tilde(2) = s_tilde(2) + conj(H_hat_ML(i, 2)) * r(i, 1) - H_hat_ML(i, 1) * conj(r(i, 2));
    end

    %% Step 4: Demodulate the received symbols using ML detection (hard decision)
    s_hat = zeros(size(s));

    % Possible transmitted symbols (BPSK)
    s_possibilities = [-1, 1];
    for i = 1:length(s)

        % Compute the metrics for each possible symbol
        metrics = arrayfun(@(s_poss) (sum(sum(abs(H_hat_ML).^2))-1) * abs(s_poss)^2 + abs(s_tilde(i) - s_poss)^2, s_possibilities);

        % Repeat the ML detection for each symbol
        [~, index] = min(metrics);
        s_hat(i) = s_possibilities(index);
    end

    %% Count the bit errors
    bitErrors_est = bitErrors_est + sum(s_hat ~= rand_bits);
    totalBits = totalBits + Nt;
end

BER_est = bitErrors_est / totalBits;

end

function BER = Alamouti(SNRdB, Nt, Nr, Niter)

SNR = 10^(SNRdB/10);  % Convert SNR from dB to linear scale
bitErrors = 0;
totalBits = 0;

for iter = 1:Niter
    %% Step 1: Compute the transmit symbols (BPSK modulation)
    rand_bits = (2*randi([0 1], Nt, 1) - 1);
    s = sqrt(1/Nt) * rand_bits;  % Adjust for E{|s|^2} = 1/Nt
    s_Alamouti = [s(1) -conj(s(2)); s(2) conj(s(1))];  % Alamouti STBC

    %% Step 2: Compute the received signals
    h = sqrt(1/2) * (randn(Nr, Nt) + 1j*randn(Nr, Nt));  % Rayleigh fading
    z = sqrt(1/2) * (randn(Nr, 2) + 1j*randn(Nr, 2));  % AWGN
    r = zeros(Nr, 2);
    for i = 1:Nr
        r(i, 1) = sqrt(SNR) * h(i, :) * s_Alamouti(:, 1) + z(i, 1);
        r(i, 2) = sqrt(SNR) * h(i, :) * s_Alamouti(:, 2) + z(i, 2);
    end

    %% Step 3: Compute the combiner output
    s_tilde = zeros(Nt, 1);
    for i = 1:Nr
        s_tilde(1) = s_tilde(1) + conj(h(i, 1)) * r(i, 1) + h(i, 2) * conj(r(i, 2));
        s_tilde(2) = s_tilde(2) + conj(h(i, 2)) * r(i, 1) - h(i, 1) * conj(r(i, 2));
    end

    %% Step 4: Demodulate the received symbols using ML detection (hard decision)
    s_hat = zeros(size(s));
    s_possibilities = [-1, 1];  % Possible transmitted symbols (BPSK)
    for i = 1:length(s)
        % Compute the metrics for each possible symbol
        metrics = arrayfun(@(s_poss) (sum(sum(abs(h).^2))-1) * abs(s_poss)^2 + abs(s_tilde(i) - s_poss)^2, s_possibilities);
        % Repeat the ML detection for each symbol
        [~, index] = min(metrics);  % ML detection
        s_hat(i) = s_possibilities(index);
    end

    %% Count the bit errors
    bitErrors = bitErrors + sum(s_hat ~= rand_bits);
    totalBits = totalBits + Nt;
end

BER = bitErrors / totalBits;

end

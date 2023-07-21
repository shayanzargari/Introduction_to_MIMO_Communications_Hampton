function BER = MRRC(SNRdB, Nt, Nr, Niter)

rho = 10^(SNRdB/10);  % Convert SNR from dB to linear scale
bitErrors = 0;
totalBits = 0;

for iter = 1:Niter
    %% Step 1: Compute the transmit symbols (BPSK modulation)
    rand_bits = (2*randi([0 1], Nt, 1) - 1);
    s = sqrt(1/Nt) * rand_bits;  % Adjust for E{|s|^2} = 1/Nt

    %% Step 2: Compute the received signals
    h = sqrt(1/2) * (randn(Nr, Nt) + 1j*randn(Nr, Nt));  % Rayleigh fading
    z = sqrt(1/2) * (randn(Nr, 1) + 1j*randn(Nr, 1));  % AWGN
    r = sqrt(rho) * (h * s) + z;

    %% Step 3: Compute the combiner output
    s_tilde = h' * r;

    %% Step 4: Demodulate the received symbols using ML detection (hard decision)
    s_hat = zeros(size(s));
    s_possibilities = [-1, 1];  % Possible transmitted symbols (BPSK)
    for i = 1:length(s)
        % Compute the metrics for each possible symbol
        metrics = arrayfun(@(s_poss) (sum(abs(h).^2)-1) * abs(s_poss)^2 + abs(s_tilde(i) - s_poss)^2, s_possibilities);
        % Repeat the ML detection for each symbol
        [~, index] = min(metrics);  % ML detection
        s_hat(i) = s_possibilities(index);
    end

    %% Count the bit errors
    bitErrors = bitErrors + sum(s_hat ~= rand_bits);
    totalBits = totalBits + Nt;
end

BER = bitErrors / totalBits;

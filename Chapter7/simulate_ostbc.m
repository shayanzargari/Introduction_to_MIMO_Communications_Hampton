function SER = simulate_ostbc(SNR, Nt, Nr, Niter, constellation, mod_order, allCombinations)

errors = 0;
total = 0;
for i = 1:Niter
    % Generate symbols
    s = constellation(randi([1 length(constellation)], mod_order, 1));

    % Get OSTBC
    S = encode_symbols(s, Nt);

    [~, p] = size(S);

    % Generate random channel matrix H and noise vector Z
    H = sqrt(1/2)*(randn(Nr, Nt) + 1j*randn(Nr, Nt));
    Z = sqrt(1/2)*(randn(Nr, p) + 1j*randn(Nr, p));

    % Simulate transmission over MIMO channel
    R = sqrt(SNR)*H*S + Z;

    % Perform maximum likelihood detection
    s_est = ml_decoding(Nt, R, SNR, H, constellation, allCombinations);

    % Count symbol errors
    errors = errors + sum(abs(s_est - s));
    total = total + Nt;
end
SER = errors / total;

end
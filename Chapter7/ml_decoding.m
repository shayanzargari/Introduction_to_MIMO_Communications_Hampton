function decoded_symbols = ml_decoding(Nt, R, SNR, H, constellation, allCombinations)

min_dist = inf;
for p = 1:size(allCombinations, 1)
    s_p = constellation(allCombinations(p, :));  % Symbol vector
    S_p = encode_symbols(s_p, Nt);   % Encode with OSTBC

    dist = norm(R - sqrt(SNR)*H*S_p, 'fro')^2;
    if dist < min_dist
        min_dist = dist;
        decoded_symbols = s_p;
    end
end

end
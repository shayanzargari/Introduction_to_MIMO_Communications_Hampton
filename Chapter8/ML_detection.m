function [s_est] = ML_detection(r_hat, M)

% Generate constellation for M-PSK
constellation = pskmod(0:(M-1), M, pi/M);

p = size(r_hat, 2);
Nt = size(r_hat, 1);
s_est = zeros(size(r_hat));

for k = 1:p
    for n = 1:Nt
        % Calculate Euclidean distances to all constellation points
        distances = abs(r_hat(n,k) - constellation).^2;

        % Find the constellation point that minimises the Euclidean distance
        [~, min_index] = min(distances);

        % This is our decoded symbol for nth antenna
        s_est(n,k) = constellation(min_index);
    end
end

end
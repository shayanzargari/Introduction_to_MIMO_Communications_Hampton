function s_est = LMMSE_Decoding(H, R, rho, M)

p = size(R, 2);
[~, Nt] = size(H);

% Calculate W
Wo = sqrt(rho)/Nt * inv((rho/Nt) * (H' * H) + eye(Nt)) * H';

% Compute R_tilde
R_tilde = Wo * R;

% Initialize the estimated symbols
s_est = zeros(Nt, p);

for j = Nt:-1:1

    % Compute r_hat_j
    r_hat_j = R_tilde(j,:) / (sqrt(rho) * Wo(j,:) * H(:,j));

    % Maximum likelihood detection
    s_est(j, :) = ML_detection(r_hat_j, M);  

end

end

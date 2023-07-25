function s_hat_j = LMMSE_IC_Decoding(H, R, rho, M)

p = size(R, 2);
[Nr, Nt] = size(H);

% Calculate W
Wo = sqrt(rho)/Nt * inv((rho/Nt) * (H' * H) + eye(Nt)) * H';

% Loop variable initialization
j = Nt;

% LMMSE-IC decoding algorithm
s_hat_j  = zeros(Nt, p);

while j >= 1
    % a) Compute R_tilde = W0*R;
    R_tilde = Wo * R;

    % b) Compute r_hat
    r_hat_j = R_tilde(j,:) / (sqrt(rho) * Wo(j,:) * H(:,j));
    
    % c) Maximum likelihood detection to estimate the transmitted symbols
    s_hat_j(j, :) = ML_detection(r_hat_j, M);  
    
    % d) Compute Pj 
    Pj = H(:,j) * s_hat_j(j, :);
    
    % e) Update R
    R = R - sqrt(rho) * Pj;
    
    % f) Update H by removing the jth column
    H(:,j) = [];
    
    % g) Recompute Wo
    Wo = sqrt(rho)/Nt * H' * inv((rho/Nt) * (H * H') + eye(Nr));  

    % h) Decrease j by 1
    j = j - 1;
end

end
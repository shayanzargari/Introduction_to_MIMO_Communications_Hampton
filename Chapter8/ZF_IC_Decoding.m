function [s_est] = ZF_IC_Decoding(H, R, rho, M)

p = size(R, 2);
[~, Nt] = size(H);

% QR decomposition of H
[Q, V] = qr(H);

% Calculate R_tilde
R_tilde = Q' * R;

% Initializing the s_est matrix
s_est = zeros(Nt, p);

% Process from the last layer to the first
for i = Nt:-1:1

    % Step 1: estimate the symbols transmitted by antenna Nt
    if i == Nt
        r_hat = R_tilde(i,:) ./ sqrt(rho) * V(i,i);

        % Maximum likelihood detection to obtain estimates of s_Nt(k)
        s_est(i, :) = ML_detection(r_hat, M);
    else

        % Step 2: cancel interference in layer i
        R_tilde(i,:) = R_tilde(i,:) - sqrt(rho) * V(i, i+1:Nt) * s_est(i+1:Nt, :);

        % Compute r_hat
        r_hat = R_tilde(i,:) ./ sqrt(rho) * V(i,i);

        % Estimate the transmitted symbols associated with layer i by performing maximum likelihood detection of r_hat
        s_est(i, :) = ML_detection(r_hat, M);
    end
end
end
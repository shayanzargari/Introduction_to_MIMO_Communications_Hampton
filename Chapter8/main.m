clc; clear all; close all;

% Simulation parameters
Nt = 5;                     % Number of transmit antennas
Nr = 5;                     % Number of receive antennas
p = 50;                     % Number of symbol periods
iter = 10^4;                % Number of iterations for the Monte Carlo simulation
M = 2;                      % MPSK
SNRdB = 0:5:20;             % SNR in dB
SNR = 10.^(SNRdB/10);       % Convert SNR from dB to linear scale

% Initialize BER to zeros
ber_zf = zeros(1, length(SNR)); 
ber_zf_ic = zeros(1, length(SNR));
ber_LMMSE = zeros(1, length(SNR));
ber_LMMSE_IC = zeros(1, length(SNR));

for i = 1:length(SNR)

    rho = SNR(i);

    for j = 1:iter
        % Generate transmitted symbols matrix
        bit_seq = randi([0 M-1], Nt, p); 

        % Modulate bits to MPSK symbols
        S = pskmod(bit_seq, M, pi/M); 

        % Generate channel matrix (Rayleigh channel)
        H = 1/sqrt(2)*(randn(Nr, Nt) + 1j*randn(Nr, Nt));

        % Generate noise
        Z = 1/sqrt(2)*(randn(Nr, p) + 1j*randn(Nr, p));

        % Received signal
        R = sqrt(rho)*H*S + Z;

        % ZF, ZF-IC, LMMSE, LMMSE-IC decoding algorithms
        S_hat_zf = ZF_Decoding(H, R, rho, M);
        S_hat_zf_ic = ZF_IC_Decoding(H, R, rho, M);
        S_est_LMMSE = LMMSE_Decoding(H, R, rho, M);
        S_est_LMMSE_IC = LMMSE_IC_Decoding(H, R, rho, M);

        % Calculate bit errors for this iteration
        bit_errors_zf = sum(S ~= S_hat_zf, 'all');
        bit_errors_zf_ic = sum(S ~= S_hat_zf_ic, 'all');
        bit_errors_LMMSE = sum(S ~= S_est_LMMSE, 'all');
        bit_errors_LMMSE_IC = sum(S ~= S_est_LMMSE_IC, 'all');

        % Accumulate bit errors
        ber_zf(i) = ber_zf(i) + bit_errors_zf;
        ber_zf_ic(i) = ber_zf_ic(i) + bit_errors_zf_ic;
        ber_LMMSE(i) = ber_LMMSE(i) + bit_errors_LMMSE;
        ber_LMMSE_IC(i) = ber_LMMSE_IC(i) + bit_errors_LMMSE_IC;
    end
    % Calculate BER for this SNR
    ber_zf(i) = ber_zf(i) / (iter*p*Nt);
    ber_zf_ic(i) = ber_zf_ic(i) / (iter*p*Nt);
    ber_LMMSE(i) = ber_LMMSE(i) / (iter*p*Nt);
    ber_LMMSE_IC(i) = ber_LMMSE_IC(i) / (iter*p*Nt);
end

% Plot BER vs SNR
figure
semilogy(SNRdB, ber_zf, '-^', 'LineWidth', 1.2); hold on;
semilogy(SNRdB, ber_zf_ic, '-s', 'LineWidth', 1.2);
semilogy(SNRdB, ber_LMMSE, '-+', 'LineWidth', 1.2);
semilogy(SNRdB, ber_LMMSE_IC, '-d', 'LineWidth', 1.2);
xlabel('SNR (dB)'); ylabel('Bit Error Rate');
legend('ZF', 'ZF-IC', 'LMMSE', 'LMMSE-IC')
grid on; box on;
title(sprintf('Demultiplexing methods for H-BLAST and V-BLAST for N_t=N_r=%d', Nt));
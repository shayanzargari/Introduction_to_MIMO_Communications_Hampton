clc; clear all; close all;
% Simulation parameters
Nt = 2;  % Number of transmit antennas
Nr = 1;  % Number of receive antennas
Niter = 1e5;  % Number of iterations for the Monte Carlo simulation
SNRdB = 5:5:30;  % SNR in dB
SER = zeros(length(SNRdB), 1);  % SER results

mod_scheme = 'QPSK';  % Modulation scheme ('BPSK', 'QPSK', '16QAM', '64QAM')
[constellation, mod_order] = get_constellation(mod_scheme);


% Generate all possible symbol combinations for ML detection
[aa, bb, cc, dd] = ndgrid(1:length(constellation));
allCombinations = [aa(:), bb(:), cc(:), dd(:)];

% Main simulation loop
for iter = 1:length(SNRdB)
    SNR = 10^(SNRdB(iter)/10);  % Convert SNR from dB to linear scale
    SER(iter) = simulate_ostbc(SNR, Nt, Nr, Niter, constellation, mod_order, allCombinations);
end

% Plot SER
figure; 
semilogy(SNRdB, SER, 'o-'); 
grid on; box on;
xlabel('SNR (dB)'); ylabel('Symbol Error Rate');
title(sprintf('OSTBC Performance for %d Transmit Antennas (Modulation: %s)', Nt, mod_scheme));
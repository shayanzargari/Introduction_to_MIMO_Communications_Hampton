clc;
clear all;
close all;

% Initialize parameters
SNRdB = 0:5:20;  % Signal-to-Noise Ratio in dB
Niter = 50000;   % Number of iterations for each SNR point
p = 2;

if p == 2
    % Define pilot matrix for p = 2
    Sp = 1/sqrt(2) * [1, 1; 1, -1];
elseif p == 4
    % Define pilot matrix for p = 4
    Sp = 1/sqrt(2) * [1, 1, -1, -1; 1, -1, 1, -1];
end

% Define the dimensions of the MIMO systems
Nt_Alamouti = 2;  % Number of transmit antennas for Alamouti
Nr_Alamouti = 1;  % Number of receive antennas for Alamouti

% Initialize arrays to store the simulation results
BER_sim_Alamouti_est = zeros(length(Nt_Alamouti), length(SNRdB));
BER_sim_Alamouti_pre = zeros(length(Nt_Alamouti), length(SNRdB));

% Perform simulations
for j = 1:length(SNRdB)
        BER_sim_Alamouti_est(1,j) = Alamouti_w_CE(SNRdB(j), Nt_Alamouti, Nr_Alamouti, Niter, Sp, p);
end

% Plot the simulation results
figure;
semilogy(SNRdB, BER_sim_Alamouti_est, 'v-', 'LineWidth', 1.5);
legend('With channel estimation (p = 2)');
xlabel('SNR (dB)');
ylabel('Bit Error Rate');
title('BER of MRRC and Alamouti in Rayleigh fading assuming BPSK');
grid on; box on;
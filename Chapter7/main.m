clc;
clear all;
close all;

% Initialize parameters
SNRdB = 0:5:45;  % Signal-to-Noise Ratio in dB
Niter = 50000;   % Number of iterations for each SNR point

% Define the dimensions of the MIMO systems
Nt_MRRC = [1 1];  % Number of transmit antennas for MRRC
Nr_MRRC = [2 4];  % Number of receive antennas for MRRC
Nt_Alamouti = [2 2];  % Number of transmit antennas for Alamouti
Nr_Alamouti = [1 2];  % Number of receive antennas for Alamouti

% Initialize arrays to store the simulation results
BER_sim_MRRC = zeros(length(Nt_MRRC), length(SNRdB));
BER_sim_Alamouti = zeros(length(Nt_Alamouti), length(SNRdB));

% Perform simulations
for j = 1:length(SNRdB)
    for i = 1:length(Nt_MRRC)
        BER_sim_MRRC(i,j) = MRRC(SNRdB(j), Nt_MRRC(i), Nr_MRRC(i), Niter);
        BER_sim_Alamouti(i,j) = Alamouti(SNRdB(j), Nt_Alamouti(i), Nr_Alamouti(i), Niter);
    end
end

% Plot the simulation results
figure;
semilogy(SNRdB, BER_sim_MRRC(1,:), 'o-', 'LineWidth', 1.5); hold on;
semilogy(SNRdB, BER_sim_Alamouti(1,:), '^-', 'LineWidth', 1.5);
semilogy(SNRdB, BER_sim_MRRC(2,:), 's-', 'LineWidth', 1.5);
semilogy(SNRdB, BER_sim_Alamouti(2,:), 'v-', 'LineWidth', 1.5);
legend('1x2 MRRC', '2x1 Alamouti', '1x4 MRRC', '2x2 Alamouti');
xlabel('SNR (dB)');
ylabel('Bit Error Rate');
title('BER of MRRC and Alamouti in Rayleigh fading assuming BPSK');
grid on; box on;
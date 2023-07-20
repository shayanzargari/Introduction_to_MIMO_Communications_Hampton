clc;
clear all;
close all;

% --------------------- Solution 3.6 ---------------------
SNRvec_dB = -20:5:20;  % SNR values in dB

% Define H1 as in Eq. 3.39
H1 = [0.46 + 0.31j, -0.079 + 0.18j, 0.43 - 0.68j;
     -0.04 + 0.66j, 0.95 - 0.50j, -0.77 - 0.51j;
      0.45 + 0.46j, 0.90 + 0.56j, 0.46 - 1.87j;
     -0.13 - 0.19j, 0.90 - 0.73j, 1.04 + 0.91j];

% Calculate and plot capacity for each calcType
C = zeros(length(SNRvec_dB), 2);
for calcType = 1:2
    C(:, calcType) = CvsSNR_EqualPowerAllocation(SNRvec_dB, H1, calcType);
end

% Plot
% figure(1);
% plot(SNRvec_dB, C(:, 1), 'o-', 'LineWidth', 2);
% hold on;
% plot(SNRvec_dB, C(:, 2), 's-', 'LineWidth', 2);
% xlabel('SNR (dB)');
% ylabel('Capacity (bits/s/Hz)');
% grid on;
% legend('calcType = 1', 'calcType = 2', 'Location', 'northwest');


% --------------------- Solution 3.7 ---------------------
[C_SingleMode, Weights] = CvsSNR_SingleMode(SNRvec_dB, H1);

% Plot
% figure(2);
% plot(SNRvec_dB, C_SingleMode, 'o-', 'LineWidth', 2);
% title('Capacity vs SNR for Single-Mode Eigenbeamforming');
% xlabel('SNR (dB)');
% ylabel('Capacity (bits/s/Hz)');
% grid on;

% --------------------- Solution 3.8 ---------------------
[C_Eigenbeamforming, gain] = CvsSNR_Eigenbeamforming(SNRvec_dB, H1);
% figure(3);
% plot(SNRvec_dB, C_Eigenbeamforming, 'o-', 'LineWidth', 2);
% title('Eigenbeamforming with Waterfilling');
% xlabel('SNR (dB)');
% ylabel('Capacity (bits/s/Hz)');
% grid on;


% --------------------- Final Plot ---------------------
figure(4);
hold on;
plot(SNRvec_dB, C(:, 1), 'o-', 'LineWidth', 1.5);
plot(SNRvec_dB, C_SingleMode, 's-', 'LineWidth', 1.5);
plot(SNRvec_dB, C_Eigenbeamforming, '+-', 'LineWidth', 1.5);

xlabel('SNR (dB)'); ylabel('Capacity (bits/s/Hz)');
grid on; box on;
legend('Equal Power Allocation', 'Single-Mode', 'Eigenbeamforming', 'Location', 'northwest');


% --------------------- Solution 3.9 ---------------------
Nt = 2; % Number of transmit antennas
Nr = 2; % Number of receive antennas
Niter = 10000; % Number of Monte Carlo iterations
C_vec = zeros(1, length(SNRvec_dB)); % Initialize capacity vector


% Calculate ergodic capacity for each SNR value
for i = 1:length(SNRvec_dB)
    C_vec(i) = ErgodicCapacity(SNRvec_dB(i), Nt, Nr, Niter);
end

% Plot the ergodic capacity
figure(5);
plot(SNRvec_dB, C_vec, 'o-', 'LineWidth', 2);
grid on; box on;
xlabel('SNR (dB)'); ylabel('Ergodic Capacity (bits/s/Hz)');
title(sprintf('Ergodic Capacity of a %d x %d MIMO system', Nt, Nr));


% --------------------- Solution 3.9 ---------------------
N = 2:2:10;  % Number of antennas (transmit and receive)
Niter = 10000;  % Number of Monte Carlo iterations
q = 10;  % Outage probability in percent
SNRvec_dB = [0, 10, 20, 30];  % SNR values in dB

% Initialize capacity matrix
C_mat = zeros(length(N), length(SNRvec_dB));

% Calculate outage capacity for each SNR value and each N
for i = 1:length(N)
    for j = 1:length(SNRvec_dB)
        C_mat(i, j) = OutageCapacity(SNRvec_dB(j), N(i), N(i), Niter, q);
    end
end

% Plot the outage capacity
figure(6);
hold on;
colors = {'b', 'r', 'g', 'k'};
markers = {'o-', 's-', 'd-', '^-'};  % Different markers for different SNRs
for j = 1:length(SNRvec_dB)
    plot(N, C_mat(:, j), markers{j}, 'Color', colors{j}, 'LineWidth', 1.5);
end
grid on; box on;
xlabel('N (Number of antennas)'); ylabel('Outage Capacity (bits/s/Hz)');
legend('SNR = 0 dB', 'SNR = 10 dB', 'SNR = 20 dB', 'SNR = 30 dB', 'Location', 'NorthWest');
title('Outage Capacity vs. Number of antennas for different SNRs');

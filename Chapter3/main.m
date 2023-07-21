clc;
clear all;
close all;

% --------------------- Solution 5.5 ---------------------
SNRdBvec = [10, 30]; % SNR values in dB
Niter = 10000; % Number of Monte Carlo iterations

% Number of transmit and receive antennas
Nt = 4;
Nr = 4;

Rr_values = 0:0.1:0.9;  % Values of |ρr| (antenna correlation)

Rt = eye(Nr);  % Transmit covariance matrix (identity matrix)

Rr_cell = cell(1, length(Rr_values));
for i = 1:length(Rr_values)
    Rr_cell{i} = Rr_values(i) * ones(Nr) + (1 - Rr_values(i)) * eye(Nr);
end

% Initialize capacity matrix to store the results
C_Corr = zeros(length(Rr_values), length(SNRdBvec));

% Calculate ergodic capacity for each |ρr| value and each SNR value
for j = 1:length(SNRdBvec)
    for i = 1:length(Rr_values)
        C_Corr(i, j) = ErgodicCapacity_Corr(SNRdBvec(j), Nt, Nr, Rt, Rr_cell{i}, Niter);
    end
end

% Plot the results
figure(1);
plot(Rr_values, C_Corr(:, 1), 'o-', 'LineWidth', 1.5);
hold on;
plot(Rr_values, C_Corr(:, 2), 's-', 'LineWidth', 1.5);
grid on; box on;
xlabel('Magnitude of Receive Correlation Coefficient, |\rho_r|');
ylabel('Ergodic Capacity (bits/s/Hz)');
legend('SNR = 10 dB', 'SNR = 30 dB', 'Location', 'northeast');
title(sprintf('Ergodic Capacity of a %dx%d MIMO system in Rayleigh fading', Nt, Nr));
ylim([5 40])


% --------------------- Solution 5.6 ---------------------
SNRdB = 10; % SNR value in dB
rho = 10^(SNRdB/10);
Kvec = linspace(0, 100, 50); % Values of K-factor to be tested
HLOS = ones(Nr, Nt); % All-ones matrix for HLOS

% Calculate ergodic capacity for each K-factor value
C_Rician = ErgodicCapacity_Rician(SNRdB, Nt, Nr, Kvec, HLOS, Niter);

% Asymptotic capacity for comparison
asymptotic_capacity = log2(1 + rho * Nr);

% Plot the results
figure(2);
plot(Kvec, C_Rician, '-', 'LineWidth', 1.5);
hold on;
plot(Kvec, asymptotic_capacity * ones(size(Kvec)), '--', 'LineWidth', 1.5);
grid on; box on;
xlabel('Rician K-factor');
ylabel('Ergodic Capacity (bits/s/Hz)');
legend('Ergodic Capacity', 'Asymptotic Capacity', 'Location', 'northeast');
title(sprintf('Ergodic Capacity of a %dx%d MIMO system in Rayleigh fading', Nt, Nr));

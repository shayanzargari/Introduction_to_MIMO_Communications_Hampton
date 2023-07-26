function [Popt] = waterfilling(singular_values_sq, rho)
% Initialize
N = length(singular_values_sq);
Popt = zeros(1, N);
p = 1;

while p <= N
    % Calculate mu
    mu = (1 + (1/rho) * sum(1 ./ singular_values_sq(1:(N-p+1)))) / (N-p+1);

    % Allocate power
    Popt(1:(N-p+1)) = mu - (1 ./ (rho .* singular_values_sq(1:(N-p+1))));

    % Check if power is allocated to channel with lowest gain
    if Popt(N-p+1) < 0
        % Discard that channel
        Popt(N-p+1) = 0;
        % Increment p
        p = p + 1;
    else
        break;
    end
end
end

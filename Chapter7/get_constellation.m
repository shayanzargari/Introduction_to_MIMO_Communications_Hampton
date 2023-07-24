function [constellation, mod_order] = get_constellation(mod_scheme)
    % Choose the modulation scheme
    switch mod_scheme
        case 'BPSK'
            constellation = [1 -1];
            mod_order = 2;
        case 'QPSK'
            constellation = (1/sqrt(2)) * [1 + 1j, 1 - 1j, -1 + 1j, -1 - 1j];
            mod_order = 4;
        otherwise
            error('Unsupported modulation scheme');
    end
end

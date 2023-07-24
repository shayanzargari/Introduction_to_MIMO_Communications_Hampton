function encoded_symbols = encode_symbols(s, Nt)

switch Nt
    case 2
        % Alamouti code
        encoded_symbols = [s(1), -conj(s(2));
            s(2),  conj(s(1))];
    case 3
        % G3
        encoded_symbols = [s(1), -s(2), -s(3), -s(4), conj(s(1)), -conj(s(2)), -conj(s(3)), -conj(s(4));
                           s(2),  s(1),  s(4), -s(3), conj(s(2)),  conj(s(1)),  conj(s(4)), -conj(s(3));
                           s(3), -s(4),  s(1),  s(2), conj(s(3)), -conj(s(4)),  conj(s(1)),  conj(s(2))];
    case 4
        % G4
        encoded_symbols = [s(1), -s(2), -s(3), -s(4), conj(s(1)), -conj(s(2)), -conj(s(3)), -conj(s(4));
                           s(2),  s(1),  s(4), -s(3), conj(s(2)),  conj(s(1)),  conj(s(4)), -conj(s(3));
                           s(3), -s(4),  s(1),  s(2), conj(s(3)), -conj(s(4)),  conj(s(1)),  conj(s(2));
                           s(4),  s(3), -s(2),  s(1), conj(s(4)),  conj(s(3)), -conj(s(2)),  conj(s(1))];
    otherwise
        error('Unsupported number of transmit antennas');
end

end
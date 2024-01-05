function x = bpsk_mapping(c,Nb)
    % QPSK Mapping Function
    % Inputs:
    %   c: Input bit sequence
    % Outputs:
    %   x: QPSK symbols

    % Mapping
    Map = [1,-1];
    
    % Initialization
    x = zeros(1, Nb);

    % BPSK mapping loop
    for i = 1:Nb
        x(i) = Map()
        j = bi2de(flip(c((2*i-1):2*i)));  % Getting mapping index
        x(i) = Map(j+1);            % Mapping
    end
end

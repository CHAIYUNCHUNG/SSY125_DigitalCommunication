function c = encoding(Nb,u,G)
    K = length(G);
    state = zeros(1,K);
    c1 = zeros(1,Nb);         % Output bit
    c2 = zeros(1,Nb);
    for i = 1:Nb
        state = [u(i), state(1:end-1)];
        C1 = de2bi(state*G(:,1));
        c1(i) = C1(1);
        C2 = de2bi(state*G(:,2));
        c2(i) = C2(1);
    end
    c = [c1;c2];
end
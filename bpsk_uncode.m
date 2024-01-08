
Nb = 100000;
BERarrayu = zeros(1,10);
range = [-1:12];
for SNR = range
    N0 = 1/(10^(SNR/10));
    u = randi([0 1],[1 Nb]);
    xu = u*2-1;
    nu = sqrt(N0)*randn(1,Nb);
    yu = xu + nu;
    
    % Detect signal
    xu_hat = zeros(1,Nb);
    for i = 1:Nb
        if yu(i)>0
            xu_hat(i) = 1;
        else
            xu_hat(i) = 0;
        end
    end
    eu = bitxor(u,xu_hat);
    BERu = sum(eu)/Nb;
    BERarrayu(SNR+2) = BERu;
end

semilogy(range,BERarrayu,'-o')
ylim([1e-4 1])
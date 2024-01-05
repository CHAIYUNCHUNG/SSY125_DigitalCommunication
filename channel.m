function y = channel(x,Nb,SNR)
    Map = [1+1j -1+1j 1-1j -1-1j];
    Es = sum(abs(Map).^2)/length(Map);  
    Eb = Es/2;
    N0 = Eb/(10^(SNR/10));  % Noise power
    nr = sqrt(N0)*randn(1,Nb);
    ni = sqrt(N0)*randn(1,Nb)*1j;
    y = x + nr + ni;
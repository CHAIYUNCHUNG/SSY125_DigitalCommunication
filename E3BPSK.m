clc
clear
BERarray = zeros(1,10);
range = [-1:8];
for SNR = range
    % u = [1 0 1 1 0 0];
    Nb = 1000;
    u = randi([0 1],[1 Nb]);
    g1 = [1 0 0 1 1]';
    g2 = [1 1 0 1 1]'; 
    G = [g1 g2];
    [K,Nc] = size(G);
    Ns = 2^(K-1);
    
    u_hat = zeros(1,Nb);
    % survivor = NaN(num_of_states,depth_of_trellis + 1);   
    % branch = NaN(num_of_states,num_of_states);    
    % path = NaN(num_of_states,depth_of_trellis + 1);            
    % final_path_state = zeros(1,depth_of_trellis + 1);
    
    QPSK00 = 1+1j;
    QPSK01 = -1+1j;
    QPSK10 = 1-1j;
    QPSK11 = -1-1j;
    Map = [1+1j -1+1j 1-1j -1-1j];
    
    c = encoding(Nb,u,G);
    x = qpsk_mapping(c,Nb);
    y = channel(x,Nb,SNR);
    
%     figure(1)
%     plot(y,'.')
%     hold on;
%     plot([0, 0], ylim, 'k--');  % Vertical line for y-axis
%     plot(xlim, [0, 0], 'k--');  % Horizontal line for x-axis
%     scatter(real(QPSK00),imag(QPSK00))
%     scatter(real(QPSK10),imag(QPSK10))
%     scatter(real(QPSK01),imag(QPSK01))
%     scatter(real(QPSK11),imag(QPSK11))
%     hold off;
%     xlabel('Re');
%     ylabel('Im');
%     title('QPSK constellation');
%     grid on;
    
    % for i=1:Nb
    %         [v,p] = mindist(Map,y(i));
    % end
    % 
    % [states,next,output] = stategenerator(G);
    % state = zeros(1,length(G)-1);
    
    bits_de = softdecode(y,Map,G);
    BER = sum(xor(bits_de,u))/Nb;
    BERarray(SNR+2) = BER;
end
    
figure(2)
semilogy(range,BERarray,'-o')
title('BER v.s. E_b/N_0 plot')
xlabel('E_b/N_0 [dB]')
ylabel('BER')
hold on
ylim([1e-4 1])
grid on
title('$\varepsilon_3$ and $\chi_{BPSK}$','Interpreter','latex')
    
    


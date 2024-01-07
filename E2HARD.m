clear
clc
BERarray = zeros(1,10);
BERarrayu = zeros(1,10);
range = [-1:8];
for SNR = range
    g1 = [1 0 1 1 1]'; % 1 + D^2 + D^3 + D^4
    g2 = [1 0 1 1 0]'; % 1 + D^2 + D^3
    G = [g1 g2];
    K = max(length(g1),length(g2)); % Block length
    Ns = 2^(K-1);       % number of states
    Nb = 100000;        % Number of input bits
    Nc = 2;             % Number of coded bits
    % SNR = 10;   % dB
    
    state = zeros(1,K);    % [input, D, D^2] state(1) = input
    c1 = zeros(1,Nb);         % Output bit
    c2 = zeros(1,Nb);
    
    % Es = 2*Eb;
    
    
    %% Encoding
    u = randi([0 1],[1 Nb]);
    % u = [1 0 0 1 0];
    for i = 1:Nb
        state = [u(i), state(1:end-1)];
        C1 = de2bi(state*g1);
        c1(i) = C1(1);
        C2 = de2bi(state*g2);
        c2(i) = C2(1);
        c = [c1;c2];
    end
    
    %% Mapping
    % For QPSK, every symbol transmits 2 bitsing
    Map = [1+1j -1+1j 1-1j -1-1j];
    x = zeros(1,Nb);
    for i = 1:Nb
        j = bi2de(c((2*i-1):2*i));  % Getting mapping index
        x(i) = Map(j+1);            % Mapping
    end
    
    %% Adding noise
    % snr_dB = 10;  % Signal-to-noise ratio in decibels
    % signalPower = sum(abs(modulatedSignal).^2) / length(modulatedSignal);
    % noisePower = signalPower / (10^(snr_dB / 10));
    % 
    % % Generate Gaussian noise with the same length as the signal
    % noise = sqrt(noisePower) * randn(size(modulatedSignal));
    % 
    % % Add noise to the signal
    % noisySignal = modulatedSignal + noise;
    
    Es = sum(abs(Map).^2)/length(Map);  
    Eb = Es/2;
    N0 = Eb/(10^(SNR/10));  % Noise power
    nr = sqrt(N0)*randn(1,Nb);
    ni = sqrt(N0)*randn(1,Nb)*1j;
    y = x + nr + ni;
    
    % Plot QPSK constellation
%     figure(1)
%     plot(y,'.')
%     hold on;
%     plot([0, 0], ylim, 'k--');  % Vertical line for y-axis
%     plot(xlim, [0, 0], 'k--');  % Horizontal line for x-axis
%     hold off;
%     xlabel('Re');
%     ylabel('Im');
%     title('QPSK constellation');
%     grid on;
    
    %% Symbol detector
    c_hat = zeros(2,Nb);
    for i = 1:Nb
        if real(y(i)) >= 0
            c_hat(1,i) = 0;
        else
            c_hat(1,i) = 1;
        end
        if imag(y(i)) >= 0
            c_hat(2,i) = 0;
        else
            c_hat(2,i) = 1;
        end
    end
    % error = bitxor(c,c_hat);
    % sum(error)
    
    
    %% Viterbi
    % Generate a matrix of state transfer.
    ST = zeros(Ns*2,(K-1)*2+1+Nc+1);  % (1:K-1) is current state. (K) is input. (K+1:2*K-1) is next state. (2*K:end-1) is ouput. (end) is index
    
    for i = 1:Ns
        % Current state
        if i >= Ns/2+1
            ST(2*i-1,1:K-1) = ST(2*i-1,1:K-1) + flip(de2bi(i-1));
            ST(2*i,1:K-1) = ST(2*i,1:K-1) + flip(de2bi(i-1));
        end

        ST(1:Ns,1:K-1) = ST(Ns+1:end,1:K-1);
        ST(1:Ns,1) = zeros(Ns,1);
    end

    for i = 1:Ns
        % Input
        ST(2*i-1,K) = 0;
        ST(2*i,K) = 1;
    
        % Next state
        ST(2*i-1, K+1:2*K-1) = [0,ST(2*i-1, 1:K-2)];
        ST(2*i, K+1:2*K-1) = [1,ST(2*i, 1:K-2)];
        
        % Next state index
        ST(2*i-1, end) = bi2de(flip(ST(2*i-1, K+1:2*K-1))) + 1;
        ST(2*i, end) = bi2de(flip(ST(2*i, K+1:2*K-1))) + 1;
    
        % Output
        OUT = de2bi([ST(2*i-1,K), ST(2*i-1,1:K-1)]*G);
        out = OUT(:,1);
        ST(2*i-1, 2*K:end-1) = out;
        OUT = de2bi([ST(2*i,K), ST(2*i,1:K-1)]*G);
        out = OUT(:,1);
        ST(2*i, 2*K:end-1) = out;
    end
    
    track = zeros(Ns*2,Nb);     % Track is set with the sequence of index (1,2,3,4,...)
    
    % Important note: state (00) always matching
    matching = zeros(Ns*2,3); 
    matching(1,1) = 1;
    % Matching
    for i = 1:Nb
        for j = 1:Ns
            if matching(j,1) ~= 0
                matching(j,2) = ST(2*matching(j,1)-1, end);     % Save the next state index
                matching(j+Ns,:) = matching(j,:);
                matching(j+Ns,2) = ST(2*matching(j,1), end);    % Index for input = 1
                track(j,i) = 0;
                track(j+Ns,i) = 1;
                for ic =u_hat 1:Nc
                    % input = 0
                    if ST(2*matching(j)-1, 2*K-1+ic) == c_hat(2*i-2+ic)
                        matching(j,3) = matching(j,3) + 1;      % If match, add 1
                    end
                             
                    % input = 1
                    if ST(2*matching(j), 2*K-1+ic) == c_hat(2*i-2+ic)
                        matching(j+Ns,3) = matching(j+Ns,3) + 1;        
                    end
                end
            end
        end
        
        % re-arrange matching matrix
        for j = 1:2*Ns-1
            for k = j+1:2*Ns
                if matching(j,2) == matching(k,2)       % Check if two routes meet at the same state
                    if matching(j,3) > matching(k,3)    % If so, compare the matched index
                        matching(k,:) = [0 0 0];        % Dismiss the less one
                        track(k,:) = zeros(1,Nb);
                    else 
                        matching(j,:) = [0 0 0];
                        track(j,:) = zeros(1,Nb);
                    end
                end
            end
        end
        
        % Moving the remained row of data to the first half of matrix matching
        index = 1;
        for j = 1:2*Ns  
            if matching(j,2) ~= 0
                register = [matching(j,2),0,matching(j,3)];
                register2 = track(j,:);
                track(j,:) = zeros(1,Nb);
                track(index,:) = register2;
                matching(j,:) = [0 0 0];
                matching(index,:) = register;
                index = index + 1;
            end
        end
        track(Ns+1:end,:) = track(1:Ns,:);
    end
    
    Maxindex = find(matching(:,end) == max(matching(:,end)));
    u_hat = track(Maxindex(1),:);
    e = bitxor(u,u_hat);    % Hamming distance (error)
    BER = sum(e)/Nb;
    BERarray((SNR+2)) = BER;

%     %% Uncoded system
%     xu = zeros(1,Nb/2);
%     for i = 1:Nb/2
%         j = bi2de(u(2*i-1:2*i));    % Getting mapping index
%         xu(i) = Map(j+1);            % Mapping
%     end
% 
%     % Add noise for uncoded system
%     nru = sqrt(N0)*randn(1,Nb/2);
%     niu = sqrt(N0)*randn(1,Nb/2)*1j;
%     yu = xu + nru + niu;
% 
%     % Detect signal
%     xu_hat = zeros(1,Nb);
%     for i = 1:Nb/2
%         if real(yu(i)) >= 0
%             xu_hat(i*2-1) = 0;
%         else
%             xu_hat(i*2-1) = 1;
%         end
%         if imag(yu(i)) >= 0
%             xu_hat(i*2) = 0;
%         else
%             xu_hat(i*2) = 1;
%         end
%     end
%     eu = bitxor(u,xu_hat);
%     BERu = sum(eu)/Nb;
%     BERarrayu(SNR+2) = BERu;
%     

end

figure(1)
semilogy(range,BERarray,'-o')
title('$\varepsilon_2$ and $\chi_{QPSK}$ Hard decoder','Interpreter','latex')
xlabel('E_b/N_0 [dB]')
ylabel('BER')
hold on
semilogy(range,BERarrayu,'-o')
legend('coded system','uncoded system')
ylim([1e-4 1])
grid on


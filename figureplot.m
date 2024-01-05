% Plot the graphs
range = [-1:8];
E1 = [0.18021,0.10694,0.04884,0.01653,0.00396,0.00065,0.00018,1e-5,1e-5,1e-5];
E2 = [0.20621,0.12611,0.06177,0.0228,0.00695,0.00091,0.00025,7e-5,4e-5,4e-5];
E2hard = [];
E3 = [0.23442,0.13082,0.04921,0.01199,0.00161,0.00021,3e-5,2e-5,1e-5,3e-5];
E3bpsk = [0.23912,0.13246,0.05177,0.01314,0.0023,0.00025,2e-5,2e-5,2e-5,1e-5];
%% Hard v.s. Soft Receiver
figure(1)
semilogy(range,E2hard,'-o',range,E2,'-o')
title('Hard v.s. Soft Receiver')
xlabel('E_b/N_0 [dB]')
ylabel('BER')
hold on
legend({'$\varepsilon_2$ Hard','$\varepsilon_2$ Soft'}, 'Interpreter', 'latex');
ylim([1e-4 1])
grid on


%% Encoder Comparison
figure(2)
semilogy(range,E1,'-o',range,E2,'-o',range,E3,'-o')
title('Encoder Comparison')
xlabel('E_b/N_0 [dB]')
ylabel('BER')
hold on
legend({'$\varepsilon_1$', '$\varepsilon_2$', '$\varepsilon_3$'}, 'Interpreter', 'latex');
ylim([1e-4 1])
grid on

%% Coding can Increase Efficiency
figure(3)
semilogy(range,E3bpsk,'-o',range,E3,'-o')
title('Coding can Increase Efficiency')
xlabel('E_b/N_0 [dB]')
ylabel('BER')
hold on
legend({'$\varepsilon_3 \chi_{BPSK}$','$\varepsilon_3 \chi_{QPSK}$'}, 'Interpreter', 'latex');
ylim([1e-4 1])
grid on


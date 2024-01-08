% Plot the graphs
range = [-1:8];
QPSK_uncoded = [0.18442,0.15974,0.13232,0.10204,0.07824,0.05631,0.03847,0.02303,0.01314,0.00626,0.00248,0.00076,0.00013,3e-5];
BPSK_uncoded = [0.18648,0.1572,0.13125,0.10419,0.07976,0.05528,0.03872,0.02357,0.01263,0.00575,0.00258,0.00071,0.0002,3e-5];
E1 = [0.18021,0.10694,0.04884,0.01653,0.00396,0.00065,0.00018,1e-5,1e-5,1e-5];
E2 = [0.20621,0.12611,0.06177,0.0228,0.00695,0.00091,0.00025,7e-5,4e-5,4e-5];
E2hard = [0.29222,0.22954,0.15785,0.09184,0.04318,0.01665,0.00432,0.00086,0.00025,4e-5];
E3 = [0.23442,0.13082,0.04921,0.01199,0.00161,0.00021,3e-5,2e-5,1e-5,3e-5];
E3bpsk = [0.23912,0.13246,0.05177,0.01314,0.0023,0.00025,2e-5,2e-5,2e-5,1e-5];
%% Hard v.s. Soft Receiver
figure(1)
semilogy(range,E2hard,'-o',range,E2,'-o',[-1:12],QPSK_uncoded,'-o')
title('Hard v.s. Soft Receiver')
xlabel('E_b/N_0 [dB]')
ylabel('BER')
hold on
legend({'$\varepsilon_2$ Hard','$\varepsilon_2$ Soft','QPSK uncode'}, 'Interpreter', 'latex');
ylim([1e-4 1])
grid on


%% Encoder Comparison
figure(2)
semilogy(range,E1,'-o',range,E2,'-o',range,E3,'-o',[-1:12],QPSK_uncoded,'-o')
title('Encoder Comparison')
xlabel('E_b/N_0 [dB]')
ylabel('BER')
hold on
legend({'$\varepsilon_1$', '$\varepsilon_2$', '$\varepsilon_3$','QPSK uncode'}, 'Interpreter', 'latex');
ylim([1e-4 1])
grid on

%% Coding can Increase Efficiency
C_BPSK = 10*log10((2^0.5-1)/0.5);
C_QPSK = 10*log10((2^1-1)/1);
figure(3)
semilogy(range,E3bpsk,'-o',[-1:12],BPSK_uncoded,'-o',range,E3,'-o',[-1:12],QPSK_uncoded,'-o')
title('Coding can Increase Efficiency')
xlabel('E_b/N_0 [dB]')
ylabel('BER')
hold on
xline(C_QPSK,'b','QPSK capacity');
xline(C_BPSK,'r','BPSK capacity');
hold off
legend({'$\varepsilon_3 \chi_{BPSK}$','BPSK uncode','$\varepsilon_3 \chi_{QPSK}$','QPSK uncode'}, 'Interpreter', 'latex');
ylim([1e-4 1])
grid on



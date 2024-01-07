% Example code for plotting a theoretical BER curve using qfunc for QPSK
EbN0dB = -1:8; % Eb/N0 range in dB
codeRate = 1/2; % Example code rate
EsN0dB = EbN0dB + 10 * log10(codeRate); % Convert Eb/N0 to Es/N0 for QPSK
Ps = qfunc(sqrt(2 * 10.^(EsN0dB / 10))); % Symbol error probability for QPSK

% Assuming QPSK modulation (2 bits per symbol)
berTheoretical = Ps / 2; % BER is half of the symbol error rate for QPSK

% Plot the results
semilogy(EbN0dB, berTheoretical);
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (BER)');
title('Theoretical BER for Convolutional Code with QPSK Modulation');
grid on;

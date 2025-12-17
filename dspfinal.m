clear
close all
clc

% User Message Input:
message = input("Input Text Message:\n", "s");
fprintf(message + "\n")
header = 'H'

% Convert text to binary
asciiValues = uint8(message); % Characters mapped to ASCII Integer Values
header_asciiValues = uint8(header); 

binMessage=dec2bin(asciiValues, 8); % ASCII Integer Values mapped to 8-bit binary
header_binMessage = dec2bin(header_asciiValues, 8);
% msg_length = numel(asciiValues);

n = 100; % Width of n = W
bit_text_msg = reshape(binMessage.', 1, [])
header_bit = reshape(header_binMessage.', 1, [])
bit_msg_w_hdr = [header_bit bit_text_msg]

boxes = [];
tic
for i = 1:length(bit_msg_w_hdr)
    %x is starting and ending points of each box
    x1=n*(i-1);
    x2=n*i;
    if bit_msg_w_hdr(i)=='0'
        y=-1;
    end
    if bit_msg_w_hdr(i)=='1'
        y=1;
    end
    %now we need to add this new box to a set of the existing boxes
    for bounds = x1:x2
        newentry=[bounds y];
        boxes=[boxes; newentry];
    end
end
toc

%plotting
width = boxes(:,1);
msg_output = boxes(:,2);
plot(width, msg_output);
xlabel('n');
ylabel('m[n]');
title('Plot of boxes');
grid on;

plot_mag_freq(msg_output)
title('Magnitude of the Fourier Transform of original signal')

% create the first cosine
l = [0:length(msg_output)-1]';
Fs = 5000;
Fc = 1000;
omega_1 = 2*pi*(Fc/Fs);
c1 = cos(omega_1*l);

x1 = msg_output.*c1;
% visualize the Fourier transforms of the demodulated signals
figure(2)
plot_mag_freq(x1);
title('Magnitude of the Fourier Transform of the demodulated signal with \omega_1')

xx1 = [zeros(Fs, 1); x1];

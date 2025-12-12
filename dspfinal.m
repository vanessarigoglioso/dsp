clear
close all
clc

% User Message Input:
message = input("Input Text Message:\n", "s");
fprintf(message + "\n")

% Convert text to binary
asciiValues = uint8(message); % Characters mapped to ASCII Integer Values
binMessage=dec2bin(asciiValues, 8) % ASCII Integer Values mapped to 8-bit binary
% msg_length = numel(asciiValues);

width = 100;
bit_text_msg = reshape(binMessage.', 1, [])

for i = 1:length(bit_text_msg)
end





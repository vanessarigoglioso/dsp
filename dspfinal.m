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
    %x is starting and ending points of each box
    x1=width*(i-1);
    x2=width*i;
    if bit_text_msg(i)=='0'
        y=-1;
    end
    if bit_text_msg(i)=='1'
        y=1;
    end
    %now we need to add this new box to a set of the existing boxes
end





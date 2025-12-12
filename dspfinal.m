clc
clear
close all

message = input("Input Text Message:\n", "s");    % Input Message from User
fprintf(message + "\n")
asciiValues = uint8(message);
binMessage=dec2bin(asciiValues, 8);

for i = 1:length(binMessage)
end


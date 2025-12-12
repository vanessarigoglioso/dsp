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
boxes=[0 0];

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
    for n = x1:x2
        newentry=[n y];
        boxes=[boxes; newentry]
    end
end

%plotting
X=boxes(:,1);
Y=boxes(:,2);
plot(X, Y);
xlabel('X values');
ylabel('Y values');
title('Plot of boxes');
grid on;







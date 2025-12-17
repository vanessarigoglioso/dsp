%Vanessa Rigoglioso and Paco Cervantes, with help from Prof Siddhartan Govindasamy
%Notes: be sure to load the recording you would like to use before loading this code. You can change parameters as needed if the code isn't producing the message you need, but make sure it is changed both here and on other files

Fs=5000;
thresh=0.1;
idx=find(abs(recording)>thresh); %once the signal has significant fluctuations, this is approximately our start
idxstart=min(idx)-100; %move over to ensure we didn't miss anything when assigning our new start point
y=recording(idxstart: end);
sound(recording, samplerate);
figure();
plot(y); %visually check that the cropped data starts near where a wave begins to form

%now put it through a cosine
l=[0:length(y)-1]';
omega_1=2*pi*1000/Fs;
c1=cos(omega_1*l);
z1=y.*c1;
figure();
plot(z1); %visual check

%put it through a low pass filter
%minimum frequency 1/50 --> 1/5 --> pi/5
% -20 to +20,  sinc or butterworth or fir

L=201;
M=(L+1)/2;
n_vector=-M:M;
omega_M=2*pi*500/Fs;
alpha=2*500/Fs;
h=alpha*sinc(alpha*n_vector);
figure();
plot(h);

zz1=conv(z1,h,'same');
figure();
plot(zz1);
xlabel("sample");
ylabel("zz1"); %visual check

%for cross correlation, add 8 bits of known message before actual message
%because it's fixed they should be shared on both sides
%cross correlation to find delay
%xcorr
%spikes where things are aligned

%header is 'H'
%header=first 800 samples

%xcorr didn't end up working, but this is the code we were trying to use

head1='H';
asciiValues = uint8(head1); % Characters mapped to ASCII Integer Values
binHead=dec2bin(asciiValues, 8) % ASCII Integer Values mapped to 8-bit binary
width_h = 100; %50 or 100, this is a parameter that can be changed, as mentioned at start of this code
bit_header = reshape(binHead.', 1, [])
header=[ ];
for i = 1:length(bit_header)
    %x is starting and ending points of each box
    x1_h=width_h*(i-1) + 1;
    x2_h=width_h*i;
    
    if bit_header(i)=='0'
        y_h=-1;
    end
    if bit_header(i)=='1'
        y_h=1;
    end
    %now we need to add this new box to a set of the existing boxes
    for n_h = x1_h:x2_h
        newentry_h=[n_h y_h];
        header=[header; y_h];
    end
end


[r,lags]=xcorr(zz1, header);
figure();
plot(r);
flipped=1; %can either be 1 or -1, change as needed to get code to work. If we got xcorr to work, this should be set to flipped=1 initially then changed in the if statement on line 82 when the signal is flipped
[tmp, idx2]=max(abs(r));
%this if below would flip the signal if need be, but we couldn't get xcorr to work, so manually change flipped to -1 in line 79 as needed
if r(idx2+1)<0
    flipped=-1;
end
%dl=lags(idx2)+1; %delay. This line doesn't work because xcorr doesn't work
dl=110; %assigning delay -- typically between about 80 and 110, but varies. Change as needed. Use the line above instead if xcorr was woriking
zzg=flipped*zz1(dl:end); %flip
figure();
plot(zzg);
title("zz good"); %visual check, should now be facing the right way, which you can confirm because we know the first bit of 'H' is '0' which maps to -1. So graph of the wave should start here at -1


k=0; %count how many entries in a row were approximately = 0, so we know when to stop converting
step1=round(width_h/2);
recoveredbinary=[];

for step=step1:width_h:length(zzg)
     if zzg(step)<-0.001
        nextentry = 0; %entries of -1 --> 0 in binary
        k=0; %magnitude of wave big enough, we have another data entry --> reset count of k
        recoveredbinary=[recoveredbinary nextentry];
     elseif zzg(step)>0.001
        nextentry=1; %entries of 1 --> 1 in binary
        k=0; %magnitude of wave big enough, we have another data entry --> reset count of k
        recoveredbinary=[recoveredbinary nextentry]; 
       elseif abs(zzg(step))<0.001 %if close to zero, add to k
          k=k+1;
          if k>=8
              break; %once we hit 8 bits in a row  of no entries, break out of the loop. we're done
          end
     end
     %recoveredbinary=[recoveredbinary nextentry];
end
disp(recoveredbinary); %show the binary which has been decoded
%you should check for ending
%halfway=zzg(stepstart:width_h:end);
%sliced=sign(halfway);

%Now get from the binary to words
%Recall: using 8bit binary UTC
%recoveredbinary should have a length which is a multiple of 8, but this is not always completely correct.
newLength = 8 * floor(length(recoveredbinary) / 8); %round DOWN to the nearest 8
truncbin = recoveredbinary(1:newLength); %our truncated binary is the same as recoveredbinary, but now has a length multiple of 8 to make it compatible for translation to characters
binary_array_8bit = reshape(truncbin, 8, [])'; %break it up every 8 bits --> each row corresponds to exactly one character
%Convert the 8 bit strings in each row to decimal values so we can just use "bin2dec"
binary_char_array = char(binary_array_8bit + '0');  % convert 0/1 → '0'/'1'
decimal_values = bin2dec(binary_char_array);
% Convert to their corresponding characters
text_message = char(decimal_values); %this is vertical
text_message = reshape(text_message, 1, []); %makes it horizontal 
% Display the result
disp("Message with header: " + text_message);
text_message = text_message(2:end); %skip header "H"
disp("Message without header: " + text_message); %here's our recovered original message!


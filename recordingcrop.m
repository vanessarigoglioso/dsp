%try changing width to 50
Fs=5000;
thresh=0.1;
idx=find(abs(recording)>thresh);
idxstart=min(idx)-100;
y=recording(idxstart: end);
sound(recording, samplerate);
figure();
plot(y);

l=[0:length(y)-1]';
omega_1=2*pi*1000/Fs;
c1=cos(omega_1*l);
z1=y.*c1;
figure();
plot(z1);

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
ylabel("zz1");

%for cross correlation, add 8 bits of known message before actual message
%because it's fixed they should be shared on both sides
%cross correlation to find delay
%xcorr
%spikes where thingse are aligned


%header=first 800 samples
head1='H';
asciiValues = uint8(head1); % Characters mapped to ASCII Integer Values
binHead=dec2bin(asciiValues, 8) % ASCII Integer Values mapped to 8-bit binary
width_h = 100; %50 or 100
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
flipped=-1;
[tmp, idx2]=max(abs(r));
if r(idx2+1)<0
    flipped=-1;
end
%dl=lags(idx2)+1; %delay
dl=110;
zzg=flipped*zz1(dl:end);
figure();
plot(zzg);
title("zz good");


k=0;
step1=round(width_h/2);
% recovery=[];
recoveredbinary=[];

for step=step1:width_h:length(zzg)
     if zzg(step)<-0.001
        nextentry = 0;
        %rec=-1;
%         recovery=[recovery; rec];
        k=0;
        recoveredbinary=[recoveredbinary nextentry];
     elseif zzg(step)>0.001
        nextentry=1;
        %rec=1;
%         recovery=[recovery; rec];
        recoveredbinary=[recoveredbinary nextentry];
        k=0;
       elseif abs(zzg(step))<0.001
          k=k+1;
          if k>=8
              break;
          end
%         rec=0;
%         recovery=[recovery; rec];
%         if any(movsum(recovery == 0, 8) == 8)
%             break;
%         end
     end
     %recoveredbinary=[recoveredbinary nextentry];
end
disp(recoveredbinary);
%you should check for ending
%halfway=zzg(stepstart:width_h:end);
%sliced=sign(halfway);

%try getting to words

newLength = 8 * floor(length(recoveredbinary) / 8); %round down to nearest 8
truncbin = recoveredbinary(1:newLength);
binary_array_8bit = reshape(truncbin, 8, [])'; 
% 2. Convert the 8-bit binary strings in each row to decimal (ASCII) values
binary_char_array = char(binary_array_8bit + '0');  % convert 0/1 → '0'/'1'
decimal_values = bin2dec(binary_char_array);
%decimal_values = bin2dec(binary_array_8bit); 
% 3. Convert the decimal values to their corresponding characters
text_message = char(decimal_values); 
text_message = reshape(text_message, 1, []);
% Display the result
disp("Message with header: " + text_message);
text_message = text_message(2:end);
disp("Message without header: " + text_message);

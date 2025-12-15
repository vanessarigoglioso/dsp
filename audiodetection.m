%test this code
%to write audio use audioDeviceWriter("SampleRate", Fs);

samplerate=44100;
framesize=1024;
%silencethreshold=0.1; %threshold of likelihood of sound that needs to be passed for recording to start
%silencelength=3; %how long you need silence until stop recording
input=audioDeviceReader("SampleRate", samplerate, "SamplesPerFrame", framesize);

%vad=voiceActivityDetector;

recording=[];
listentime=10;
frameduration=framesize/samplerate;
time=0;
%silenceframes=0;
speechdetected=false;
disp("Listening for "+listentime+" sec");

while time<listentime
    audioFrame=input();
    %probability=vad(audioFrame); %how likely it is that sound detected in this frame
    % Start recording once speech is detected
    %if mean(probability)>silencethreshold
    %    speechdetected=true;
    %elseif speechdetected
    %    silenceframes=silenceframes+1;
    %end
    
    %if speechdetected
    %    recording=[recording; audioFrame];
    %end
    recording=[recording; audioFrame];
    time=time+frameduration;
    %drawnow;   % allows command window interaction
    %if evalin('base','exist(''stop'',''var'') && stop')
    %    disp("Stopped by user.");
    %    break;
    %end
end
release(input);
sound(recording, samplerate);
plot(recording);

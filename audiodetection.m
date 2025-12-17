%Vanessa Rigoglioso and Paco Cervantes, with help from Prof. Siddhartan Govindasamy
%Note: parameters can be changed as needed to improve accuracy, but be sure to change them in each file

samplerate=5000;
framesize=1024;
input=audioDeviceReader("SampleRate", samplerate, "SamplesPerFrame", framesize);

recording=[];
listentime=7; %change as needed, time in seconds
frameduration=framesize/samplerate;
time=0; %initialize time
disp("Listening for "+listentime+" sec");

while time<listentime
    audioFrame=input(); %input from computer microphone
    recording=[recording; audioFrame]; %add each frame to recording
    time=time+frameduration;
end
release(input);
sound(recording, samplerate); %listen back to recording for auditory check of clarity
plot(recording);

title("Plot of raw recording"); %visual check. Will be helpful for later comparisons to the plots produced in recordingcrop.m

% ******NOTE******* Be sure to save .mat file of recording in command window if the recording sounds clear enough when played, so it can be processed and converted back into a message in recordingcrop.m

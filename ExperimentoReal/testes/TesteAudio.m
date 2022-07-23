clear all;
close all;
sca; % screen close all
PsychPortAudio('Close');

PsychDefaultSetup(2);  %some default settings for setting up Psychtoolbox


InitializePsychSound(1);   %initialize Sounddriver
nrchannels = 2;      %number of channels
devs = PsychPortAudio('GetDevices');
freq = devs(1).DefaultSampleRate;
repetitions = 1;     %how many times to we wish to play the sound
pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);


% Load sound file 
% Load sound file 
sounds = cell(3, 1);
sounds(1, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number1.wav')';
sounds(2, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number2.wav')';
sounds(3, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number3.wav')';


%Arquivos
StimuliFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/';
ResultsFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/ResultadosReal/';
StimList = {'number1.wav' 'number2.wav' 'number3.wav'};


%Pre Training Loop
vet = [1 1 2 2 3 3];
rvet = randperm(6);   


%KbQueueCreate; %creates cue using defaults
%KbQueueStart;  %start recording
%FlushEvents('keyDown');  %removing the queue of events for key presses
%keyboard
GetSecs = 0;
for trial = 1:6   %runs 6 trials
    starttime=GetSecs + rand + .5;    %interval between .5 and 1.5 seconds
    %FileName = StimList{vet(rvet(trial'	))}; %select the filename for the current trial
    %Stim = audioread([ '/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/' FileName;])'; 
    PsychPortAudio('FillBuffer', pahandle, sounds{vet(rvet(trial)), 1});
    WaitSecs(starttime);
    PsychPortAudio('Start', pahandle);
    %PsychPortAudio('Start', pahandle,sounds{vet(rvet(i)), 1},starttime); %starts sound at starttime (timing should be calibrated)
    %endtime=KbWait();  %waits for a key-press
   
    %RTtext=sprintf('Response Time',endtime-starttime); %makes feedback string
    %DrawFormattedText(window,RTtext,'center'  ,'center',[255 0 255]); %shows RT
    %vbl=Screen('Flip',window); %swaps backbuffer to frontbuffer
    %Screen('Flip',window,vbl+1); %erases feedback after 1 second  
   
end     

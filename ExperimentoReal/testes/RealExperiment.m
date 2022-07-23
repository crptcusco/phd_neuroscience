%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    RealExperiment.m  August 29, 2019
%    This program displays three diferents sounds for participants to make a
%    choice response. In the blocks they press the numbers 1, 2, or 3 keys(keyboard).
%    There are 36 trials per block (10 blocks).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Real Experiment Parameters

% Clear the workspace
clear all;
close all;
sca; % screen close all
PsychPortAudio('Close');

% Enter participant number
prompt = {'Número do participante:' 'Idade:'};
dlg_title = 'Participante';
num_lines = 1;
def = {'' ''}; %default responses
answer = inputdlg(prompt,dlg_title,num_lines,def); %presents box to enter data into
switch isempty(answer)
    case 1 %deals with both cancel and X presses
        error(fail1)
    case 0
        pnumber = (answer{1});
        age = (answer{2});
end
SUBJECT = answer {1,:}; %gets subject name
baseName=[SUBJECT 'REAL']; %makes unique filename
save(baseName, 'SUBJECT','age') % save in the workspace


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Screen Setup
PsychDefaultSetup(2);  %some default settings for setting up Psychtoolbox
CompScreen = get(0,'ScreenSize');  %find out the size of this computer screen
screens = Screen('Screens');   %screen numbers
screenNumber = max(Screen('Screens'));

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it grey
[window,windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
% Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);

Screen('FillRect', window, black);
Screen('TextSize', window,28);
Screen('TextFont', window,'Courier New');
Screen('TextStyle', window, 1);

HideCursor;

KbName('UnifyKeyNames');    %compatibility of keynaming
Key1=KbName('RightArrow'); 
Key2=KbName('DownArrow');
Key3=KbName('LeftArrow');
spaceKey = KbName('space'); 
escapeKey = KbName('ESCAPE');

RestrictKeysForKbCheck([Key1 Key2 Key3 spaceKey escapeKey]); % Restrict keys 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sound Setup      
InitializePsychSound(1);   %initialize Sounddriver
nrchannels = 2;      %number of channels
devs = PsychPortAudio('GetDevices');
freq = devs(1).DefaultSampleRate;
repetitions = 1;     %how many times to we wish to play the sound
pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);
% Load sound file 
sounds = cell(3, 1);
sounds(1, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number1.wav')';
sounds(2, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number2.wav')';
sounds(3, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number3.wav')';




%PsychPortAudio('FillBuffer', pahandle, [wavedata wavedata]'); %Fill the audio playback buffer with the audio data, doubled for stereo presentation
%PsychPortAudio('Volume', pahandle, 0.5); % Set the volume to half for this demo

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RT Box Setup

rtbox = PsychRTBox('Open'); % Open connection to the first RTBox connected to any USB port on the computer. 

% Query and print all box settings inside the returned struct 'boxinfo':
boxinfo = PsychRTBox('BoxInfo', rtbox);
disp(boxinfo);

% Start response collection and recording by the box:
% This is not strictly needed here, as the box is already "started" after opening the 
% connection, but it doesn't hurt to use it. If the box is already started, this command 
% will get automatically ignored:
PsychRTBox('Start', rtbox);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial Instructions on Screen
line1 = 'SEJA BEM VINDO(A) AO EXPERIMENTO!';
line2 = '\n \n \n O objetivo deste é investigar os níveis de aquisição de habilidades';
line3 = '\n motoras e aprendizagem cortical.'
line4 = '\n \n \n \n \n \n <Aperte a tecla BARRA para continuar.>';
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels *0.30, white);

Screen('Flip', window); %flip to the screen

WaitSecs(.5);
KbWait;


% Pre Training Instructions   %presentation of the stimuli
line1 = 'Você ouvirá os números 1, 2 ou 3.';
line2 = '\n \n O dedo correspondente ao número apresentado deverá apertar a tecla';
line3= '\n referente no teclado o mais rápido possível.';
line4 = '\n \n "Número 1 para o dedo anelar."';
line5 = '\n "Número 2 para o dedo médio."';
line6 = '\n "Número 3 para o dedo indicador."';
line7 = '\n \n \n \n PRESTE MUITA ATENÇÃO!';
line8 = '\n \n \n \n \n   <Aperte a tecla BARRA para continuar.>';

DrawFormattedText(window, [line1 line2 line3 line4 line5 line6 line7 line8],...
    'center', screenYpixels *0.25, white);

Screen('Flip', window); %flip to the screen

WaitSecs(.5);
KbWait;

%Vetor com a sequência gerada pela árvore de contexto
  %load('/home/numec/Documentos/sequences');
  %load('/home/numec/Documentos/QuintSeq');
  %load('/home/numec/Documentos/seqpen');
% seq = seq_quaternary;
% seq = seq_ternary;
% seq = QuintSeq(1:4000);
 %seq = seqpen;

%Arquivos
StimuliFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/';
ResultsFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/ResultadosReal/';
StimList = {'number1.wav' 'number2.wav' 'number3.wav'};

%Pre Training Loop
vet = [1 1 2 2 3 3];
rvet = randperm(6);   
StimOrder = randperm(length(StimList));
RandomStim = StimList(StimOrder);

%function [Resp, RT] = collectResponse(varargin)
%collectResponse([waitTime],[moveOn],[allowedKeys],[KbDevice],[PTBParams])

KbQueueCreate; %creates cue using defaults
KbQueueStart;  %start recording
FlushEvents('keyDown');  %removing the queue of events for key presses
%for trial = 1:length(seq)
for trial = 1:6   %runs 6 trials
    starttime=GetSecs + rand + .5    %interval between .5 and 1.5 seconds
    FileName = RandomStim{trial}; %select the filename for the current trial
    Stim = audioread([StimuliFolder '/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/';]);
    % PsychPortAudio('FillBuffer', pahandle, sounds(:, :, seq(trial));
    PsychPortAudio('FillBuffer', pahandle, sounds(:, :, vet(rvet(trial))));
    WaitSecs(starttime);
    PsychPortAudio('Start', pahandle);
    PsychPortAudio('Start', pahandle,sounds(:, :, vet(rvet(i))),starttime); %starts sound at starttime (timing should be calibrated)
    endtime=KbWait();  %waits for a key-press
   
    RTtext=sprintf('Response Time',endtime-starttime); %makes feedback string
    DrawFormattedText(window,RTtext,'center'  ,'center',[255 0 255]); %shows RT
    vbl=Screen('Flip',window); %swaps backbuffer to frontbuffer
    Screen('Flip',window,vbl+1); %erases feedback after 1 second  
   
end     
Screen('CloseAll');
  
  %[w,rect] = Screen('OpenWindow', 0, [0 0 0]);
  %ntrials=10; %number of trials
  %r=50;       %radius of circle in pixels
  %tmin = 1;   %minimum time between trials
  %tmax = 3;   %maximum
  %rtime = zeros(1,ntrials);
  %x0=rect(3)/2;
  %y0=rect(4)/2;
  %rkey=KbName('Space');  %response key = spacebar
  %for i=1:ntrials
       %keyIsDown = 1;
       %while(keyIsDown)  %first wait until all keys are released
             %[keyIsDown, secs, keyCode] = KbCheck;
             %WaitSecs(0.001);  %delay to prevent CPU hogging
       %end
       %draw fixation point
       %Screen('FrameRect', w,[255 255 255], [x0-3,y0-3,x0+3,y0+3]);
       %Screen('Flip', w);
       %waitTime = rand * (tmax-tmin) + tmin;
       %starttime = GetSecs;
       %while(~keycode(rkey))
              %if GetSecs-starttime > waitTime
                  %waitTime = Inf;   %so as not repeat this part
                  %Screen('FillOval', w, [255 255 255], [x0-r,y0-r,x0+r,y0+r]);
                  %Screen('Flip', w);
                  %time0=GetSecs;
              %end
              %[keyIsDown,secs,keyCode] = KbCheck;
              %WaitSecs(0.001);
       %end
       %rtime(i)=secs-time0;
       %Screen('Flip',w);
  %end
  %Screen('Close',w);
  %avg_rtime = 1000*mean(rtime)   %mean reaction time in milliseconds
  
  
  
%Collect keyboard response
[keyIsDown, secs, keyCode, deltaSecs] = KbCheck([deviceNumber]); %checking which key was been pressed
KeyPressed = KbName(find(keyCode));  %finding the key that has been pressed
response=KbName(keyCode);
responsenumber=KbName(response);


press = 0;  
while 0
  [Key1, Key2, Key3] = KbCheck;
  
  if (keyIsDown)   %has a key been pressed?
      KeyPressed = KbName(find(keyCode));  %finding the key that has been pressed
      response=KbName(keyCode);
      responsenumber=KbName(response);
      
    if KeyPressed==Key1('RightArrow')
        press = Key1;
        RT = endtime - starttime; 
    elseif KeyPressed==Key2('DownArrow')
        press = Key2;
        RT = endtime - starttime; 
    elseif KeyPressed==Key3('LeftArrow')
        press = Key3;
        RT = endtime - starttime; 
      Screen ('CloseAll');
      break;
  end
end 
 
KbQueueStop;   %stop recording

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Training and Test Instructions
line1 = 'Novamente você ouvirá um número e apertará a tecla';
line2 = '\n com o dedo correspondente da mão direita.'
line3 = '\n \n "Número 1 para o dedo anelar."'
line4 = '\n "Número 2 para o dedo médio."'
line5 = '\n "Número 3 para o dedo indicador."'
line6 = '\n \n \n Agora FECHE OS OLHOS e os mantenham assim até o final.'
line7 = '\n \n Evite ao máximo qualquer movimento que nao seja o dos dedos.'
line8 = '\n \n \n PRESTE MUITA ATENÇÃO!'
line9 = '\n \n \n \n \n <Aperte a tecla BARRA para continuar.>';
DrawFormattedText(window, [line1 line2 line3 line4 line5 line6 line7 line8 line9],...
    'center', screenYpixels *0.25, white);

Screen('Flip', window); %flip to the screen

WaitSecs(.5);
KbWait;

% Training and Test Loop

% Experimental Parameters
%ErrorDelay = 1; %secs 
%interTrialInterval = .3; %secs 
%nTrialsPerBlock = 36;

% Context tree which will determine our condition combinations
    %trialorder = Shuffle(1:nTrialsPerBlock); % randomize trial order for each block

    

   
   
% Final Message
line1 = 'PARABÉNS!!!';
line2 = '\n \n O experimento chegou ao fim!'
line3 = '\n \n \n Muito obrigada pela sua participação.'
line4 = '\n \n \n \n \n <Aperte a tecla ESC para sair.>';
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels *0.35, white);

Screen('Flip', window); %flip to the screen

WaitSecs(.5);
KbWait;


SUBJECT = answer {1,:}; %gets subject name
baseName=[SUBJECT 'REAL']; %makes unique filename
save(baseName, 'SUBJECT','age') % save in the workspace
save(baseName, 'SUBJECT','age', '.m')
save(ResultsFolder, 'ResultadosReal');

PsychPortAudio('Close');  %close audiobuffer
ShowCursor;
sca; % screen close all


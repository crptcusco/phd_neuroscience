%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Real Experiment Parameters

% Clear the workspace %
clear all;
close all;
sca; % screen close all
PsychPortAudio('Close');

% Enter participant number %
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Screen Setup %
PsychDefaultSetup(2);  %some default settings for setting up Psychtoolbox
CompScreen = get(0,'ScreenSize');  %find out the size of this computer screen
screens = Screen('Screens');   %screen numbers
screenNumber = max(Screen('Screens'));

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it black %
[window,windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window in pixels %
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
% Get the centre coordinate of the window in pixels %
[xCenter, yCenter] = RectCenter(windowRect);

Screen('FillRect', window, black);
Screen('TextSize', window,28);
Screen('TextFont', window,'Courier New');
Screen('TextStyle', window, 1);

ListenChar(2); %makes it so characters typed do not show up in the command window
HideCursor;

KbName('UnifyKeyNames');    %compatibility of keynaming

activeKeys = [KbName('LeftArrow') KbName('DownArrow') KbName('RightArrow') KbName('space') KbName('ESCAPE')];

Key1 = KbName('LeftArrow');
Key2 = KbName('DownArrow');
Key3 = KbName('RightArrow');
spaceKey = KbName('space');
escapeKey = KbName('ESCAPE');

%RestrictKeysForKbCheck(activeKeys);
%RestrictKeysForKbCheck([Key1 Key2 Key3 spaceKey escapeKey]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sound Setup %    
InitializePsychSound(1);   %initialize Sounddriver
nrchannels = 2;      %number of channels
devs = PsychPortAudio('GetDevices');
freq = devs(1).DefaultSampleRate;
repetitions = 1;     %how many times to we wish to play the sound
pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);

% Load sound file %
sounds = cell(3, 1);
sounds(1, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number1.wav')';
sounds(2, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number2.wav')';
sounds(3, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number3.wav')';
for i = 1:3
	lensound(i) = length(sounds{i}(1, :)); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial Instructions on Screen %
line1 = 'SEJA BEM VINDO(A) AO EXPERIMENTO!';
line2 = '\n \n \n O objetivo deste é investigar os níveis de aquisição de habilidades';
line3 = '\n motoras e aprendizagem cortical.'
line4 = '\n \n \n \n \n \n <Aperte a tecla BARRA para continuar.>';
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels *0.30, white);
Screen('Flip', window); %flip to the screen
WaitSecs(.5);
KbWait;

% Pre Training Instructions %
line1 = 'Você ouvirá os números 1, 2 ou 3.';
line2 = '\n \n O dedo correspondente ao número apresentado deverá apertar a tecla';
line3= '\n referente no teclado o mais rápido possível.';
line4 = '\n \n "Número 1 para o dedo indicador."';
line5 = '\n "Número 2 para o dedo médio."';
line6 = '\n "Número 3 para o dedo anelar."';
line7 = '\n \n \n \n PRESTE MUITA ATENÇÃO!';
line8 = '\n \n \n \n \n   <Aperte a tecla BARRA para continuar.>';
DrawFormattedText(window, [line1 line2 line3 line4 line5 line6 line7 line8],...
    'center', screenYpixels *0.25, white);
Screen('Flip', window); %flip to the screen
WaitSecs(.5);
KbWait;

cont = 3;
contdown = fliplr(1:cont);
for k = 1:cont
Screen('TextSize', window,300);
colorChangeCounter = 0;
color = rand(1, 3);
	DrawFormattedText(window,num2str(contdown(k)),'center'  ,'center',color); 
	Screen('Flip',window); %swaps backbuffer to frontbuffer
	WaitSecs(1);
end
	DrawFormattedText(window,'   ','center'  ,'center',[255 0 255]); 
	Screen('Flip',window); %swaps backbuffer to frontbuffer


% Arquivos %
StimuliFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/';
ResultsFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/ResultadosReal/';
StimList = {'number1.wav' 'number2.wav' 'number3.wav'};


% RT Box Setup - CEDRUS RESPONSE BOX %


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pre Training Loop %
vet = [1 1 2 2 3 3];
rvet = randperm(6);   
rt = [];
response = [];


for trial = 1:6   %runs 6 trials
    starttime= (rand/2) + .5;    %interval between .5 and 1.5 seconds 
    baseRect = [0 0 20 20];
    maxDiameter = max(baseRect) * 1.01;
    centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
    rectColor = [255 0 255];
    Screen('FillOval', window, rectColor, centeredRect, maxDiameter);
    Screen('Flip', window);
    PsychPortAudio('FillBuffer', pahandle, sounds{vet(rvet(trial)), 1});
    PsychPortAudio('Start', pahandle);
    WaitSecs((length(sounds{vet(rvet(trial)), :}(1, :)))/freq);
    s = GetSecs;
    endtime=KbWait();  %waits for a key-press
    
    respToBeMade = true;
    while respToBeMade == true
	[keyIsDown, secs, keyCode] = KbCheck;
 	if keyCode(escapeKey)
     	    ShowCursor;
     	    sca;
     	    return
	%if any(keyCode(activeKeys))
	%	rt = [rt endtime-s];
	%	keyResp = find(keyCode);
        elseif keyCode(Key1)
     		keyResp(1) = '1';
     		respToBeMade = false;
 	elseif keyCode(Key2) 
    		keyResp(2) = '2';
     		respToBeMade = false;
	elseif keyCode(Key3)
     		keyResp(3) = '3';
     		respToBeMade = false;   	
	end
     end
    
     rt = [rt endtime-s]
     RT = rt'
     KbReleaseWait();
     keyResp = keyCode(activeKeys);
%response = KbName(keyCode);
     response = [response;[keyResp]]; 
	
     Screen('TextSize', window,28);
     WaitSecs(starttime);
end   


beepLengthSecs = 1; % Length of the beep
beepPauseTime = 1; % Length of the pause between beeps
startCue = 0; % Start immediately (0 = immediately)
waitForDeviceStart = 1; % Should we wait for the device to really start (1 = yes)
PsychPortAudio('Volume', pahandle, 0.5); % Set the volume to half for this demo
myBeep = MakeBeep(500, beepLengthSecs, freq); % Make a beep which we will play back to the user
PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);
PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
[actualStartTime, ~, ~, estStopTime] = PsychPortAudio('Stop', pahandle, 1, 1); % Wait for the beep to end.
startCue = estStopTime + beepPauseTime; % Compute new start time for follow-up beep, beepPauseTime after end of previous one
PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
PsychPortAudio('Stop', pahandle, 1, 1);

avg = [];
avg = mean(rt); 
AVGtext= ['Média RT  ' num2str(avg)];
DrawFormattedText(window,AVGtext,'center'  ,'center',[255 0 255]); %shows avg
Screen('Flip', window);
%vbl=Screen('Flip',window); %swaps backbuffer to frontbuffer
%Screen('Flip',window,vbl+2); %erases feedback after 1 second  
KbWait;
  
% Final Message %
Screen('TextSize', window,28);
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
save(baseName, 'SUBJECT', 'age', 'vet', 'rvet', 'response', 'RT', 'avg'); 
%CedrusResponseBox(‘Close’, handle);
%CedrusResponseBox(‘CloseAll’);
PsychPortAudio('Close');  %close audiobuffer
ListenChar(0);
ShowCursor;
sca;

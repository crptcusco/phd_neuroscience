% Real Experiment Parameters

% Clear the workspace
clear all;
close all;
sca; % screen close all
PsychPortAudio('Close');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Screen Setup
PsychDefaultSetup(2);  %some default settings for setting up Psychtoolbox
CompScreen = get(0,'ScreenSize');  %find out the size of this computer screen
screens = Screen('Screens');   %screen numbers
screenNumber = max(Screen('Screens'));

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it black
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
Key1=KbName('LeftArrow'); 
Key2=KbName('DownArrow');
Key3=KbName('RightArrow');
spaceKey = KbName('space'); 
escapeKey = KbName('ESCAPE');

RestrictKeysForKbCheck([Key1 Key2 Key3 spaceKey escapeKey]); % Restrict keys 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


%PsychPortAudio('FillBuffer', pahandle, [wavedata wavedata]'); %Fill the audio playback buffer with the audio data, doubled for stereo presentation
%PsychPortAudio('Volume', pahandle, 0.5); % Set the volume to half for this demo


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
	DrawFormattedText(window,num2str(contdown(k)),'center'  ,'center',color); %shows RT
	Screen('Flip',window); %swaps backbuffer to frontbuffer
	WaitSecs(1);
end
	DrawFormattedText(window,'   ','center'  ,'center',[255 0 255]); %shows RT
	Screen('Flip',window); %swaps backbuffer to frontbuffer



%Arquivos %

StimuliFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/';
ResultsFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/ResultadosReal/';
StimList = {'number1.wav' 'number2.wav' 'number3.wav'};


%Pre Training Loop %
vet = [1 1 2 2 3 3];
rvet = randperm(6);   


%KbQueueCreate; %creates cue using defaults
%KbQueueStart;  %start recording
%FlushEvents('keyDown');  %removing the queue of events for key presses


for trial = 1:6   %runs 6 trials
    starttime= (rand/2) + .5;    %interval between .5 and 1.5 seconds
    %FileName = StimList{vet(rvet(trial'	))}; %select the filename for the current trial
    %Stim = audioread([ '/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/' FileName;])'; 
    PsychPortAudio('FillBuffer', pahandle, sounds{vet(rvet(trial)), 1});   
    PsychPortAudio('Start', pahandle);
    WaitSecs((length(sounds{vet(rvet(trial)), :}(1, :)))/freq);
    s = GetSecs;
    %PsychPortAudio('Start', pahandle,sounds{vet(rvet(i)), 1},starttime); %starts sound at starttime (timing should be calibrated)
    endtime=KbWait();  %waits for a key-press
    Screen('TextSize', window,28);
    Screen('TextSize', window,28);
    RTtext= ['Response Time   ' num2str(endtime-s)]; %makes feedback string
    DrawFormattedText(window,RTtext,'center'  ,'center',[255 0 255]); %shows RT
    vbl=Screen('Flip',window); %swaps backbuffer to frontbuffer
    Screen('Flip',window,vbl+2); %erases feedback after 1 second  
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


respToBeMade = true;
	[keyIsDown, secs, keyCode] = KbCheck;
	WaitSecs(0.5);
	while respToBeMade
		[keyIsDown,secs, keyCode] = KbCheck;
		if keyCode(Key1)
			KbReleaseWait;
			WaitSecs(0.5);
		return
		elseif keyCode(Key2)
			KbReleaseWait;
			WaitSecs(0.5);
			PsychPortAudio('FillBuffer', pahandle, somtst(:, :,tstvet(1))*0.031627);	
			PsychPortAudio('Start', pahandle);
			[keyIsDown, secs, keyCode] = KbCheck;
		elseif keyCode(Key3)
			KbReleaseWait;
			WaitSecs(0.5);
		end
	end

%[keyIsDown, secs, keyCode] = KbCheck([1]); %checking which key was been pressed
%KeyPressed = KbName(find(keyCode));  %finding the key that has been pressed
%response=KbName(keyCode);
%responsenumber=KbName(response);

% Training and Test Instructions %
Screen('TextSize', window,28);
line1 = 'Novamente você ouvirá um número e apertará a tecla';
line2 = '\n com o dedo correspondente da mão direita.'
line3 = '\n \n "Número 1 para o dedo indicador."'
line4 = '\n "Número 2 para o dedo médio."'
line5 = '\n "Número 3 para o dedo anelar."'
line6 = '\n \n \n Agora FECHE OS OLHOS e os mantenham assim até o final.'
line7 = '\n \n Evite ao máximo qualquer movimento que nao seja o dos dedos.'
line8 = '\n \n \n PRESTE MUITA ATENÇÃO!'
line9 = '\n \n \n \n \n <Aperte a tecla BARRA para continuar.>';
DrawFormattedText(window, [line1 line2 line3 line4 line5 line6 line7 line8 line9],...
    'center', screenYpixels *0.25, white);

Screen('Flip', window); %flip to the screen

WaitSecs(.5);
KbWait;

% Training/Test Loop %



                                
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
   
% Final Message %
line1 = 'PARABÉNS!!!';
line2 = '\n \n O experimento chegou ao fim!'
line3 = '\n \n \n Muito obrigada pela sua participação.'
line4 = '\n \n \n \n \n <Aperte a tecla ESC para sair.>';
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels *0.35, white);

Screen('Flip', window); %flip to the screen

WaitSecs(.5);
KbWait;


%SUBJECT = answer {1,:}; %gets subject name
%baseName=[SUBJECT 'REAL']; %makes unique filename
%save(baseName, 'SUBJECT','age') % save in the workspace



PsychPortAudio('Close');  %close audiobuffer
ShowCursor;
sca; % screen close all


% Clear the workspace %
clear all;
close all;
sca; 
PsychPortAudio('Close');

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

RestrictKeysForKbCheck(activeKeys);

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
disp(size(sounds{1, 1}))
sounds(2, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number2.wav')';
sounds(3, 1) = audioread('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/number3.wav')';
for i = 1:3
	lensound(i) = length(sounds{i}(1, :)); 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initial Instructions on Screen %
line1 = 'SEJA BEM VINDO(A) AO EXPERIMENTO!';
line2 = '\n \n \n O objetivo deste é investigar os níveis de aquisição de habilidades';
line3 = '\n motoras e aprendizagem cortical.';
line4 = '\n \n \n \n \n \n <Aperte a tecla BARRA para continuar>';
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels *0.30, white);
Screen('Flip', window); 
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
line8 = '\n \n \n \n \n   <Aperte a tecla BARRA para continuar>';
DrawFormattedText(window, [line1 line2 line3 line4 line5 line6 line7 line8],...
    'center', screenYpixels *0.25, white);
Screen('Flip', window); 
WaitSecs(.5);
KbWait;

cont = 3;
contdown = fliplr(1:cont);
for k = 1:cont
	Screen('TextSize', window,300);
	colorChangeCounter = 0;
	color = rand(1, 3);				  	 DrawFormattedText(window,num2str(contdown(k)),'center'  ,'center',color); 
	Screen('Flip',window); 
	WaitSecs(1);
end
	DrawFormattedText(window,'   ','center'  ,'center',[255 0 255]); 
	Screen('Flip',window); 

% Arquivos %
%StimuliFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/';
%ResultsFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/ResultadosReal/';
%StimList = {'number1.wav' 'number2.wav' 'number3.wav'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pre Training Loop %
vet = [1 1 2 2 3 3];
seq = randperm(6); 
rt1 = zeros(1, length(seq))-1; %tempo de resposta (tempo de reação)
response = cell(1, length(seq)); %tecla respondida
antecipatedresponse = []; %resposta antecipada
beepLengthSecs = 1;
PsychPortAudio('Volume', pahandle, 0.5);
Beep = MakeBeep(500, beepLengthSecs, freq);
SBeep = [Beep; Beep];

%ponto rosa no centro da tela
baseRect = [0 0 20 20];
maxDiameter = max(baseRect) * 1.01;
centeredRect = CenterRectOnPointd(baseRect, xCenter, yCenter);
rectColor = [255 0 255];

% Fernando code

RespNames = {'LeftArrow', 'DownArrow', 'RightArrow'};
trial = 0;
while trial <= length(seq)   %run 6 trials
	trial = trial +1;
    	Screen('FillOval', window, rectColor, centeredRect, maxDiameter);
    	Screen('Flip', window); %flipa a bolinha na tela
    	KbReleaseWait();
    	keyIsDown = 0;
    	respToBeMade = true;
    	if trial ~= 1 
		antecip = true;
		FlushEvents('keyDown');  %limpa as teclas apertadas anteriormente
		antecipTime = GetSecs;
		while antecip  %se antecipar a resposta
			KeyDown = KbCheck;
			if KeyDown == 1  
				PsychPortAudio('FillBuffer', pahandle, SBeep);
				PsychPortAudio('Start', pahandle); % soa um beep
				antecipatedresponse = [antecipatedresponse find(not(cellfun('isempty',strfind(RespNames,KbName(find(keyCode))))))]; %descobre a tecla apertada e marca como vazio
				WaitSecs(1);
				trial = trial +1; %passa para o próximo trial
				antecip = false; 
			end
			testSecs = GetSecs
			if testSecs - antecipTime >= 0.5  % se for num tempo maior ou igual a 50ms, não ocorreu antecipação
			antecip = false;
			end
		end
	end
		PsychPortAudio('FillBuffer', pahandle, sounds{vet(seq(trial)), 1});
     		PsychPortAudio('Start', pahandle); %libera o estímulo
     		WaitSecs((length(sounds{vet(seq(trial)), :}(1, :)))/freq);
     		startTime = GetSecs; % get the time stamp at the start of waiting for key input 
     		FlushEvents('keyDown');
     		KbReleaseWait();
     		[secs, keyCode, deltaSecs] = KbWait;

     		acerto = false;
     		while ~acerto
			KeyNumber = find(not(cellfun('isempty',strfind(RespNames,KbName(find(keyCode))))));
	     		response{trial} = [response{trial} KeyNumber];
			if KeyNumber == vet(seq(trial))
				endtime = GetSecs;
				rt1(trial) = endtime-startTime; %tempo de reação
	 		acerto = true;
			else 
		        	FlushEvents('keyDown');
 		        	KbReleaseWait();
  		        	[secs, keyCode, deltaSecs] = KbWait;
			end
     		end 
end 
	
	WaitSecs(0.1);
	beepLengthSecs = 1; % Length of the beep
	beepPauseTime = 1; % Length of the pause between beeps
	startCue = 0; % Start immediately (0 = immediately)
	waitForDeviceStart = 1; % Should we wait for the device to really start (1 = yes)
	PsychPortAudio('Volume', pahandle, 0.5); % Set the volume to half for this demo
	myBeep = MakeBeep(500, beepLengthSecs, freq); % Make a beep which we will play back to the user
	PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);
	PsychPortAudio('Start', pahandle, repetitions, startCue, 	waitForDeviceStart);
	[actualStartTime, ~, ~, estStopTime] = PsychPortAudio('Stop', pahandle, 1, 1); % Wait for the beep to end.
	startCue = estStopTime + beepPauseTime; % Compute new start time for follow-up beep, beepPauseTime after end of previous one
	PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
	PsychPortAudio('Stop', pahandle, 1, 1);

	avg = [];
	avg = mean(rt1);
	Screen('TextSize', window,28);  
	AVGtext= ['Média Tempo de Reação  ' num2str(avg)];
	DrawFormattedText(window,AVGtext,'center'  ,'center',[255 0 255]);
	vbl = Screen('Flip', window); 
	WaitSecs(5);
   

% Final Message %
Screen('TextSize', window,28);
line1 = 'PARABÉNS!!!';
line2 = '\n \n O experimento chegou ao fim!';
line3 = '\n \n \n Muito obrigada pela sua participação.';
line4 = '\n \n \n \n \n <Aperte a tecla ESC para sair>';
DrawFormattedText(window, [line1 line2 line3 line4],...
    'center', screenYpixels *0.35, white);
Screen('Flip', window); 
WaitSecs(.5);
KbWait;

baseName=['REAL']; %makes unique filename
save(baseName, 'vet', 'seq', 'response', 'rt1', 'antecipatedresponse', 'avg'); 
PsychPortAudio('Close');  
ListenChar(1);
ShowCursor;
sca;

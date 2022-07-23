clear all;
close all;
sca; % screen close all
PsychPortAudio('Close');

KbName('UnifyKeyNames');    %compatibility of keynaming

activeKeys = [KbName('LeftArrow') KbName('DownArrow') KbName('RightArrow') KbName('space') KbName('ESCAPE')];

Key1 = KbName('LeftArrow');
Key2 = KbName('DownArrow');
Key3 = KbName('RightArrow');
spaceKey = KbName('space');
escapeKey = KbName('ESCAPE');

RestrictKeysForKbCheck(activeKeys);

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

vet = [1 1 2 2 3 3];
rvet = randperm(6); 
rt1 = zeros(1, length(rvet))-1; %tempo de resposta
response = cell(1, length(rvet)); %tecla respondida
antecipatedresponse = [];
beepLengthSecs = 1;
PsychPortAudio('Volume', pahandle, 0.5);
Beep = MakeBeep(500, beepLengthSecs, freq);
SBeep = [Beep; Beep];


% Fernando code

RespNames = {'LeftArrow', 'DownArrow', 'RightArrow'};
trial = 0;
while trial <= length(rvet)   %runs 6 trials
    trial = trial +1;
%    Screen('FillOval', window, rectColor, centeredRect, maxDiameter);
%    Screen('Flip', window); 
    KbReleaseWait();
    keyIsDown = 0;
    respToBeMade = true;
    if trial ~= 1
	antecip = true;
	FlushEvents('keyDown');
	antecipTime = GetSecs;
	while antecip
		KeyDown = KbCheck;
		if KeyDown == 1
			PsychPortAudio('FillBuffer', pahandle, SBeep);
			PsychPortAudio('Start', pahandle);
			antecipatedresponse = [antecipatedresponse find(not(cellfun('isempty',strfind(RespNames,KbName(find(keyCode))))))];
			WaitSecs(1);
			trial = trial +1;
			antecip = false;
		end
		testSecs = GetSecs
		if testSecs - antecipTime >= 0.5
			antecip = false;
		end
	end
    end
     PsychPortAudio('FillBuffer', pahandle, sounds{vet(rvet(trial)), 1});
     PsychPortAudio('Start', pahandle);
     WaitSecs((length(sounds{vet(rvet(trial)), :}(1, :)))/freq);
     startTime = GetSecs; % get the time stamp at the start of waiting for key input 
     FlushEvents('keyDown');
     KbReleaseWait();
     [secs, keyCode, deltaSecs] = KbWait;

     acerto = false;
     while ~acerto
	     KeyNumber = find(not(cellfun('isempty',strfind(RespNames,KbName(find(keyCode))))));
	     response{trial} = [response{trial} KeyNumber];
	     if KeyNumber == vet(rvet(trial))
			endtime = GetSecs;
			rt1(trial) = endtime-startTime;
	 		acerto = true;
	     else 
		        FlushEvents('keyDown');
 		        KbReleaseWait();
  		        [secs, keyCode, deltaSecs] = KbWait;
	     end
      end
end

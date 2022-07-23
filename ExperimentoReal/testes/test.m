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



% Vetor com a sequência gerada pela árvore de contexto %
seq = load('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sequences/X1.csv');
%seq = load('/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sequences/X2.csv');

seq = seq+1;
rt2 = zeros(1, length(seq))-1; %tempo de resposta
responseTeste = cell(1, length(seq)); %tecla respondida
antecipatedresponse = [];

beepLengthSecs = 1;
PsychPortAudio('Volume', pahandle, 0.5);
Beep = MakeBeep(500, beepLengthSecs, freq);
SBeep = [Beep; Beep];

RespNames = {'LeftArrow', 'DownArrow', 'RightArrow'};

		
for bloco = 1:2;
	WaitSecs(2);
  t = (1+(bloco-1)*150:bloco*150);
	
trial = 0; 
    while trial <= length(btrial)   %150 trials
    		trial = trial +1;
%    		Screen('FillOval', window, rectColor, centeredRect, maxDiameter);
%    		Screen('Flip', window); 
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
	PsychPortAudio('FillBuffer', pahandle, sounds{(seq(trial)), 1});
     	PsychPortAudio('Start', pahandle);
 	WaitSecs(lensound(seq(trial))/freq);
     	startTime = GetSecs; % get the time stamp at the start of waiting for key input 
     	FlushEvents('keyDown');
     	KbReleaseWait();
     	[secs, keyCode, deltaSecs] = KbWait;

     	acerto = false;
	while ~acerto
		KeyNumber = find(not(cellfun('isempty',strfind(RespNames,KbName(find(keyCode))))));
	     	responseTeste{trial} = [responseTeste{trial} KeyNumber];
		if KeyNumber == (seq(trial))
			endtime = GetSecs;
			rt2(trial) = endtime-startTime;
	 		acerto = true;
		else 
		        FlushEvents('keyDown');
 		        KbReleaseWait();
  		        [secs, keyCode, deltaSecs] = KbWait;
		end
	end
    end
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

end

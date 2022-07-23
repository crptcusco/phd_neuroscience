%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ChoiceRT.m   YVJ     Feb 18, 2009 Revised Feb 27, 2016
%   This program displays a red or a blue star for participants to make a
%   choice response. In some blocks they click the left or right side of
%   the mouse in response to the color of the star. In other blocks they
%   press the left or right arrow keys. There are 10 trials per block
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Experimental parameters
clear all;
rand('state', sum(100*clock)); 
Screen('Preference', 'SkipSyncTests', 1);

ErrorDelay=1; interTrialInterval = .5; nTrialsPerBlock = 10; 

KbName('UnifyKeyNames');
Key1=KbName('LeftArrow'); Key2=KbName('RightArrow');
spaceKey = KbName('space'); escKey = KbName('ESCAPE');
corrkey = [80, 79]; % left and right arrow
gray = [127 127 127 ]; white = [ 255 255 255]; black = [ 0 0 0];
bgcolor = white; textcolor = black;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sound feedback
BeepFreq = [800 1300 2000]; BeepDur = [.1 .1 .1];
Beep1 = MakeBeep(BeepFreq(1), BeepDur(1));
Beep2 = MakeBeep(BeepFreq(2), BeepDur(2));
Beep3 = MakeBeep(BeepFreq(3), BeepDur(3));
Beep4 = [Beep1 Beep2 Beep3];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Login prompt and open file for writing data out
prompt = {'Outputfile', 'Subject''s number:', 'age', 'gender', 'group', 'Num of Blocks'};
defaults = {'ChoiceRT', '98', '18', 'F', 'control' , '8'};
answer = inputdlg(prompt, 'ChoiceRT', 2, defaults);
[output, subid, subage, gender, group, nBlocks] = deal(answer{:}); % all input variables are strings
outputname = [output gender subid group subage '.xls'];
nblocks = str2num(nBlocks); % convert string to number for subsequent reference

if exist(outputname)==2 % check to avoid overiding an existing file
    fileproblem = input('That file already exists! Append a .x (1), overwrite (2), or break (3/default)?');
    if isempty(fileproblem) | fileproblem==3
        return;
    elseif fileproblem==1
        outputname = [outputname '.x'];
    end
end
outfile = fopen(outputname,'w'); % open a file for writing data out
fprintf(outfile, 'subid\t subage\t gender\t group\t keyboardOrMouse\t blockNumber\t trialNumber\t redOrBlue\t accuracy\t ReactionTime\t \n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Screen parameters
[mainwin, screenrect] = Screen(0, 'OpenWindow');
Screen('FillRect', mainwin, bgcolor);
center = [screenrect(3)/2 screenrect(4)/2];
Screen(mainwin, 'Flip');

%   load images
im = imread('redStar.jpg'); redStar = Screen('MakeTexture', mainwin, im);
im = imread('blueStar.jpg'); blueStar = Screen('MakeTexture', mainwin, im);

%   potential locations to place the star.
nrow = 6; ncolumn = 6; cellsize = 100;
for ncells = 1:nrow.*ncolumn
    xnum = (mod(ncells-1, ncolumn)+1)-3.5;
    ynum = ceil(ncells/nrow)-3.5;
    cellcenter(ncells,1) = center(1)+xnum.*cellsize;
    cellcenter(ncells,2) = center(2)+ynum.*cellsize;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Experimental instructions, wait for a spacebar response to start
Screen('FillRect', mainwin ,bgcolor);
Screen('TextSize', mainwin, 24);
Screen('DrawText',mainwin,['Report the color of the star. Press spacebar to start the experiment.'] ,center(1)-350,center(2)-20,textcolor);
Screen('Flip',mainwin );

keyIsDown=0;
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            break ;
        elseif keyCode(escKey)
            ShowCursor;
            fclose(outfile);
            Screen('CloseAll');
            return;
        end
    end
end
WaitSecs(0.3);

% counterbalance the order of keyboard and mouse responses for even and odd numbered participants
if mod(str2num(subid),2)==0
    firstblock=1;  
else
    firstblock=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Block loop

for a = 1:str2num(nBlocks)
    Screen('FillRect', mainwin, bgcolor);
    Screen('TextSize', mainwin, 24);
    
    if mod(a,2)==firstblock
        blocktype = 'keyboard';
        Screen('DrawText', mainwin, ['Keyboard response: left arrow for red, right arrow for blue'], center(1)-300, center(2)+130, textcolor);
        
    else
        blocktype = 'mouse';
        Screen('DrawText', mainwin, ['Mouse response: left click for red, right click for blue'], center(1)-300, center(2)+130, textcolor);
    end
    Screen('DrawText', mainwin, ['Click to start'], center(1)-300, center(2)+30, textcolor);
    Screen('Flip', mainwin);
    GetClicks;
    WaitSecs(1);
    
    trialorder = Shuffle(1:nTrialsPerBlock); % randomize trial order for each block
    
    % trial loop
    for i = 1:nTrialsPerBlock;
        cellindex = Shuffle(1:nrow.*ncolumn); % randomize the position of the star within the grid specified earlier
        itemloc = [cellcenter(cellindex(1),1)-cellsize/2, cellcenter(cellindex(1),2)-cellsize/2, cellcenter(cellindex(1),1)+cellsize/2, cellcenter(cellindex(1),2)+cellsize/2];
        Screen('FillRect', mainwin ,bgcolor);
        
        % present the stimulus
        if mod(trialorder(i),2)==0
            Screen('DrawTexture', mainwin, redStar, [], itemloc);
            answer=1;
        else
            Screen('DrawTexture', mainwin, blueStar, [], itemloc);
            answer=2;
        end
        
        Screen('Flip', mainwin); % must flip for the stimulus to show up on the mainwin
        %ShowCursor('hand');
        
        
        % now record  response
        timeStart = GetSecs;keyIsDown=0; correct=0; rt=0;
        
        if mod(a,2)~=firstblock %% mouse response
           [clicks,w,x,yhichButton]=GetClicks([],0,[]);
            rt=1000.*(GetSecs-timeStart);
            Screen('Flip', mainwin);
            if (whichButton==answer)
                correct=1;Snd('Play', Beep4);
            else
                correct=0;Snd('Play', Beep1); WaitSecs(ErrorDelay);
            end
            Screen('Flip', mainwin);
        else  %% keyboard response
            while 1
                [keyIsDown, secs, keyCode] = KbCheck;
                FlushEvents('keyDown');
                if keyIsDown
                    nKeys = sum(keyCode);
                    if nKeys==1
                        if keyCode(Key1)||keyCode(Key2)
                            rt = 1000.*(GetSecs-timeStart);
                            keypressed=find(keyCode);
                            Screen('Flip', mainwin);
                            break;
                        elseif keyCode(escKey)
                            ShowCursor; fclose(outfile);  Screen('CloseAll'); return
                        end
                        keyIsDown=0; keyCode=0;
                    end
                end
            end
            if (keypressed==corrkey(1)&&answer==1)||(keypressed==corrkey(2)&&answer==2)
                correct=1;Snd('Play', Beep4);
            else
                correct=0; Snd('Play', Beep1); WaitSecs(ErrorDelay);
            end
        end
        
        Screen('FillRect', mainwin ,bgcolor); Screen('Flip', mainwin);
        
        % write data out
        fprintf(outfile, '%s\t %s\t %s\t %s\t %s\t %d\t %d\t %d\t %d\t %6.2f\t \n', subid, ...,
            subage, gender, group, blocktype, a, i, answer, correct, rt);
        WaitSecs(interTrialInterval);
    end  % end of trial loop
end % end of block loop

Screen('CloseAll');
fclose(outfile);
fprintf('\n\n\n\n\nFINISHED this part! PLEASE GET THE EXPERIMENTER...\n\n');




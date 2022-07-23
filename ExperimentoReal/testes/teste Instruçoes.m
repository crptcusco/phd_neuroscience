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

StimuliFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/Sounds/';
ResultsFolder ='/home/patricia/Desktop/ExperimentoReal/ExperimentoReal/ResultadosReal/';
StimList = {'number1.wav' 'number2.wav' 'number3.wav'};

% Screen Setup

PsychDefaultSetup(2);  %some default settings for setting up Psychtoolbox
CompScreen = get(0,'ScreenSize');  %find out the size of this computer screen
screens = Screen('Screens');   %screen numbers
screenNumber = max(Screen('Screens'));

white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey= white / 2;

% Open an on screen window and color it grey
[window,windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
% Get the centre coordinate of the window in pixels
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
line8 = '\n \n \n \n \n    <Aperte a tecla BARRA para continuar.>';

DrawFormattedText(window, [line1 line2 line3 line4 line5 line6 line7 line8],...
    'center', screenYpixels *0.25, white);

Screen('Flip', window); %flip to the screen

WaitSecs(.5);
KbWait;

% Randomly seed the random number generation
vet = [10 9 8 7 6 5 4 3 2 1];
rvet = randperm(10);   

% We set the text size to be nice and big here
Screen('TextSize', window, 300);
nominalFrameRate = Screen('NominalFrameRate', window);
presSecs = [sort(repmat(1:10, 1, nominalFrameRate), 'descend') 0];

% We change the color of the number every "nominalFrameRate" frames
colorChangeCounter = 0;

% Randomise a start color
color = rand(1, 3);

% Here is our drawing loop
for i = 1:length(presSecs)

    % Convert our current number to display into a string
    numberString = num2str(presSecs(i));

    % Draw our number to the screen
    DrawFormattedText(window, numberString, 'center', 'center', color);

    % Flip to the screen
    Screen('Flip', window);

    % Decide if to change the color on the next frame
    colorChangeCounter = colorChangeCounter + 1;
    if colorChangeCounter == nominalFrameRate
        color = rand(1, 3);
        colorChangeCounter = 0;
    end

end

% Wait a second before closing the screen
WaitSecs(1);
     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Training and Test Instructions
Screen('TextSize', window,28);      
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
    
ShowCursor;
sca; % screen close all  

 %% PsychToolBox parameters

    % screen Preferences
    Screen('Preference', 'VBLTimestampingMode', 3);%Add this to avoid timestamping problems
    Screen('Preference', 'DefaultFontName', 'Geneva');
    Screen('Preference', 'DefaultFontSize', 30); %fontsize
    Screen('Preference', 'DefaultFontStyle', 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend,1+2=bold and italic.
    Screen('Preference', 'DefaultTextYPositionIsBaseline', 1); % align text on a line 
    
    % Colors definition
    white = [255 255 255]; 
    black = [0 0 0]; 
    red= [255 0 0]; 
    
    % Start PsychToolBox
    screens=Screen('Screens');
    Screen('Preference', 'SkipSyncTests', 2);
    screenNumber=max(screens); % Main screen
    [win,winRect] = Screen('OpenWindow',screenNumber,black); 
    HideCursor;


%% Coordinates
    % Size of stimuli
    xstim = 125; % from the stimuli files
    ystim = 125; % from the stimuli files 
    % Center location
    [xc, yc] = RectCenterd(winRect); % Get coordinates of screen center 
    xcPourEuro = xc - xstim/2-50;
    ycPourEuro = yc - ystim;
    xcPourMark = xc-15;
    ycPourMark = yc + ystim;
    ycObsMark = yc - ystim;
    % Distance between center and stimuli 
    decalageX = 300;
    decalageY = -250;
    % Rectangles definition
    rectCentre = [xc-xstim/2, yc-ystim/2, xc-xstim/2, yc-ystim/2];
    rectStim = [0, 0, xstim, ystim] + rectCentre; %specify position of stimuli square
    rectFeed = [0, decalageY, xstim, ystim+decalageY] + rectCentre; %specify the position of the feedback square
    rectDecalageX = [decalageX, 0, decalageX, 0]; % Translation on the x axis (300 0 300 0)
    rectDecalageY = [0, decalageY, 0, decalageY]; % Translation on the x axis (300 0 300 0)

    screenshotrect = [xc-xc/2, yc-yc/2+decalageY/2, xc+xc/2, yc+yc/2+decalageY/2];
    
%% keyboard parameters
    KbName('UnifyKeyNames'); % Use same key codes across operating systems for better portability % usa questo
    
%% loading exp images (supposed to be in the same directory as the script)
%Load images
Lose=imread(fullfile('Stimfiles', 'Lose.png')); 
texLose = Screen('MakeTexture', win, Lose);
Win=imread(fullfile('Stimfiles', 'Win.png')); 
texWin = Screen('MakeTexture', win, Win);
Play=imread(fullfile('Stimfiles', 'Play.png')); 
texPlay = Screen('MakeTexture', win, Play);
Pause=imread(fullfile('Stimfiles', 'Pause.png')); 
texPause = Screen('MakeTexture', win, Pause);

%% loading stimulus images
%stim_A{1}=uint8(imread(fullfile('Stimfiles', 'Stim111.bmp'))); % allocate/order stimuli  #session #pair(randomized) #stim(randomized between 1 and 2)
%texStim_A{1}=Screen('MakeTexture', win, stim_A{1});
        
%stim_B{1}=uint8(imread(fullfile('Stimfiles', 'Stim112.bmp'))); % allocate/order stimuli  #session #pair(randomized) #stim(randomized between 1 and 2)
%texStim_B{1}=Screen('MakeTexture', win, stim_B{1});

% ========= DISPLAY FUNCTIONS  ========= %

 %% PTB parameters

    % Screen Preferences
    Screen('Preference', 'VBLTimestampingMode', 3);%Add this to avoid timestamping problems
    Screen('Preference', 'DefaultFontName', 'Geneva');
    Screen('Preference', 'DefaultFontSize', 30); %fontsize
    Screen('Preference', 'DefaultFontStyle', 0); % 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend,1+2=bold and italic.
    Screen('Preference', 'DefaultTextYPositionIsBaseline', 1); % align text on a line 
    
    % Colors definition
    white = [255 255 255]; 
    black = [0 0 0]; 
    red= [255 0 0]; 
    
    % Start PTB
    screens=Screen('Screens');
    Screen('Preference', 'SkipSyncTests', 2);
    screenNumber=max(screens); % Main screen
    [win,winRect] = Screen('OpenWindow',screenNumber,black);
    winRect = [0,0,800,600];
    HideCursor;


%% Coordinates
    [xc, yc] = RectCenterd(winRect);    %Get coordinates of screen center 
    xOffsetLeft = xc+300;               %for left image
    xOffsetRight = xc-300;              %for right image
    yOffset = 450;
    
%% keyboard parameters
    KbName('UnifyKeyNames'); % Use same key codes across operating systems for better portability % usa questo
    
%% Load images

    Lose=imread(fullfile('Stimfiles', 'Lose.png')); 
    texLose = Screen('MakeTexture', win, Lose);
    Win=imread(fullfile('Stimfiles', 'Win.png')); 
    texWin = Screen('MakeTexture', win, Win);
    Play=imread(fullfile('Stimfiles', 'Play.png')); 
    texPlay = Screen('MakeTexture', win, Play);
    Pause=imread(fullfile('Stimfiles', 'Pause.png')); 
    texPause = Screen('MakeTexture', win, Pause);

    [imagePlayHeight, imagePlayWidth, colorChannels]= size(Play);
    [imagePauseHeight, imagePauseWidth, colorChannels]= size(Pause);
    [imageLoseHeight, imageLoseWidth, colorChannels]= size(Lose);
    [imageWinHeight, imageWinWidth, colorChannels]= size(Win);
    
    %Position play_pause
    imagePlayPauseRectLeft = [xOffsetLeft, yOffset, xOffsetLeft+imagePlayWidth, yOffset+imagePlayHeight];
    imagePlayPauseRectRight = [xOffsetRight, yOffset, xOffsetRight+imagePauseWidth, yOffset+imagePauseHeight];
    Screen('DrawTexture', win, texPlay,[],imagePlayPauseRectLeft);
    Screen('DrawTexture', win, texPause,[],imagePlayPauseRectRight);
    Screen('Flip',win);

    %Position pause_play


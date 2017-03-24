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
    
    % Keyboard parameters
    KbName('UnifyKeyNames');
    keyLeft=KbName('leftArrow');
    keyRight=KbName('rightArrow');
    
    % Start PTB
    screens=Screen('Screens');
    Screen('Preference', 'SkipSyncTests', 2);
    screenNumber=max(screens); % Main screen
    [win,winRect] = Screen('OpenWindow',screenNumber,black);
    winRect = [0,0,800,600];
    HideCursor;

%% Load stimuli

    Lose=imread(fullfile('Stimfiles', 'Lose.png')); 
    texLose = Screen('MakeTexture', win, Lose);
    Win=imread(fullfile('Stimfiles', 'Win.png')); 
    texWin = Screen('MakeTexture', win, Win);
    Play=imread(fullfile('Stimfiles', 'Play.png')); 
    texPlay = Screen('MakeTexture', win, Play);
    Pause=imread(fullfile('Stimfiles', 'Pause.png')); 
    texPause = Screen('MakeTexture', win, Pause);
    
%% Stimuli positions
    % Size of stimuli (depends on file dimensions)
    sizePlay = 110;
    sizePause = 108;
    sizeWin = 117;
    sizeLose = 83;
    
    [xc, yc] = RectCenterd(winRect);    %get coordinates of screen center
    xcOffsetLeft = xc+300;              %to position left image
    xcOffsetRight = xc+600;             %to position right image
    ycOffset = yc+150;

    %Screen when Play is on the left and Pause is on the right
    imageRectPlayLeft = [xcOffsetLeft, ycOffset, xcOffsetLeft+sizePlay, ycOffset+sizePlay];
    imageRectPauseRight = [xcOffsetRight, ycOffset, xcOffsetRight+sizePause, ycOffset+sizePause];
    
    %Screen when Pause is on the left and Play is on the right
    imageRectPlayRight = [xcOffsetRight, ycOffset, xcOffsetRight+sizePlay, ycOffset+sizePlay];
    imageRectPauseLeft = [xcOffsetLeft, ycOffset, xcOffsetLeft+sizePause, ycOffset+sizePause];


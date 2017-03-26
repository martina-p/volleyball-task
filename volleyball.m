clc;
clear all;

% ========= SET LOGFILES ========= 
subjectID=input('Participant number: ');
DateTime = datestr(now,'yyyymmdd-HHMM');
if ~exist('Logfiles', 'dir')
    mkdir('Logfiles');
end
resultname = fullfile('Logfiles', strcat('Sub',num2str(subjectID),'_', DateTime, '.mat'));
backupfile = fullfile('Logfiles', strcat('Bckup_Sub',num2str(subjectID), '_', DateTime, '.mat')); %save under name composed by number of subject and session

% ========= PARAMETERS ========= %
nblocks=1;
nresp=2;
nTrials=10;
%numTrials=[2,4,6,8];                                                %possible nr of trials per block
%thisBlockTrials=numTrials(randi(numel(numTrials)));                 %randomly determines num trials per block
condOrder = randsrc(1,nblocks,[1 0]);                               %vector of 0s and 1s randomly distributed in equal number
contTable = [9 3; 7 1; 8 5; 6 3; 6 6; 4 4; 5 8; 3 6; 3 9; 1 7];     %Contingency table {play, do not play} for each block: 1 = 1/10 ; 2 = 2/10 ; 3 = 3/10 ; 4 = 4/10 ; 5 = 5 / 10; ...
conTableShuffled = contTable(randperm(10),:);                       %Shuffle contingencies for each block

% ========= LOOP ========= %
% Start PTB-related stuff
psychExpInit; 
trialnb = 0;

for x=1:nblocks
    P_OA = conTableShuffled(x,:);                                   %Define P_OA = {play, do not play} for this block
    trials_P_OA = zeros(10,2);                                      %Generate pseudo-random sequence of outcomes for Action 1 = trials_P_OA1

    %DrawFormattedText(win, ['Stai per testare il giocatore numero 1!'],'center','center',white);    
    %Screen('Flip',win);
    %WaitSecs(3);
    
    for j=1:nresp                           %Loop over actions
        for i=1:nTrials                   %Loop over trials
            if i < (P_OA(:,j)+1)            %Assign correct and incorrect outcomes (basically overwrite trials_P_OA)
            trials_P_OA(i,j) = 1;
            else
            end;
        end;
    end;
    
    trials_P_OA_shuffled = trials_P_OA(randperm(10),:);             %Shuffle trials_P_OA
    
        k = 1;
        noresp = 0;

        for k=1:nTrials
            trialnb = trialnb + 1
            blocknb(trialnb,1) = x
            thistrial(trialnb,1) = k
            
            if condOrder(:,x)==0
             Screen('DrawTexture', win, texPlay,[],imageRectPlayLeft);
             Screen('DrawTexture', win, texPause,[],imageRectPauseRight);
             Screen('Flip',win);
            elseif condOrder(:,x)==1
             Screen('DrawTexture', win, texPlay,[],imageRectPlayRight);
             Screen('DrawTexture', win, texPause,[],imageRectPauseLeft);
             Screen('Flip',win);
            end
           
            RestrictKeysForKbCheck([27,37,39]); %restrict key presses to right and left arrows
            %Check response
            [secs, keyCode, deltaSecs] = KbWait([],2); %wait for 1 key press
            if keyCode(:,37) == 1 %leftArrow
                n = 1;
            elseif keyCode(:,39) == 1 %rightArrow
                n = 2;
            end
            
                %Set outcomes according to A-O contingencies
                if trials_P_OA_shuffled(trialnb,n) == 1
                   outcome = 11    
                   Screen('DrawTexture', win, texWin,[]);
                   Screen('Flip',win);
                   WaitSecs(.5);
                else
                   outcome = 12    
                   Screen('DrawTexture', win, texLose,[]);    
                   Screen('Flip',win);
                   WaitSecs(.5);
                end;
                k = k + 1;
                choices(trialnb,1) = n;
                outcomes(trialnb,1) = outcome;
            end
            
end

% ========= SAVE DATA & CLOSE ========= %
subject(1:trialnb,1) = subjectID;
data = [subject, blocknb, thistrial, choices, outcomes]; 
save(resultname, 'data');
Screen('CloseAll');
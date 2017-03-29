% Clear workspace
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
%numTrials=[8,16,36,40];                                          %possible nr of trials per block
%thisBlockTrials=numTrials(randi(numel(numTrials)));              %randomly determines num trials per block (if we want to make it random)
contTable = [9 3; 7 1; 8 5; 6 3; 6 6; 4 4; 5 8; 3 6; 3 9; 1 7];   %Contingency table {play, do not play} for each block: 1 = 1/10 ; 2 = 2/10 ; 3 = 3/10 ; 4 = 4/10 ; 5 = 5 / 10; ...
conTableShuffled = contTable(randperm(10),:);                     %Shuffle contingencies for each block
condOrder = randsrc(1,nblocks,[1 0]);                             %vector of 0s and 1s randomly distributed in equal number, This is for play_pause or pause_play display
    
% ========= STUFF FOR TEXT-BASED SCREENS ========= %
players=randperm(nblocks,nblocks);                                %create as many "player numbers" as nr of blocks
    
% ========= LOOP ========= %
% Start PTB
    psychExpInit; 
    trialnb = 0;
    k = 1;

for x=1:nblocks
    P_OA = conTableShuffled(x,:); %set P_OA = {play, do not play} for this block
    lateTrials=zeros(nTrials,1); % preallocate late trials occurrences
    
    %First screen of the block, present the "player"
    DrawFormattedText(win,['Stai per testare il giocatore numero  ' num2str(players(nblocks,1))],'center','center',white);
    Screen('Flip',win);
    WaitSecs(.5);
    
    %Fixation cross
    Screen('DrawLines',win,crossLines,crossWidth,crossColor,[xc,yc]);
    Screen('Flip',win);
    WaitSecs(.5);
 
        while k <= nTrials
            trialnb = trialnb + 1;
            blocknb(trialnb,1) = x;
            thistrial(trialnb,1) = k;
            
            RestrictKeysForKbCheck([27,37,39]); %restrict key presses to right and left arrows
            
            %Present stimuli
            if condOrder(:,x)==0   
                Screen('DrawTexture', win, texPlay,[],imageRectPlayLeft);
                Screen('DrawTexture', win, texPause,[],imageRectPauseRight);
            elseif condOrder(:,x)==1
                Screen('DrawTexture', win, texPlay,[],imageRectPlayRight);
                Screen('DrawTexture', win, texPause,[],imageRectPauseLeft);
            end
            Screen('Flip',win);
            
            keyIsDown=0;
            maxStimDuration=GetSecs+3; %set max stim duration
            startTime=GetSecs; %start recording reaction time
            
            %Check which key was pressed
            while ~keyIsDown && GetSecs<maxStimDuration
                [keyIsDown, pressedSecs, keyCode] = KbCheck(-1);  
            end
                
                %Spot late trials & keep track of them for later
                if GetSecs>maxStimDuration
                    if condOrder(:,x)==0   
                        Screen('DrawTexture', win, texPlay,[],imageRectPlayLeft);
                        Screen('DrawTexture', win, texPause,[],imageRectPauseRight);
                    elseif condOrder(:,x)==1
                        Screen('DrawTexture', win, texPlay,[],imageRectPlayRight);
                        Screen('DrawTexture', win, texPause,[],imageRectPauseLeft);
                    end                    
                 DrawFormattedText(win,['?'],xc,yc,red);    
                 Screen('Flip',win);
                 WaitSecs(.5);
                 lateTrials(trialnb,1)=1;
                 continue
                end
 
            reactionTime = pressedSecs-startTime; %get reaction time
            
            %Set outcomes
               if keyCode(:,37) == 1 %leftArrow
                    n = 1;
               elseif keyCode(:,39) == 1 %rightArrow
                    n = 2;
               end
            
            condizione = 1;
            outcome = (rand > P_OA(condizione,n)/10);
            
            %Show win /lose cues
            if outcome == 1
               if condOrder(:,x)==0   
                   Screen('DrawTexture', win, texPlay,[],imageRectPlayLeft);
                   Screen('DrawTexture', win, texPause,[],imageRectPauseRight);
               elseif condOrder(:,x)==1
                   Screen('DrawTexture', win, texPlay,[],imageRectPlayRight);
                   Screen('DrawTexture', win, texPause,[],imageRectPauseLeft);
               end
                  Screen('DrawTexture', win, texWin,[],imageWin);
            else
              if condOrder(:,x)==0   
                    Screen('DrawTexture', win, texPlay,[],imageRectPlayLeft);
                    Screen('DrawTexture', win, texPause,[],imageRectPauseRight);
               elseif condOrder(:,x)==1
                    Screen('DrawTexture', win, texPlay,[],imageRectPlayRight);
                    Screen('DrawTexture', win, texPause,[],imageRectPauseLeft);
              end
                    Screen('DrawTexture', win, texLose,[],imageLose);
            end      
                Screen('Flip',win);
                WaitSecs(.5);   
            
            nLateTrials=numel(find(lateTrials(:,1)==1))
            k=k+1;
            
            %Store loop iterations
            reactionTimes(trialnb,1) = reactionTime;
            choices(trialnb,1) = n;
            outcomes(trialnb,1) = outcome;
        end  
end
       
% ========= SAVE DATA & CLOSE ========= %
subject(1:trialnb,1) = subjectID;
data = [subject, blocknb, thistrial, choices, reactionTimes, outcomes]; 
save(resultname, 'data');
Screen('CloseAll');
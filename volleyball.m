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
%numTrials=[8,16,36,40];                                           %possible nr of trials per block
%thisBlockTrials=numTrials(randi(numel(numTrials)));               %randomly determines num trials per block (if we want to make it random)
contTable = [9 3; 7 1; 8 5; 6 3; 6 6; 4 4; 5 8; 3 6; 3 9; 1 7];     %Contingency table {play, do not play} for each block: 1 = 1/10 ; 2 = 2/10 ; 3 = 3/10 ; 4 = 4/10 ; 5 = 5 / 10; ...
conTableShuffled = contTable(randperm(10),:);                      %Shuffle contingencies for each block
condOrder = randsrc(1,nblocks,[1 0]);                             %vector of 0s and 1s randomly distributed in equal number, This is for play_pause or pause_play display

% ========= LOOP ========= %
% Start PTB
    psychExpInit; 
    trialnb = 0;

for x=1:nblocks
    P_OA = conTableShuffled(x,:); %set P_OA = {play, do not play} for this block
    k = 1;
    
        for k=1:nTrials
            trialnb = trialnb + 1
            blocknb(trialnb,1) = x
            thistrial(trialnb,1) = k
            
            RestrictKeysForKbCheck([27,37,39]); %restrict key presses to right and left arrows
                  
            if condOrder(:,x)==0   
                Screen('DrawTexture', win, texPlay,[],imageRectPlayLeft);
                Screen('DrawTexture', win, texPause,[],imageRectPauseRight);
            elseif condOrder(:,x)==1
                Screen('DrawTexture', win, texPlay,[],imageRectPlayRight);
                Screen('DrawTexture', win, texPause,[],imageRectPauseLeft);
            end
            Screen('Flip',win);
            
            [secs, keyCode, deltaSecs] = KbWait([],2); %wait for 1 key press
                   
            if keyCode(:,37) == 1 %leftArrow
               n = 1;
            elseif keyCode(:,39) == 1 %rightArrow
               n = 2;
            end
            
            %Set outcomes
            condizione = 1;
            outcome = (rand > P_OA(condizione,n)/10);
            
            if outcome == 1
               if condOrder(:,x)==0   
                   Screen('DrawTexture', win, texPlay,[],imageRectPlayLeft);
                   Screen('DrawTexture', win, texPause,[],imageRectPauseRight);
               elseif condOrder(:,x)==1
                   Screen('DrawTexture', win, texPlay,[],imageRectPlayRight);
                   Screen('DrawTexture', win, texPause,[],imageRectPauseLeft);
               end
                  Screen('DrawTexture', win, texWin,[],destinationRectWin);
            else
              if condOrder(:,x)==0   
                    Screen('DrawTexture', win, texPlay,[],imageRectPlayLeft);
                    Screen('DrawTexture', win, texPause,[],imageRectPauseRight);
               elseif condOrder(:,x)==1
                    Screen('DrawTexture', win, texPlay,[],imageRectPlayRight);
                    Screen('DrawTexture', win, texPause,[],imageRectPauseLeft);
              end
                    Screen('DrawTexture', win, texLose,[],destinationRectLose);
            end      
                Screen('Flip',win);
                WaitSecs(.5);
             
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
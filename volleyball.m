% Clear workspace
clc;

% ========= SET LOGFILES ========= 
subjectID = input('Participant number: ');
DateTime = datestr(now,'yyyymmdd-HHMM');

if ~exist('Logfiles', 'dir')
    mkdir('Logfiles');
end

%There will be two data files with different names: 
resultname = fullfile('Logfiles', strcat('Sub',num2str(subjectID),'_', DateTime, '.mat'));                          %this one is for choice data over trials
resultnameQuestions = fullfile('Logfiles', strcat('Sub',num2str(subjectID),'questions_', DateTime, '.mat'));        %this one is for end-of-block questions

backupfile = fullfile('Logfiles', strcat('Bckup_Sub',num2str(subjectID), '_', DateTime, '.mat')); %save under name composed by number of subject and date of session

% ========= PARAMETERS & DATA PREALLOCATION ========= %
nblocks = 3;                                                        %modify with desired number of blocks
ntrials = 10;                                                       %modify with desired number of trials per block
%numTrials = [8,16,36,40];                                          %possible nr of trials per block
%thisBlockTrials = numTrials(randi(numel(numTrials)));              %randomly determines num trials per block

contTable = [9 3; 7 1; 8 5; 6 3; 6 6; 4 4; 5 8; 3 6; 3 9; 1 7];   %Contingency table {play, do not play} for each block: 1 = 1/10 ; 2 = 2/10 ; 3 = 3/10 ; 4 = 4/10 ; 5 = 5 / 10; ...
conTableShuffled = contTable(randperm(10),:);                     %Shuffle contingencies for each block
condOrder = randi([0,1],1,10);                                    %vector of 0s and 1s for play_pause or pause_play conditions

players = randperm(nblocks);                                      %create as many unique "player numbers" as there are blocks
thisblock = zeros((ntrials*nblocks),1);                           %preallocate block nr storage to be recorded for each trial
condition = zeros((ntrials*nblocks),1);                           %preallocate condition (play_pause or pause_play) to be recorded for each trial
respEndOfBlock = {nblocks,4};                                     %prealocate responses to end-of-block questions
M = {1, 2, 3, 4, 5, 6};                                           %positions for instruction screens

% ========= DISPLAY INSTRUCTIONS ========= %

psychExpInit;                                %start PTB

RestrictKeysForKbCheck([32,37,39]);          %restrict key presses to space, right and left arrows
exitInstructions = false;                    %cue which determines whether to exit the instructions
pos = 1;                                     %initial position to go back and forth between the slides

Screen('DrawTexture', win, texslide1);       %show first slide      
Screen('Flip',win);                             

while exitInstructions == false                 %loop instructions until space key is pressed
    [secs, keyCode, deltaSecs] = KbWait([],2);  %waits for key press
    
    %depending on button press, either move pos or exit instructions
    
    if keyCode(:,32) == 1 %space
        exitInstructions = true;
    elseif keyCode(:,37) == 1 %leftArrow
           pos = pos-1
    elseif keyCode(:,39) == 1 %rightArrow
           pos = pos+1       
    end
    
    if pos == 8
       break
    end   
    
    %show instructions slide according to position
    thisSlide=imread(fullfile('Stimfiles', strcat('Slide',num2str(pos),'.bmp'))); 
    texslide = Screen('MakeTexture', win, thisSlide);
    Screen('DrawTexture', win, texslide);
    Screen('Flip',win);
    continue
    
end

% ========= LOOPS ========= %
blocknb = 0; %initial block value
trialnb = 0; %initial trial value
  
for x = 1:nblocks
    k=1;
    blocknb = blocknb + 1;
    P_OA = conTableShuffled(x,:);   %set P_OA = {play, do not play} for this block
    lateTrials = zeros(ntrials,1);  %preallocate late trials occurrences
    
    thisblockplayer = players(:,x); %chose this block's "player"
    
    %First screen of the block, indtroduce the "player"
    DrawFormattedText(win,['Stai per testare il giocatore numero  ' num2str(thisblockplayer)],'center','center',white);
    Screen('Flip',win);
    WaitSecs(3);
    
    %Fixation cross
    Screen('DrawLines',win,crossLines,crossWidth,crossColor,[xc,yc]);
    Screen('Flip',win);
    WaitSecs(3);
 
        while k <= ntrials %use while instead of for loop to accomodate late trials
            trialnb = trialnb + 1;
            thistrial(trialnb,1) = k; %store number of trial
            thisblock(trialnb,1) = blocknb; %store block nr
            condition(trialnb,1) = condOrder(:,x); %store condition type (play_pause or pause_play)
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
            
            keyIsDown = 0;
            maxStimDuration = GetSecs+3; %set max stim duration
            startTime = GetSecs; %start recording reaction time
            
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
                 lateTrials(trialnb,1) = 1;
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
            
            %Show win/lose cues
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
            
            nLateTrials = numel(find(lateTrials(:,1)==1)); %count how many late trials there have been
            
            %Store iterations
            reactionTimes(trialnb,1) = reactionTime;
            choices(trialnb,1) = n;
            outcomes(trialnb,1) = outcome;
            k=k+1;               
        end
        
% ========= END-OF-BLOCK QUESTIONS ========= %
        %prova
        DrawFormattedText(win,'Giudica l impatto che questo giocatore ha avuto sulla squadra con un valore da -100 a +100.',150,300,white);
        DrawFormattedText(win,'Per esempio:',150,350,white);
        DrawFormattedText(win,'«-100»  : questo giocatore fa sempre perdere la squadra',150,450,white);
        DrawFormattedText(win,'«0» : questo giocatore non ha alcun impatto sulla performance della squadra',150,500,white);
        DrawFormattedText(win,'«100» : questo giocatore fa sempre vincere la squadra',150,550,white);
        respQ1=Ask(win,'Inserisci adesso il valore usando la tastiera, poi premi INVIO per continuare:   ',white,black,'GetChar',[800 300 1000 1000],'center',20);
        Screen('Flip',win);
        
        DrawFormattedText(win,'Clicca ancora su INVIO per confermare il valore inserito e passare alla schermata successiva.',150,300,white);
        DrawFormattedText(win,'Se invece vuoi modificarlo, scrivi adesso il nuovo valore, poi premi INVIO per continuare.',150,350,white);
        respQ12=Ask(win,'Nuovo valore:   ',white,black,'GetChar',[800 100 1000 1000],'center',20);
        Screen('Flip',win);
        
        DrawFormattedText(win,'Grazie, il punteggio è stato registrato correttamente.',150,300,white);
        DrawFormattedText(win,'Ora per favore rispondi a questa domanda scrivendo SI o NO usando la tastiera:',150,350,white);
        respQ3=Ask(win,'Faresti giocare questo giocatore nel prossimo campionato?   ',white,black,'GetChar',[800 100 1000 1000],'center',20);
        Screen('Flip',win);
        
        DrawFormattedText(win,'Ne sei sicuro?',150,300,white);
        respQ4=Ask(win,'0 = per niente, 100 = completamente:   ',white,black,'GetChar',[800 100 1000 1000],'center',20);
        Screen('Flip',win);
        
        %Store responses after each block
        respEndOfBlock{blocknb,1}=respQ1;
        respEndOfBlock{blocknb,2}=respQ12;
        respEndOfBlock{blocknb,3}=respQ3;
        respEndOfBlock{blocknb,4}=respQ4;
end
       
% ========= SAVE DATA & CLOSE ========= %
subject(1:trialnb,1) = subjectID;
data = [subject, thisblock, condition, thistrial, choices, outcomes, reactionTimes];
dataQuestions = (respEndOfBlock);
save(resultnameQuestions, 'dataQuestions');
save(resultname, 'data');

Screen('CloseAll');

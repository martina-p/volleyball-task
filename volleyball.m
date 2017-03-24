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

nblocks=4;
nresp=2;
numTrials=[2,4,6,8];                                                %possible nr of trials per block
thisBlockTrials=numTrials(randi(numel(numTrials)));                 %randomly determines num trials per block
condOrder = randsrc(1,nblocks,[1 0]);                               %vector of 0s and 1s randomly distributed in equal number


contTable = [9 3; 7 1; 8 5; 6 3; 6 6; 4 4; 5 8; 3 6; 3 9; 1 7];     %Contingency table {play, do not play} for each block: 1 = 1/10 ; 2 = 2/10 ; 3 = 3/10 ; 4 = 4/10 ; 5 = 5 / 10; ...
conTableShuffled = contTable(randperm(10),:);                       %Shuffle contingencies for each block

%psychExpInit; % Start all PTB-related stuff

% ========= LOOP ========= %
trialnb = 0;

for x=1:nblocks
    P_OA = conTableShuffled(x,:);           %Define P_OA = {play, do not play} for this block
    trials_P_OA = zeros(10,2);              %Generate pseudo-random sequence of outcomes for Action 1 = trials_P_OA1
    
    if condOrder(:,x)==0
       disp('This is a play_pause block')
    elseif condOrder(:,x)==1
       disp('This is a pause_play block')
    end
    
    for j=1:nresp                           %Loop over actions
        for i=1:thisBlockTrials              %Loop over trials
            if i < (P_OA(:,j)+1)            %Assign correct and incorrect outcomes (basically overwrite trials_P_OA)
            trials_P_OA(i,j) = 1;
            else
            end;
        end;
    end;

        k = 1;
        noresp = 0;
        n_A1 = 1;
        n_A2 = 1;

        for k=1:thisBlockTrials
            trialnb = trialnb + 1
            blocknb(trialnb,1) = x
            thistrial(trialnb,1) = k
            n = input('Play? ');
            if n == 1                                  %Set outcomes according to A-O contingencies
                if trials_P_OA(n_A1,n) == 1
                disp('WIN');
                else
                disp('LOST')
                end;
                n_A1 = n_A1 + 1
            elseif n == 2 
                if trials_P_OA(n_A2,n) == 1
                disp('WIN');
                else
                disp('LOST')
                end;
                n_A2 = n_A2 + 1
            end;
            k = k + 1;
        end
end

% ========= SAVE DATA ========= %
subject(1:trialnb,1) = subjectID;
data = [subject, blocknb, thistrial]; 
save(resultname, 'data');


%Close screen
Screen('CloseAll');
function getKeypress
clc;
clear all;

WaitSecs(.5);
startTime = GetSecs();
keyIsDown = 0;
tEnd = GetSecs+5;

while ~keyIsDown && GetSecs<tEnd
    [keyIsDown, pressedSecs, keyCode] = KbCheck(-1);
    if GetSecs>tEnd
        fprintf('\n too late\n');
        break
    end
end

pressedKey = KbName(find(keyCode));
reactionTime = pressedSecs-startTime;

fprintf('\nKey was pressed at %.4f seconds\n\n', reactionTime);
end
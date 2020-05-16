--- m18s, midcentury modular 5/9/20 livestream version
-- in 1: clock
-- in 2: 0-5 offset, 8 position sequence selector
-- out 1: cv 1
-- out 2: gate 1
-- out 3: cv 2
-- out 4: gate 2

mod1 = 7/12
mod2 = 0

function shouldGateFire (stage, numStages, gateMode)
    if stage <= numStages then
        if gateMode == "all" or (gateMode == "single" and stage == 1) or
          (gateMode == "every2" and (stage + 1) % 2 == 0) or
          (gateMode == "every3" and (stage + 2) % 3 == 0) or
          (gateMode == "every4" and (stage + 3) % 4 == 0) or
          (gateMode == "random" and math.random(0, 1) == 0) or
          (gateMode == "long" and numStages == 1) then
            return true
        end
    end
    return false
end

nextStep1 = 1
nextStage1 = 1
pingPongDir1 = 'forward'
fixedLengthStageCount1 = 1
function advance1()
    if (nextStep1 > #seq1) then
        nextStep1 = 1
        nextStage1 = 1
    end
    local nextNote1 = seq1[nextStep1][1]
    local nextNumStages1 = seq1[nextStep1][2]
    local nextGateMode1 = seq1[nextStep1][3]

    if nextStage1 == 1 then
        output[1].volts = nextNote1/12 + oct1 + mod1
    end

    if shouldGateFire(nextStage1, nextNumStages1, nextGateMode1) then
        output[2](pulse(gateLength1, 8))
    elseif nextGateMode1 == "long" and nextStage1 == 1 then
        output[2].volts = 8
    elseif nextGateMode1 == "long" and nextStage1 >= nextNumStages1 then
        output[2].volts = 0
    end

    if mode1 == "fixedLength" and fixedLengthStageCount1 >= fixedLength1 then
        nextStep1 = 1
        nextStage1 = 1
        fixedLengthStageCount1 = 1
        output[2].volts = 0 -- just in case you need to clear out a long gate
    else
        if mode1 == "fixedLength" then
            fixedLengthStageCount1 = fixedLengthStageCount1 + 1
        end
        if nextStage1 >= nextNumStages1 or nextStep1 > #seq1 then
            if mode1 == "forward" or mode1 == "fixedLength" then
                nextStep1 = nextStep1 % #seq1 + 1
            elseif mode1 == "pingPong" then
                if nextStep1 == #seq1 then
                    pingPongDir1 = 'reverse'
                elseif nextStep1 == 1 then
                    pingPongDir1 = 'forward'
                end

                if pingPongDir1 == 'forward' then
                    nextStep1 = nextStep1 % #seq1 + 1
                else
                    nextStep1 = nextStep1 % #seq1 - 1
                    if nextStep1 == -1 then
                        nextStep1 = #seq1 - 1
                    end
                end           
            elseif mode1 == "random" then
                nextStep1 = math.random(1, #seq1)
            end
            nextStage1 = 1
        else
            nextStage1 = nextStage1 + 1
        end
    end
end

nextStep2 = 1
nextStage2 = 1
pingPongDir2 = 'forward'
fixedLengthStageCount2 = 1
function advance2()
    if (nextStep2 > #seq2) then
        nextStep2 = 1
        nextStage2 = 1
    end
    local nextNote2 = seq2[nextStep2][1]
    local nextNumStages2 = seq2[nextStep2][2]
    local nextGateMode2 = seq2[nextStep2][3]

    if nextStage2 == 1 then
        output[3].volts = nextNote2/12 + oct2 + mod2
    end

    if shouldGateFire(nextStage2, nextNumStages2, nextGateMode2) then
        output[4](pulse(gateLength2, 8))
    elseif nextGateMode2 == "long" and nextStage2 == 1 then
        output[4].volts = 8
    elseif nextGateMode2 == "long" and nextStage2 >= nextNumStages2 then
        output[4].volts = 0
    end

    if mode2 == "fixedLength" and fixedLengthStageCount2 >= fixedLength2 then
        nextStep2 = 1
        nextStage2 = 1
        fixedLengthStageCount2 = 1
        output[4].volts = 0 -- just in case you need to clear out a long gate
    else
        if mode2 == "fixedLength" then
            fixedLengthStageCount2 = fixedLengthStageCount2 + 1
        end
        if nextStage2 >= nextNumStages2 or nextStep2 > #seq2 then
            if mode2 == "forward" or mode2 == "fixedLength" then
                nextStep2 = nextStep2 % #seq2 + 1
            elseif mode2 == "pingPong" then
                if nextStep2 == #seq2 then
                    pingPongDir2 = 'reverse'
                elseif nextStep2 == 1 then
                    pingPongDir2 = 'forward'
                end

                if pingPongDir2 == 'forward' then
                    nextStep2 = nextStep2 % #seq2 + 1
                else
                    nextStep2 = nextStep2 % #seq2 - 1
                    if nextStep2 == -1 then
                        nextStep2 = #seq2 - 1
                    end
                end           
            elseif mode2 == "random" then
                nextStep2 = math.random(1, #seq2)
            end
            nextStage2 = 1
        else
            nextStage2 = nextStage2 + 1
        end
    end
end

function advance()
    -- advance1()
    -- advance2()
end

function init()
    changeSeqNum(1)
    input[1]{ mode = "change", direction = "rising" }
    input[1].change = advance
    input[2]{ mode = 'stream', time = 0.1 }
    input[2].stream = switch
end

-- voice 1
gateLength1 = .01

-- voice 2
gateLength2 = .01
fixedLength2 = 10

function changeSeqNum(n)
    if (n == 1) then
        mode1 = "forward"
        oct1 = 0
        seq1 = {
            { 5, 1, "every3"},
            { 0, 1, "random"},
            { 5, 1, "every3"},
            { 9, 1, "single"},
            { 5, 1, "every3"},
        }

        mode2 = "pingPong"
        oct2 = -1
        seq2 = { 
            { 0, 1, "long" },
            { 2, 1, "random" },
            { 4, 1, "every3" },
        }
    elseif (n == 2) then
        seq1 = {
            { 5, 2, "every3"},
            { 0, 6, "random"},
            { 17, 6, "all"},
            { 9, 8, "long"},
            { 5, 2, "every3"},
        }  

        seq2 = { 
            { 0, 8, "long" },
            { 2, 4, "random" },
            { 4, 6, "every3" },
            { 26, 4, "every2" },
            { 0, 8, "long" },
        }
    elseif (n == 3) then
        seq1 = {
            { 5, 2, "every2"},
            { 0, 6, "all"},
            { 17, 6, "all"},
            { 9, 8, "long"},
            { 5, 2, "every2"},
        }  
        mode2 = "forward"
        seq2 = { 
            { 0, 8, "long" },
            { 2, 4, "random" },
            { 4, 6, "every4" },
            { 6, 4, "every3" },
            { 9, 2, "long" },
            { 7, 6, "every4" },
            { 4, 4, "every3" },
            { 7, 2, "every3" },
        }
    elseif (n == 4) then
        mode1 = "fixedLength"
        fixedLength1 = 14
        seq1 = { { 0, 2, "all" }, { 5, 2, "every2" } }     
    elseif (n == 5) then
        mode2 = "pingPong"
        oct2 = 0
        seq2 = { { -12, 8, "long" }, { 3, 8, "every3" }, { 2, 3, "every4" }, { 19, 2, "random" } }
    elseif (n == 6) then
        oct1 = 0
        seq1 = { { 0, 2, "all" }, { 5, 2, "every2" }, { 12, 3, "single" } }
    elseif (n == 7) then
        oct1 = 1
    elseif (n == 8) then
        oct1 = -1
        oct2 = -1
    end
end

prev_v = -1
function switch(v)
    local scale_v = math.floor( (v + .5) * 7 / 5 ) + 1
    if scale_v ~= prev_v then
        changeSeqNum(scale_v)
        prev_v = scale_v
    end
end

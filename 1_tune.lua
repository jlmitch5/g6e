--- tune ~ start things off with everything tuned to C
-- in 1: clock
-- out 1: cv 1
-- out 2: gate 1
-- out 3: cv 2
-- out 4: gate 2
-- jf connected to ii in synth mode, outputs notes

function playJFNote ()
    ii.jf.play_note(0, 10)
end

function init()
    ii.jf.mode(1)
    input[1]{ mode = "change", direction = "rising" }
    input[1].change = playJFNote
    output[1].volts = 0
    output[2].volts = 10
    output[3].volts = 0
    output[4].volts = 10
end

--- this_afternoon ~ a somewhat-linked dual arpeggiator
-- output 1 control voltage 1
-- output 2 v/oct 1
-- output 3 control voltage 2
-- output 4 v/oct 2

-- original patch notes:
-- for warps and mangrove
-- output 1 goes to warps algorithm attenuated to taste
-- output 2 goes to warps pitch (channel 1)
-- output 3 goes to mangrove formant attenuated to taste
-- output 4 goes to mangrove pitch
-- warps is a self-patched complex oscillator (channel 1 is on-board osc, aux out to in 2)
-- mix warps and mangrove and put into three sisters all
-- control 3 sisters cut off with some of the output 1 and 3 control signals
-- use additional 3 sisters outs for feeding back into the oscillators
-- delay and reverb for maximum vibes

-- update these to make new things appear
seq = { 12, 9, 7, 5, 4, 0 }
switchRepeats = 4
varDivisor1 = 4
seq2 = { 0, 4, 5, 7, 9, 12 }
switch2Repeats = 4
varDivisor2 = 4
level = 5
time = 4

-- leave these be (probably)
step = 1
switch = 1
a = math.random(1, varDivisor1)
b = math.random(1, varDivisor1)
c = math.random(1, varDivisor1)
step2 = 1
switch2 = 1
d = math.random(1, varDivisor2)
e = math.random(1, varDivisor2)
f = math.random(1, varDivisor2)

function brutus()
    print("foo!")
    output[1].volts = seq[step]/12 + 0
    output[1].slew = math.random(0, 2)/100
    step = ((step + math.random(0, 1)) % #seq) + 1
    if step == 1 then
        switch = (switch + 1) % switchRepeats
        if switch == 1 then
            a = math.random(1, varDivisor1)
            b = math.random(1, varDivisor1)
            c = math.random(1, varDivisor1)
        end
    end
end

function mimi()
    output[3].volts = seq2[step2]/12
    output[3].slew = math.random(0, 2)/100
    step2 = ((step2 + math.random(0, 1)) % #seq2) + 1
    if step2 == 1 then
        switch2 = (switch2 + 1) % switch2Repeats
        if switch2 == 1 then
            d = math.random(1, varDivisor2)
            e = math.random(1, varDivisor2)
            f = math.random(1, varDivisor2)
        end
    end
end

function init()
    output[2]( loop
        { brutus
        , to(function() return level/a end, function() return time/b end)
        , brutus
        , to(function() return -level/c end, function() return time/a end)
        , brutus
        , to(function() return level/b end, function() return time/c end)
        , brutus
        , to(function() return -level/a end, function() return time/b end)
        , brutus
        , to(function() return level/c end, function() return time/a end)
        , brutus
        , to(function() return -level/b end, function() return time/c end)
        }
    )
    output[4]( loop
        { mimi
        , to(function() return level/d end, function() return time/e end)
        , mimi
        , to(function() return -level/f end, function() return time/d end)
        , mimi
        , to(function() return level/e end, function() return time/f end)
        , mimi
        , to(function() return -level/d end, function() return time/e end)
        , mimi
        , to(function() return level/f end, function() return time/d end)
        , mimi
        , to(function() return -level/e end, function() return time/f end)
        }
    )
end

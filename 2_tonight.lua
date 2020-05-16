--- tonight ~ a wandering and loose(/lost?) voice
-- output 1 control voltage 1
-- output 3 v/oct 1
-- output 4 always on gate

-- original patch notes:
-- for mangrove
-- output 1 goes to mangrove's formant attenuated to taste (constant wave mode)
-- output 3 goes to mangrove' pitch
-- mangrove's out to delay and reverb for maximum vibes

-- update these to make new things appear
seq = { 0, 4, 5, 7, 9 }
switchRepeats = 2
level = 5
time = 1.3
lowerDivisor = 1
upperDivisor = 10

-- leave these be (probably)
step = 1
switch = 1
a = math.random(lowerDivisor,upperDivisor)
b = math.random(lowerDivisor,upperDivisor)
c = math.random(lowerDivisor,upperDivisor)
-- a = 5
-- b = 5
-- c = 5

function toby()
    -- print("here")
    output[3].volts = seq[step]/12
    output[3].slew = math.random(0,2)/100
    -- advances sequencer every 1 or 2 steps
    step = ((step + math.random(0, 1)) % #seq) + 1 
    if step == 1 then
        switch = (switch + 1) % switchRepeats
        if switch == 1 then
            -- these are updated to change the timing of the asl stages
            a = math.random(lowerDivisor,upperDivisor)
            b = math.random(lowerDivisor,upperDivisor)
            c = math.random(lowerDivisor,upperDivisor)
            -- a = 5
            -- b = 5
            -- c = 5
        end
    end
end

function changeRandomBounds(v)

    new_v = math.floor(v / 6 * 5 + .5) + 1
    lowerDivisor = new_v
    upperDivisor = 10 - new_v
    print(lowerDivisor .. ":" .. upperDivisor)
end

function init()
    input[2]{ mode = 'stream', time = 0.1 }
    input[2].stream = changeRandomBounds
    output[4].volts = 10
    output[1]( loop
        { toby
        , to(function() return level/a end, function() return time/b end)
        , toby
        , to(function() return -level/c end, function() return time/a end)
        , toby
        , to(function() return level/b end, function() return time/c end)
        , toby
        , to(function() return -level/a end, function() return time/b end)
        }
    )

    -- output[1](
    --     loop {
    --         to(5, 1.3),
    --         to(-5, 1.3)
    --     }
    -- )
end




-- 1..9
-- 2..8
-- 3..7
-- 4..6
-- 5..5
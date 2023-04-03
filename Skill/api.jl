#
# API function go here, to be called by the
# skill-actions (and trigger-actions):
#

function move_roller(payload, action)


    # find rollers in the room:
    #
    rollers, room = match_rollers(payload)

    if length(rollers) == 0
        publish_say(:no_rollers, room)
        return false
    end

    print_log("Rollers in room $(room): $(rollers)")

    # get params for the devices and move:
    #
    for roller in rollers
        move_one_roller(roller, action)
    end
end
    
function match_rollers(payload)

    # get the slot values:
    #
    room = extract_slot_value(SLOT_ROOM, payload, default=get_siteID(payload))
    devices = get_config(INI_ROLLERS, multiple=true)

    rollers = []
    for device in devices
        r = get_config("room", one_prefix=device)
        if r == room
            push!(rollers, device)
        end
    end
    return rollers, room
end


function move_roller_sunny(payload, action)

    cloud_limit = get_config(INI_CLOUDY, cast_to=Int, default=60)
    pre_sunset = get_config(INI_SUNSET_PRE, cast_to=Int, default=30)

    # no sun protection if cloudy:
    #
    w = get_weather()

println("weather: $w")

    sunny = true
    if !isnothing(w) && w[:clouds] > cloud_limit
        sunny = false
        print_log("Cloudy, no sun protection.")
    end

    # no sun protection if it is already close to sunset:
    #
    if !isnothing(w)
        if w[:sunset] - Dates.Minute(pre_sunset) < Dates.now()
            sunny = false
            print_log("Close to sunset, no sun protection.")
        end
    end
println("sunny2: $sunny")

    if sunny
        print_log("Sunny, sun protection.")
        move_roller(payload, action)
    else
        move_roller(payload, :open)
    end
end





function move_all_rollers(payload, action)

    rollers = get_config(INI_ROLLERS, multiple=true)

    if length(rollers) == 0
        publish_say(:no_rollers_in_house)
        return false
    end

    print_log("Rollers in the house: $(rollers)")

    # get params for the devices and move:
    #
    for roller in rollers
        move_one_roller(roller, action)
    end
end






function move_one_roller(roller, action)

    # get postition in prercent from config.ini:
    #
    positions = get_config("positions", one_prefix=roller, multiple=true)
    room = get_config("room", one_prefix=roller)

    if length(positions) == 3
        pos_open = positions[1]
        pos_half = positions[2]
        pos_close = positions[3]
    else
        pos_open = 100
        pos_half = 50
        pos_close = 0
    end

    if action == :open
        pos = pos_open
        say = :i_open_one_roller
    elseif action == :half
        pos = pos_half
        say = :i_close_one_roller
    else
        pos = pos_close
        say = :i_close_one_roller
    end


    # get driver and params:
    #
    driver = get_config("driver", one_prefix=roller, multiple=true)

    if length(driver) < 2
        print_log("No driver defined for roller $(roller).")
    else

        # driver shelly 2.5:
        #
        if driver[1] == "shelly2.5" 
            ip = driver[2]
            user = nothing
            password = nothing

            if length(driver) > 2
                user = driver[3]
            end
            if length(driver) > 3
                password = driver[4]
            end

            if move_shelly_25_roller(ip, :to_pos, pos=pos, 
                        user=user, password=password)
                publish_say(say, Symbol(roller), :in_room, room)
            else
                publish_say(:could_not_move_roller, room, Symbol(roller))
            end
        else
            print_log("Unknown driver $(driver[1]) for roller $roller.")
        end
    end
end



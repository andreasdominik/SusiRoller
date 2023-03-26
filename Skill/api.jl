#
# API function go here, to be called by the
# skill-actions (and trigger-actions):
#

function move_roller(payload, action)

    # get the slot values:
    #
    room = extract_slot_value(SLOT_ROOM, payload, default=get_siteID(payload))

    # find rollers in the room:
    #
    devices = get_config(ROLLERS, multiple=true)

    rollers = []
    for device in devices
        r = get_config("room", one_prefix=device)
        if r == room
            push!(rollers, device)
        end
    end

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


function move_all_rollers(payload, action)

    rollers = get_config(ROLLERS, multiple=true)

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
        say = :i_open_rollers
    elseif action == :half
        pos = pos_half
        say = :i_close_rollers
    else
        pos = pos_close
        say = :i_close_rollers
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
                publish_say(say, room)
            else
                publish_say(:could_not_move_roller, room)
            end
        else
            print_log("Unknown driver $(driver[1]) for roller $roller.")
        end
    end
end



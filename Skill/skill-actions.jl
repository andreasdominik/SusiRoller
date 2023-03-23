#
# actions called by the main callback()
# provide one function for each intent, defined in the Snips/Rhasspy
# console.
#
# ... and link the function with the intent name as shown in config.jl
#
# The functions will be called by the main callback function with
# 2 arguments:
# + MQTT-Topic as String
# + MQTT-Payload (The JSON part) as a nested dictionary, with all keys
#   as Symbols (Julia-style).
#




"""
    Susi_RollerUpDown_action(topic, payload)

Generated dummy action for the intent Susi:RollerUpDown.
This function will be executed when the intent is recognized.
"""
function Susi_RollerUpDown_action(topic, payload)

    print_log("action Susi_RollerUpDown_action() started.")

    action = extract_slot_value(SLOT_ACTION, payload, default="close")

    if action == "open"
        ac = :open
    else
        ac = :close
    end

    move_roller(payload, ac)

    publish_end_session("")
    return true
end





"""
    Susi_RollerHalf_action(topic, payload)

Generated dummy action for the intent Susi:RollerHalf.
This function will be executed when the intent is recognized.
"""
function Susi_RollerHalf_action(topic, payload)

    print_log("action Susi_RollerHalf_action() started.")

    move_roller(payload, :half)

    publish_end_session("")
    return true
end

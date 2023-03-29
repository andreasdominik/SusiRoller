# DO NOT CHANGE THE FOLLOWING 3 LINES UNLESS YOU KNOW
# WHAT YOU ARE DOING!
# set CONTINUE_WO_HOTWORD to true to be able to chain
# commands without need of a hotword in between:
#
const CONTINUE_WO_HOTWORD = false

# set a local const LANG:
#
const LANG = get_language()



# Slots:
# Name of slots to be extracted from intents:
#
const SLOT_ACTION = "action"
# const SLOT_DEVICE = "device"  no device spec - only all rollers in a room
const SLOT_ROOM = "room"


# name of entries in config.ini:
#
INI_ROLLERS = "devices"
INI_SUNSET_PRE = "mins_before_sunset"
INI_CLOUDY = "cloud_limit"

#
# link between actions and intents:
# intent is linked to action::Funktion
#
# register_intent_action("TEMPLATE_SKILL", TEMPLATE_INTENT_action)
# register_on_off_action(TEMPLATE_INTENT_action)
register_intent_action("Susi:RollerUpDown", Susi_RollerUpDown_action)
register_intent_action("Susi:RollerHalf", Susi_RollerHalf_action)
register_intent_action("Susi:RollerAll", Susi_RollerAll_action)
register_intent_action("Susi:RollerSunprotection", Susi_RollerSun_action)

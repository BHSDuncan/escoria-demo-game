# A simple dialog manager for Escoria
tool
extends EditorPlugin
class_name SimpleDialogPlugin


const MANAGER_CLASS="res://addons/escoria-dialog-simple/esc_dialog_simple.gd"
const SETTINGS_ROOT="escoria/dialog_simple"

const AVATARS_PATH = "%s/avatars_path" % SETTINGS_ROOT
const TEXT_SPEED_PER_CHARACTER = "%s/text_speed_per_character" % SETTINGS_ROOT
const FAST_TEXT_SPEED_PER_CHARACTER = "%s/fast_text_speed_per_character" % SETTINGS_ROOT
const READING_SPEED_IN_WPM = "%s/reading_speed_in_wpm" % SETTINGS_ROOT
const CLEAR_TEXT_BY_CLICK_ONLY = "%s/clear_text_by_click_only" % SETTINGS_ROOT
const LEFT_CLICK_ACTION = "%s/left_click_action" % SETTINGS_ROOT

const LEFT_CLICK_ACTION_SPEED_UP = "Speed up"
const LEFT_CLICK_ACTION_INSTANT_FINISH = "Instant finish"
const LEFT_CLICK_ACTION_NOTHING = "None"


var leftClickActions: Array = [
	LEFT_CLICK_ACTION_SPEED_UP,
	LEFT_CLICK_ACTION_INSTANT_FINISH,
	LEFT_CLICK_ACTION_NOTHING
]


# Override function to return the plugin name.
func get_plugin_name():
	return "escoria-dialog-simple"


# Unregister ourselves
func disable_plugin():
	print("Disabling plugin Escoria Dialog Simple")
	ESCProjectSettingsManager.remove_setting(
		ESCProjectSettingsManager.DEFAULT_DIALOG_TYPE
	)

	ESCProjectSettingsManager.remove_setting(
		AVATARS_PATH
	)

	ESCProjectSettingsManager.remove_setting(
		TEXT_SPEED_PER_CHARACTER
	)

	ESCProjectSettingsManager.remove_setting(
		FAST_TEXT_SPEED_PER_CHARACTER
	)

	ESCProjectSettingsManager.remove_setting(
		CLEAR_TEXT_BY_CLICK_ONLY
	)

	ESCProjectSettingsManager.remove_setting(
		READING_SPEED_IN_WPM
	)

	ESCProjectSettingsManager.remove_setting(
		LEFT_CLICK_ACTION
	)

	EscoriaPlugin.deregister_dialog_manager(MANAGER_CLASS)


# Add ourselves to the list of dialog managers
func enable_plugin():
	print("Enabling plugin Escoria Dialog Simple")

	if EscoriaPlugin.register_dialog_manager(self, MANAGER_CLASS):
		ESCProjectSettingsManager.register_setting(
			ESCProjectSettingsManager.DEFAULT_DIALOG_TYPE,
			"floating",
			{
				"type": TYPE_STRING
			}
		)

		ESCProjectSettingsManager.register_setting(
			AVATARS_PATH,
			"res://game/dialog_avatars",
			{
				"type": TYPE_STRING,
				"hint": PROPERTY_HINT_DIR
			}
		)

		ESCProjectSettingsManager.register_setting(
			TEXT_SPEED_PER_CHARACTER,
			0.1,
			{
				"type": TYPE_REAL
			}
		)

		ESCProjectSettingsManager.register_setting(
			FAST_TEXT_SPEED_PER_CHARACTER,
			0.25,
			{
				"type": TYPE_REAL
			}
		)

		ESCProjectSettingsManager.register_setting(
			CLEAR_TEXT_BY_CLICK_ONLY,
			false,
			{
				"type": TYPE_BOOL
			}
		)

		ESCProjectSettingsManager.register_setting(
			READING_SPEED_IN_WPM,
			200,
			{
				"type": TYPE_INT
			}
		)

		var leftClickActionsString: String = ",".join(leftClickActions)

		ESCProjectSettingsManager.register_setting(
			LEFT_CLICK_ACTION,
			"Speed up",
			{
				"type": TYPE_STRING,
				"hint": PROPERTY_HINT_ENUM,
				"hint_string": leftClickActionsString
			}
		)

	else:
		get_editor_interface().set_plugin_enabled(
			get_plugin_name(),
			false
		)

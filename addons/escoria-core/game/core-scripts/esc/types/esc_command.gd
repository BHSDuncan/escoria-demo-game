# An ESC command
extends ESCStatement
class_name ESCCommand


# Regex matching command lines
#const REGEX = \
#	'^(\\s*)(?<name>[^\\s]+)(\\s(?<parameters>([^\\[]|$)+))?' +\
#	'(\\[(?<conditions>[^\\]]+)\\])?'


# The name of this command
var name: String

# Parameters of this command
var parameters: Array = []

# A list of ESCConditions to run this command.
# Conditions are combined using logical AND
var conditions: Array = []

# True if command was called from a string (usual case) instead of passing parameters directly.
var commandCalledAsString = true

func exported() -> Dictionary:
	var export_dict: Dictionary = .exported()
	export_dict.class = "ESCCommand"
	export_dict.name = name
	export_dict.parameters = parameters
	export_dict.conditions = conditions
	return export_dict


# Check, if conditions match
func is_valid() -> bool:
	if not command_exists():
		escoria.logger.error(
			self,
			"Invalid command detected: %s" % self.name +
				"Command implementation not found in any command directory."
		)
		return false

	return .is_valid()


# Checks that the command exists
#
# *Returns* True if the command exists, else false.
func command_exists() -> bool:
	for base_path in ESCProjectSettingsManager.get_setting(
			ESCProjectSettingsManager.COMMAND_DIRECTORIES
		):
		var command_path = "%s/%s.gd" % [
			base_path.trim_suffix("/"),
			self.name
		]
		if ResourceLoader.exists(command_path):
			return true
	return false


# Run this command
func run() -> int:
	var command_object = escoria.command_registry.get_command(self.name)
	if command_object == null:
		return ESCExecution.RC_ERROR
	else:
		var argument_descriptor = command_object.configure()
		var prepared_arguments = argument_descriptor.prepare_arguments(
			self.parameters
		) if commandCalledAsString else self.parameters

		if command_object.validate(prepared_arguments):
			escoria.logger.debug(
				self,
				"Running command %s with parameters %s."
						% [self.name, prepared_arguments]
			)

			escoria.event_manager.add_running_command(self)

			var rc = command_object.run(prepared_arguments)
			if rc is GDScriptFunctionState:
				rc = yield(rc, "completed")

			escoria.event_manager.running_command_finished(self)

			escoria.logger.debug(
				self,
				"[%s] Return code: %d." % [self.name, rc]
			)
			return rc
		else:
			return ESCExecution.RC_ERROR


# This function interrupts the command. If it was not started, it will not run.
# If it had already started, the execution will be considered as finished
# immediately and finish. If it was already finished, nothing will happen.
func interrupt():
	_is_interrupted = true
	var command = escoria.command_registry.get_command(self.name)
	if command.has_method("interrupt"):
		command.interrupt()


# Override of built-in _to_string function to display the statement.
func _to_string() -> String:
	return "%s: %s" % [name, str(parameters)]

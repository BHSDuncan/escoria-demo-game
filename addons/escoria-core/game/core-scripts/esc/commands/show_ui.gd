## `show_ui()`
##
## Unhides the game UI. Idempotent, so calling this multiple times achieves the same result.
## @ESC
extends ESCBaseCommand
class_name ShowUiCommand


# Return the descriptor of the arguments of this command
func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		0,
		[],
		[]
	)


# Run the command
func run(command_params: Array) -> int:
	escoria.main.current_scene.game.show_ui()

	return ESCExecution.RC_OK


# Function called when the command is interrupted.
func interrupt():
	# Do nothing
	pass

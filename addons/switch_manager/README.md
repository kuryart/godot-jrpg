# Switch Manager

This is a simple tool used for helping manage small one-time events. For example, enemy encounters, dialogue that disappears after interaction, etc.

## Usage

> [!WARNING]
> The Switch Manager will not work unless you [autoload](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) the `state_machine.tscn`!<br/>
> As it will only work if it is a `Singleton`.

If you need to change/add/remove switches outside of runtime, you can change them in `state_machine.tscn`'s scene.<br/>
You can also change the **Save Path** there.

To use the Switch Manager is quite easy, there are easy to use and expand upon functions inside `state_machine.gd`.

Here is a list of functions and their use...

| Function | Arguments | Usage |
|----------|-----------|-------|
| `save_switches()` | None | Saves the current list of switches to a file specified in **SAVE_PATH**. |
| `load_switches()` | None | Loads a list of switches from a file specified in **SAVE_PATH**. |
| `erase_switches()` | None | Erases the current list of switches and clear the file specified in **SAVE_PATH**. |
| `create_switch(..)` | Switch Name, and Switch State (default state is false) | Adds a new switch to the switches list with the specified name and state. |
| `toggle_switch(.)` | Switch Name | Toggles a switch's state, returns the new state. (Flips a `False` state into a `True` one and vice versa) |
| `set_switch_state(..)` | Switch Name, and Switch State (default state is false) | Sets a switch's state to the one specifed.  |
| `get_switch(.)` | Switch Name | Returns a switch's current state, if the switch is unable to be found it will return `null`. |
| `delete_switch(.)` | Switch Name | Deletes a switch from the switches list. |
| `get_switches()` | None | Returns an Array containing the switches. |

> [!WARNING]
> If the `create_switch(..)` recieves a switch name that *already* exists, it will instead set the switch's state to the one specified.

# Support

If you have any issues, create an [Issue](https://github.com/AlecSouthward/Switch-Manager/issues/new) or message me on Discord at `itsmealec`.

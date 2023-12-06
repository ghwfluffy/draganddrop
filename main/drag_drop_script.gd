extends ColorPickerButton

# Returns the data to pass from an object when you click and drag away from
# this object. Also calls set_drag_preview() to show the mouse dragging
# something so the user knows that the operation is working.
func _get_drag_data(_pos):
    # Use another colorpicker as drag preview.
    var cpb = ColorPickerButton.new()
    cpb.color = color
    cpb.size = Vector2(80.0, 50.0)

    # Allows us to center the color picker on the mouse
    var preview = Control.new()
    preview.add_child(cpb)
    cpb.position = -0.5 * cpb.size

    # Sets what the user will see they are dragging
    set_drag_preview(preview)

    # Return color as drag data.
    return [self, color]


# Returns a boolean by examining the data being dragged to see if it's valid
# to drop here.
func _can_drop_data(_pos, data):
    return typeof(data) == 28 and typeof(data[1]) == TYPE_COLOR

# Takes the data being dragged and processes it. In this case, we are
# assigning a new color to the target color picker button.
func _drop_data(_pos, data):
    if data[1] == color:
        color = Color(0, 0, 0, 1)
        data[0].color = Color(0, 0, 0, 1)

    var done = true
    var children = get_tree().current_scene.get_node("GridContainer").get_children()
    for child in children:
        if child.color != Color(0, 0, 0, 1):
            done = false
            break
    if done:
        get_tree().current_scene.get_node("Information").text = "You WIN!"

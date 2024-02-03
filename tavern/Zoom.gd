extends Node

var DEBUG = null;
var camera = null

var last_drag_distance = -1  # Used for pinch zoom

var touch_1 = null
var touch_2 = null

# Called when the node enters the scene tree for the first time.
func _ready():
    camera = get_tree().get_root().get_node("Tavern/Camera2D")
    DEBUG = get_tree().get_root().get_node("Tavern/HUD/DEBUG")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func handle_zoom(event):
    # Handle scroll wheel zoom
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
            camera.zoom -= Vector2(0.01, 0.01)
        elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
            camera.zoom += Vector2(0.01, 0.01)

    if event is InputEventMagnifyGesture:
        var zoom_change = (1.0 - event.factor) * 0.25
        camera.zoom += Vector2(zoom_change, zoom_change)

    # Handle pinch zoom
    if event is InputEventScreenDrag:
        if event.index == 0:  # First touch point
            touch_1 = event.position
        elif event.index == 1:  # Second touch point
            touch_2 = event.position

        if touch_1 and touch_2:
            var current_distance = touch_1.distance_to(touch_2)
            if last_drag_distance != -1:
                var zoom_change = (current_distance - last_drag_distance) * 0.01
                camera.zoom += Vector2(zoom_change, zoom_change)
            last_drag_distance = current_distance

    # Reset pinch zoom tracking on release
    if event is InputEventScreenTouch and event.is_pressed() == false:
        touch_1 = null;
        touch_2 = null;
        last_drag_distance = null;
    elif event is InputEventScreenTouch and event.is_pressed() == true:
        if event.index == 0:  # First touch point
            touch_1 = event.position
        elif event.index == 1:  # Second touch point
            touch_2 = event.position

    if camera.zoom[0] > 2.0:
        camera.zoom = Vector2(2.0, 2.0)
    elif camera.zoom[0] < 0.3:
        camera.zoom = Vector2(0.3, 0.3)

#func _on_background_area_input_event(viewport, event, shape_idx):
    #handle_zoom(event)

func _input(event):
    DEBUG.text = str(event)
    handle_zoom(event)

extends Area2D

var newDeltaX
var newDeltaY
var deltaX
var deltaY
var touchPos = Vector2()
var areaEnt = false

var dragging = false
var camera

func _on_input_event(viewport, event, shape_idx):
    #print(event)
    if event is InputEventMouseButton or event is InputEventScreenTouch:
        if event.pressed:
            touchPos = event.get_position()
            dragging = true
        else:
            dragging = false

    # Only move the character while dragging
    if dragging and event is InputEventMouseMotion:
        var currentPos = event.get_position()
        var delta = currentPos - touchPos
        delta.x *= 0.275
        delta.y *= 0.275
        set_position(get_position() + delta)
        touchPos = currentPos  # Update the touch position
        #camera.offset += delta

#func _input(event):
#    var oldEvent = areaEnt
#    if (event is InputEventMouseButton || event is InputEventScreenTouch):
#        areaEnt = event.pressed
#    if areaEnt && !oldEvent:
#        touchPos = event.get_position()
#    # Letting go
#    if !areaEnt && oldEvent:
#        deltaX = event.get_position().x - touchPos.x
#        deltaY = event.get_position().y - touchPos.y
#        #set_position(get_position() + Vector2(deltaX, deltaY))
#        print(Vector2(deltaX,deltaY))
#        set_position(get_position() + Vector2(deltaX,deltaY))

# Called when the node enters the scene tree for the first time.
func _ready():
    camera = get_tree().get_root().get_node("Tavern/Camera2D") # Make sure to set 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

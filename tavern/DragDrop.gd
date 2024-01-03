extends Node

var camera = null
var player = null
var touchPos = null
var dragging = null

class Draggable:
    func move(delta) -> void:
        pass

    func done_moving() -> void:
        pass

    func is_background() -> bool:
        return false

class DragPlayer extends Draggable:
    func _init(camera, player, sprite):
        self.camera = camera
        self.player = player
        self.sprite = sprite

    func move(delta) -> void:
        delta.x *= 0.275
        delta.y *= 0.275
        delta.x /= camera.zoom[0]
        delta.y /= camera.zoom[1]
        player.set_position(player.get_position() + delta)
        if abs(delta.y) > abs(delta.x):
            if delta.y < 0:
                sprite.texture = load("res://character/assets/boy-up.png")
            elif delta.y > 0:
                sprite.texture = load("res://character/assets/boy-down.png")
        else:
            if delta.x < 0:
                sprite.texture = load("res://character/assets/boy-left.png")
            elif delta.x > 0:
                sprite.texture = load("res://character/assets/boy-right.png")

    func done_moving() -> void:
        sprite.texture = load("res://character/assets/boy-down.png")

    var camera = null
    var player = null
    var sprite = null

class DragCamera extends Draggable:
    func _init(camera):
        self.camera = camera

    func move(delta) -> void:
        delta.x *= -1
        delta.y *= -1
        delta.x /= self.camera.zoom[0]
        delta.y /= self.camera.zoom[1]
        camera.offset += delta

    func is_background() -> bool:
        return true

    var camera = null
    
func _ready():
    var camera_instance = get_tree().get_root().get_node("Tavern/Camera2D")
    camera = DragCamera.new(camera_instance)
    player = DragPlayer.new(
        camera_instance,
        get_tree().get_root().get_node("Tavern/Player"),
        get_tree().get_root().get_node("Tavern/Player/Sprite2D"),
    )

func handle_drag(draggable, event):
    var is_move_event = event is InputEventMouseButton or event is InputEventScreenTouch
    if is_move_event:
        if event.pressed:
            if dragging == null:
                touchPos = event.get_position()
                dragging = draggable
            elif dragging != draggable and !draggable.is_background():
                dragging.done_moving()
                dragging = draggable
        elif dragging:
            dragging.done_moving()
            dragging = null

    if dragging:
        var currentPos = event.get_position()
        var delta = currentPos - touchPos
        dragging.move(delta)
        touchPos = currentPos  # Update the touch position


func _on_player_input_event(viewport, event, shape_idx):
    handle_drag(player, event)

func _on_background_area_input_event(viewport, event, shape_idx):
    handle_drag(camera, event)

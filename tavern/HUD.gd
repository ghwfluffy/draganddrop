extends CanvasLayer

var inventory = null

func set_item_visible(item, visible: bool) -> void:
    if item is Sprite2D:
        item.visible = visible
    for child in item.get_children():
        set_item_visible(child, visible)
        
func get_item_visible(item) -> bool:
    if item is Sprite2D:
        return item.visible
    for child in item.get_children():
        if child is Sprite2D:
            return child.visible
    return false
        

# Called when the node enters the scene tree for the first time.
func _ready():
    inventory = get_node("Inventory")
    set_item_visible(inventory, false)

func _on_inventory_button_pressed():
    set_item_visible(inventory, !get_item_visible(inventory))

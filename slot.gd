extends Panel

var item = null
var stack_count = 0

@onready var icon = $CenterContainer/Panel/item
@onready var count_label = $ItemQuantity

func set_item(new_item,quantity):
	item = new_item
	stack_count = quantity
	update_slot()

func update_slot():
	if item:
		icon.texture = item["texture"]
		count_label.text = str(stack_count)
	else:
		icon.texture = null
		count_label.text = ""

func clear_slot():
	item = null
	stack_count = 0
	update_slot()

func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if item:
				get_tree().set_input_as_handled()
				emit_signal("item_selected", self)

# Signals for item interactions
signal item_selected(inventory_slot)

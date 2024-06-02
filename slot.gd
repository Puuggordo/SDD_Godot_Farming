extends Panel

var item = null
var stack_count = 0

@onready var icon = $CenterContainer/Panel/item
@onready var count_label = $ItemQuantity

func set_item(new_item,quantity):
	icon.texture = new_item["texture"]
	count_label.text = str(quantity)

func set_empty():
	item = null
	icon.texture = null
	count_label.text = ""

func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if item:
				get_tree().set_input_as_handled()
				emit_signal("item_selected", self)

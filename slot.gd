extends Panel

var item = null
var stack_count = 0

@onready var icon = $CenterContainer/Panel/item
@onready var count_label = $ItemQuantity
@onready var BG_sprite = $background

func set_item(new_item,quantity):
	icon.texture = new_item["texture"]
	count_label.text = str(quantity)
	set_tooltip_text(new_item["name"])
	BG_sprite.frame = 1


func set_empty():
	item = null
	icon.texture = null
	count_label.text = ""
	set_tooltip_text("")
	BG_sprite.frame = 0

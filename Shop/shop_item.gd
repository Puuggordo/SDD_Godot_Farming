extends Control

@onready var icon = $TextureRect
@onready var name_label = $Name
@onready var cost_label = $Cost
@onready var quantity_label = $Quantity

@export var item: Item


func _ready():
	cost_label.text = str(item.cost) + " Honey"
	name_label.text = item.item_name
	icon.texture = item.item_texture
	update_shop()

func update_shop():
	Global.add_item_to_shop(item)

func _process(delta):
	quantity_label.text = str(item.quantity)


func _on_up_pressed():
	item.quantity+=1
	update_shop()


func _on_down_pressed():
	if !item.quantity <= 0:
		item.quantity -=1
	update_shop()

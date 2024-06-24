extends Control

@onready var icon = $TextureRect
@onready var name_label = $Name
@onready var cost_label = $Cost
@onready var quantity_label = $Quantity

@export var quantity = 0
@export var item_type = ""
@export var item_name = ""
@export var description = ""
@export var max_stack = 5
@export var item_texture : Texture2D = null
@export var cost = 100


func _ready():
	cost_label.text = str(cost) + " Honey"
	name_label.text = item_name
	icon.texture = item_texture
	update_shop()

func update_shop():
	var item_dictionary = {
		"quantity":quantity,
		"type":item_type,
		"name":item_name,
		"texture":item_texture,
		"max_stack":max_stack,
		"cost":cost
	}
	Global. add_item_to_shop(item_dictionary)
	

func _process(delta):
	quantity_label.text = str(quantity)


func _on_up_pressed():
	quantity +=1
	update_shop()


func _on_down_pressed():
	if !quantity <= 0:
		quantity -=1
	update_shop()

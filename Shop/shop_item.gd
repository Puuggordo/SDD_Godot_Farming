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
	tooltip_text = """Strengths: %s 
	Weaknesses: %s 
	Pollen range: %s-%s""" % [str(item.strengths), str(item.weaknesses), str(item.pollen_range_min), str(item.pollen_range_max)]
	update_shop()

func update_shop():
	# Add the current item to the shop's inventory.
	Global.add_item_to_shop(item)

func _process(delta):
	# Continuously update the quantity label to display the current quantity of the item.
	quantity_label.text = str(item.quantity)

func _on_up_pressed():
	# Increment the item quantity by 1 when the up button is pressed.
	item.quantity += 1
	# Update the shop to reflect the new quantity.
	update_shop()

func _on_down_pressed():
	# Decrement the item quantity by 1 if it's greater than 0 when the down button is pressed.
	if !item.quantity <= 0:
		item.quantity -= 1
	# Update the shop to reflect the new quantity.
	update_shop()

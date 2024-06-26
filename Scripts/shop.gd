extends CanvasLayer

var current_item = 0
var select = 0
@onready var name_label = $ScrollContainer/VBoxContainer/ItemContainer/Item/Name
@onready var cost_label = $ScrollContainer/VBoxContainer/ItemContainer/Item/Cost
@onready var quantity_label = $ScrollContainer/VBoxContainer/ItemContainer/Item/Quantity
@onready var item_container = $ScrollContainer/VBoxContainer/ItemContainer.get_child_count()
@onready var total_label = $ScrollContainer/VBoxContainer/Total
var sum = 0

func _process(delta):
	total_label.text = "Total: " + str(sum)
	cart_update()

func cart_update():
	sum = 0
	for i in range(Global.shop_items.size()):
		if Global.shop_items[i] !=null:
			sum += Global.shop_items[i]["cost"]*Global.shop_items[i]["quantity"]


func currency_checker():
	var sufficent_funds
	if Global.player_funds >= sum:
		Global.player_funds-=sum
		sum = 0
		sufficent_funds =  true
	else:
		print("Insufficent funds")
		sufficent_funds = false
	print(Global.player_funds)

func _on_button_pressed():
	currency_checker()

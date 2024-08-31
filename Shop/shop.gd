extends CanvasLayer

var current_item = 0
var select = 0
@onready var name_label = $ScrollContainer/ItemContainer/Item/Name
@onready var cost_label = $ScrollContainer/ItemContainer/Item/Cost
@onready var quantity_label = $ScrollContainer/ItemContainer/Item/Quantity
@onready var item_container = $ScrollContainer/ItemContainer.get_child_count()
@onready var total_label = $Total
var sum = 0
var sufficent_funds


func _process(delta):
	total_label.text = "Total: " + str(sum)
	cart_update()


func cart_update():
	sum = 0
	for i in range(Global.shop_items.size()):
		if Global.shop_items[i] !=null:
			sum += Global.shop_items[i].cost*Global.shop_items[i].quantity


func currency_checker():
	if Global.player_funds >= sum:
		Global.player_funds-=sum
		sum = 0
		sufficent_funds =  true
	else:
		print("Insufficent funds")
		sufficent_funds = false

func shop_item_to_inventory():
	for i in range(Global.shop_items.size()):
		if Global.shop_items[i] != null:
			print(Global.shop_items[i].quantity)
			if Global.shop_items[i].quantity != 0:
				Global.add_item_to_inventory(Global.shop_items[i])
				Global.shop_items[i].quantity = 0


func _on_button_pressed():
	currency_checker()
	if sufficent_funds:
		shop_item_to_inventory()



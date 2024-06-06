extends CanvasLayer

var current_item = 0
var select = 0
@onready var icon = $Control/AnimatedSprite2D
@onready var name_label = $Control/Name
@onready var cost_label = $Control/Cost
@onready var buy_button = $Control/Buy
func _ready():
	switchItem(current_item)


func switchItem(select):
	for i in range(Global.shop_items.size()):
		if select == i:
			current_item = select
			icon.play(Global.shop_items[current_item]["Name"])
			name_label.text = Global.shop_items[current_item]["Name"]
			cost_label.text = "Cost: " + str(Global.shop_items[current_item]["Cost"])


func buy_button_display():
	if current_item == 0 and Global.strawberry_buy == false:
			buy_button.text = "Buy"
			buy_button.disabled = false
	elif current_item == 1 and Global.lettuce_buy == false:
			buy_button.text = "Buy"
			buy_button.disabled = false
	elif current_item == 2 and Global.corn_buy == false:
			buy_button.text = "Buy"
			buy_button.disabled = false
	else:
		buy_button.text = "Bought"
		buy_button.disabled = true

func coin_buy():
	if Global.coin_number >= Global.shop_items[current_item]["Cost"]:
		Global.coin_number -= Global.shop_items[current_item]["Cost"]
		buy_button.text = "Bought"
		buy_button.disabled = true


func _on_next_pressed():
	switchItem(current_item + 1)
	buy_button_display()


func _on_prev_pressed():
	switchItem(current_item - 1)
	buy_button_display()


func _on_buy_pressed():
	if current_item == 0:
		if Global.strawberry_buy == false:
			coin_buy()
			Global.strawberry_buy = true
	elif current_item == 1:
		if Global.lettuce_buy == false:
			coin_buy()
			Global.lettuce_buy = true
	elif current_item == 2:
		if Global.corn_buy == false:
			coin_buy()
			Global.corn_buy = true


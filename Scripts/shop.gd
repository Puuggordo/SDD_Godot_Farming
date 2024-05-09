extends CanvasLayer

var current_item = 0
var select = 0

func _ready():
	switchItem(current_item)


func switchItem(select):
	for i in range(Global.item.size()):
		if select == i:
			current_item = select
			$Control/AnimatedSprite2D.play(Global.item[current_item]["Name"])
			$Control/Name.text = Global.item[current_item]["Name"]
			$Control/Cost.text = "Cost: " + str(Global.item[current_item]["Cost"])


func buy_button_display():
	if current_item == 0 and Global.strawberry_buy == false:
			$Control/Buy.text = "Buy"
			$Control/Buy.disabled = false
	elif current_item == 1 and Global.lettuce_buy == false:
			$Control/Buy.text = "Buy"
			$Control/Buy.disabled = false
	elif current_item == 2 and Global.corn_buy == false:
			$Control/Buy.text = "Buy"
			$Control/Buy.disabled = false
	else:
		$Control/Buy.text = "Bought"
		$Control/Buy.disabled = true

func coin_buy():
	if Global.coin_number >= Global.item[current_item]["Cost"]:
		Global.coin_number -= Global.item[current_item]["Cost"]
		$Control/Buy.text = "Bought"
		$Control/Buy.disabled = true


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


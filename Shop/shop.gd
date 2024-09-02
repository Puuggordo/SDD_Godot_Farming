extends CanvasLayer

var current_item = 0
var select = 0
@onready var item_container = $ScrollContainer/ItemContainer.get_child_count()
@onready var total_label = $Total
var sum = 0
var sufficent_funds


func _process(delta):
	# Update the total label with the current sum.
	total_label.text = "Total: " + str(sum)
	# Call cart_update to recalculate the sum of items in the cart.
	cart_update()

func cart_update():
	# Reset the sum to 0 before calculating.
	sum = 0
	# Iterate through each item in the shop's inventory.
	for i in range(Global.shop_items.size()):
		# If the item exists, add its cost multiplied by its quantity to the sum.
		if Global.shop_items[i] != null:
			sum += Global.shop_items[i].cost * Global.shop_items[i].quantity

func currency_checker():
	# Check if the player has enough funds to cover the total sum.
	if Global.player_funds >= sum:
		# Deduct the sum from the player's funds and reset the sum to 0.
		Global.player_funds -= sum
		sum = 0
		# Set sufficient_funds to true, indicating the player can afford the purchase.
		sufficent_funds = true
	else:
		# Print a message if the player doesn't have enough funds and set sufficient_funds to false.
		print("Insufficient funds")
		sufficent_funds = false

func shop_item_to_inventory():
	# Iterate through each item in the shop's inventory.
	for i in range(Global.shop_items.size()):
		# If the item exists, proceed to check its quantity.
		if Global.shop_items[i] != null:
			# If the item's quantity is not zero, add it to the player's inventory and reset its quantity to zero.
			if Global.shop_items[i].quantity != 0:
				Global.add_item_to_inventory(Global.shop_items[i])
				Global.shop_items[i].quantity = 0

func _on_button_pressed():
	# Check if the player has sufficient funds before proceeding with the purchase.
	currency_checker()
	# If the player has enough funds, transfer the shop items to the player's inventory.
	if sufficent_funds:
		shop_item_to_inventory()



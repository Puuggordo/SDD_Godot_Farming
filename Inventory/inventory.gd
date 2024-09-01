extends Control


@onready var grid_container = $NinePatchRect/GridContainer


func _ready():
	# Connects the inventory update signal to the on_inventory_update function.
	Global.inventoryUpdate.connect(on_inventory_update)
	# Calls the on_inventory_update function immediately to initialise the inventory display.
	on_inventory_update()

# Function that gets called whenever the inventory needs to be updated
func on_inventory_update():
	# Clears the grid container to prepare it for the updated inventory slots.
	Global.clear_grid(grid_container)
	# Get the total number of items in the inventory.
	var total_items = Global.inventory.size()
	# Loop through each item in the inventory.
	for i in range(total_items):
		var item = Global.inventory[i]
		# Instantiate a new slot for each item.
		var slot = Global.slot_scene.instantiate()
		# Add the new slot to the grid container.
		grid_container.add_child(slot)
		# Set the default background color of the slot to white.
		slot.BG_sprite.self_modulate = Color.WHITE
		# If the item is one of the last 5 items, change the background color to a specific shade.
		if i >= total_items - 5:
			slot.BG_sprite.self_modulate = Color.html("c5a392")
		# If the item is not null, set the item in the slot with its quantity.
		if item != null:
			slot.set_item(item, item.quantity)
		else:
			# If the item is null, set the slot as empty.
			slot.set_empty()
	# Ensure all items in the inventory are unique after updating.
	Global.make_items_unique()



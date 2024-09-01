extends Control

@onready var container = $NinePatchRect/HBoxContainer
var selected_slot = 0


func _ready():
	# Connect the inventory update signal to the on_hotbar_update function and call it to initialize the hotbar.
	Global.inventoryUpdate.connect(on_hotbar_update)
	on_hotbar_update()


func _process(delta):
	# Loop through slot numbers to ensure selected_slot stays within the valid range.
	if selected_slot > 4:
		selected_slot = 0
	elif selected_slot < 0:
		selected_slot = 4
	# Update the slot selection panel to visually represent the currently selected slot.
	slot_selection_panel()
	# Set the currently selected hotbar item based on the selected slot index.
	Global.hotbar_selected_item = Global.inventory[selected_slot + 10]


# Function called when the signal to update the inventory is received.
func on_hotbar_update():
	# Clear the existing items in the container to prepare for new updates.
	Global.clear_grid(container)
	var total_items = Global.inventory.size()
	# Iterate through each item in the inventory to update the hotbar slots.
	for i in range(total_items):
		var item = Global.inventory[i]
		var slot = Global.slot_scene.instantiate()
		# Highlight the last five slots differently.
		if i >= total_items - 5:
			container.add_child(slot)
			slot.inventory_slot = false
			slot.BG_sprite.self_modulate = Color.html("c5a392")
			# Set the slot with item details if the item is not null; otherwise, set it as empty.
			if item != null:
				slot.set_item(item, item.quantity)
			else:
				slot.set_empty()
	# Ensure all items in the inventory are unique after update.
	Global.make_items_unique()


func slot_selection_panel():
	# Update the visibility of the selection panel based on the selected slot.
	for i in range(container.get_child_count()):
		var slot = container.get_child(i)
		if selected_slot == i:
			slot.select_panel.show()  # Show the selection panel for the selected slot.
		else:
			slot.select_panel.hide()  # Hide the selection panel for other slots.


func _unhandled_input(event):
	# Handle input for scrolling through hotbar slots if scrolling is allowed.
	if Global.hotbar_can_scroll:
		if event.is_action_pressed("scroll_up"):
			selected_slot += 1  # Move to the next slot when scrolling up.
		if event.is_action_pressed("scroll_down"):
			selected_slot -= 1  # Move to the previous slot when scrolling down.

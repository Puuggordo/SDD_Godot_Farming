extends Panel

var item = null
var stack_count = 0

@onready var icon = $CenterContainer/item
@onready var count_label = $ItemQuantity
@onready var BG_sprite = $background


func set_item(new_item: Item,quantity):
	icon.texture = new_item.item_texture
	count_label.text = str(quantity)
	set_tooltip_text(new_item.item_name)
	BG_sprite.frame = 1


func set_empty():
	item = null
	icon.texture = null
	count_label.text = ""
	set_tooltip_text("")
	BG_sprite.frame = 0


func _get_drag_data(at_position):
	# Get index of selected item
	var selected_item_index = get_index()
	# Get selected item
	var selected_item = Global.inventory[selected_item_index]
	# If the selected item is an item (not null)
	if selected_item is Item:
		# Remove at the selected item index and replace with null
		# This is to 
		Global.inventory.remove_at(selected_item_index)
		Global.inventory.insert(selected_item_index, null)
		# Put selected item and its index into a dictonary called data
		var data = {} 
		data.selected_item = selected_item
		data.selected_item_index = selected_item_index
		# Set the current item being dragged = data (There is an item being dragged)
		Global.current_drag_data = data
		#var drag_preview = drag_preview_scene.instantiate()
		#get_parent().add_child(drag_preview)
		#drag_preview.texture = selected_item.item_texture
		# Send a singal to update the inventory
		Global.inventoryUpdate.emit()
		# Give the data to the _can_drop_data function
		return data

# Checks if the the data can be dropped at the current mouse position (If the node under the mouse position is a slot)
func _can_drop_data(at_position, data):
	# If true, then give the data to the _drop_data function
	return data


func _drop_data(at_position, data):
	# Get index of where the selected item is going to be dropped
	var new_item_index = get_index()
	# TODO: rename new item index to "item of where the selected item is going to be dropped"
	# Get the item of where the selected item is going to be dropped
	var new_item = Global.inventory[new_item_index]
	Global.inventory.remove_at(data.selected_item_index)
	Global.inventory.insert(data.selected_item_index,new_item)
	Global.inventory.remove_at(new_item_index)
	Global.inventory.insert(new_item_index,data.selected_item)
	# Set the current item being dragged = null (There is no item being dragged)
	Global.current_drag_data = null
	# Send a singal to update the inventory
	Global.inventoryUpdate.emit()

func _notification(what: int) -> void:
	# If the drag is not successful
	if what == NOTIFICATION_DRAG_END and not get_viewport().gui_is_drag_successful():
		# If the dragged slot not = null
		if Global.current_drag_data != null:
			# Remove the slot at the begining slot (remove null)
			Global.inventory.remove_at(Global.current_drag_data.selected_item_index)
			# Insert the dragged slot back to its previous position
			Global.inventory.insert(Global.current_drag_data.selected_item_index, Global.current_drag_data.selected_item)
			# Send a singal to update the inventory
			Global.inventoryUpdate.emit()


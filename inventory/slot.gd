extends Panel


var stack_count = 0
var inventory_slot = true
@onready var icon = $CenterContainer/item
@onready var count_label = $ItemQuantity
@onready var BG_sprite = $background
@onready var select_panel = $Panel


func _ready():
	select_panel.hide()


func set_item(new_item: Item,quantity):
	icon.texture = new_item.item_texture
	count_label.text = str(quantity)
	set_tooltip_text(new_item.item_name)
	BG_sprite.frame = 1
	if new_item.type == "flower":
		tooltip_text = """Strengths: %s 
		Weaknesses: %s 
		Pollen range: %s-%s""" % [str(new_item.strengths), str(new_item.weaknesses), str(new_item.pollen_range_min), str(new_item.pollen_range_max)]
	if new_item.type == "fertiliser":
		tooltip_text = """Pollen effect: %s
		Growth effect: %s""" %[str(new_item.effect_pollen), str(new_item.effect_growth)]

func set_empty():
	icon.texture = null
	count_label.text = ""
	set_tooltip_text("")
	BG_sprite.frame = 0
	tooltip_text = ""


func _get_drag_data(at_position):
	# Get index of selected item
	var selected_slot_index = get_index()
	# Get selected item
	var selected_slot = Global.inventory[selected_slot_index]
	# If the selected item is an item (not null) and a inventory slot
	if selected_slot is Item and inventory_slot:
		# Remove at the selected item index and replace with null
		Global.inventory.remove_at(selected_slot_index)
		Global.inventory.insert(selected_slot_index, null)
		# Put selected item and its index into a dictonary called data
		var data = {} 
		data.selected_slot = selected_slot
		data.selected_slot_index = selected_slot_index
		# Set the current item being dragged = data (There is an item being dragged)
		Global.current_drag_data = data
		# Send a singal to update the inventory
		Global.inventoryUpdate.emit()
		# Give the data to the _can_drop_data function
		return data

# Checks if the the data can be dropped at the current mouse position (If the node under the mouse position is a slot)
func _can_drop_data(at_position, data):
	# If the slot is a inventory slot, then give the data to the _drop_data function
	if inventory_slot:
		return data


func _drop_data(at_position, data):
	# Get index of where the selected item is going to be dropped
	var dropped_slot_index = get_index()
	# Get the item of where the selected item is going to be dropped
	var dropped_slot = Global.inventory[dropped_slot_index]
	Global.inventory.remove_at(data.selected_slot_index)
	Global.inventory.insert(data.selected_slot_index,dropped_slot)
	Global.inventory.remove_at(dropped_slot_index)
	Global.inventory.insert(dropped_slot_index,data.selected_slot)
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
			Global.inventory.remove_at(Global.current_drag_data.selected_slot_index)
			# Insert the dragged slot back to its previous position
			Global.inventory.insert(Global.current_drag_data.selected_slot_index, Global.current_drag_data.selected_slot)
			# Send a singal to update the inventory
			Global.inventoryUpdate.emit()


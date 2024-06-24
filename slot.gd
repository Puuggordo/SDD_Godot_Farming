extends Panel

var item = null
var stack_count = 0

@onready var icon = $CenterContainer/item
@onready var count_label = $ItemQuantity
@onready var BG_sprite = $background
@onready var drag_preview_scene = preload("res://drag_preview.tscn")


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
		var data = {} 
		data.selected_item = selected_item
		data.selected_item_index = selected_item_index
		Global.current_drag_data = data
		var drag_preview = drag_preview_scene.instantiate()
		get_parent().add_child(drag_preview)
		drag_preview.texture = selected_item.item_texture
		Global.inventoryUpdate.emit()
		return data


func _can_drop_data(at_position, data):
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
	Global.current_drag_data = null
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
			Global.inventoryUpdate.emit()


extends Control

@onready var container = $NinePatchRect/HBoxContainer
var selected_slot = 0


func _ready():
	Global.inventoryUpdate.connect(on_hotbar_update)
	on_hotbar_update()

func _process(delta):
	if selected_slot > 4:
		selected_slot = 0
	elif selected_slot < 0:
		selected_slot = 4
	slot_selection_panel()
	Global.hotbar_selected_item = Global.inventory[selected_slot+10]

# When the singal to update the inventory is received 
func on_hotbar_update():
	Global.clear_grid(container)
	var total_items = Global.inventory.size()
	for i in range(total_items):
		var item = Global.inventory[i]
		var slot = Global.slot_scene.instantiate()
		if i >= total_items - 5:
			container.add_child(slot)
			slot.inventory_slot = false
			slot.BG_sprite.self_modulate = Color.html("c5a392")
			if item != null:
				slot.set_item(item, item.quantity)
			else:
				slot.set_empty()
	Global.make_items_unique()


func slot_selection_panel():
	for i in range(container.get_child_count()):
		var slot = container.get_child(i)
		if selected_slot == i:
			slot.select_panel.show()
		else:
			slot.select_panel.hide()

func _unhandled_input(event):
	if Global.hotbar_can_scroll:
		if event.is_action_pressed("scroll_up"):
			selected_slot += 1
		if event.is_action_pressed("scroll_down"):
			selected_slot -= 1

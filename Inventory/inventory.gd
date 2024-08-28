extends Control


@onready var grid_container = $NinePatchRect/GridContainer


func _ready():
	Global.inventoryUpdate.connect(on_inventory_update)
	on_inventory_update()

# When the singal to update the inventory is received 
func on_inventory_update():
	Global.clear_grid(grid_container)
	var total_items = Global.inventory.size()
	for i in range(total_items):
		var item = Global.inventory[i]
		var slot = Global.slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.BG_sprite.self_modulate = Color.WHITE
		if i >= total_items - 5:
			slot.BG_sprite.self_modulate = Color.html("c5a392")
		if item != null:
			slot.set_item(item, item.quantity)
		else:
			slot.set_empty()
	Global.make_items_unique()



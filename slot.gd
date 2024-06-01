extends Panel

@onready var backgroundSprite = $background
@onready var itemSprite = $CenterContainer/Panel/item

func update(slot: InventorySlot):
	if !slot.item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = slot.item.texture

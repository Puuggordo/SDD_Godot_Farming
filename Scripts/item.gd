class_name Item
extends Resource

enum weather_types {rain, wind, heat, drought, snow}
@export var quantity: int
@export var item_name: String
@export_enum("flower", "fertiliser") var type: String
@export var item_texture: Texture2D
@export var max_stack: int
@export var cost: int
@export var inventory_quantity: int
@export var shop_quantity: int

@export_subgroup("Flower")
@export var strengths: Array[weather_types]
@export var weaknesses: Array[weather_types]

@export_subgroup("Fertiliser")
@export var effect_pollen: int
@export var effect_growth: int
@export var effect_add_strengths: Array[weather_types]
@export var effect_remove_weaknesses: Array[weather_types]

#var item_data = {
	#"quantity": quantity,
	#"item_name": item_name,
	#"type": type,
	#"texture": item_texture,
	#"max_stack": max_stack,
	#"cost": cost,
	#"inventory_quantity": inventory_quantity,
	#"shop_quantity": shop_quantity,
	#"strengths": strengths,
	#"weaknesses": weaknesses,
	#"effect_pollen": effect_pollen,
	#"effect_growth": effect_growth,
	#"effect_add_strengths": effect_add_strengths,
	#"effect_remove_weaknesses": effect_remove_weaknesses,
#}

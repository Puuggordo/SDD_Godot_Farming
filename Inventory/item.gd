class_name Item
extends Resource

var weather_types = ["rain", "wind", "heat", "drought", "snow"]
@export var quantity: int
@export var item_name: String
@export_enum("flower", "fertiliser") var type: String
@export var item_texture: Texture2D
@export var max_stack: int
@export var cost: int
#@export var inventory_quantity: int
#@export var shop_quantity: int

@export_subgroup("Flower")
@export var strengths: Array[String]
@export var weaknesses: Array[String]
@export var pollen_range_min: int
@export var pollen_range_max: int
@export var growth_frames: SpriteFrames

@export_subgroup("Fertiliser")
@export var effect_pollen: float
@export var effect_growth: float
@export var effect_add_strengths: Array[String]
@export var effect_remove_weaknesses: Array[String]

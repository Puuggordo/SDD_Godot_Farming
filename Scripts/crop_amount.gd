extends PanelContainer

@onready var carrot_amount = %carrot_amount
@onready var onion_amount = %onion_amount
@onready var strawberry_amount = %strawberry_amount
@onready var corn_amount = %corn_amount
@onready var lettuce_amount = %lettuce_amount
@onready var apple_amount = %apple_amount
@onready var orange_amount = %orange_amount


func _ready():
	pass

func _process(_delta):
	size.y = 0
	carrot_amount.text = "= " + str(Global.carrot_number)
	onion_amount.text = "= " + str(Global.onion_number)
	strawberry_amount.text = "= " + str(Global.strawberry_number)
	lettuce_amount.text = "= " + str(Global.lettuce_number)
	corn_amount.text = "= " + str(Global.corn_number)
	apple_amount.text = "= " + str(Global.apple_number)
	orange_amount.text = "= " + str(Global.orange_number)

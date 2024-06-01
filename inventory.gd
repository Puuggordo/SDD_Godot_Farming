extends Control

signal opened
signal closed

var isOpen = false

@onready var inventory = preload("res://playerInventory.tres")
@onready var slots = $NinePatchRect/GridContainer.get_children()


func _ready():
	update()

func update():
	for i in range(min(inventory.slots.size(),slots.size())):
		slots[i].update(inventory.slots[i])


func open():
	visible = true
	isOpen = true
	opened.emit()


func close():
	visible = false
	isOpen = false
	closed.emit()

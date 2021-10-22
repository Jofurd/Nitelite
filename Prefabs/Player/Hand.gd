extends Node2D


var inventory = preload("res://Prefabs/Items/Inventory.tres")
onready var heldItem = $Item


func _ready():
	inventory.connect("items_changed", self, "updateHeldItem")

func updateHeldItem(_indexes):
	var primarySlot = inventory.items[0]
	if primarySlot is Item:
		if primarySlot.heldForm != null:
			if heldItem != null:
				heldItem.queue_free()
			var newItem = load(primarySlot.heldForm)
			heldItem = newItem.instance()
			self.add_child(heldItem)
		else:
			loademptyHand()
	else:
		loademptyHand()

func loademptyHand():
	if heldItem != null:
		heldItem.queue_free()
	var emptyHand = load("res://Prefabs/Items/EmptyHand.tscn")
	heldItem = emptyHand.instance()
	self.add_child(heldItem)

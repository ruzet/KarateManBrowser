extends Node2D
@onready var ActiveProjectiles = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	for ActiveProjectile in ActiveProjectiles:
		ActiveProjectile.update(delta)
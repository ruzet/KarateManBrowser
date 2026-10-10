extends Node2D

@onready var ActiveProjectiles = []

func _ready() -> void:
	ActiveProjectiles.append(Projectile.new())
	
	for ActiveProjectile in ActiveProjectiles:
		ActiveProjectile.init()
	pass

func _process(_delta: float) -> void:
	pass

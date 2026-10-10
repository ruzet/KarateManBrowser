extends Node2D

@onready var ActiveProjectiles = []

func _ready() -> void:
	while true:
		var NewProj = Projectile.new()
		add_child(NewProj)
		NewProj.init()
		ActiveProjectiles.append(NewProj)

func _process(delta: float) -> void:
	for ActiveProjectile in ActiveProjectiles:
		ActiveProjectile.update(delta)

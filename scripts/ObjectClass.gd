class_name Projectile
extends Node2D

@export var XVelocity = 200
@export var YVelocity = 1150
@export var Gravity = 1500
@export var Scale = 3
@export var ScaleDecrement = 0.025
@export var ProjectileNode = Sprite2D.new()

func init(ProjectileType: String = "Pot"):
	self.position = Vector2(800, 600)
	self.name = "Projectile"
	self.z_index = -10
	ProjectileNode.name = "ProjectileSprite"
	ProjectileNode.texture = load("res://assets/Projectiles/" + ProjectileType + ".png")
	add_child(ProjectileNode)

func update(delta):
	Scale -= ScaleDecrement
	self.position = Vector2(self.position.x - (XVelocity * delta), self.position.y - (YVelocity * delta))
	if self.position.y > 400 && YVelocity < 0:
		XVelocity = 0
		YVelocity = 0
		Gravity = 0 
		ScaleDecrement = 0
	self.scale = Vector2(Scale, Scale)
	YVelocity -= Gravity * delta

func delete():
	self.queue_free()

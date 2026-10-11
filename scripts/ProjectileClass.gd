class_name Projectile
extends Node2D

@export var XVelocity = 150
@export var YVelocity = 1150
@export var Gravity = 1500
@export var Scale = 3
@export var ScaleDecrement = 0.03
@export var RotatePerFrame = 0
@export var TimeExisting = 0
@export var ProjectileNode = Sprite2D.new()
@export var Type: String

func init(ProjectileType: String = "Pot"):
	self.position = Vector2(900, 610)
	self.name = "Projectile"
	self.z_index = -10
	Type = ProjectileType
	ProjectileNode.name = "ProjectileSprite"
	ProjectileNode.texture = load("res://assets/Projectiles/" + ProjectileType + ".png")
	add_child(ProjectileNode)

func update(delta):
	Scale -= ScaleDecrement
	TimeExisting += delta

	self.position = Vector2(self.position.x - (XVelocity * delta), self.position.y - (YVelocity * delta))
	self.rotation_degrees = self.rotation_degrees - RotatePerFrame
	if self.position.y > 600 && YVelocity < -50:
		XVelocity = 0
		YVelocity = 0
		Gravity = 0 
		ScaleDecrement = 0
		RotatePerFrame = 0
	self.scale = Vector2(Scale, Scale)
	YVelocity -= Gravity * delta

func delete():
	self.queue_free()

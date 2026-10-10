class_name Projectile
extends Node2D

@export var XVelocity = 0
@export var YVelocity = 0
@export var Gravity = 10
@export var Scale = 5
@export var ProjectileNode = Sprite2D.new()

func init(ProjectileType: String = "Pot"):
	self.name = "Projectile"
	ProjectileNode.name = "ProjectileSprite"
	ProjectileNode.texture = load("res://assets/Projectiles/" + ProjectileType + ".png")
	add_child(ProjectileNode)

func update(delta):
	self.position = Vector2(self.position.x - (XVelocity * delta), self.position.y - (YVelocity * delta))
	self.scale = Vector2(Scale, Scale)
	YVelocity -= Gravity * delta

func delete():
	self.queue_free()
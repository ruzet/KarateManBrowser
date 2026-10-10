class_name Projectile
extends Node

@export var XVelocity = 0
@export var YVelocity = 0
@export var Gravity = 0
@export var Size = 0
@export var ProjectileNode = Sprite2D.new()

func init():
	ProjectileNode.name = "Projectile"
	add_child(ProjectileNode)
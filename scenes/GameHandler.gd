extends Node2D
@onready var SongPlayer = find_child("SongPlayer")
@onready var Metronome = find_child("Metronome")
@onready var Beat = find_child("Beat")
@onready var Offset = find_child("Offset")

@onready var KarateJoeHead = find_child("KarateJoeHead")
@onready var KarateJoeBody = find_child("KarateJoeBody")
@onready var KarateJoeLeftArm = find_child("KarateJoeLeftArm")
@onready var KarateJoeLeftLeg = find_child("KarateJoeLeftLeg")
@onready var KarateJoeRightLeg = find_child("KarateJoeRightLeg")

@onready var OriginalHeadPosition = Vector2(-8, -75)
@onready var OriginalBodyPosition = Vector2(0, 0)
@onready var OriginalLeftArmPosition = Vector2(9, -55)
@onready var OriginalLeftLegPosition = Vector2(16, 84)
@onready var OriginalRightLegPosition = Vector2(-31, 84)

@onready var HeadTween = create_tween()
@onready var BodyTween = create_tween()
@onready var ArmTween = create_tween()

func ReturnToOriginalPositions():
	HeadTween.stop()
	BodyTween.stop()
	ArmTween.stop()
	KarateJoeHead.position = OriginalHeadPosition
	KarateJoeBody.position = OriginalBodyPosition
	KarateJoeLeftArm.position = OriginalLeftArmPosition
	KarateJoeLeftLeg.position = OriginalLeftLegPosition
	KarateJoeRightLeg.position = OriginalRightLegPosition

func Punch():
	var Cooldown = 0.03
	ReturnToOriginalPositions()
	self.set_meta("CanBop", false)
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoeArmNormal.png")
	KarateJoeLeftArm.position = Vector2(5, -76)
	await get_tree().create_timer(Cooldown * 3).timeout
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoePunch1.png")
	KarateJoeLeftArm.position = Vector2(5, -62)
	await get_tree().create_timer(Cooldown).timeout
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoePunch2.png")
	KarateJoeLeftArm.position = Vector2(5, -54)
	await get_tree().create_timer(Cooldown).timeout
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoePunch3.png")
	KarateJoeLeftArm.position = OriginalLeftArmPosition
	await get_tree().create_timer(Cooldown).timeout
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoeArmIdle.png")
	await get_tree().create_timer(60 / self.get_meta("BPM")).timeout
	self.set_meta("CanBop", true)

func Bop():
	if self.get_meta("CanBop") == true:
		var HeadPosition = Vector2(0, -70)
		var BodyPosition = Vector2(0, 10)
		var ArmPosition = Vector2(9, -45)
		if HeadTween:
			HeadTween.stop()
		if BodyTween:
			BodyTween.stop()
		if ArmTween:
			ArmTween.stop()
		HeadTween = create_tween()
		BodyTween = create_tween()
		ArmTween = create_tween()
		KarateJoeHead.position = HeadPosition
		KarateJoeBody.position = BodyPosition
		KarateJoeLeftArm.position = ArmPosition
		HeadTween.tween_property(KarateJoeHead, "position", OriginalHeadPosition, 0.1)
		BodyTween.tween_property(KarateJoeBody, "position", OriginalBodyPosition, 0.1)
		ArmTween.tween_property(KarateJoeLeftArm, "position", OriginalLeftArmPosition, 0.1)
		HeadTween.play()
		BodyTween.play()
		ArmTween.play()

func _input(event):
	if event.is_action_pressed("Punch"):
		Punch()

func _ready() -> void:
	Beat.wait_time = 60 / self.get_meta("BPM")
	Offset.wait_time = self.get_meta("Offset") / 1000

	SongPlayer.play()
	Offset.start()
	await Offset.timeout
	Beat.start()

	while  true:
		Bop()
		await Beat.timeout
	

func _process(_delta: float) -> void:
	pass

extends Node2D
@onready var SongPlayer = find_child("SongPlayer")
@onready var SFXPlayer = find_child("SFXPlayer")
@onready var Objects = find_child("Objects")
@onready var HitEffect = find_child("HitEffect")

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
@onready var Projectiles = []
@onready var Queue = []
@onready var ProjectileChart = {
	"15" = "Pot",
	"23" = "Pot",
	"31" = "Pot",
	"39" = "Pot",
	"47" = "Pot",
	"51" = "Rock",
	"59" = "Pot",
	"63" = "Pot",
	"67" = "Pot",
	"71" = "Pot",
	"75" = "Soccer",
	"80" = "Pot",
	"87" = "Pot",
	"91" = "Rock",
	"97" = "Pot",
	"99" = "Pot",
	"101" = "Pot",
	"103" = "Pot",
	"105" = "Soccer",
	"109" = "Lightbulb",
	"110" = "Lightbulb",
	"111" = "Rock",
	"113" = "Pot",
	"115" = "Pot",
	"117" = "Pot",
	"119" = "Pot",
	"121" = "Pot",
	"123" = "Pot",
	"125" = "Pot",
	"127" = "Pot",
	"129" = "Pot",
	"131" = "Rock",
	"134" = "Lightbulb",
	"135" = "Bomb",
}

@onready var HeadTween = create_tween()
@onready var BodyTween = create_tween()
@onready var ArmTween = create_tween()
@onready var LegTween = create_tween()

@onready var BeatNumber = 0
@onready var CurrentProjectile = null
@onready var CurrentHitTime = 0
@onready var HitTiming = 55.0 / 1000.0
@onready var BarelyTiming = 80.0 / 1000.0
@onready var TimePerBeat = 60.0 / 119.0
@onready var PunchID = 0
@onready var OffsetSec = 0.0
@onready var Flow = 0

func GetSongTime() -> float:
	return SongPlayer.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

func PlaySound(SoundPath: String):
	SFXPlayer.stream = load(SoundPath)
	SFXPlayer.play()

func DeleteProjectile(P):
	Projectiles.erase(P)
	if is_instance_valid(P):
		P.delete()

func ReturnToOriginalPositions():
	HeadTween.stop()
	BodyTween.stop()
	ArmTween.stop()
	LegTween.stop()
	KarateJoeHead.position = OriginalHeadPosition
	KarateJoeBody.position = OriginalBodyPosition
	KarateJoeLeftArm.position = OriginalLeftArmPosition
	KarateJoeLeftLeg.position = OriginalLeftLegPosition
	KarateJoeRightLeg.position = OriginalRightLegPosition

func MakeRhythm(ProjectileType: String, ExpectedHitTime: float):
	var Proj = Projectile.new()
	Projectiles.append(Proj)
	Proj.init(ProjectileType)
	PlaySound("res://assets/SFX/Throw.wav")
	
	Objects.add_child(Proj)
	Queue.append({"proj": Proj, "time": ExpectedHitTime})

func ProcessInput():
	if is_instance_valid(CurrentProjectile) && CurrentHitTime:
		var Target = CurrentProjectile
		var HitOffset = abs(GetSongTime() - CurrentHitTime)

		if HitOffset < HitTiming:
			CurrentProjectile = null
			PlaySound("res://assets/SFX/PotHit.wav")
			Target.XVelocity = -1500
			Target.YVelocity = 0
			Target.Gravity = 500
			Target.RotatePerFrame = 10
			Target.ScaleDecrement = 0

			Flow += 1
			HitEffect.position = Target.position
			HitEffect.visible = true
			await get_tree().create_timer(0.05).timeout
			HitEffect.visible = false
			await get_tree().create_timer(0.5).timeout
			DeleteProjectile(Target)
		elif HitOffset < BarelyTiming:
			CurrentProjectile = null
			PlaySound("res://assets/SFX/Barely.wav")
			Target.XVelocity = -30
			Target.YVelocity = 100
			Target.Gravity = 350
			Target.RotatePerFrame = 5
			Target.ScaleDecrement = 0
			await get_tree().create_timer(2).timeout
			DeleteProjectile(Target)

func Punch():
	PunchID += 1
	var MyID = PunchID
	var Cooldown = 0.03
	self.set_meta("CanBop", false)
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoeArmNormal.png")
	KarateJoeLeftArm.position = Vector2(5, -76)
	await get_tree().create_timer(Cooldown * 5).timeout
	if MyID != PunchID: return
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoePunch1.png")
	KarateJoeLeftArm.position = Vector2(5, -62)
	await get_tree().create_timer(Cooldown).timeout
	if MyID != PunchID: return
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoePunch2.png")
	KarateJoeLeftArm.position = Vector2(5, -54)
	await get_tree().create_timer(Cooldown).timeout
	if MyID != PunchID: return
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoePunch3.png")
	KarateJoeLeftArm.position = OriginalLeftArmPosition
	await get_tree().create_timer(Cooldown).timeout
	if MyID != PunchID: return
	KarateJoeLeftArm.texture = load("res://assets/KarateJoe/KarateJoeArmIdle.png")
	await get_tree().create_timer(TimePerBeat / 2).timeout
	if MyID != PunchID: return
	self.set_meta("CanBop", true)

func Punch2():
	var HeadPosition = Vector2(-3, -70)
	var BodyPosition = Vector2(3, 3)
	var LegPosition = Vector2(20, 84)
	if HeadTween:
		HeadTween.stop()
	if BodyTween:
		BodyTween.stop()
	if LegTween:
		LegTween.stop()
	HeadTween = create_tween()
	BodyTween = create_tween()
	LegTween = create_tween()
	KarateJoeHead.position = HeadPosition
	KarateJoeBody.position = BodyPosition
	KarateJoeLeftLeg.position = LegPosition
	HeadTween.tween_property(KarateJoeHead, "position", OriginalHeadPosition, 0.1)
	BodyTween.tween_property(KarateJoeBody, "position", OriginalBodyPosition, 0.1)
	LegTween.tween_property(KarateJoeLeftLeg, "position", OriginalLeftLegPosition, 0.1)
	HeadTween.play()
	BodyTween.play()
	LegTween.play()

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
		ReturnToOriginalPositions()
		PlaySound("res://assets/SFX/Punch.wav")
		Punch()
		Punch2()
		ProcessInput()

func _ready() -> void:
	OffsetSec = self.get_meta("Offset") / 1000.0
	SongPlayer.play()

func _process(delta: float) -> void:
	TimePerBeat = 60.0 / self.get_meta("BPM")
	var SongTime = GetSongTime()

	while SongTime >= OffsetSec + BeatNumber * TimePerBeat:
		BeatNumber += 1
		var BeatTime = OffsetSec + (BeatNumber - 1) * TimePerBeat
		Bop()
		if ProjectileChart.has(str(BeatNumber)):
			MakeRhythm(ProjectileChart.get(str(BeatNumber)), BeatTime + TimePerBeat)

	# Drop a deleted current projectile
	if not is_instance_valid(CurrentProjectile):
		CurrentProjectile = null

	# Promote the next projectile
	if Queue.size() > 0:
		var Next = Queue[0]
		if CurrentProjectile == null or SongTime >= Next.time - BarelyTiming:
			Queue.pop_front()
			CurrentProjectile = Next.proj
			CurrentHitTime = Next.time

	for i in range(Projectiles.size() - 1, -1, -1):
		var P = Projectiles[i]
		P.update(delta)
		if P.TimeExisting > 5:
			DeleteProjectile(P)

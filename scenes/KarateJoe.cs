using Godot;
using System;

public partial class KarateJoe : Sprite2D
{
	//Godot.Sprite2D Head = this.GetNode<Godot.Sprite2D>("KarateJoeHead");
	//Godot.Sprite2D Torso = this.GetNode<Godot.Sprite2D>("KarateJoeBody");
	//Godot.Sprite2D LeftArm = this.GetNode<Godot.Sprite2D>("KarateJoeLeftArm");
	//Godot.Sprite2D LeftLeg = this.GetNode<Godot.Sprite2D>("KarateJoeLeftLeg");
	//Godot.Sprite2D RightLeg = this.GetNode<Godot.Sprite2D>("KarateJoeRightLeg");

	public int Bop()
	{
		return 0;
	}
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Console.WriteLine("Hello, World");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}

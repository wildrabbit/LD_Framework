package org.wildrabbit.world;
import flixel.addons.editors.tiled.TiledObject;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class Enemy extends Entity
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);		
	}
	
	override public function load(obj:TiledObject):Void
	{
		super.load(obj);
		makeGraphic(32, 32, FlxColor.AQUAMARINE);
	}
	
	override public function notifyWorld(world:World):Void
	{		
		// Subclasses should implement this by registering themselves in the appropriate world collection if necessary
		// Basically, as in this example: world.AddEntity(this);
		world.addEnemy(this);
	}
	
}
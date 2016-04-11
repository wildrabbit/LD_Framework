package org.wildrabbit.world;

import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Assets;
import openfl.geom.Rectangle;
import org.wildrabbit.ld.PlayState;

/**
 * ...
 * @author wildrabbit
 */
class Entity extends FlxSprite
{
	public static var paused:Bool = false;

	// Properties fetched from Tiled
	var tiledObj: TiledObject = null;
	var name:String = "";
	
	var disabled:Bool = false;
	
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
	}
	
	override public function update(elapsed:Float):Void
	{
		if (Entity.paused) return;
		if (disabled) return;
		super.update(elapsed);
	}
	
	public function getFrameRectangle(frames:FlxAtlasFrames, key:String):FlxRect
	{
		for (frame in frames.frames)
		{
			if (frame.name == key)
			{
				return frame.frame;
			}
		}		
		return null;
	}
	
	public function load(obj:TiledObject):Void
	{
		tiledObj = obj;
		name = obj.name;
		
		if (obj.custom.contains("atlas"))
		{
			var srcStr:String = "assets/images/" + obj.custom.get("atlas") ;
			var frames = FlxAtlasFrames.fromTexturePackerJson(srcStr + ".png", Assets.getText(srcStr + ".json"));
			
			var r:FlxRect = getFrameRectangle(frames, obj.custom.get("key"));
			width = r.width;
			height = r.height;
			offset.set( - ((r.width - frameWidth) * 0.5), - ((r.height- frameHeight) * 0.5));
			centerOrigin();
		}			
		setPosition(obj.x, obj.y - height);		
	}
	
	public function notifyWorld(world:World):Void
	{		
		// Subclasses should implement this by registering themselves in the appropriate world collection if necessary
		// Basically, as in this example: world.AddEntity(this);
	}
	
	public function startFadeIn(time:Float, ?callback:FlxTween -> Void):Void
	{
		alpha = 0;
		if (callback != null)
		{
			FlxTween.tween(this, { alpha:1 }, time, { type:FlxTween.ONESHOT, ease:FlxEase.backIn, onComplete:callback} );			
		}
		else 
		{
			FlxTween.tween(this, { alpha:1 }, time, { type:FlxTween.ONESHOT, ease:FlxEase.backIn} );
		}
		
		
		scale.set();
		FlxTween.tween(scale, { x:1, y:1 }, time, { type:FlxTween.ONESHOT, ease:FlxEase.backIn} );
	}
	
	public function startFadeOut(time:Float, ?callback:FlxTween -> Void):Void
	{
		alpha = 1;
		if (callback != null)
		{
			FlxTween.tween(this, { alpha:0 }, time, { type:FlxTween.ONESHOT, ease:FlxEase.backOut, onComplete:callback} );			
		}
		else 
		{
			FlxTween.tween(this, { alpha:0 }, time, { type:FlxTween.ONESHOT, ease:FlxEase.backOut} );
		}
				
		scale.set(1,1);
		FlxTween.tween(scale, { x:0, y:0 }, time, { type:FlxTween.ONESHOT, ease:FlxEase.backOut} );
	}

	public function setDisabled(value:Bool):Void
	{
		if (value)
		{
			velocity.x = velocity.y = 0;
			acceleration.x = acceleration.y = 0;
			drag.x = drag.y = 0;
		}
		else
		{
			//acceleration.y = gravity;
			drag.set(Std.parseFloat(tiledObj.custom.get("dragX")), Std.parseFloat(tiledObj.custom.get("dragX"))); 
		}
		solid = !value;
		immovable = value;
		disabled = value;
	}
		
	public function die():Void
	{
		setDisabled(true);
	}
}
package org.wildrabbit.ld;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import haxe.Log;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		
		var btn:FlxButton = new FlxButton(0,0, "To the game!", OnButtonClicked);
		add(btn);
		btn.x = (FlxG.width - btn.width) * 0.5;
		btn.y = (FlxG.height - btn.height) * 0.5;

	}
	
	public function OnButtonClicked():Void 
	{
		Log.trace("On to next state!");
		FlxG.switchState(new PlayState());
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{		
		super.update();
	}
}
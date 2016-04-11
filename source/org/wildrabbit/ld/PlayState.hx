package org.wildrabbit.ld;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import org.wildrabbit.world.World;
import org.wildrabbit.world.MapManager;

/**
 * A FlxState which can be used for the actual gameplay.
 * For now, we'll let the state itself be in charge of coordinating gameplay.
 * As a game grows in size, consider deferring all that functionality to a separate "GameplayManager" class, which will be responsible
 * for handling anything directly related to gameplay. The state, thus would basically delegate in that and other subsystems (ui?, etc)
 * @author wildrabbit
 */
class PlayState extends FlxState
{
	private var mMapManager:MapManager;
	private var mLevelList:Array<String>;
	private var mTestButton:FlxButton;
	private var mWorld:World;
	private var mCurrentLevelId:String;
	private var mStartingLevelIdx:Int;
	
	public function getMapManager():MapManager
	{
		return mMapManager;
	}
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
		
		mLevelList = ["test2.tmx", "test.tmx"];
		mMapManager = new MapManager( mLevelList );
		mStartingLevelIdx = 0;
		mCurrentLevelId = mMapManager.getLevelId(mStartingLevelIdx);
		
		mWorld = new World(this, mCurrentLevelId);
		mWorld.build();
		
		mTestButton = new FlxButton(10, 10, "Next!", OnButtonClicked);
		add(mTestButton);
	}
	
	public function OnButtonClicked():Void
	{
		remove(mWorld);
		mWorld.destroy();
		mCurrentLevelId = mMapManager.getNextMapId(mCurrentLevelId, true);
		if (mCurrentLevelId != "")
		{
			mWorld = new World(this, mCurrentLevelId);
			mWorld.build();			
		}
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		
		remove(mTestButton);
		mTestButton = null;
		
		mLevelList = null;
		
		mMapManager.destroy();
		mMapManager = null;
		
		remove(mWorld);
		mWorld.destroy();
		mWorld = null;
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		mWorld.update(elapsed);
	}
}
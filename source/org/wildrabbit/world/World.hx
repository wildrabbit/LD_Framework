package org.wildrabbit.world;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTile;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTile;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import haxe.io.Path;
import flixel.util.FlxCollision;
import org.wildrabbit.core.Pair;
import org.wildrabbit.utils.MyFlxTilemap;
import org.wildrabbit.ld.PlayState;
import org.wildrabbit.world.Enemy;
import org.wildrabbit.world.Player;


	
typedef EntityConfig = 
{
	var typeName:String;
	var className:String;
}

/**
 * A level representation, particularly wrapping a Tiled map
 * @author wildrabbit
 */
class World extends FlxGroup
{
	public var mParent:PlayState;
	public var mMapId:String;
	
	public var mEntityConfig:Map<String,Array<EntityConfig>>;

	public var mIgnoredObjects:Array<String>;

	public var mBg0:MyFlxTilemap;
	public var mBg1:MyFlxTilemap;
	// TODO: Generalize/Add/replace tile-dependent layers when needed
	
	public var mCharacters:FlxTypedGroup<Entity>;
	// TODO: Add/Replace with more specific collections when needed
	public var mPlayer:Entity;
	
	public var rows:Int = 20;
	public var cols:Int = 25;
	
	public function new(state:PlayState, tiledLevelName:String) 
	{
		super();
		mParent = state;
		mMapId = tiledLevelName;
		mParent.add(this);
		
		mPlayer = null;
		mBg0 = mBg1 = null;
		mCharacters = new FlxTypedGroup<Entity>();
		
		mEntityConfig = new Map();
		mEntityConfig["player"] = [{typeName:"Player", className:"org.wildrabbit.world.Player"}];	// IMPORTANT: The classes must be compiled so that 
		mEntityConfig["others"] = [{typeName:"Enemy", className:"org.wildrabbit.world.Enemy"}];		// They can be resolved by flash.utils.getDefinitionByName()
		mIgnoredObjects = null;
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		remove(mPlayer);
		mPlayer = null;
		
		for (e in mCharacters)
		{
			remove(e);
		}
		mCharacters.clear();
		mCharacters = null;
		
		mEntityConfig = null;
		mIgnoredObjects = null;
		mMapId = null;
		
		remove(mBg0);
		mBg0.destroy();
		mBg0 = null;
		
		remove(mBg1);
		mBg1.destroy();
		mBg1 = null;

		mParent = null;
	}
	
	public function build():Void
	{
		var mapSize:Pair<Int> = mParent.getMapManager().getMapDimensions(mMapId);
		
		var managerRef:MapManager = mParent.getMapManager();
		var mapDimensions:Pair<Int> = managerRef.getMapDimensions(mMapId);
		
		// Example: 
		mBg0 = managerRef.buildTilemap(mMapId, "bg0", "land");
		add(mBg0);
		mBg1 = managerRef.buildTilemap(mMapId, "bg1", "decos");
		add(mBg1);

		// Now object layers
		managerRef.loadEntities(this);
	}
	
	public function addPlayer(p:Player):Void
	{
		mPlayer = p;
		add(mPlayer);
	}
	
	public function addEnemy(e:Enemy):Void
	{
		mCharacters.add(e);
		add(e);
	}
}
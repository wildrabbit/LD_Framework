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

	public var mBackgroundTiles:MyFlxTilemap;
	// TODO: Add/replace tile-dependent layers if needed
	
	public var mCharacters:FlxTypedGroup<Entity>;
	// TODO: Add/Replace with more specific collections if needed
	public var mPlayer:Entity;
	
	public var rows:Int = 20;
	public var cols:Int = 25;
	
	public function new(state:PlayState, tiledLevelName:String) 
	{
		super();
		mParent = state;
		mMapId = tiledLevelName;
		
		mBackgroundTiles = null;
		mCharacters = new FlxTypedGroup<Entity>();
		
		mEntityConfig = new Map();
		// Example: 
		//[
		//	"items" => {typeName:"Player", className:"org.chaoneurogue.characters.Player"},
		//	"some other items" => {typeName:"Key", className:"org.chaoneurogue.world.items.Key",objectGroupLayerName:"Items"},
		//];
		mIgnoredObjects = null;
	}
	
	public function build():Void
	{
		var mapSize:Pair<Int> = mParent.getMapManager().getMapDimensions(mMapId);
		FlxG.camera.setBounds(0, 0 , mapSize.mX, mapSize.mY, true);
		FlxG.camera.follow(mPlayer);
		
		var managerRef:MapManager = mParent.getMapManager();
		var mapDimensions:Pair<Int> = managerRef.getMapDimensions(mMapId);
		
		// If we need to parse the layers, use tileLayer.properties.contains/get
		// To define a collision callback, tilemap.SetTileProperties(TileID, CollisionType, Callback);
		// To change a map's properties: var tile:FlxTile = cast(tileObj, FlxTile);
		// tile.tilemap.setTileByIndex(tile.mapIndex, 0, true);
		
		// Example: 
		mBackgroundTiles = managerRef.buildTilemap(mMapId, "background", "tileset");
		add(mBackgroundTiles);

		// Now object layers
		managerRef.loadEntities(this);
	}
}
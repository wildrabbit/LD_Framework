package org.chaoneurogue.world;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTile;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTile;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import flixel.FlxSprite;
import haxe.io.Path;
import flixel.util.FlxCollision;
import org.chaoneurogue.utils.MyFlxTilemap;
import org.chaoneurogue.ld.PlayState;

/**
 * ...
 * @author ith1ldin
 */
class Level extends TiledMap
{
	// We may need to split this in a better way
	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;	
	
	private inline static var PATH_LEVEL_TILESHEETS = "assets/images/";
	
	public function new(tiledLevel:Dynamic) 
	{
		super(tiledLevel);
		
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		
		for (tileLayer in layers)
		{
			if (!tileLayer.visible) continue;
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			if (tileSheetName == null)
			{
				throw "'tileset property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer'";
			}
			
			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null)
			{
				throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
			}
			
			var imagePath = new Path(tileSet.imageSource);
			var processedPath = PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			var tilemap:MyFlxTilemap = new MyFlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			
			// The tilemap needs to be added to the Flx Hierarchy!!
			
			// If we need to parse the layers, use tileLayer.properties.contains/get
			// To define a collision callback, tilemap.SetTileProperties(TileID, CollisionType, Callback);
			// To change a map's properties: var tile:FlxTile = cast(tileObj, FlxTile);
			// tile.tilemap.setTileByIndex(tile.mapIndex, 0, true);
		}	
	}
	public function loadObjects(state:PlayState)
	{
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				loadObject(o, group, state);
			}
		}
		// Register things in the state collections if necessary
	}
	
	private function loadObject(tiledObj:TiledObject, tiledObjGroup:TiledObjectGroup, state:PlayState)
	{
		var x:Int = tiledObj.x;
		var y:Int = tiledObj.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (tiledObj.gid != -1)
			y -= tiledObjGroup.map.getGidOwner(tiledObj.gid).tileHeight;
		
			// This method will create specific subclasses, and make the playstate aware of them in case it wants to add it to the game groups or similar
			Entity.Create(tiledObj, tiledObjGroup, state, x, y);		
		}
	}
}
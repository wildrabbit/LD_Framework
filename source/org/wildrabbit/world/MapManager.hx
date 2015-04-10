package org.wildrabbit.world;
import haxe.ds.Vector;
import haxe.io.Path;
import openfl.utils.Dictionary;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledTileSet;
import org.wildrabbit.core.Pair;
import org.wildrabbit.utils.MyFlxTilemap;
import org.wildrabbit.world.World.EntityConfig;

/**
 * ...
 * @author ith1ldin
 */
class MapManager
{
	var mMapList: Vector<String>;
	var mTiledMapList:Array<TiledMap>;	//We could use a dictionary and save on getIndex() calls, but the level lists are small enough
	
	public function new(levelList:Array<String>) 
	{
		mMapList = new Vector<String>(levelList.length);
		mTiledMapList = new Array<TiledMap>();
		
		var idx:Int = 0;
		for (item in levelList)
		{
			mMapList[idx] = item.substring(0, item.indexOf(".tmx"));
			mTiledMapList.push(new TiledMap("assets/data/" + item));			
			idx++;
		}
	}

	public function getLevelId(mapIdx:Int):String 
	{
		if (mapIdx >= 0 && mapIdx < mMapList.length)
		{
			return mMapList[mapIdx];
		}
		else return "";
	}

	public function getMapIndex(mapId:String):Int
	{
		var i:Int = 0;
		while (i < mMapList.length)
		{
			if (mMapList[i] == mapId)
			{
				return i;
			}
			i++;
		}
		return -1;
	}
		
	public function getLayerTilesFromMap(mapId:String, layerId:String):Array<Int>
	{
		var mapIdx:Int = getMapIndex(mapId);
		if (mapIdx == -1) return null;
		
		return mTiledMapList[mapIdx].getLayer(layerId).tileArray;
	}
	
	public function getTilesetPathFromMap(mapId:String, tilesetName:String = "level"):String
	{
		var mapIdx:Int = getMapIndex(mapId);
		if (mapIdx == -1) return null;		
		
		var tileSet:TiledTileSet = mTiledMapList[mapIdx].getTileSet(tilesetName);
		var imagePath = new Path(tileSet.imageSource);
		var processedPath = "assets/images/" + imagePath.file + "." + imagePath.ext;
		
		return processedPath;
	}
	
	public function getTileDimensions(mapId:String, tilesetName:String = "level"):Pair<Int>
	{
		var dimensions:Pair<Int> = new Pair<Int>(32, 32);
		var map:TiledMap = getMap(mapId);
		
		if (map != null)
		{
			var tileSet:TiledTileSet = map.getTileSet(tilesetName);
			dimensions.set(tileSet.tileWidth, tileSet.tileHeight);
		}
		return dimensions;
	}
	
	public function getNextMapId(mapId:String, cycle:Bool = false):String
	{	
		var idx:Int = getMapIndex(mapId);
		if (idx < 0) 
		{
			return "";
		}
		else
		{
			var nextIndex:Int = idx + 1;
			if (nextIndex < mMapList.length)
			{
				if (cycle)
				{
					nextIndex = nextIndex % mMapList.length;
				}
				else 
				{
					return "";
				}
			}
			return mMapList[nextIndex];
		}
		return "";
	}
	
	public function getMap(mapId:String):TiledMap
	{
		var idx:Int = getMapIndex(mapId);
		if (idx != -1)
		{
			return mTiledMapList[idx];
		}
		else return null;
	}
	
	public function getMapDimensions(mapId:String):Pair<Int>
	{
		var dims:Pair<Int> = new Pair<Int>(0, 0);
		var map:TiledMap = getMap(mapId);
		if (map != null)
		{
			dims.set(map.fullWidth, map.fullHeight);
		}
		return dims;
	}
	
	public function buildTilemap(mapId:String, layerId:String, tilesetId:String = "level", autoTileIdx:Int = 0, startingIndex:Int = 1, drawIndex:Int = 1, collideIndex:Int = 3):MyFlxTilemap
	{
		var tilemap:MyFlxTilemap = new MyFlxTilemap();
		var tiledObj:TiledMap = getMap(mapId);
		if (tiledObj != null)
		{
			var tileSet:TiledTileSet = tiledObj.getTileSet(tilesetId);
			var imagePath = new Path(tileSet.imageSource);
			var processedPath = "assets/images/" + imagePath.file + "." + imagePath.ext;		
			tilemap.loadMap(tiledObj.getLayer(layerId).tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, autoTileIdx, startingIndex, drawIndex, collideIndex);
		}
		return tilemap;
	}
	
	public function loadEntities(world:World):Void
	{
		var map:TiledMap = getMap(world.mMapId);
		if (map == null) return;
		
		var objects:Array<TiledObject> = null;
		var classInstance:Entity;
		var i:Int = 0;
		var c:Class<Dynamic>;		
		
		var ignore:Array<String> = world.mIgnoredObjects;
		var configs:Array<EntityConfig> = null;
		var numConfigs:Int = 0;
		for (objectLayerName in world.mEntityConfig.keys())
		{
			objects = map.getObjectGroup(objectLayerName).objects;
			for (o in objects)
			{
				i = 0;
				numConfigs = configs.length;
				configs = world.mEntityConfig[objectLayerName];
				while (i< numConfigs)
				{
					if ((ignore == null || ignore.indexOf(o.type) == -1) && o.type == configs[i].typeName)
					{
						c = Type.resolveClass(configs[i].className);
						classInstance = Type.createInstance(c, []);
						classInstance.load(o, world);
					}
					numConfigs++;
				}
			}
		}
	}
}
package org.wildrabbit.utils ;

import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;

/**
 * Expose additional functionality from the Tiled object
 * @author wildrabbit
 */
class MyFlxTilemap extends FlxTilemap
{

	public function new() 
	{
		super();	
	}
	
	public function getTileObjects():Array<FlxTile>
	{
		return _tileObjects;
	}
	
}
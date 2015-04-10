package org.wildrabbit.core ;

/**
 * ...
 * @author ith1ldin
 */
@:generic
class Pair<T>
{
	public var mX:T;
	public var mY:T;
	
	public function new(x:T, y:T) 
	{
		mX = x;
		mY = y;
	}
	
	public function set(x:T, y:T):Void
	{
		mX = x;
		mY = y;
	}
}
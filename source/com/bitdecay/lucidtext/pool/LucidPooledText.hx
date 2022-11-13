package com.bitdecay.lucidtext.pool;

import flixel.text.FlxBitmapText;
import flixel.util.FlxPool;

class LucidPooledText extends FlxBitmapText implements IFlxPooled {
	public static var pool(get, never):IFlxPool<LucidPooledText>;

	static var _pool = new FlxPool<LucidPooledText>(LucidPooledText);

	var _inPool:Bool = false;

	public static inline function get(X:Float = 0, Y:Float = 0, str:String, fontSize:Int = 0):FlxBitmapText
	{
		var txt = _pool.get();
		txt.x = X;
		txt.y = Y;
		txt.text = str;

		// cheeky abuse of the getter to get it to update the pixels
		txt.width;
		if (fontSize > 0) {
			var scale = 1.0 * fontSize / txt.height;
			txt.scale.set(scale, scale);
		}
		txt.updateHitbox();
		txt._inPool = false;
		return txt;
	}

	public function put():Void {
		if (!_inPool)
		{
			_inPool = true;
			_pool.putUnsafe(this);
		}
	}

	static function get_pool():IFlxPool<LucidPooledText> {
		return _pool;
	}
}
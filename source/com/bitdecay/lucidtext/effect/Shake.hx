package com.bitdecay.lucidtext.effect;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.text.FlxText;

class Shake implements Effect {
	var size:Float = 5;

	public function new() {}

	public function setProperties(props:Dynamic) {
		size = Std.parseFloat(props.size);
		trace('Size: ${size}');
	}

	public function apply(o:FlxText, i:Int):ActiveFX {
		var initialPos = FlxPoint.get(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
		var offset = FlxPoint.get();
		return new ActiveFX(o, (delta:Float) -> {
			if (initialPos.x == Math.NEGATIVE_INFINITY && initialPos.y == Math.NEGATIVE_INFINITY) {
				o.getPosition().copyTo(initialPos);
			}
			offset.set(FlxG.random.float(0, size), 0);
			offset.rotate(FlxPoint.weak(), FlxG.random.int(0, 360));
			o.setPosition(initialPos.x + offset.x, initialPos.y + offset.y);
		});
		return null;
	}
}

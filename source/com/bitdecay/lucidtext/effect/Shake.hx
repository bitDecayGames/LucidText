package com.bitdecay.lucidtext.effect;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * Adds shake to the affected characters
 */
class Shake implements Effect {
	var size:Float = 5;

	public function new() {}

	public function getUserProperties():Map<String, PropertySetters.PropertySetterFunc> {
		return ["size" => PropertySetters.setFloat,];
	}

	public function apply(o:FlxText, i:Int):ActiveFX {
		var offset = FlxPoint.get();
		var tempPosition = FlxPoint.get();
		return new ActiveFX(o, (delta:Float) -> {
			o.getPosition(tempPosition);

			// undo our previous offset;
			tempPosition.subtractPoint(offset);

			// then calculate our new offset and add it to the working temp position
			offset.set(FlxG.random.float(0, size), 0);
			offset.rotate(FlxPoint.weak(), FlxG.random.int(0, 360));
			tempPosition.addPoint(offset);

			// set our position
			o.setPosition(tempPosition.x, tempPosition.y);
		});
	}
}

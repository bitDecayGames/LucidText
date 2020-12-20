package com.bitdecay.lucidtext.effect.builtin;

import flixel.math.FlxPoint;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * A sine wave motion for the affected characters
**/
class Wave implements Effect {
	var height:Float = 10.0;
	var speed:Float = 2.0;
	var offset:Float = 0.1;
	var reverse:Bool = false;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		var fields:Map<String, (Dynamic, String, String) -> Void> = [
			"height" => Setters.setFloat,
			"speed" => Setters.setFloat,
			"offset" => Setters.setFloat,
			"reverse" => Setters.setIfTrueBool
		];

		return fields;
	}

	public function apply(o:FlxText, i:Int):ActiveFX {
		var posOffset = FlxPoint.get();
		var tempPosition = FlxPoint.get();

		var timer = i * offset;

		return new ActiveFX(o, (delta:Float) -> {
			if (reverse) {
				timer += delta;
			} else {
				// Personal preference: This direction looks better to be the 'default'
				timer -= delta;
			}

			o.getPosition(tempPosition);

			// undo our previous offset;
			tempPosition.subtractPoint(posOffset);

			// then calculate our new offset and add it to the working temp position
			posOffset.y = Math.sin(timer * speed) * height;
			tempPosition.addPoint(posOffset);

			// set our position
			o.setPosition(tempPosition.x, tempPosition.y);
		});
	}
}

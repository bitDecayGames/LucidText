package com.bitdecay.lucidtext.effect.builtin;

import flixel.math.FlxPoint;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * A circular motion for the affected characters
**/
class Scrub implements Effect {
	public var height:Float = 8.0;
	public var speed:Float = 10.0;
	public var offset:Float = 0.1;
	public var reverse:Bool = false;
	public var y_mod:Float = 1.0;
	public var x_mod:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		var fields:Map<String, (Dynamic, String, String) -> Void> = [
			"height" => Setters.setFloat,
			"speed" => Setters.setFloat,
			"offset" => Setters.setFloat,
			"reverse" => Setters.setBool,
			"x_mod" => Setters.setFloat,
			"y_mod" => Setters.setFloat,
		];

		return fields;
	}

	public function apply(o:FlxText, i:Int):ActiveFX {
		var posOffset = FlxPoint.get();
		var tempPosition = FlxPoint.get();

		var timer = -i * offset;

		// we want the letters to move up, which is the -y direction
		var radius = -height / 2;

		return new ActiveFX(o, (delta:Float) -> {
			if (reverse) {
				timer -= delta;
			} else {
				// Personal preference: This direction looks better to be the 'default'
				timer += delta;
			}

			o.getPosition(tempPosition);

			// undo our previous offset;
			tempPosition.subtractPoint(posOffset);

			// then calculate our new offset and add it to the working temp position
			posOffset.x = Math.cos(timer * speed) * radius * x_mod;
			posOffset.y = (Math.sin(timer * speed) * radius + radius) * y_mod;
			tempPosition.addPoint(posOffset);

			// set our position
			o.setPosition(tempPosition.x, tempPosition.y);
		});
	}
}
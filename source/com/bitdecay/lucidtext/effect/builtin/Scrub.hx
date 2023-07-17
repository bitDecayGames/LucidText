package com.bitdecay.lucidtext.effect.builtin;

import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

@description("A circular motion for the affected characters")
class Scrub implements Effect {
	@description("Height in pixels for the effect")
	public var height:Float = 8.0;

	@description("Cycle speed")
	public var speed:Float = 10.0;

	@description("Cycle offset between adjacent characters")
	public var offset:Float = 0.1;

	@description("Set to true to reverse the cycle")
	public var reverse:Bool = false;

	@description("Scalar for how much the effect moves in on the y axis")
	public var y_mod:Float = 1.0;

	@description("Scalar for how much the effect moves in on the x axis")
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

	public function apply(o:FlxBitmapText, i:Int):EffectUpdater {
		var posOffset = FlxPoint.get();
		var tempPosition = FlxPoint.get();

		var timer = -i * offset;

		// we want the letters to move up, which is the -y direction
		var radius = -height / 2;

		return (delta:Float) -> {
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

			return true;
		};
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}

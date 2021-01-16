package com.bitdecay.lucidtext.effect.builtin;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

@description("Adds shake to the affected characters")
class Shake implements Effect {
	@description("Distance in pixels away from the starting position the character can move")
	public var dist:Float = 3;

	@description("Number of shakes per second")
	public var perSec:Int = 30;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return [
			"dist" => Setters.setFloat,
			"perSec" => Setters.setInt,
		];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		var offset = FlxPoint.get();
		var tempPosition = FlxPoint.get();

		var localDelay = 1 / Math.max(1, perSec);
		var timer = 0.0;
		return (delta:Float) -> {
			timer -= delta;
			if (timer > 0) {
				return true;
			}

			timer += localDelay;
			o.getPosition(tempPosition);

			// undo our previous offset;
			tempPosition.subtractPoint(offset);

			// then calculate our new offset and add it to the working temp position
			offset.set(FlxG.random.float(0, dist), 0);
			offset.rotate(FlxPoint.weak(), FlxG.random.int(0, 360));
			tempPosition.addPoint(offset);

			// set our position
			o.setPosition(tempPosition.x, tempPosition.y);

			return true;
		};
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}

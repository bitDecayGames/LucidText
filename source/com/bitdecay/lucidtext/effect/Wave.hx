package com.bitdecay.lucidtext.effect;

import com.bitdecay.lucidtext.PropertySetters.PropertySetterFunc;
import flixel.math.FlxPoint;
import flixel.text.FlxText;

/**
 * A sine wave motion for the affected characters
 *
 * Supports the following properties:
 *   * `height`  - the amplitude of the sine path
 *   * `speed`   - the frequency of the sine path
 *   * `offset`  - the timing offset between characters in seconds
 *   * `reverse` - control if the sine waves travel in reverse
**/
class Wave implements Effect {
	public var height:Float = 10.0;
	public var speed:Float = 2.0;
	public var offset:Float = 0.1;
	public var reverse:Bool = false;

	public function new() {}

	public function getUserProperties():Map<String, PropertySetterFunc> {
		var fields:Map<String, (Dynamic, String, String) -> Void> = [
			"height" => PropertySetters.setFloat,
			"speed" => PropertySetters.setFloat,
			"offset" => PropertySetters.setFloat,
			"reverse" => PropertySetters.setIfTrueBool
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

package com.bitdecay.lucidtext.effect.builtin;

import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * A sine wave motion for the affected characters
**/
class Wave extends Scrub {
	public function new() {
		super();
		height = 10.0;
		speed = 4.0;
		offset = 0.3;
		x_mod = 0.0;
	}

	override public function getUserProperties():Map<String, PropSetterFunc> {
		// only expose a subset of the properties
		var fields:Map<String, (Dynamic, String, String) -> Void> = [
			"height" => Setters.setFloat,
			"speed" => Setters.setFloat,
			"offset" => Setters.setFloat,
			"reverse" => Setters.setBool
		];

		return fields;
	}
}

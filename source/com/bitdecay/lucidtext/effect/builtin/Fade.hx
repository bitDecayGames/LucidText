package com.bitdecay.lucidtext.effect.builtin;

import flixel.math.FlxMath;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.ModifiableOptions;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

@description("Fades out the characters")
class Fade implements Effect {
	@description("Seconds to fade over")
	public var time:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return [
			'time' => Setters.setFloat,
		];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		var total = time;
		var remaining = time;
		return (delta) -> {
			if (o.visible) {
				remaining -= delta;
				o.alpha = remaining / total;
			}
			return true;
		}
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}

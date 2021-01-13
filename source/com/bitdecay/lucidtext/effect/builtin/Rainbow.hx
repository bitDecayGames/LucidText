package com.bitdecay.lucidtext.effect.builtin;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.ModifiableOptions;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Applies a rainbow effect
**/
class Rainbow implements Effect {
	public var bright:Float = 1.0;
	public var speed:Float = 1;
	public var offset:Int = 20;
	public var reverse:Bool = false;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return [
			"bright" => Setters.setFloat,
			"offset" => Setters.setInt,
			"speed" => Setters.setFloat,
			"reverse" => Setters.setBool,
		];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		var color = new FlxColor(0xFFFF0000);
		color.brightness = Math.min(Math.max(0, bright), 1);
		var deltaMod = 360 * speed;
		var hue:Float = -i * offset;
		var rev = reverse;
		return (delta) -> {
			hue += delta * (deltaMod * (rev ? -1 : 1));
			if (hue < 0) {
				hue += 360;
			}
			if (hue >= 360) {
				hue -= 360;
			}
			color.hue = hue;
			o.color = color;
			return true;
		};
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}
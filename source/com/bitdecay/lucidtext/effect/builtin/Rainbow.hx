package com.bitdecay.lucidtext.effect.builtin;

import flixel.util.FlxColor;
import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.ModifiableOptions;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Applies a rainbow effect
**/
@description("Causes characters to cycle colors")
class Rainbow implements Effect {
	@description("Brightness")
	@range(0.0, 1.0)
	public var bright:Float = 1.0;

	@description("How fast the rainbow effect should cycle")
	public var speed:Float = 1;

	@description("Amount of hue offset between adjacent characters")
	public var offset:Int = 20;

	@description("Set to true to reverse the hue cycle")
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

	public function apply(o:FlxBitmapText, i:Int):EffectUpdater {
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

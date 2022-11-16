package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxBitmapText;
import flixel.math.FlxMath;
import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.ModifiableOptions;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Allows setting the color of characters.
 *
 * Currently only supports colors as integer, most usefully
 * in the hexidecimal form 0xRRGGBB
**/
@description("Allows setting the color of characters")
class Color implements Effect {
	private static var colorsByID = new Map<String, Int>();

	public static function registerColor(name:String, rgb:Int) {
		colorsByID.set(name, rgb);
	}

	@description("Color integer formatted as `0xRRGGBB`")
	public var rgb:Int = 0xFF000000;

	@description("Float value controlling transparency")
	@range(0.0, 1.0)
	public var alpha:Int = 1;

	@description("Use a pre-registered color by ID")
	public var id:String = "";

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return [
			'id' => Setters.setString,
			'rgb' => Setters.setInt,
			'alpha' => Setters.setFloat,
		];
	}

	public function apply(o:FlxBitmapText, i:Int):EffectUpdater {
		if (id != null && id.length > 0) {
			if (Color.colorsByID.exists(id)) {
				o.color = Color.colorsByID.get(id);
			} else {
				trace('WARNING: No color registered with name "$id"');
				o.color = 0xFF00FF;
			}
		} else {
			o.color = rgb;
		}
		o.alpha = FlxMath.bound(alpha, 0, 1);
		return null;
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}

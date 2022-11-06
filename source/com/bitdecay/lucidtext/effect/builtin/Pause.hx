package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Allows inserting a dynamic pause into a typed string of text.
 *
 * NOTE: This effect renders the character AFTER the tag, and
 *       pauses once that character has been rendered
**/
@description("Allows inserting a dynamic pause into a typed string of text")
class Pause implements Effect {
	private var enforcer:Int = -1;

	@description("Seconds to pause")
	private var t:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["t" => Setters.setFloat];
	}

	public function apply(o:FlxBitmapText, i:Int):EffectUpdater {
		return null;
	}

	public function begin(ops:ModifiableOptions) {
		ops.delay = t;
	}

	public function end(ops:ModifiableOptions) {}
}

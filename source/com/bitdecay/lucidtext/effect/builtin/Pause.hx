package com.bitdecay.lucidtext.effect.builtin;

import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Allows inserting a dynamic pause into a typed string of text.
 *
 * NOTE: This effect renders the character AFTER the tag, and
 *       pauses once that character has been rendered
**/
class Pause implements Effect {
	private var t:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["t" => Setters.setFloat];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		var countdown = t;
		return (delta) -> {
			if (!o.visible) {
				return true;
			}

			countdown -= delta;
			return countdown <= 0;
		}
	}

	public function begin(ops:TypeOptions) {}

	public function end(ops:TypeOptions) {}
}

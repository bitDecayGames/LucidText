package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxText;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Allows inserting a dynamic pause into a typed string of text.
 *
 * NOTE: This effect renders the character AFTER the tag, and
 *       pauses once that character has been rendered
**/
class Pause implements Effect {
	private var enforcer:Int = -1;
	private var t:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["t" => Setters.setFloat];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		if (enforcer == -1) {
			enforcer = i;
		}

		if (enforcer != i) {
			throw 'the \'pause\' tag at position ${i} should be a void tag: <pause/>. If slow typing is intended, adjust the type speed';
		}

		var countdown = t;
		return (delta) -> {
			if (!o.visible) {
				return true;
			}

			countdown -= delta;
			return countdown <= 0;
		}
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}

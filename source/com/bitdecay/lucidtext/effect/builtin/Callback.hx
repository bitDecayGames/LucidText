package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

@description("Non-visual effect to allow easy use of tag callbacks function for programmatic interaction")
class Callback implements Effect {
	@description("Just a value that code can watch for to perform arbitrary actions")
	public var val:String = "";

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["val" => Setters.setString];
	}

	public function apply(o:FlxBitmapText, i:Int):EffectUpdater {
		return null;
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}

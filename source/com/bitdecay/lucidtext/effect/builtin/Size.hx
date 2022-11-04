package com.bitdecay.lucidtext.effect.builtin;

import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import com.bitdecay.lucidtext.properties.Setters;

@description("Allows setting the size of characters relative to their current size")
class Size implements Effect {
	@description("Scalar to modify the base size")
	@range(0.1, 10)
	public var mod:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["mod" => Setters.setFloat];
	}

	public function apply(o:FlxBitmapText, i:Int):EffectUpdater {
		var preHeight = o.height * o.scale.y;
		var preScale = o.scale;
		var botCenterPoint = o.getPosition().add(0, preHeight);

		o.scale.set(preScale.x * mod, preScale.y * mod);
		var postHeight = o.height * o.scale.y;
		o.updateHitbox();
		var alignmentOffset = (preHeight - postHeight) / 2;
		o.setPosition(botCenterPoint.x, botCenterPoint.y - postHeight - alignmentOffset);
		botCenterPoint.put();
		return null;
	}

	public function begin(ops:ModifiableOptions) {}

	public function end(ops:ModifiableOptions) {}
}

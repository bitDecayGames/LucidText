package com.bitdecay.lucidtext.effect.builtin;

import com.bitdecay.lucidtext.effect.Effect.EffectUpdater;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Allows setting the size of characters relative to their current size
**/
class Size implements Effect {
	public var mod:Float = 1.0;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["mod" => Setters.setFloat];
	}

	public function apply(o:FlxText, i:Int):EffectUpdater {
		var preHeight = o.size;
		var botCenterPoint = o.getPosition().add(0, o.height);
		o.size = Std.int(o.size * mod);
		o.updateHitbox();
		var postHeight = o.size;
		// take the new height difference divided by 4 because we want to move it
		// half of the height added to the bottom side of the letter
		var alignmentOffset = (preHeight - postHeight) / 4;
		o.setPosition(botCenterPoint.x, botCenterPoint.y - o.height - alignmentOffset);

		return null;
	}

	public function begin(ops:TypeOptions) {}

	public function end(ops:TypeOptions) {}
}

package com.bitdecay.lucidtext.effect.builtin;

import flixel.FlxObject;
import flixel.text.FlxText;
import com.bitdecay.lucidtext.properties.Setters;

/**
 * Allows setting the size of characters
**/
class Size implements Effect {
	var s:Int;

	public function new() {}

	public function getUserProperties():Map<String, PropSetterFunc> {
		return ["s" => Setters.setInt];
	}

	public function apply(o:FlxText, i:Int):ActiveFX {
		var midPoint = o.getMidpoint();
		o.size = s;
		setPositionMidpoint(o, midPoint.x, midPoint.y);
		return null;
	}

	private static function setPositionMidpoint(o:FlxObject, x:Float, y:Float) {
		o.setPosition(x - o.width / 2, y - o.height / 2);
	}
}

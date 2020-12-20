package com.bitdecay.lucidtext.effect;

import flixel.text.FlxText;

class Color implements Effect {
	var color:Int;

	public function new() {}

	public function setProperties(props:Dynamic) {
		color = Std.parseInt(props.c);
	}

	public function apply(o:FlxText, i:Int):ActiveFX {
		o.color = color;
		return null;
	}
}

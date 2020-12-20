package com.bitdecay.lucidtext.effect;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;

/**
 * A sine wave motion for the affected characters
 *
 * Supports the following properties:
 *   * `height` - the amplitude of the sine path
 *   * `speed`  - the frequency of the sine path
 *   * `timing` - the timing offset between characters in seconds
**/
class Wave implements Effect {
	var height:Float = 0.0;
	var speed:Float = 0.0;
	var offset:Float = 0.0;

	public function new() {}

	public function setProperties(props:Dynamic) {
		height = Std.parseFloat(props.height);
		speed = Std.parseFloat(props.speed);
		offset = Std.parseFloat(props.offset);
	}

	public function apply(o:FlxText, i:Int):ActiveFX {
		var myVars = {
			myHeight: height,
			tweenTo: -height,
		};

		FlxTween.tween(myVars, {myHeight: myVars.tweenTo}, speed, {
			type: FlxTweenType.PINGPONG,
			ease: FlxEase.linear,
			onUpdate: (t) -> {
				o.y += myVars.myHeight;
			},
			// Not using startDelay makes this very tricky to get right
			startDelay: i * offset,
		});

		// NOTE: These are useful calculations that might come in handy if we
		//       try to rework how the 'startDelay' works
		// var maxHeight = (2.5*height*12*speed)/2;
		// trace(Math.sin(0.5) * maxHeight);

		return null;
	}
}

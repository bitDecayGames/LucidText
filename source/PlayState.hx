package;

import flixel.tweens.FlxEase;
import haxe.Timer;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;
import com.bitdecay.lucidtext.Parser;

class PlayState extends FlxState {
	var helloText:TextGroup;

	override public function create():Void {
		super.create();

		Parser.parseText("hello <wave height=10>bitch</wave>. How r u?");

		helloText = new TextGroup(0, 0, "Hello there!");
		add(helloText);

		add(new TextGroup(100, 100, "This is a relatively simple test"));
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		helloText.y += 100 * elapsed;
	}
}

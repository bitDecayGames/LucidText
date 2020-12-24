package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		#if debug
		addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true, false));
		#else
		addChild(new FlxGame(0, 0, MainMenuState, 1, 60, 60, true, false));
		#end
	}
}

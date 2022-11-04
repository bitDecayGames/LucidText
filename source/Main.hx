package;

import openfl.display.FPS;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.MainMenuState;

class Main extends Sprite {
	public static var fps = new FPS();
	public function new() {
		super();

		FlxG.autoPause = false;
		addChild(new FlxGame(MainMenuState, 1, 60, 60, true, false));

		fps.visible = false;
		addChild(fps);
	}
}

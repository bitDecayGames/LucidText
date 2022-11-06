package;

#if lucid_debug
import com.bitdecay.lucidtext.effect.EffectRegistry;
#end

import openfl.display.FPS;
import openfl.display.Sprite;

import flixel.FlxG;
import flixel.FlxGame;
import states.MainMenuState;

class Main extends Sprite {
	public static var fps = new FPS();
	public function new() {
		super();

		FlxG.autoPause = false;
		addChild(new FlxGame(MainMenuState, 1, 60, 60, true, false));

		fps.visible = false;
		addChild(fps);

		#if lucid_debug
		EffectRegistry.dumpToConsole();
		#end
	}
}

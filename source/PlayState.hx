package;

import haxe.rtti.Meta;
import com.bitdecay.lucidtext.effect.EffectRegistry;
import com.bitdecay.lucidtext.dialog.DialogOptions;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import com.bitdecay.lucidtext.TypeOptions;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.FlxG;
import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;
import com.bitdecay.lucidtext.TypingGroup;
import com.bitdecay.lucidtext.dialog.DialogManager;

class PlayState extends FlxState {
	var helloText:TypingGroup;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.WHITE;

		EffectRegistry.dumpToConsole();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}

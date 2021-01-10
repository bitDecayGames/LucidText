package;

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

		// FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultColor = FlxColor.BLACK;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;
		FlxG.autoPause = false;

		var textMap = [
			"first" => [
				"The Dialog Manager gives a way to handle text data with a key->value pattern",
				"Things will automatically be broken up and fitted to the provided text box (which is pretty cool)",
				"It doesn't, <smaller>however</smaller>, handle paging text if it's too long... tags <wave>likely</wave> mess things up"
			]
		];

		var dialogOpts = new DialogOptions();
		dialogOpts.progressionKey = FlxKey.SPACE;

		var options = new TypeOptions(new FlxRect(20, 30, FlxG.width - 40, 100), AssetPaths.slice__png, [4, 4, 12, 12]);
		options.nextIconMaker = () -> {
			var nextPageIcon = new FlxSprite();
			nextPageIcon.loadGraphic(AssetPaths.nextPage__png, true, 32, 32);
			nextPageIcon.animation.add("play", [0, 1, 2, 3, 4, 1], 10);
			nextPageIcon.animation.play("play");
			return nextPageIcon;
		};
		options.checkPageConfirm = (delta) -> {
			return FlxG.keys.justPressed.SPACE;
		}

		// var dialogMgr = new DialogManager(textMap, this, camera, dialogOpts, options);
		// add(dialogMgr);

		// dialogMgr.loadDialog("first");

		helloText = new TypingGroup("<fade>THIS FADES OVER TIME</fade>", options);
		add(helloText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		// FlxG.watch.addQuick("helloText Finished:", helloText.finished);
	}
}

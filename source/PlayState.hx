package;

import misc.FlxTextFactory;
import flixel.FlxState;
import com.bitdecay.lucidtext.TextGroup;

class PlayState extends FlxState {
	var helloText:TextGroup;

	override public function create():Void {
		super.create();

		FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		TextGroup.textMakerFunc = FlxTextFactory.makeSimple;

		helloText = new TextGroup(100, 100, "<color c=0xFF0000><wave>hello</color> Stephanie...</wave> How <shake size=3>are you?</shake>", 24);
		add(helloText);
		var other = FlxTextFactory.make("hello Stephanie... How are you?", 100, 130, 24);
		add(other);

		var smaller = new TextGroup(100, 200,
			"<color c=0xFF0000><wave height=10 speed=20 offset=0.1>hello</color> Stephanie...</wave> How <size s=24>are</size>  <size s=48>you?</size>", 16);
		add(smaller);
		var otherSmaller = FlxTextFactory.make("hello Stephanie... How are you?", 100, 230, 16);
		add(otherSmaller);

		var smallest = new TextGroup(100, 300,
			"<color c=0xFF0000><wave height=1 speed=2 offset=0.1>hello</color> Stephanie...</wave> How <shake size=1>are you?</shake>", 8);
		add(smallest);
		var otherSmallest = FlxTextFactory.make("hello Stephanie... How are you?", 100, 330, 8);
		add(otherSmallest);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		helloText.y += 10 * elapsed;
	}
}

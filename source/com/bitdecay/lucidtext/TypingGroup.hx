package com.bitdecay.lucidtext;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxRect;

class TypingGroup extends TextGroup {
	var position:Int = 0;
	var typeSpeed:Float = 20;

	var elapsed:Float = 0.0;
	var calcedTimePerChar:Float = 0.0;

	var bounds:FlxRect;

	public function new(box:FlxRect, text:String, size:Int) {
		super(box.left, box.top, text, size);

		calcedTimePerChar = 1 / typeSpeed;
		bounds = box;

		// var backing = new FlxSprite(box.left, box.top);
		var backing = new FlxSprite(0, 0);
		backing.makeGraphic(Std.int(box.width), Std.int(box.height), FlxColor.BLUE);

		for (m in members) {
			m.visible = false;
		}

		organizeTextToRect();

		// We want the preAdd stuff of the FlxSpriteGroup...
		add(backing);
		// ...but we also want the backing to be at index zero
		members.remove(backing);
		members.insert(0, backing);
	}

	private function organizeTextToRect() {
		var wordMatcher:EReg = ~/\b\w+\b/g;
		var wordStarts:Array<Int> = [];
		var wordLengths:Map<Int, Int> = [];
		wordMatcher.map(renderText, (m) -> {
			wordStarts.push(m.matchedPos().pos);
			wordLengths.set(m.matchedPos().pos, m.matchedPos().len);
			return m.matched(0);
		});

		for (start in wordStarts) {
			for (k in start...start + wordLengths[start]) {
				if (members[k].x + members[k].width > bounds.right) {
					shuffleMembersNextRow(start);
					break;
				}
			}
		}
	}

	private function shuffleMembersNextRow(begin:Int) {
		var xCoord = x;
		// this likely isn't a great value to use, we want the "base" line size for the font
		var yCoordOffset = members[begin].height;
		for (i in begin...members.length) {
			members[i].x = xCoord;
			members[i].y += yCoordOffset;
			xCoord += members[i].width + TextGroup.spacingMod;
		}
	}

	public function setTypeSpeed(charPerSec:Float) {
		typeSpeed = charPerSec;
		calcedTimePerChar = 1 / typeSpeed;
	}

	override public function update(delta:Float) {
		super.update(delta);
		FlxG.watch.addQuick("cursorPos: ", position);
		FlxG.watch.addQuick("memLen: ", members.length);

		elapsed += delta;
		while (elapsed > calcedTimePerChar && position < members.length) {
			elapsed -= calcedTimePerChar;
			members[position].visible = true;
			position++;
		}
	}
}

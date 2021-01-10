package com.bitdecay.lucidtext;

import flixel.math.FlxRect;
import flixel.FlxSprite;

typedef CheckConfirmFunc = (Float) -> Bool;

class TypeOptions {
	public var windowAsset:String;
	public var slice9:Array<Int> = null;
	public var margins:Float = 10.0;
	public var fontSize:Int = 24;

	/**
	 * A function to check for user confirmation of page
	 *
	 * @default defaults to a 2 second timer
	**/
	public var checkPageConfirm:CheckConfirmFunc;

	/**
	 * Called to create the 'next' icon if one is desired
	**/
	public var nextIconMaker:() -> FlxSprite;

	public var modOps:ModifiableOptions;

	public function new(windowAsset:String = null, slice9:Array<Int> = null, ?margins:Float, ?fntSize:Int, ?modOps:ModifiableOptions) {
		this.windowAsset = windowAsset;
		this.slice9 = slice9;

		if (margins != null) {
			this.margins = margins;
		}

		if (fntSize != null) {
			this.fontSize = fntSize;
		}

		if (modOps == null) {
			modOps = new ModifiableOptions();
		}
		this.modOps = modOps;

		checkPageConfirm = getDelayConfirmFunc(2);
	}

	public function clone():TypeOptions {
		return new TypeOptions(windowAsset, slice9, margins, fontSize, modOps == null ? null : modOps.clone());
	}

	public function getTimePerCharacter():Float {
		if (modOps.charsPerSecond <= 0) {
			return 0;
		} else {
			return 1 / modOps.charsPerSecond;
		}
	}

	private static function getDelayConfirmFunc(delay:Float):CheckConfirmFunc {
		var timer = delay;
		return (delta) -> {
			timer -= delta;
			if (timer <= 0) {
				// reset our timer for next time
				timer = delay;
				return true;
			} else {
				return false;
			}
		}
	}
}

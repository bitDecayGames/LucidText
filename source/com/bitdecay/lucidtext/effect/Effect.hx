package com.bitdecay.lucidtext.effect;

import flixel.text.FlxText;

/**
 * An interface for simple effect logic. Implement this interface
 * and register the new Effect with the EffectRegistry
**/
interface Effect {
	/**
	 * Pass in properties the effect may need
	 */
	public function setProperties(props:Dynamic):Void;

	/**
	 * Applies the effect to the given FlxText object
	 *
	 * @param o The FlxText object to apply the effect to
	 * @param i The index of the given FlxText, useful for effects
	 *          that need to apply differently to each letter
	 *          (Such as a sine wave through a word)
	 *
	 * @return An active effect object to be updated
	 */
	public function apply(o:FlxText, i:Int):ActiveFX;
}

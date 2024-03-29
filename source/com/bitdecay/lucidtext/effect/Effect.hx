package com.bitdecay.lucidtext.effect;

import flixel.text.FlxBitmapText;
import com.bitdecay.lucidtext.ModifiableOptions;
import com.bitdecay.lucidtext.properties.Setters.PropSetterFunc;

/**
 * A function that takes in a delta time and returns true if the text should continue typing, false otherwise
 *
 * NOTE: For the sake of web builds, all exposed 'UserProperties' must have a default value assigned in the
 * field declaration so the javascript sees the property correctly when using reflection
**/
typedef EffectUpdater = (Float) -> Bool;

/**
 * An interface for simple effect logic. Implement this interface
 * and register the new Effect with the EffectRegistry.
 *
 * Note: All instance fields can be made editable if there is an
 *       appropriate `PropSetterFunc` for its type
**/
interface Effect {
	/**
	 * Get all expected user-defined properties for an effect
	**/
	public function getUserProperties():Map<String, PropSetterFunc>;

	/**
	 * Applies the effect to the given FlxBitmapText object
	 *
	 * @param o The FlxBitmapText object to apply the effect to
	 * @param i The index of the given FlxBitmapText, useful for effects
	 *          that need to apply differently to each letter
	 *          (Such as a sine wave through a word)
	 *
	 * @return An EffectUpdater to be updated, or `null`
	 *         if no updates are needed for the effect
	 */
	public function apply(o:FlxBitmapText, i:Int):EffectUpdater;

	public function begin(ops:ModifiableOptions):Void;
	public function end(ops:ModifiableOptions):Void;
}

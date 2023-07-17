package misc;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxText.FlxTextAlign;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.text.FlxBitmapText;

/**
 * A factory to help create FlxBitmapText objects in a consistent mannor
 */
class FlxBitmapTextFactory {
	/**
	 * Default size for anything this factory creates
	 */
	public static var defaultSize:Int = 8;

	/**
	 * Default font for anything this factory creates
	 */
	public static var defaultFont:String = FlxAssets.FONT_DEFAULT;

	/**
	 * Default color for anything this factory creates
	 */
	public static var defaultColor:Int = FlxColor.WHITE;

	/**
	 * Default alignment for anything this factory creates
	 */
	public static var defaultAlign:FlxTextAlign = FlxTextAlign.LEFT;

	/**
	 * Creates a FlxBitmapText object
	 *
	 * @param text  The text to display
	 * @param x     The X position of the new FlxBitmapText
	 * @param y     The Y position of the new FlxBitmapText
	 * @param size  `Optional` The font size if something other than default is desired
	 * @param align `Optional` The font alignment
	**/
	public static function make(text:String, ?x:Float, ?y:Float, ?size:Int, ?align:Null<FlxTextAlign>, ?color:Int):FlxBitmapText {
		var txt = new FlxBitmapText(FlxBitmapFont.getDefaultFont());
		txt.x = x;
		txt.y = y;
		txt.text = text;
		txt.color = color == null ? defaultColor : color;
		txt.alignment = align == null ? defaultAlign : align;

		// cheeky abuse of the getter to get it to update the pixels
		txt.width;
		// TODO: should be scale?
		if (size != null) {
			var scale = 1.0 * size / txt.height;
			txt.scale.set(scale, scale);
		}
		txt.updateHitbox();
		return txt;
	}

	/**
	 * Creates a FlxBitmapText object with the project defaults. Handy for handing function to other
	 * things to call
	 *
	 * @param text  The text to display
	 * @param x     The X position of the new FlxBitmapText
	 * @param y     The Y position of the new FlxBitmapText
	**/
	public static function makeSimple(text:String, x:Float, y:Float, size:Int):FlxBitmapText {
		return make(text, x, y, size);
	}
}

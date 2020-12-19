package misc;

import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.text.FlxText;

/**
 * A factory to help create FlxText objects in a consistent mannor
 */
class FlxTextFactory {
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
	 * Creates a FlxText object with the project defaults
	 *
	 * @param text  The text to display
	 * @param x     The X position of the new FlxText
	 * @param y     The Y position of the new FlxText
	 * @param size  `Optional` The font size if something other than default is desired
	 * @param align `Optional` The font alignment
	**/
	public static function make(text:String, ?x:Float, ?y:Float, ?size:Int, ?align:Null<FlxTextAlign>, ?color:Int):FlxText {
		var txt = new FlxText(x, y, text);
		txt.setFormat(defaultFont, size == null ? defaultSize : size, color == null ? defaultColor : color, align == null ? defaultAlign : align);
		return txt;
	}

	/**
	 * Creates a FlxText object with the project defaults. Handy for handing function to other
	 * things to call
	 *
	 * @param text  The text to display
	 * @param x     The X position of the new FlxText
	 * @param y     The Y position of the new FlxText
	**/
	public static function makeSimple(text:String, x:Float, y:Float, size:Int):FlxText {
		return make(text, x, y, size);
	}
}

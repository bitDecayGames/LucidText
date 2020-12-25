package com.bitdecay.lucidtext.parse;

import com.bitdecay.lucidtext.effect.builtin.Pause;
import massive.haxe.log.Log;
import com.bitdecay.lucidtext.effect.builtin.Scrub;
import com.bitdecay.lucidtext.effect.EffectRegistry;
import com.bitdecay.lucidtext.effect.builtin.Wave;
import massive.munit.Assert;
import com.bitdecay.lucidtext.parse.Parser;

class ParserTest {
	@Test
	public function testParsedEffect() {
		var text = "Wavy <wave height=543 speed=54 offset=0.123>World</wave>";
		var parser = new Parser(text);
		parser.parse();

		Assert.areEqual(1, parser.effects.length);
		Assert.isType(parser.effects[0].effect, Wave);
		var wave = cast(parser.effects[0].effect, Wave);
		Assert.areEqual(543, wave.height);
		Assert.areEqual(54, wave.speed);
		Assert.areEqual(0.123, wave.offset);
	}

	@Test
	public function testVoidCloserTagFails() {
		var text = "VoidCloser <wave>Test</wave />";
		var parser = new Parser(text);
		var except = Assert.throws(String, parser.parse);
		Assert.isTrue(StringTools.contains(except, "closing tags cannot also be void tags"), except);
		Assert.isTrue(StringTools.contains(except, "21"), except);
	}

	@Test
	public function testVoidTag() {
		var text = "Pause<pause /> test";
		var parser = new Parser(text);
		parser.parse();

		Assert.areEqual(1, parser.effects.length);

		var fx = parser.effects[0];
		Assert.isType(fx.effect, Pause);
		Assert.areEqual(5, fx.startIndex);
		Assert.areEqual(5, fx.endIndex);
	}

	@Test
	public function testMultipleVoidTag() {
		var text = "Do<pause /> two<pause /> pauses";
		var parser = new Parser(text);
		parser.parse();

		Assert.areEqual(2, parser.effects.length);

		var fx = parser.effects[0];
		Assert.isType(fx.effect, Pause);
		Assert.areEqual(2, fx.startIndex);
		Assert.areEqual(2, fx.endIndex);

		fx = parser.effects[1];
		Assert.isType(fx.effect, Pause);
		Assert.areEqual(6, fx.startIndex);
		Assert.areEqual(6, fx.endIndex);
	}

	@Test
	public function testNestedSameTagFails() {
		var text = "<shake>Shaking <shake size=20>harder</shake> World</shake>";
		var parser = new Parser(text);
		var except = Assert.throws(String, parser.parse);
		Assert.isTrue(StringTools.contains(except, "this library doesn't handle nested tags with the same effect"));
		Assert.isTrue(StringTools.contains(except, "shake"));
	}

	// TODO: This should be an error situation
	// @Test
	// public function testMissingOpenTag() {
	// 	var text = "</shake>Shaking";
	// 	var parser = new Parser(text);
	// 	var except = Assert.throws(String, parser.parse);
	// 	Assert.isTrue(StringTools.contains(except, "found closing tag with no opening tag"), 'got except: ${except}');
	// 	Assert.isTrue(StringTools.contains(except, "/shake"), 'got except: ${except}');
	// }

	@Test
	public function testBadTagThrows() {
		var text = "<badTag>Hi</badTag>";
		var parser = new Parser(text);
		var except = Assert.throws(String, parser.parse);
		Assert.isTrue(StringTools.contains(except, "no registered effect with name 'badTag'"), 'got exception ${except}');
	}

	@Test
	public function testDefaultsApplied() {
		EffectRegistry.register("defaultTest", () -> return new Scrub());
		EffectRegistry.registerDefault("defaultTest",
		{
			height: "1234",
			reverse: "true",
		});

		var text = "<defaultTest>Hi</defaultTest>";
		var parser = new Parser(text);
		parser.parse();
		Assert.areEqual(1, parser.effects.length);
		var fx:Scrub = cast(parser.effects[0].effect, Scrub);
		Assert.areEqual(1234, fx.height);
		Assert.areEqual(true, fx.reverse);
	}
}
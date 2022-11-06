package com.bitdecay.lucidtext.parse;

import com.bitdecay.lucidtext.effect.builtin.Shake;
import com.bitdecay.lucidtext.effect.builtin.Bigger;
import massive.munit.Assert;

import com.bitdecay.lucidtext.effect.builtin.Pause;
import com.bitdecay.lucidtext.effect.builtin.Scrub;
import com.bitdecay.lucidtext.effect.EffectRegistry;
import com.bitdecay.lucidtext.effect.builtin.Wave;
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
		Assert.areEqual(5, fx.startTag.position);
		Assert.areEqual(5, fx.endTag.position);
	}

	@Test
	public function testMultipleVoidTag() {
		var text = "Do<pause /> two<pause /> pauses";
		var parser = new Parser(text);
		parser.parse();

		Assert.areEqual(2, parser.effects.length);

		var fx = parser.effects[0];
		Assert.isType(fx.effect, Pause);
		Assert.areEqual("pause", fx.startTag.tag);
		Assert.areEqual(2, fx.startTag.position);
		Assert.areEqual(2, fx.endTag.position);

		fx = parser.effects[1];
		Assert.isType(fx.effect, Pause);
		Assert.areEqual("pause", fx.startTag.tag);
		Assert.areEqual(6, fx.startTag.position);
		Assert.areEqual(6, fx.endTag.position);
	}

	@Test
	public function testNestedSameTagFails() {
		var text = "<shake>Shaking <shake size=20>harder</shake> World</shake>";
		var parser = new Parser(text);
		var except = Assert.throws(String, parser.parse);
		Assert.isTrue(StringTools.contains(except, "this library doesn't handle nested tags with the same effect"));
		Assert.isTrue(StringTools.contains(except, "shake"));
	}

	@Test
	public function testMissingOpenTag() {
		var text = "</shake>Shaking";
		var parser = new Parser(text);
		var except = Assert.throws(String, parser.parse);
		Assert.isTrue(StringTools.contains(except, "found closing tag with no opening tag"), 'got except: ${except}');
		Assert.isTrue(StringTools.contains(except, "/shake"), 'got except: ${except}');
	}

	@Test
	public function testOffsetTagg() {
		var text = "<bigger>big and <shake>shaking</bigger> interlaced</shake>";
		var parser = new Parser(text);
		parser.parse();

		Assert.areEqual(2, parser.effects.length);

		var fx = parser.effects[0];
		Assert.isType(fx.effect, Bigger);
		Assert.areEqual("bigger", fx.startTag.tag);
		Assert.areEqual(0, fx.startTag.position);
		Assert.areEqual(15, fx.endTag.position);

		fx = parser.effects[1];
		Assert.isType(fx.effect, Shake);
		Assert.areEqual("shake", fx.startTag.tag);
		Assert.areEqual(8, fx.startTag.position);
		Assert.areEqual(26, fx.endTag.position);
	}

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
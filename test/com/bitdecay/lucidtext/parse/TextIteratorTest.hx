package com.bitdecay.lucidtext.parse;

import massive.munit.Assert;
import com.bitdecay.lucidtext.parse.TextIterator;

class TextIteratorTest {
	@Test
	public function testTaglessString() {
		var text = "Hello World";
		var iter = new TextIterator(text);
		var tag = iter.getNextTag();

		Assert.isNull(tag);
	}

	@Test
	public function testInnerTags() {
		var text = "Hello <inside> World";
		var iter = new TextIterator(text);
		var tag = iter.getNextTag();

		Assert.isNotNull(tag);
		Assert.areEqual("inside", tag.tag);
		Assert.areEqual(6, tag.position);
		Assert.areEqual(6, tag.rawPosition);
		Assert.isEmpty(tag.options);
	}

	@Test
	public function testTagAtBeginning() {
		var text = "<start> Hello World";
		var iter = new TextIterator(text);
		var tag = iter.getNextTag();

		Assert.isNotNull(tag);
		Assert.areEqual("start", tag.tag);
		Assert.areEqual(0, tag.position);
		Assert.areEqual(0, tag.rawPosition);
		Assert.isEmpty(tag.options);
	}

	@Test
	public function testTagAtEnd()
	{
		var text = "World</shake>";
		var iter = new TextIterator(text);
		var tag = iter.getNextTag();

		Assert.isNotNull(tag);
		Assert.areEqual("shake", tag.tag);
		Assert.areEqual(5, tag.position);
		Assert.areEqual(5, tag.rawPosition);
		Assert.isEmpty(tag.options);
	}

	@Test
	public function testUnterminatedTagEndTextFails(){
		var text = "<shake";
		var iter = new TextIterator(text);
		var except = Assert.throws(String, iter.getNextTag);
		Assert.isTrue(StringTools.contains(except, "Expected '>' but reached end of string"));
	}

	@Test
	public function testParseOptions() {
		var text = "<opTag height=54 speed=32>hello";
		var iter = new TextIterator(text);
		var tag = iter.getNextTag();

		Assert.isFalse(tag.close);
		Assert.areEqual("opTag", tag.tag);
		Assert.areEqual("height=54 speed=32", tag.options);
		Assert.areEqual(0, tag.position);
		Assert.areEqual(0, tag.rawPosition);
	}

	@Test
	public function testRawPosition() {
		var text = "Chars<tag>moreChars<tag2>";
		var iter = new TextIterator(text);
		var tag = iter.getNextTag();
		Assert.isNotNull(tag);

		tag = iter.getNextTag();
		Assert.isNotNull(tag);

		Assert.areEqual("tag2", tag.tag);
		Assert.areEqual(14, tag.position);
		Assert.areEqual(19, tag.rawPosition);
	}

	@Test
	public function testFullTagPair()
	{
		var text = "<wave height=54 speed=32>wave</wave>";
		var iter = new TextIterator(text);
		var waveOpen = iter.getNextTag();

		Assert.isFalse(waveOpen.close);
		Assert.areEqual("wave", waveOpen.tag);
		Assert.areEqual("height=54 speed=32", waveOpen.options);
		Assert.areEqual(0, waveOpen.position);
		Assert.areEqual(0, waveOpen.rawPosition);

		var waveClose = iter.getNextTag();
		Assert.isTrue(waveClose.close);
		Assert.areEqual("wave", waveClose.tag);
		Assert.areEqual("", waveClose.options);
		Assert.areEqual(4, waveClose.position);
		Assert.areEqual(29, waveClose.rawPosition);
	}

	public function testGetAllTags() {
		var text = "<wave><dave><save>";
		var iter = new TextIterator(text);
		var tags = iter.getAllTags();
		Assert.areEqual(3, tags.length);
		Assert.areEqual(tags[0].tag, "wave");
		Assert.areEqual(tags[1].tag, "dave");
		Assert.areEqual(tags[2].tag, "save");
	}
}
package com.bitdecay.lucidtext.parse;

import massive.munit.Assert;

class OptionsTest {
	@Test
	public function testSimpleSingleParse()
	{
		var op = Options.parse("key=value");
		var fields = Reflect.fields(op);
		Assert.areEqual(fields, ["key"]);
		Assert.areEqual(op.key, "value");
	}

	@Test
	public function testSimpleMultiParse()
	{
		var op = Options.parse("key=hello other=world");
		var fields = Reflect.fields(op);
		Assert.areEqual(fields, ["key", "other"]);
		Assert.areEqual(op.key, "hello");
		Assert.areEqual(op.other, "world");
	}

	@Test
	public function testKeyOnlyFails()
	{
		var except = Assert.throws(String, () -> {Options.parse("key");});
		Assert.isTrue(StringTools.contains(except, "unexpected option 'key'"), 'got exception: ${except}');
	}
}
package com.bitdecay.lucidtext.effect;

import massive.munit.Assert;
import com.bitdecay.lucidtext.effect.builtin.Scrub;

class EffectRegistryTest {
	@Test
	public function testRegisterDefaultForExistingEffect() {
		EffectRegistry.register("testABC", () -> return new Scrub());
		EffectRegistry.registerDefault("testABC", {height: 123});
	}

	@Test
	public function testRegisterDefaultThrowsForNonExistingEffect() {
		var except = Assert.throws(String, () -> EffectRegistry.registerDefault("notHere", {height: 123}));
		Assert.isTrue(StringTools.contains(except, "no registered effect with name 'notHere'"), 'got exception ${except}');
	}
}
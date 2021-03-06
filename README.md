![LucidTest](assets/images/ludic.gif?raw=true "LucidText")

LucidText is a HaxeFlixel library designed to give easy access to juicy text in the style of games like Paper Mario, Animal Crossing, and Celeste.

## Table of Contents

* [Design Principals](#design-principals)
* [Tagging](#tagging)
* [Custom Tags](#custom-tags)
* [Discoverability](#discoverability)
* [Testing](#testing)
* [Formatting](#formatting)

### Design Principals

#### **Foundational Concepts**

* User Input
	* This library is designed to allow a user to customize in-game text without needing to touch the code.
	* This is achieved by expecting styling directives to be part of the text strings in the form of HTML-style tags. See [Tagging](#tagging) for more information.
* Effects
	* An effect can be anything that occurs when a position in a string is reached
		* A few examples of Effects:
			1. One time change such as `color` or `size`
			1. Actively updated Effects such as `wave` and `shake`
			1. Specialty effects such as `pause` which are used internally for temporal effects
		* Any effects involving motion should avoid using the `FlxTween` engine as that causes strange behavior if the user attempts to move the text object while the tween is active
	* Effects can be used to do anything!

### Tagging

Tags follow an HTML style and are contained directly in the input strings.

The title image at the top of this readme is created by specifying:

`Welcome to <wave>LucidText!</wave>`

This library comes with various generic style tags, a few of which are:

* `wave` - A sine wave that moves through the text
* `color` - Set the color of the text
* `shake` - Adds a random shake to the text

Tags can also have various options set. The `wave`, for example, effect has `speed` and `height` (among others). Using these options looks like:
```
Welcome to <wave height=30 speed=5>LucidText!</wave>
```
Which would render as:

![LucidTest](assets/images/lucid_options.gif?raw=true "LucidText")

#### **Two kinds of tags**

The majority of tags are intended to apply an effect to range of characters, such as the `wave` effect used in the title image. Tags can be applied to a singular position in a string, as well. These are currently used for certain specialty effects, namely `page` and `pause`, which apply to a position in the string as opposed to a range of characters. These are written like HTML void elements: `<page/>` and `<pause/>` respectively.

### Custom Tags

If the built-in tags are insufficient for a project's needs, custom tags can be eaily added:

1. Create a class that implements the `Effect` interface
1. Register the effect with via the `EffectRegistry.register(...)` function
1. Any text loaded after registering an effect can use the tag thereafter

### Discoverability

One of the hardest parts of using a library like this is knowing what the available options are. To combat this, the current state of the `EffectRegistry` can be dumped.

By calling `EffectRegistry.dumpToConsole()` will look at the annotations on each registered effect and print out the available information to console. A snippet of this output looks like this:

```
┌ ───── ┐
│ color │
└ ───── ┘
  └ description: [Allows setting the color of characters]
  └ parameters
     ├ rgb
     │  └ description: [Color integer formatted as `0xRRGGBB`]
     └ alpha
        ├ range: [0,1]
        └ description: [Float value controlling transparency]
```

This might be better accomplished by a documentation generator in the future.

### Testing

This project has been set up with MUnit to handle the unit tests. After various failed attempts at getting MUnit working with other projects, [this article](https://ashes999.github.io/learnhaxe/integration-testing-in-munit-with-haxeflixel.html) finally had a simple setup that cooperated well.

#### **Dependencies**

```
haxelib install munit
haxelib install hamcrest
```

#### **Running Tests**

From the `test/` directory, simply run `lime test neko` and the tests will be executed.

#### **Adding Tests**

Tests should be put into a class that groups relevant tests together. If these tests are added to a new class, it must be added to the `TestSuite.hx` for it to be seen and run by MUnit.
* In `TestSuite.hx`, add a new line to add a class to the test suite with `add(<Class with tests>);`

### Formatting

This project uses the `formatter` library ([this repo](https://github.com/HaxeCheckstyle/haxe-formatter)) for all formatting.

To install the formatter, run:
```
haxelib install formatter
```

To format the source code, run:
```
haxelib run formatter -s source/
```
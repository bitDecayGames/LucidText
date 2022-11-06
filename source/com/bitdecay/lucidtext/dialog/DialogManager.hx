package com.bitdecay.lucidtext.dialog;

import haxe.Timer;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.input.keyboard.FlxKey;

import com.bitdecay.lucidtext.TypeOptions;
import com.bitdecay.lucidtext.TypingGroup;

class DialogManager extends FlxBasic {
	static inline final FontSize = 10;

	var currentDialogIndex:Int = -1;
	var currentDialogId:String = "";

	// TODO: Pull these out into an Options class that we can pass around
	//       Will need to also put font size in there if it makes sense
	static inline final CharactersPerTextBox = 100;
	static inline final NextPageDelayMs = 4000;
	static inline final NextPageInputDelayMs = 500;

	var dialogMap:Map<String, Array<String>>;

	public var typeText:TypingGroup;
	public var typeOptions:TypeOptions;

	var textItems:Array<String>;
	var currentIndex:Int = 0;
	var typing:Bool;
	var fastTyping:Bool = false;
	var canManuallyTriggerNextPage:Bool;

	// Keep references to the timers to reset them whenever a new page of text starts
	// Initialize them to real timers to avoid the need to check for null
	var autoProgressTimer:Timer = new Timer(1000);
	var manuallyProgressTimer:Timer = new Timer(1000);

	var dialogOptions:DialogOptions;

	public function new(_dialogMap:Map<String, Array<String>>, _parentState:FlxState, _camera:FlxCamera, ?dialogOpts:DialogOptions, ?typeOpts:TypeOptions) {
		super();

		dialogMap = _dialogMap;

		if (dialogOpts != null) {
			dialogOptions = dialogOpts;
		} else {
			dialogOptions = new DialogOptions(new FlxRect(20, 30, FlxG.width - 40, 100));
		}

		if (typeOpts == null) {
			// Likely not a great default, but it will suffice
			typeOpts = new TypeOptions();
		}
		typeOptions = typeOpts;

		typeText = new TypingGroup(dialogOptions.window, "", typeOptions);
		typeText.scrollFactor.set(0, 0);
		typeText.cameras = [_camera];
		_parentState.add(typeText);
	}

	public function loadDialog(id:String) {
		if (dialogMap[id] == null) {
			trace("id (" + id + ") not found in dialog map");
			return;
		}
		textItems = dialogMap[id].copy();
		startTyping(textItems[0]);
		currentDialogId = id;
	}

	public function startTyping(text:String):Void {
		typeText.revive();
		typing = true;
		fastTyping = false;

		typeText.loadText(text);
		canManuallyTriggerNextPage = false;
		autoProgressTimer.stop();
		manuallyProgressTimer.stop();

		typeText.pageCallback = () -> {};

		// Set onComplete function in-line
		typeText.finishCallback = () -> {
			typing = false;

			if (dialogOptions.onTypingEnd != null) {
				dialogOptions.onTypingEnd();
			}

			// After NextPageDelayMs, the next page of text will be loaded
			autoProgressTimer = Timer.delay(() -> {
				continueToNextItem();
			}, NextPageDelayMs);

			// After NextPageInputDelayMs, the user can press a button to continue to the next page instead of waiting
			manuallyProgressTimer = Timer.delay(() -> {
				canManuallyTriggerNextPage = true;
			}, NextPageInputDelayMs);
		};

		if (dialogOptions.onTypingBegin != null) {
			dialogOptions.onTypingBegin();
		}
	}

	public function continueToNextItem():Void {
		currentIndex++;
		// When there is no more text to display, transition to completed state
		if (currentIndex >= textItems.length) {
			completeDialog();
		} else {
			startTyping(textItems[currentIndex]);
		}
	}

	public function completeDialog() {
		typeText.kill();

		fastTyping = false;
		canManuallyTriggerNextPage = false;
		autoProgressTimer.stop();
		manuallyProgressTimer.stop();
	}

	override public function update(delta:Float):Void {
		super.update(delta);

		if (typeText.waitingForConfirm) {}

		// Update loop exclusively handles user input
		if (dialogOptions.progressionKey != FlxKey.NONE) {
			if (typing && !fastTyping && FlxG.keys.anyJustPressed([dialogOptions.progressionKey])) {
				fastTyping = true;
				typeOptions.modOps.charsPerSecond *= 2;
				if (dialogOptions.onTypingSpeedUp != null) {
					dialogOptions.onTypingSpeedUp();
				}
			}

			if (canManuallyTriggerNextPage && FlxG.keys.anyJustPressed([dialogOptions.progressionKey])) {
				continueToNextItem();
			}
		}
	}

	public function getCurrentDialogIndex():Int {
		return currentDialogIndex;
	}

	public function getCurrentDialogId():String {
		return currentDialogId;
	}

	public function isTyping():Bool {
		return typing;
	}

	public function isDone():Bool {
		return !typing;
	}
}

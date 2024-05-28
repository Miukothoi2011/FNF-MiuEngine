package debug;

import flixel.FlxG;
import flixel.util.FlxStringUtil;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import lime.system.System;

import states.MainMenuState;
import backend.CoolSystemThingy;

import Main;

#if cpp
import external.memory.Memory;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	
	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;
	#if cpp
	public var memoryLeakMegas(get, never):Float; // memory leak
	#else
	public var memoryLeakMegas(default, null):Float = 0; // memory leak
	#end

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font('vcr.ttf'), #if mobile 14 #else 12 #end, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];
	}
	
	var deltaTimeout:Float = 0.0;
	
	// All the colors:			      Red,	      Orange,     Yellow,     Green,      Blue,       Violet/Purple
	final rainbowColors:Array<Int> = [0xFFFF0000, 0xFFFFA500, 0xFFFFFF00, 0xFF00FF00, 0xFF0000FF, 0xFFFF00FF];
	var colorInterp:Float = 0;
	var currentColor:Int = 0;

	// Event Handlers
	@:noCompletion
	private override function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;
		if(currentCount != cacheCount) updateText(); // Psych Dev remove the 'if(currentCount != cacheCount)' so i back this

		deltaTimeout += deltaTime;
		colorInterp += deltaTime / 330; // Division so that it doesn't give you a seizure on 60 FPS
		
		cacheCount = currentCount;
	}

	public dynamic function updateText():Void { // so people can override it in hscript, here: Main.fpsVar.updateText = function() { ... }
		if (ClientPrefs.data.showFPS)
			text = 'FPS: ${currentFPS}' + (ClientPrefs.data.ffmpegMode ? ' (Rendering Mode)' : '');

		if (ClientPrefs.data.showMemory) {
			#if !cpp
			if(memoryMegas > memoryLeakMegas)
				memoryLeakMegas = memoryMegas;
			#end

			text += '\nMemory: ${FlxStringUtil.formatBytes(memoryMegas)}'
			+ (ClientPrefs.data.showMemoryLeak ? ' / ${FlxStringUtil.formatBytes(memoryLeakMegas)}' : '');
		}

		if (ClientPrefs.data.showEngineVersion)
			text += '\nMiu Engine ${MainMenuState.miuEngineVersion} (Modified PE ${MainMenuState.psychEngineVersion})'; // Inspired by SB Engine by Stefan2008 (https://github.com/Stefan2008Git)
		
		if (ClientPrefs.data.showDebugInfo) {
			text += '\nOS: ${System.platformLabel} ${System.platformVersion}';
			text += '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}';
			if (FlxG.state.subState != null)
				text += '\nSubstate: ${Type.getClassName(Type.getClass(FlxG.state.subState))}';
			text += '\nHaxe ' + CoolSystemThingy.getHaxeVer;
			text += '\nOpenFL ' + CoolSystemThingy.getOpenFLVer;
			text += '\nLime ' + CoolSystemThingy.getLimeVer;
			text += '\nFlixel ' + FlxG.VERSION;
		}
		
		if (ClientPrefs.data.showRainbowFPS) {
			var colorIndex1:Int = Math.floor(colorInterp);
			var colorIndex2:Int = (colorIndex1 + 1) % rainbowColors.length;
			var startColor:Int = rainbowColors[colorIndex1];
			var endColor:Int = rainbowColors[colorIndex2];
			var segmentInterp:Float = colorInterp - colorIndex1;
			var interpolatedColor:Int = interpolateColor(startColor, endColor, segmentInterp);

			textColor = interpolatedColor;

			// Check if the current color segment interpolation is complete
			if (colorInterp >= rainbowColors.length) {
				// Reset colorInterp to start the interpolation cycle again
				textColor = rainbowColors[0];
				colorInterp = 0;
			}
		} else {
			textColor = 0xFFFFFFFF;
			if (currentFPS <= ClientPrefs.data.framerate / 2 && currentFPS >= ClientPrefs.data.framerate / 3) {
				textColor = 0xFFFFFF00;
			} else if (currentFPS <= ClientPrefs.data.framerate / 3 && currentFPS >= ClientPrefs.data.framerate / 4) {
				textColor = 0xFFFF8000;
			} else if (currentFPS <= ClientPrefs.data.framerate / 4) {
				textColor = 0xFFFF0000;
			}
		}
	}
	
	private function interpolateColor(startColor:Int, endColor:Int, t:Float):Int {
        // Extract color components (RGBA) from startColor
        var startR:Int = (startColor >> 16) & 0xFF;
        var startG:Int = (startColor >> 8) & 0xFF;
        var startB:Int = startColor & 0xFF;
        var startA:Int = (startColor >> 24) & 0xFF;

        // Extract color components (RGBA) from endColor
        var endR:Int = (endColor >> 16) & 0xFF;
        var endG:Int = (endColor >> 8) & 0xFF;
        var endB:Int = endColor & 0xFF;
        var endA:Int = (endColor >> 24) & 0xFF;

        // Perform linear interpolation for each color component
        var interpolatedR:Int = Math.round(startR + t * (endR - startR));
        var interpolatedG:Int = Math.round(startG + t * (endG - startG));
        var interpolatedB:Int = Math.round(startB + t * (endB - startB));
        var interpolatedA:Int = Math.round(startA + t * (endA - startA));

        // Combine interpolated color components into a single color value
        var interpolatedColor:Int = (interpolatedA << 24) | (interpolatedR << 16) | (interpolatedG << 8) | interpolatedB;

        return interpolatedColor;
	}

	inline function get_memoryMegas():Float
		#if cpp
		return Memory.getCurrentUsage();
		#else
		return cast(System.totalMemory, UInt);
		#end

	#if cpp
	inline function get_memoryLeakMegas():Float return Memory.getPeakUsage();
	#end

	public function getText():String // Main.fpsVar.getText();
		return text;
}
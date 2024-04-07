package options;

class GameRendererSettingsSubState extends BaseOptionsMenu
{
	var fpsOption:Option;
	public function new()
	{
		title = 'Game Renderer';
		rpcTitle = 'Game Renderer Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Video Rendering Mode', //Name
			#if windows 'If checked, the game will render songs you play to an MP4.\nThey will be located in a folder inside assets called gameRenders.' #else 'If checked, the game will render each frame as a screenshot into a folder. They can then be rendered into MP4s using FFmpeg.\nThey are located in a folder called gameRenders.' #end,
			'ffmpegMode',
			'bool');
		addOption(option);

        	var option:Option = new Option('Show Debug Info',
			"If checked, the Botplay text will show how long it took to render 1 frame.",
			'ffmpegInfo',
			'bool');
		addOption(option);

        	var option:Option = new Option('Video Framerate',
			"How much FPS would you like for your videos?",
			'targetFPS',
			'float');
		addOption(option);

		final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		option.minValue = 1;
		option.maxValue = 1000;
		option.scrollSpeed = 125;
		option.decimals = 0;
		option.defaultValue = Std.int(FlxMath.bound(refreshRate, option.minValue, option.maxValue));
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		fpsOption = option;

		#if windows
		var option:Option = new Option('Video Bitrate: ',
			"Use this option to set your video's bitrate!",
			'renderBitrate',
			'float');
		addOption(option);

		option.minValue = 1.0;
		option.maxValue = 100.0;
		option.scrollSpeed = 5;
		option.changeValue = 0.01;
		option.decimals = 2;
		option.displayFormat = '%v Mbps';
		#end
		
		#if !windows
		var option:Option = new Option('Lossless Screenshots',
			"If checked, screenshots will save as PNGs.\nOtherwise, It uses JPEG.",
			'lossless',
			'bool');
		addOption(option);

		var option:Option = new Option('JPEG Quality',
			"Change the JPEG quality in here.\nThe recommended value is 50.",
			'quality',
			'int');
		addOption(option);

		option.minValue = 1;
		option.maxValue = 100;
		option.scrollSpeed = 30;
		option.decimals = 0;

		var option:Option = new Option('Garbage Collection Rate',
			"After how many seconds rendered should a garbage collection be performed?\nIf it's set to 0, the game will not garbage collect at all.",
			'renderGCRate',
			'float');
		addOption(option);

		option.minValue = 1.0;
		option.maxValue = 60.0;
		option.scrollSpeed = 3;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.displayFormat = '%vs';

       		var option:Option = new Option('No Screenshot',
			"If checked, Skip taking of screenshot.\nIt's a function for debug.",
			'noCapture',
			'bool');
		addOption(option);
		#end

		//cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
		super();
	}
	function onChangeFramerate()
	{
		fpsOption.scrollSpeed = fpsOption.getValue() / 2;
	}

	function resetTimeScale()
	{
		FlxG.timeScale = 1;
	}
}
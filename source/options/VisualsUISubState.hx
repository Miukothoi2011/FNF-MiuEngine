package options;

import objects.Note;
import objects.StrumNote;
import objects.Alphabet;

class VisualsUISubState extends BaseOptionsMenu
{
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var notesTween:Array<FlxTween> = [];
	var noteY:Float = 90;
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence

		// for note skins
		notes = new FlxTypedGroup<StrumNote>();
		for (i in 0...Note.colArray.length)
		{
			var note:StrumNote = new StrumNote(370 + (560 / Note.colArray.length) * i, -200, i, 0);
			note.centerOffsets();
			note.centerOrigin();
			note.playAnim('static');
			notes.add(note);
		}

		// options

		var noteSkins:Array<String> = Mods.mergeAllTextsNamed('images/noteSkins/list.txt');
		if(noteSkins.length > 0)
		{
			if(!noteSkins.contains(ClientPrefs.data.noteSkin))
				ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin; //Reset to default if saved noteskin couldnt be found

			noteSkins.insert(0, ClientPrefs.defaultData.noteSkin); //Default skin always comes first
			var option:Option = new Option('Note Skins:',
				"Select your prefered Note skin.",
				'noteSkin',
				'string',
				noteSkins);
			addOption(option);
			option.onChange = onChangeNoteSkin;
			noteOptionID = optionsArray.length - 1;
		}
		
		var noteSplashes:Array<String> = Mods.mergeAllTextsNamed('images/noteSplashes/list.txt');
		if(noteSplashes.length > 0)
		{
			if(!noteSplashes.contains(ClientPrefs.data.splashSkin))
				ClientPrefs.data.splashSkin = ClientPrefs.defaultData.splashSkin; //Reset to default if saved splashskin couldnt be found

			noteSplashes.insert(0, ClientPrefs.defaultData.splashSkin); //Default skin always comes first
			var option:Option = new Option('Note Splashes Skins:',
				"Select your prefered Note Splash variation or turn it off.",
				'splashSkin',
				'string',
				noteSplashes);
			addOption(option);
		}

		var option:Option = new Option('Note Splash Opacity',
			'How much transparent should the Note Splashes be.',
			'splashAlpha',
			'percent');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool');
		addOption(option);

		var option:Option = new Option('Opponent Note Splashes',
			"If checked, opponent note hits will show particles.",
			'opponentNoteSplashes',
			'bool');
		addOption(option);

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			['Time Left', 'Time Elapsed', 'Time Left/Elapsed', 'Song Name', 'Song Name + Time', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool');
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool');
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool');
		addOption(option);

		var option:Option = new Option('Health Bar Opacity: ',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent');
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		/*var option:Option = new Option('BF Icon Style:',
			"You want choose BF icon style?",
			'bfIconStyle',
			'string',
			['Default', 'VS Nonsense V2', 'Doki Doki+', 'Leather Engine', "Mic'd Up", 'FPS Plus', 'SB Engine', "OS 'Engine'"]);
		addOption(option);
		
		var option:Option = new Option('Smooth Health',
			"(unfinished)",
			'smoothHealth',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Smooth Health Type:',
			"(unfinished)",
			'smoothHealthType',
			'string',
			['Golden Apple 1.5', 'Indie Cross']);
		addOption(option);*/
		
		var option:Option = new Option('Icon Bounce:',
			"What icon bounce you want use?",
			'iconBounce',
			'string',
			['None', 'Default', 'New Psych', 'Old Psych', 'OS Engine', 'Strident Crisis'/*, 'Golden Apple', 'Dave and Bambi'*/]); //THIS TEMP. ONLY, IT NOT MEANT I REMOVE ALL ELSE ICON BOUNCE, I FIX THIS.
		addOption(option);
		
		var option:Option = new Option('Hide Score Text',
			"It checked, the Score Text is hide.",
			'hideScoreTxt',
			'bool');
		addOption(option);

		var option:Option = new Option('Hide Watermark Text',
			"It checked, the Watermark Text is hide.",
			'hideWatermarkTxt',
			'bool');
		addOption(option);

		var option:Option = new Option('Time Text Bounce',
			'If checked, the time bar text will bounce on every beat hit.',
			'timeBounce',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Show Notes Counting',
			"If checked, score text with show Note Counter.",
			'showNotesCounting',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Show NPS',
			"(UNFINISHED)",
			'showNPS',
			'bool');
		addOption(option);
		
		#if !mobile //mobile user can't using this (it's enable default).
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool');
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		if (ClientPrefs.data.showFPS) {
			var option:Option = new Option('Show Memory',
				'If checked, the game will show your Memory (a.k.a RAM) usage.',
				'showMemory',
				'bool');
			addOption(option);
			
			var option:Option = new Option('Show Memory Leak',
				'If checked, the game will show your maximum Memory \n(a.k.a RAM) usage (Require enable \"Show Memory\").',
				'showMemoryLeak',
				'bool');
			addOption(option);
			
			var option:Option = new Option('Show Engine Version',
				'If checked, shows engine version on FPS Counter.',
				'showEngineVersion',
				'bool');
			addOption(option);
			
			var option:Option = new Option('Show Debug Info',
				'If checked, the game will show additional debug info.\nNote: Turn on FPS Counter before using this!',
				'showDebugInfo',
				'bool');
			addOption(option);
			
			var option:Option = new Option('Show Rainbow FPS',
				'?',
				'showRainbowFPS',
				'bool');
			addOption(option);
		}
		
		var option:Option = new Option('Show Loading Screen on Loading Chart',
			'?',
			'showLoadingScreen',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Random Botplay Text',
			'?',
			'showLoadingScreen',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			'bool');
		addOption(option);
		#end

		#if desktop
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord",
			'discordRPC',
			'bool');
		addOption(option);
		#end

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			'bool');
		addOption(option);
		
		super();
		add(notes);
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		
		if(noteOptionID < 0) return;

		for (i in 0...Note.colArray.length)
		{
			var note:StrumNote = notes.members[i];
			if(notesTween[i] != null) notesTween[i].cancel();
			if(curSelected == noteOptionID)
				notesTween[i] = FlxTween.tween(note, {y: noteY}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
			else
				notesTween[i] = FlxTween.tween(note, {y: -200}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
		}
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	function onChangeNoteSkin()
	{
		notes.forEachAlive(function(note:StrumNote) {
			changeNoteSkin(note);
			note.centerOffsets();
			note.centerOrigin();
		});
	}

	function changeNoteSkin(note:StrumNote)
	{
		var skin:String = Note.defaultNoteSkin;
		var customSkin:String = skin + Note.getNoteSkinPostfix();
		if(Paths.fileExists('images/$customSkin.png', IMAGE)) skin = customSkin;

		note.texture = skin; //Load texture and anims
		note.reloadNote();
		note.playAnim('static');
	}

	override function destroy()
	{
		if(changedMusic && !OptionsState.onPlayState) FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.data.showFPS;
	}
	#end
}

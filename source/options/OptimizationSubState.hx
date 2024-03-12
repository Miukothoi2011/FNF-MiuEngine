package options;

class OptimizationSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Optimization';
		rpcTitle = 'Optimization Settings Menu'; //for Discord Rich Presence
		
			//I'd suggest using "Chars & BG" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Chars & BG', //Name
			'If unchecked, gameplay will only show the HUD.', //Description
			'charsAndBG', //Save data variable name
			'bool'); //Variable type
		addOption(option);

		var option:Option = new Option('Enable GC',
			"If checked, then the game will be allowed to garbage collect, reducing RAM usage I suppose.\nIf you experience memory leaks, turn this on, and\nif you experience lag with it on then turn it off.",
			'enableGC',
			'bool');
		addOption(option);

		var option:Option = new Option('Light Opponent Strums',
			"If this is unchecked, the Opponent strums won't light up when the Opponent hits a note.",
			'opponentLightStrum',
			'bool');
		addOption(option);

		var option:Option = new Option('Light Botplay Strums',
			"If this is unchecked, the Player strums won't light when Botplay is active.",
			'botLightStrum',
			'bool');
		addOption(option);

		var option:Option = new Option('Light Player Strums',
			"If this is unchecked, then uh.. the player strums won't light up.\nit's as simple as that.",
			'playerLightStrum',
			'bool');
		addOption(option);

		var option:Option = new Option('Show Ratings & Combo',
			"If checked, shows the ratings & combo. Kinda defeats the purpose of this engine though...",
			'showRatingsPopUp',
			'bool');
		addOption(option);

		var option:Option = new Option('Show Unused Combo Popup',
			"If checked, shows the unused 'Combo' popup, ONLY when Botplay is inactive.",
			'showUnusedCombo',
			'bool');
		addOption(option);

		var option:Option = new Option('Even LESS Botplay Lag',
			"Reduce Botplay lag even further.",
			'dontShowRatingsPopUpIfBotplay',
			'bool');
		addOption(option);
		
		super();
	}
}
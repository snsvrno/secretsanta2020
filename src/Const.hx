/*
 * Copyright (c) 2020 snsvrno
 * 
 * Collection of constants that are for tweaking the appearance and
 * function of various parts of the game.
 * 
 */

class Const {

	////////////////////////////////////////////////////////////////////////////////////////
	// GENERAL THINGS

	/**
	 * The game title that is displayed throughout the game, in the window
	 * and in the menus.
	 */
	inline static public var GAMETITLE : String = "an Unexpected Sojourn";

	////////////////////////////////////////////////////////////////////////////////////////
	// SAVE INFORMATION
	inline static public var SAVE_FILE_NAME : String ="progress";
	
	////////////////////////////////////////////////////////////////////////////////////////
	// WORLD CONTAINER SETTINGS
	// these effect the background and such for the world container

	/** The game world width */
	inline static public var WORLD_WIDTH : Int = 700;
	/** The game world height */
	inline static public var WORLD_HEIGHT : Int = 400;
	/** The background inside the world (behind the map). */
	inline static public var WORLD_BACKGROUND_COLOR : Int = 0x000000;
	/**
	 * The engine background color, should match whatever the webpage
	 * color is if building to js. Could be any other color in other
	 * builds because it doesn't need to match with anything else.
	 */
	inline static public var BACKGROUND_COLOR : Int = 0xFF38332F;
	/**
	 * The amount of screen padding, in pixels to give between the 
	 * main scene and the container (window, webpage, etc..)
	 */
	inline static public var WORLD_SCREEN_PADDING : Int = 30;
	/** The rounded screen corners. */
	inline static public var WORLD_CORNER_RADIUS : Int = 20;
	/** How much past the edge of the screen should we draw the corner radius */
	inline static public var WORLD_CORNER_RADIUS_OVERSHOOT : Int = 10;

	////////////////////////////////////////////////////////////////////////////////////////
	// SPLASH SETTINGS

	inline static public var SPLASH_TEXT_COLOR : Int = 0xFFFFFFFF;
	inline static public var SPLASH_TOOL_LOGO_MAXWIDTH : Int = 50;
	inline static public var SPLASH_TOOL_FONT_MAXHEIGHT : Int = 30;
	inline static public var SPLASH_TOOL_LOGO_PADDING : Int = 10;
	inline static public var SPLASH_TIMER_WAIT : Float = 2.0;
	inline static public var SPLASH_TIMER_FADE : Float = 0.5;
	inline static public var SPLASH_OVER_LINK_ALPHA : Float = 0.65;
	inline static public var SPLASH_SNSVRNO_SWITCHTIME : Float = 0.2;
	inline static public var SPLASH_SNSVRNO_WEBSITE : String = "http://snsvrno.github.io";

	////////////////////////////////////////////////////////////////////////////////////////
	// MENU SETTINGS

	inline static public var MENU_BACKGROUND_OPACITY : Float = 0.85;

	inline static public var MENU_TITLE_SIZE : Float = 1.0;
	inline static public var MENU_BUTTON_SIZE_NORMAL : Float = 1.0;
	inline static public var MENU_BUTTON_SIZE_OVER : Float = 1.5;
	inline static public var MENU_BUTTON_COLOR : Int = 0xAAAAAA;
	inline static public var MENU_BUTTON_COLOR_GAMEMENU_ONLIGHT : Int = 0x000000;
	inline static public var MENU_BUTTON_COLOR_GAMEMENU_ONDARK : Int = 0xAAAAAA;
	inline static public var MENU_BUTTON_OVER_COLOR : Int = 0xFFFFFF;
	inline static public var MENU_BUTTON_OVEROUT_TIMER : Float = 0.1;

	static public var MENU_TITLE_FONT : h2d.Font;
	static public var MENU_FONT : h2d.Font;
	static public var MENU_FONT_SMALL : h2d.Font;
	static public var ICON_FONT : h2d.Font;

	////////////////////////////////////////////////////////////////////////////////////////
	// PROGRESS VARIABLES

	inline static public var PROGRESS_SIZE : Float = 0.5;
	inline static public var PROGRESS_DESCRIPTION_SIZE : Float = 0.30;
	inline static public var PROGRESS_CYCLES : String = "completedCycles";
	inline static public var PROGRESS_COLOR_TEXT : Int = 0xFFCCCCCC;
	inline static public var PROGRESS_COLOR_DESCRIPTION : Int = 0xFF777777;
	inline static public var PROGRESS_COLOR_VALUE : Int = 0xFF77FF77;

	////////////////////////////////////////////////////////////////////////////////////////
	// ACHIEVEMENTS

	inline static public var ACHIEVEMENTS_DISABLED : Int = 0xFF777777;
	inline static public var ACHIEVEMENTS_ACHIEVED : Int = 0xFFFF7777;
	inline static public var ACHIEVEMENTS_SIZE : Float = 0.5;
	inline static public var ACHIEVEMENTS_ICON_SIZE : Float = 160;
	inline static public var ACHIEVEMENTS_ICON_SIZE_OVER : Float = 200;
	inline static public var ACHIEVEMENTS_ICON_PADDING : Float = 16;
	inline static public var ACHIEVEMENTS_DESCRIPTION_SIZE : Float = 0.30;
	inline static public var ACHIEVEMENTS_TITLE_COLOR : Int = 0xFFFFFFFF;
	inline static public var ACHIEVEMENTS_DESCRIPTION_COLOR : Int = 0xFFAAAAAA;
	inline static public var ACHIEVEMENTS_ANIMATION_LENGTH : Float = 0.15;
	inline static public var ACHIEVEMENTS_UNACHIEVED_INTENSITY : Float = 0.75;
	inline static public var ACHIEVEMENTS_POPUP_TEXT : String = "Achievement `0`!";
	static public var ACHIEVEMENTS_TITLE_FONT : h2d.Font;
	static public var ACHIEVEMENTS_DESCRIPTION_FONT : h2d.Font;

	////////////////////////////////////////////////////////////////////////////////////////
	// MAP CONTAINER SETTINGS

	/** The map opacity when inside of a scene. */
	inline static public var MAP_DISABLED_OPACITY : Float = 0.15;

	inline static public var MAP_MORNING_COLOR : Int = 0xD6751B;
	inline static public var MAP_AFTERNOON_COLOR : Int = 0xFFFFFF;
	inline static public var MAP_EVENING_COLOR : Int = 0x233066;

	// different opacity values that it will move between when changing the time
	// ment to give it an issusion of the sun and different lighting based on different periods.
	inline static public var MAP_FRINGE_OPACITY : Float = 0.40;
	inline static public var MAP_PEAK_OPACITY : Float = 0.15;

	inline static public var MAP_ICON_SIZE : Float = 25;

	////////////////////////////////////////////////////////////////////////////////////////
	// CYCLE OVER SCREEN SETTINGS

	inline static public var CYCLEOVER_ITEM_COLOR : Int = 0xFFFFFF;
	inline static public var CYCLEOVER_VALUE_COLOR : Int = 0xFF00FF;

	////////////////////////////////////////////////////////////////////////////////////////
	// MAP LOCATION SETTINGS

	inline static public var LOCATION_HIGHLIGHT_ALPHA : Float = 0.5;
	inline static public var LOCATION_UNACCESSABLE_ALPHA : Float = 0.75;
	inline static public var LOCATION_TEXT_SIZE : Float = 0.85;
	static public var MAP_LOCATION_FONT : h2d.Font;

	////////////////////////////////////////////////////////////////////////////////////////
	// ICON UI OBJECT

	inline static public var ICON_MAX_SIZE : Int = 50;
	inline static public var ICON_TITLE_SIZE : Float = 0.5;
	inline static public var ICON_DESCRIPTION_SIZE : Float = 0.25;

	////////////////////////////////////////////////////////////////////////////////////////
	// GENERAL TEXT SETTINGS
	inline static public var BACKPACK_COLOR : Int = 0x38332f;
	inline static public var BACKPACK_COLOROVER : Int = 0xa06a3b;
	inline static public var BACKPACK_ICONSIZE : Int = 25;
	inline static public var BACKPACK_ICONROUNDEDCORNERS : Int = 10;
	inline static public var BACKPACK_ROUNDEDCORNERS : Int = 0;
	inline static public var BACKPACK_ICONPADDING : Int = 10;
	inline static public var BACKPACK_ICONOVERALPHA : Float = 0.75;
	inline static public var BACKPACK_ITEMSIZE : Int = 50;
	inline static public var BACKPACK_ITEMOPACITY : Float = 0.75;
	inline static public var BACKPACK_ITEMPADDING : Int = 10;
	inline static public var BACKPACK_NAMECOLOR : Int = 0xFFFFFFFF;
	inline static public var BACKPACK_DESCRIPTIONCOLOR : Int = 0xFFAAAAAA;
	inline static public var BACKPACK_NOTIFICATIONTIMER : Float = 1.5;
	inline static public var BACKPACK_NOTIFICATIONTIMERINTENSITY : Float = 0.05;
	inline static public var BACKPACK_DRAWERSPEED : Float = 0.15;
	static public var BACKPACK_NAMEFONT : h2d.Font;
	static public var BACKPACK_DESCRIPTIONFONT : h2d.Font;

	////////////////////////////////////////////////////////////////////////////////////////
	// GENERAL TEXT SETTINGS
	inline static public var TEXT_ITALICS_SLANT : Float = 0.25;
	inline static public var TEXT_ACTION_SLANT : Float = 0.0;
	inline static public var TEXT_DANCING_INTENSITY : Float = 0.2;
	inline static public var TEXT_DANCING_SPEED : Float = 0.55;

	static public var TEXT_FONT_NORMAL : h2d.Font;
	static public var TEXT_FONT_BOLD : h2d.Font;
	inline static public var TEXT_FONT_BOLD_Y_OFFSET : Int = 2; 
	static public var TEXT_FONT_ACTION : h2d.Font;
	inline static public var TEXT_FONT_ACTION_Y_OFFSET : Int = 3; 
	static public var TEXT_FONT_ITALICS : h2d.Font;
	inline static public var TEXT_FONT_ITALICS_Y_OFFSET : Int = 0; 
	static public var TEXT_FONT_DANCING : h2d.Font;
	inline static public var TEXT_FONT_DANCING_Y_OFFSET : Int = 0; 

	static public var TEXT_FONT_SNSVRNO : h2d.Font;

	////////////////////////////////////////////////////////////////////////////////////////
	// TEXT & SPEECH BUBBLES
	// these options deal with the actual dialogue bubbles.

	/** The wordwrap width for speech bubbles. */
	inline static public var BUBBLE_MAX_WIDTH : Float = 250.;
	/** The radius of the rounded corners for speech bubbles. */
	inline static public var BUBBLE_CORNER_RADIUS : Int = 4;
	/** Padding around the text in a speech bubble. */
	inline static public var BUBBLE_TEXT_PADDING : Int = 10;
	/** Color of the speech bubble. */
	inline static public var BUBBLE_BACKGROUND_COLOR : Int = 0x38332f;
	/** Color of the speech bubble. */
	inline static public var BUBBLE_BACKGROUND_ALPHA : Float = 1;
	inline static public var BUBBLE_NEXT_TIMER : Float = 1.;

	/** italics text color */
	inline static public var BUBBLE_TEXT_COLOR_ITALICS : Int = 0xFF12ea8d;
	/** bold text color */
	inline static public var BUBBLE_TEXT_COLOR_BOLD : Int = 0xFFea8d12;
	/** normal text color */
	inline static public var BUBBLE_TEXT_COLOR_REGULAR : Int = 0xFFDDDDDD;
	/** action text color */
	inline static public var BUBBLE_TEXT_COLOR_ACTION : Int = 0xFFfc4179;
	/** variable's text color */
	inline static public var BUBBLE_TEXT_COLOR_VARIABLE : Int = 0xFF8d12ea;

	////////////////////////////////////////////////////////////////////////////////////////
	// TEXT & SPEECH CHOICE WHEELS
	// these options are only for choices (part of the choice circle
	// wheel).

	/** The minimum radius of the choice circle. */
	inline static public var CHOICE_RADIUS : Int = 40;
	/** The radius of the choice circle onOut interactive object. */
	inline static public var CHOICE_RADIUS_OUT : Int = 60;
	/** Padding between choice items. */	
	inline static public var CHOICE_PADDING : Int = 20;

	inline static public var WHEEL_FADE_PADDING : Int = 50;

	static public var CHOICE_FONT : h2d.Font;

	/** The wordwrap width for speech bubbles. */
	inline static public var CHOICE_MAX_WIDTH : Float = 175.;
	/** The radius of the rounded corners for speech bubbles. */
	inline static public var CHOICE_CORNER_RADIUS : Int = 4;
	/** Padding around the text in a speech bubble. */
	inline static public var CHOICE_TEXT_PADDING : Int = 6;
	/** the padding between choices in the wheel */
	/** Color of the dialogue bubble. */
	inline static public var CHOICE_BACKGROUND_COLOR : Int = 0x000000;
	/** Color of the dialogue bubble. */
	inline static public var CHOICE_BACKGROUND_ALPHA : Float = 1;

	/** choice's mouse over text color */
	inline static public var CHOICE_TEXT_OPACITY_OVER : Float = 1;
	/** choice's normal text color */
	inline static public var CHOICE_TEXT_OPACITY_NORMAL : Float = 0.75;
	/** choice's used text color */
	inline static public var CHOICE_TEXT_OPACITY_USED : Float = 0.25;

	/** A drop shadow for the speech bubble. */
	inline static public var CHOICE_DROPSHADOW : Bool = true;
	inline static public var CHOICE_DROPSHADOW_DX : Float = 0;
	inline static public var CHOICE_DROPSHADOW_DY : Float = 3;
	inline static public var CHOICE_DROPSHADOW_COLOR : Int = 0x000000;
	inline static public var CHOICE_DROPSHADOW_ALPHA : Float = 0.35;

	////////////////////////////////////////////////////////////////////////////////////////
	// POPUP 
	// these relate to the popups that appear at the top of the screen.
	// the popup fades in, waits a defined amount of time at full opactiy
	// and then fades out again. these are not interactable and just there to
	// inform the player that something of note has happened.

	/** The minimum size (width or height) of the popup's image */
	inline static public var POPUP_MIN_IMAGE_SIZE : Int = 50;
	/** Padding between the content and edges of the popup */
	inline static public var POPUP_PADDING : Int = 10;
	/** The max width of the text inside the popup */
	inline static public var POPUP_MAX_WIDTH : Int = 200;
	/** The duration (in seconds) of the fade in and fade out */
	inline static public var POPUP_FADE_DURATION : Float = 0.25;
	/** The duration (in seconds) that the popup will wait at fill opacity. */
	inline static public var POPUP_WAIT_DURATION : Float = 1.5;
	/** popup background color */
	inline static public var POPUP_BACKGROUND_COLOR : Int = 0x38332f;
	/** popup background opacity */
	inline static public var POPUP_BACKGROUND_ALPHA : Float = 1;
	/** popup rounded corner radius */
	inline static public var POPUP_CORNER_RADIUS : Float = 2.;
	// variables are defined as integer positions of the passed array, in the
	// case of popups there is only one variable that is passed and it is the 
	// name of the item, which is in index [0], so `0` will be replaced with
	// that item name when parsing the text.
	/** popup text for finding an item */
	inline static public var POPUP_TEXT_ITEM_FOUND : String = "Found `0`!";
	/** popup text for loosing an item */
	inline static public var POPUP_TEXT_ITEM_LOST : String = "Lost `0`.";

	////////////////////////////////////////////////////////////////////////////////////////
	// CLOCK / TIMEPIECE
	// The number of time slots that each period has, basically means
	// the number of places the player can move too and interact with
	// during a period.

	/** how many "days" are there in the game */
	inline static public var CLOCK_PERIODS : Int = 6;
	/** how many "hours" are there per day in the game */
	inline static public var CLOCK_SLOTS : Int = 2;
	/** the size of the clock object on the screen. */
	inline static public var CLOCK_SCALE : Float = 0.5;
	/** padding between the clock and the edge of the world */
	inline static public var CLOCK_SCREEN_PADDING : Int = 10;
	/** whether or not we want the clock to do some minor animating */
	inline static public var CLOCK_IDLE : Bool = true;
	/** bouncing period / speed */
	inline static public var CLOCK_IDLE_PERIOD : Float = 3.;
	/** bouncing strength */
	inline static public var CLOCK_IDLE_STRENGTH : Float = 2.;

	inline static public var CLOCK_TEXT_COLOR_MORNING : Int = 0xFFea8d12;
	inline static public var CLOCK_TEXT_COLOR_AFTERNOON : Int = 0xFFea8d12;
	inline static public var CLOCK_TEXT_COLOR_EVENING : Int = 0xFFea8d12;
	inline static public var CLOCK_OUTLINE_COLOR : Int = 0xFF000000;
	inline static public var CLOCK_OUTLINE_SIZE : Float = 1.0;
	inline static public var CLOCK_ATTENTION_INTENSITY : Float = 0.25;
	inline static public var CLOCK_ATTENTION_LENGTH : Float = 1;

	static public function initalize() {

		// loads the fonts.
		MENU_TITLE_FONT = hxd.Res.fonts.moga64.toFont();
		MENU_FONT = hxd.Res.fonts.gra24.toFont();
		MENU_FONT_SMALL = hxd.Res.fonts.gra16.toFont();
		
		CHOICE_FONT = hxd.Res.fonts.wolf16.toFont();
		TEXT_FONT_NORMAL = hxd.Res.fonts.wolf24.toFont();
		TEXT_FONT_BOLD = hxd.Res.fonts.edi24.toFont();
		TEXT_FONT_ITALICS = hxd.Res.fonts.edi24.toFont();
		TEXT_FONT_ACTION = hxd.Res.fonts.bra24.toFont();
		TEXT_FONT_DANCING = hxd.Res.fonts.wolf24.toFont();

		TEXT_FONT_SNSVRNO = hxd.Res.fonts.sye64.toFont();

		MAP_LOCATION_FONT = hxd.Res.fonts.gra16.toFont();

		BACKPACK_NAMEFONT = hxd.Res.fonts.wolf24.toFont();
		BACKPACK_DESCRIPTIONFONT = hxd.Res.fonts.edi16.toFont();

		ACHIEVEMENTS_DESCRIPTION_FONT = hxd.Res.fonts.edi16.toFont();
		ACHIEVEMENTS_TITLE_FONT = hxd.Res.fonts.wolf24.toFont();

		ICON_FONT = hxd.Res.fonts.fa_24.toFont();
	}
}
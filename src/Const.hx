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
	inline static public var GAMETITLE : String = "SS2020";
	
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
	inline static public var BACKGROUND_COLOR : Int = 0xFF00FFFF;
	/**
	 * The amount of screen padding, in pixels to give between the 
	 * main scene and the container (window, webpage, etc..)
	 */
	inline static public var WORLD_SCREEN_PADDING : Int = 10;
	/** The rounded screen corners. */
	inline static public var WORLD_CORNER_RADIUS : Int = 20;
	/** How much past the edge of the screen should we draw the corner radius */
	inline static public var WORLD_CORNER_RADIUS_OVERSHOOT : Int = 10;

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
	// MAP LOCATION SETTINGS

	inline static public var LOCATION_HIGHLIGHT_ALPHA : Float = 0.25;
	inline static public var LOCATION_UNACCESSABLE_ALPHA : Float = 0.75;

	////////////////////////////////////////////////////////////////////////////////////////
	// GENERAL TEXT SETTINGS
	inline static public var TEXT_ITALICS_SLANT : Float = 0.1;

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
	inline static public var BUBBLE_BACKGROUND_COLOR : Int = 0xFF0000;
	/** Color of the speech bubble. */
	inline static public var BUBBLE_BACKGROUND_ALPHA : Float = 1;

	/** italics text color */
	inline static public var BUBBLE_TEXT_COLOR_ITALICS : Int = 0xFF00FFFF;
	/** bold text color */
	inline static public var BUBBLE_TEXT_COLOR_BOLD : Int = 0xFF7a14e0;
	/** normal text color */
	inline static public var BUBBLE_TEXT_COLOR_REGULAR : Int = 0xFFDDDDDD;
	/** action text color */
	inline static public var BUBBLE_TEXT_COLOR_ACTION : Int = 0xFFFF00FF;
	/** variable's text color */
	inline static public var BUBBLE_TEXT_COLOR_VARIABLE : Int = 0xFFFFFF00;

	////////////////////////////////////////////////////////////////////////////////////////
	// TEXT & SPEECH CHOICE WHEELS
	// these options are only for choices (part of the choice circle
	// wheel).

	/** The radius of the choice circle. */
	inline static public var CHOICE_RADIUS : Int = 40;
	/** The radius of the choice circle onOut interactive object. */
	inline static public var CHOICE_RADIUS_OUT : Int = 60;

	/** The wordwrap width for speech bubbles. */
	inline static public var CHOICE_MAX_WIDTH : Float = 100.;
	/** The radius of the rounded corners for speech bubbles. */
	inline static public var CHOICE_CORNER_RADIUS : Int = 4;
	/** Padding around the text in a speech bubble. */
	inline static public var CHOICE_TEXT_PADDING : Int = 6;
	/** Color of the dialogue bubble. */
	inline static public var CHOICE_BACKGROUND_COLOR : Int = 0x000000;
	/** Color of the dialogue bubble. */
	inline static public var CHOICE_BACKGROUND_ALPHA : Float = 1;

	/** choice's mouse over text color */
	inline static public var CHOICE_TEXT_COLOR_OVER : Int = 0xFFFFFFFF;
	/** choice's normal text color */
	inline static public var CHOICE_TEXT_COLOR_REGULAR : Int = 0xFFAAAAAA;
	/** choice's used text color */
	inline static public var CHOICE_TEXT_COLOR_USED : Int = 0xFF444444;

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
	inline static public var POPUP_BACKGROUND_COLOR : Int = 0x000000;
	/** popup background opacity */
	inline static public var POPUP_BACKGROUND_ALPHA : Float = 0.85;
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
	// LOCATION

	inline static public var LOCATION_TEXT_SIZE : Float = 2.;

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

	static public function initalize() {
	}
}
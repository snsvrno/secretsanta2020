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

	/**
	 * The engine background color, should match whatever the webpage
	 * color is if building to js. Could be any other color in other
	 * builds because it doesn't need to match with anything else.
	 */
	inline static public var BACKGROUNDCOLOR : Int = 0xFF00FFFF;

	inline static public var WORLDWIDTH : Int = 700;
	inline static public var WORLDHEIGHT : Int = 400;
	inline static public var WORLDBACKGROUNDCOLOR : Int = 0x000000;
	inline static public var WORLDBACKGROUNDDISABLEDOPACTIY : Float = 0.15;

	/**
	 * The amount of screen padding, in pixels to give between the 
	 * main scene and the container (window, webpage, etc..)
	 */
	inline static public var SCREENPADDING : Int = 10;

	/** The rounded screen corners. */
	inline static public var SOFTCORNERRADIUS : Int = 20;
	inline static public var RADIUSBLEED : Int = 10;

	inline static public var PLAYERTEXTHEIGHT : Int = 100;
	inline static public var PLAYERTEXTPADDING : Int = 10;
	inline static public var PLAYERTEXTOVEROPACITY : Float = 0.35;

	inline static public var TEXTITALICSANGLE : Float = 0.4;

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
	inline static public var BUBBLE_TEXT_COLOR_BOLD : Int = 0xFFFFFFFF;
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

	////////////////////////////////////////////////////////////////////////////////////////
	// CLOCK / TIMEPIECE
	// The number of time slots that each period has, basically means
	// the number of places the player can move too and interact with
	// during a period.

	/** how many "days" are there in the game */
	inline static public var CLOCK_PERIODS : Int = 6;
	/** how many "hours" are there per day in the game */
	inline static public var CLOCK_SLOTS : Int = 2;

	static public function initalize() {
	}
}
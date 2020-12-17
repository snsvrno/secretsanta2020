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

	/**
	 * The rounded screen corners.
	 */
	inline static public var SOFTCORNERRADIUS : Int = 20;
	inline static public var RADIUSBLEED : Int = 10;

	inline static public var PLAYERTEXTHEIGHT : Int = 100;
	inline static public var PLAYERTEXTPADDING : Int = 10;
	inline static public var PLAYERTEXTOVEROPACITY : Float = 0.35;

	inline static public var TEXTITALICSANGLE : Float = 0.4;

	static public function initalize() {
	}
}
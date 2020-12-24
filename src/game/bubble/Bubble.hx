package game.bubble;

class Bubble extends h2d.Object {

	private var background : h2d.Graphics;

	private var lines : Array<Text>;
	private var pos : Int = 0;

	public var height(get, null) : Float;
	private function get_height() : Float return lines[pos].height + 2 * Const.BUBBLE_TEXT_PADDING;

	public var width(get, null) : Float;
	private function get_width() : Float return lines[pos].width + 2 * Const.BUBBLE_TEXT_PADDING;

	/**
	 * adds a special manual bubble that will disappear when the mouse moves away.
	 * 
	 * @param text 
	 * @param x 
	 * @param y 
	 * @return Bubble
	 */
	public static function manual(text : String, x : Float, y : Float, ?wrapWidth : Float) : Bubble {
		var bubble = new Bubble();
		bubble.setText(text, wrapWidth);

		bubble.x = x;
		bubble.y = y;

		var interactive = new h2d.Interactive(bubble.width, bubble.height, bubble);
		interactive.x = - bubble.width/2;
		interactive.y = - bubble.height/2;
		interactive.onOut = function(e : hxd.Event) {
			bubble.remove();
		}

		return bubble;
	}

	public function new(?dialogue : Data.Dialogue, ?parent : h2d.Object) {
		super(parent);

		background = new h2d.Graphics(this);

		if (dialogue != null) setText(dialogue.text, Const.BUBBLE_MAX_WIDTH);
	}

	private function setText(text : String, ?maxWidth : Float) {

		lines = Text.parse(text, maxWidth);

		// adds the text line so it displays.
		addChild(lines[0]);

		// adjusts the background
		setBackground();
	}

	/**
	 * Moves to the next dialogue sequence. Will return false if it was already at the last 
	 * sequence.
	 * @return Bool
	 */
	public function next() : Bool {

		if (pos == lines.length - 1) return false;
		else {

			// removes the most recently displayed text
			lines[pos].remove();

			// increments to the next line and adds it as a child
			// so it can be displayed.
			pos++;
			addChild(lines[pos]);

			// adjusts the background
			setBackground();

			return true;
		}
	}

	/**
	 * Creates the background pill where the text resides.
	 */
	private function setBackground() {
		background.clear();
		background.beginFill(Const.BUBBLE_BACKGROUND_COLOR, Const.BUBBLE_BACKGROUND_ALPHA);
		background.drawRoundedRect(-width/2, -height/2, width, height, Const.BUBBLE_CORNER_RADIUS);
		background.endFill();
	}

}
package game.bubble;

class Bubble extends h2d.Object {

	static private final padding : Int = 10;
	static private final cornerRadius : Int = 4;
	static private final maxWidth : Float = 300;

	private var background : h2d.Graphics;

	private var lines : Array<Text>;
	private var pos : Int = 0;

	public var height(get, null) : Float;
	private function get_height() : Float return lines[pos].height + 2 * padding;

	public var width(get, null) : Float;
	private function get_width() : Float return lines[pos].width + 2 * padding;

	public function new(dialogue : Data.Dialogue, parent : h2d.Object) {
		super(parent);

		background = new h2d.Graphics(this);
		lines = Text.parse(dialogue.text, maxWidth);

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

	private function setBackground() {
		background.clear();
		background.beginFill(0xFF0000);
		background.drawRoundedRect(-width/2, -height/2, width, height, cornerRadius);
		background.endFill();
	}

}
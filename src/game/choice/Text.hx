package game.choice;

class Text extends h2d.Object {

	static private final overColor : h3d.Vector = h3d.Vector.fromColor(Const.CHOICE_TEXT_COLOR_OVER);
	static private final normalColor : h3d.Vector = h3d.Vector.fromColor(Const.CHOICE_TEXT_COLOR_REGULAR);
	static private final alreadyColor : h3d.Vector = h3d.Vector.fromColor(Const.CHOICE_TEXT_COLOR_USED);

	private var text : h2d.Text; 
	private var interactive : h2d.Interactive;

	public function new(dialogue : Data.Dialogue, parent : h2d.Object) {
		super(parent);

		var font = hxd.res.DefaultFont.get();

		var background = new h2d.Graphics(this);
		text = new h2d.Text(font, this);
		text.maxWidth = Const.CHOICE_MAX_WIDTH;

		text.text = evalulate(dialogue.display);
		if (Game.variables.isChosenOption(dialogue.id)) text.color = alreadyColor;
		else text.color = normalColor;

		background.beginFill(Const.CHOICE_BACKGROUND_COLOR, Const.CHOICE_BACKGROUND_ALPHA);
		background.drawRoundedRect(-Const.CHOICE_TEXT_PADDING, -Const.CHOICE_TEXT_PADDING, text.textWidth + 2*Const.CHOICE_TEXT_PADDING, text.textHeight + 2*Const.CHOICE_TEXT_PADDING, Const.CHOICE_CORNER_RADIUS);
		background.endFill();

		interactive = new h2d.Interactive(text.textWidth, text.textHeight, this);
		// adds this local because we need to track the original color because a mouse over
		// could change the used color to normal.
		var lastColor : h3d.Vector;
		interactive.onOver = function(e : hxd.Event) { 
			lastColor = text.color;
			text.color = overColor;
		};
		interactive.onOut = function(e : hxd.Event) text.color = lastColor; 
	}

	public function setHook(hook : (e : hxd.Event) -> Void) interactive.onClick = hook;

	public function setX(x : Float) {
		this.x = x - text.textWidth / 2;
	}

	public function setY(y : Float) {
		this.y = y - text.textHeight	 / 2;
	}

	/**
	 * Evaluates formating and variables, but doesn't actually do any style to it.
	 * No formatting.
	 * @param string 
	 * @return String
	 */
	private function evalulate(string : String) : String {
		var newText = "";
		
		var items = game.bubble.Text.parse(string);
		for (i in items) {
			newText += i.asString();
		}

		return newText;
	}
}
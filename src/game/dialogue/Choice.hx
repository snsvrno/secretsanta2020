package game.dialogue;

/**
 * The object that is inside the `wheel`, that shows the possible choice options in a conversation.
 */
class Choice extends h2d.Object {

	public var height(get, null) : Float;
	private function get_height() : Float return text.height * scaleY;
	// private function get_height() : Float return text.textHeight * scaleY;

	public var width(get, null) : Float;
	private function get_width() : Float return text.width * scaleX;
	// private function get_width() : Float return text.textWidth * scaleX;

	// private var text : h2d.Text; 
	private var text : Text;
	private var interactive : h2d.Interactive;
	private var background : h2d.Graphics;

	public var onOver : Null<() -> Void>;
	public var onOut : Null<() -> Void>;
	public var onClick : Null<() -> Void>;

	public function new(?dialogue : Data.Dialogue, ?parent : h2d.Object) {
		super(parent);

		background = new h2d.Graphics(this);

		// creates the text object
		text = new Text(this);
		text.maxWidth = Const.CHOICE_MAX_WIDTH;
		text.alpha = Const.CHOICE_TEXT_OPACITY_NORMAL;

		// loads the text if a dialogue option.
		if (dialogue != null) { 
			text.setText(dialogue.display);
			text.x = text.width/2;
			text.y = text.height/2;
			if (Game.variables.isChosenOption(dialogue.id)) { 
				text.alpha = Const.CHOICE_TEXT_OPACITY_USED;
			}
		}

		interactive = new h2d.Interactive(0, 0, this);
		// adds this local because we need to track the original color because a mouse over
		// could change the used color to normal.
		var lastOp : Float;
		interactive.onOver = function(e : hxd.Event) { 
			lastOp = text.alpha;
			text.alpha = Const.CHOICE_TEXT_OPACITY_OVER;
			if (onOver != null) onOver();
		};
		interactive.onOut = function(e : hxd.Event) { 
			text.alpha = lastOp;
			if (onOut != null) onOut();
		}
		interactive.onClick = (e:hxd.Event) -> if(onClick != null) onClick();

		if (dialogue != null) updateSize();
	}

	override function onAdd() {
		super.onAdd();
		if (background != null) updateSize();
	}

	public function passThroughEvents() interactive.propagateEvents = true;

	private function updateSize() {

		background.beginFill(Const.CHOICE_BACKGROUND_COLOR, Const.CHOICE_BACKGROUND_ALPHA);
		background.drawRoundedRect(-Const.CHOICE_TEXT_PADDING, -Const.CHOICE_TEXT_PADDING, text.width + 2*Const.CHOICE_TEXT_PADDING, text.height + 2*Const.CHOICE_TEXT_PADDING, Const.CHOICE_CORNER_RADIUS);
		background.endFill();

		interactive.width = text.width;
		interactive.height = text.height;
	}

	static public function fromString(text : String, ?parent : h2d.Object) : Choice {
		var newText = new Choice(null, parent);

		newText.text.setText(text);
		newText.text.x = newText.text.width/2;
		newText.text.y = newText.text.height/2;
		newText.updateSize();

		return newText;
	}

	public function setX(x : Float) this.x = x - text.width / 2;
	public function setY(y : Float) this.y = y - text.height / 2;
}
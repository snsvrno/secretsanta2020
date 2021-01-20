package game.dialogue;

/**
 * The object that is inside the `wheel`, that shows the possible choice options in a conversation.
 */
class Choice extends h2d.Object {

	////////////////////////////////////////////
	// PRIVATE MEMBERS

	private var text : Text;
	private var interactive : h2d.Interactive;
	private var background : h2d.Graphics;

	////////////////////////////////////////////
	// PUBLIC MEMBERS

	public var height(get, null) : Float;
	private function get_height() : Float return text.height * scaleY;

	public var width(get, null) : Float;
	private function get_width() : Float return text.width * scaleX;

	public var onOver : Null<() -> Void>;
	public var onOut : Null<() -> Void>;
	public var onClick : Null<() -> Void>;

	public var grouping : Null<Data.QuestlinesKind>;
	public var used(default, null) : Bool = false;

	public function new(?dialogue : Data.Dialogue, ?parent : h2d.Object) {
		super(parent);

		background = new h2d.Graphics(this);
		background.filter = new h2d.filter.Nothing();

		grouping = dialogue.questlineId;

		// creates the text object
		text = new Text(Const.CHOICE_FONT, this);
		text.maxWidth = Const.CHOICE_MAX_WIDTH;
		text.alpha = Const.CHOICE_TEXT_OPACITY_NORMAL;

		// loads the text if a dialogue option.
		if (dialogue != null) { 
			text.setText(dialogue.display);
			text.x = text.width/2;
			text.y = text.height/2;
			if (Game.variables.isChosenOption(dialogue.id)) { 
				used = true;
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

		var color = Const.CHOICE_BACKGROUND_COLOR;
		if (grouping != null) { 
			color = Data.questlines.get(grouping).color;
			text.enableShadow();
		}

		if (Const.CHOICE_DROPSHADOW) {
			background.beginFill(color, 1);
			background.drawRoundedRect(
				-Const.CHOICE_TEXT_PADDING + Const.CHOICE_DROPSHADOW_DX, 
				-Const.CHOICE_TEXT_PADDING + Const.CHOICE_DROPSHADOW_DY, 
				text.width + 2*Const.CHOICE_TEXT_PADDING, 
				text.height + 2*Const.CHOICE_TEXT_PADDING, 
				Const.CHOICE_CORNER_RADIUS
			);
			background.setColor(Const.CHOICE_DROPSHADOW_COLOR, Const.CHOICE_DROPSHADOW_ALPHA);
			background.drawRoundedRect(
				-Const.CHOICE_TEXT_PADDING + Const.CHOICE_DROPSHADOW_DX, 
				-Const.CHOICE_TEXT_PADDING + Const.CHOICE_DROPSHADOW_DY, 
				text.width + 2*Const.CHOICE_TEXT_PADDING, 
				text.height + 2*Const.CHOICE_TEXT_PADDING, 
				Const.CHOICE_CORNER_RADIUS
			);
			background.endFill();
		}

		background.beginFill(color, Const.CHOICE_BACKGROUND_ALPHA);
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
package game.ui;

class Button extends Text {
	private var timer : sn.Timer;
	private var container : Null<VStack>;
	private var interactive : h2d.Interactive;

	public var normalColor(default, set) : Int = Const.MENU_BUTTON_COLOR;
	private function set_normalColor(color : Int) : Int {
		setColor(color);
		return normalColor = color;
	}
	public var overColor : Int = Const.MENU_BUTTON_OVER_COLOR;

	public var description : String = "";
	public var descriptionObject : Null<Text> = null;
	public var onClick : Null<() -> Void>;
	
	public function new (text : String, ?font : h2d.Font, ?parent : h2d.Object) {
		
		// do this before we call super because super calls setAlignment when
		// adding the text, which will be null since we create the interactive
		// afterwards.
		interactive = new h2d.Interactive(0,0);

		super(text, font, parent);

		setScale(Const.MENU_BUTTON_SIZE_NORMAL);
		setColor(normalColor);

		this.addChild(interactive);
		interactive.width = textObject.textWidth;
		interactive.height = textObject.textHeight;
		interactive.onOver = onOver;
		interactive.onOut = onOut;
		interactive.onClick = function(e:hxd.Event){
			if (onClick != null) { 
				onClick();
				// to reset the button to normal state.
				onOut();
			}
		}

		timer = new sn.Timer(Const.MENU_BUTTON_OVEROUT_TIMER, true);
		timer.updateCallback = function() {
			setScale(Const.MENU_BUTTON_SIZE_NORMAL + (Const.MENU_BUTTON_SIZE_OVER - Const.MENU_BUTTON_SIZE_NORMAL) * timer.timerPercent);
			if (container != null) container.alignChildren();
		}
		timer.finalCallback = function() {
			setScale(Const.MENU_BUTTON_SIZE_OVER);
			if (container != null) container.alignChildren();
		}
		timer.stop();
	}

	public function setContainerHook(parent : VStack) {
		container = parent;
	}

	private function onOver(?e : hxd.Event) {
		if (descriptionObject != null) descriptionObject.setText(description);
		timer.reset();
		setColor(overColor);
	}

	private function onOut(?e : hxd.Event) {
		if (descriptionObject != null) descriptionObject.setText("");
		timer.reverse();
		setColor(normalColor);
	}

	override public function setAlignment(?horizontal : game.ui.alignment.Horizontal, ?vertical : game.ui.alignment.Vertical) {

		if (horizontal != null) this.horizontal = horizontal;
		if (vertical != null) this.vertical = vertical;

		switch(this.horizontal) {
			case Left: interactive.x = 0;
			case Center: interactive.x = -interactive.width / 2;
			case Right: interactive.x = -interactive.width;
		}

		switch(this.vertical) {
			case Top: interactive.y = 0;
			case Middle: interactive.y = -interactive.height / 2;
			case Bottom: interactive.y = -interactive.height;
		}

		super.setAlignment();
	}

	override public function setText(text : String) {
		super.setText(text);
		interactive.width = textObject.textWidth;
		interactive.height = textObject.textHeight;
		setAlignment();
	}
}
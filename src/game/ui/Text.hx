package game.ui;

class Text extends game.ui.Element {

	var textObject : h2d.Text;

	var horizontal : game.ui.alignment.Horizontal = Left;
	var vertical : game.ui.alignment.Vertical = Top;

	public var text(get, null) : String;
	private function get_text() : String return textObject.text;

	override public function getHeight() : Float return textObject.textHeight * scaleY;
	override public function getWidth() : Float return textObject.textWidth * scaleX;

	#if debug
	var background : h2d.Graphics;
	#end

	public function new(text : String, ?font : h2d.Font, ?parent : h2d.Object) {
		super(parent);

		var loadedfont = if (font != null) font; else Const.MENU_FONT;
		textObject = new h2d.Text(loadedfont, this);
		#if debug
		background = new h2d.Graphics(textObject);
		#end
		setText(text);
		
		#if debug
		if (Debug.displays.get(Debug.DISPLAYS_UI_TEXT_BOUNDS) == true) {
			var background2 = new h2d.Graphics(this);
			background2.lineStyle(1, 0xff0000);
			background2.beginFill(0xFF0000,1);
			background2.drawCircle(0, 0, 6);
			background2.endFill();
		}
		#end
	}

	public function setHeight(height : Int) {
		var scale = height / textObject.textHeight;
		setScale(scale);
	}

	public function setWidth(width : Int) {
		var scale = width / textObject.textWidth;
		setScale(scale);
	}

	public function setText(text : String) {
		textObject.text = text;
		setAlignment();
		
		#if debug
		if (Debug.displays.get(Debug.DISPLAYS_UI_TEXT_BOUNDS) == true) {
			background.clear();
			background.beginFill(0xFF0000,0.5);
			background.drawRect(0, 0, textObject.textWidth, textObject.textHeight);
			background.endFill();
		}
		#end
	}

	public function setColor(color : Int) {
		textObject.textColor = color;
	}

	public function setWrapWidth(width : Int) textObject.maxWidth = width;

	override public function setAlignment(?horizontal : game.ui.alignment.Horizontal, ?vertical : game.ui.alignment.Vertical) {

		if (horizontal != null) this.horizontal = horizontal;
		if (vertical != null) this.vertical = vertical;

		switch(this.horizontal) {
			case Left: textObject.x = 0;
			case Center: textObject.x = -textObject.textWidth / 2;
			case Right: textObject.x = -textObject.textWidth;
		}

		switch(this.vertical) {
			case Top: textObject.y = 0;
			case Middle: textObject.y = -textObject.textHeight / 2;
			case Bottom: textObject.y = -textObject.textHeight;
		}
	}

}
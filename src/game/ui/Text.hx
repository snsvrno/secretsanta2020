package game.ui;

class Text extends game.ui.Element {

	var textObject : h2d.Text;

	var horizontal : game.ui.alignment.Horizontal = Left;
	var vertical : game.ui.alignment.Vertical = Top;

	override public function getHeight() : Float return textObject.textHeight * scaleY;
	override public function getWidth() : Float return textObject.textWidth * scaleX;

	public function new(text : String, ?font : h2d.Font, ?parent : h2d.Object) {
		super(parent);

		var loadedfont = if (font != null) font; else Const.MENU_FONT;
		textObject = new h2d.Text(loadedfont, this);
		setText(text);
	}

	public function setText(text : String) {
		textObject.text = text;
		setAlignment();
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
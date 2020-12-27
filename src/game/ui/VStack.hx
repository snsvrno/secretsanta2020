package game.ui;

class VStack extends game.ui.Element {

	private var childrenAlignment : game.ui.alignment.Horizontal = Left;
	private var horizontal : game.ui.alignment.Horizontal = Left;
	private var vertical : game.ui.alignment.Vertical = Top;

	private var padding : Int = 0;

	private var stack : h2d.Object;
	private var elements : Array<game.ui.Element> = [];

	public function new (?parent : h2d.Object) {
		super(parent);
		stack = new h2d.Object(this);
	}

	public function push(object : game.ui.Element) {
		elements.push(object);
		stack.addChild(object);
		setAlignment();
	}

	override public function setAlignment(?horizontal : game.ui.alignment.Horizontal, ?vertical : game.ui.alignment.Vertical) {

		if (horizontal != null) this.horizontal = horizontal;
		if (vertical != null) this.vertical = vertical;

		switch(this.horizontal) {
			case Left: stack.x = 0;
			case Center: stack.x = - getWidth() / 2;
			case Right: stack.x = - getWidth();
		}

		switch(this.vertical) {
			case Top: stack.y = 0;
			case Middle: stack.y = - getHeight() / 2;
			case Bottom: stack.y = - getHeight();
		}

		alignChildren();
	}

	public override function getWidth() : Float { 
		var w = 0.;
		for (c in elements) {
			if (c.getWidth() > w) w = c.getWidth();
		}
		return w;
	}
	public override function getHeight() : Float {
		var h = 0.;
		for (c in elements) { 
			if (h != 0.) h += padding;
			h += c.getHeight();
		}
		return h;
	}

	public function setChildrenAlignment(horizontal : game.ui.alignment.Horizontal, ?vertical : game.ui.alignment.Vertical) {
		childrenAlignment = horizontal;
		if (vertical != null) for (a in elements) a.setAlignment(null, vertical);
		alignChildren();
	}

	public function alignChildren() {
		var cy = 0.;
		var cx = switch(childrenAlignment) {
			case Left: 0;
			case Center: getWidth() / 2;
			case Right: getWidth();
		}

		for (i in 0 ... elements.length) {
			elements[i].x = cx;
			elements[i].y = cy;
			elements[i].setAlignment(childrenAlignment, Top);

			cy += elements[i].getHeight() + padding;
		}
	}

}
package game.ui;

import h2d.Object;

class HStack extends game.ui.Element {

	private var childrenAlignment : game.ui.alignment.Vertical = Top;
	private var horizontal : game.ui.alignment.Horizontal = Left;
	private var vertical : game.ui.alignment.Vertical = Top;

	public var padding : Int = 0;

	private var stack : h2d.Object;
	private var elements : Array<game.ui.Element> = [];

	public function new (?parent : h2d.Object) {
		super(parent);
		stack = new h2d.Object(this);
	}

	public function push(object : game.ui.Element, ?index : Int) {
		if (index != null) {
			stack.addChildAt(object, index);
			elements.insert(index, object);
		} else { 
			stack.addChild(object);
			elements.push(object);
		}
		setAlignment();
	}

	public function pushAll(objects : Array<game.ui.Element>) {
		for (o in objects) push(o);
	}
	
	public function removeObject(object : game.ui.Element) {
		elements.remove(object);
		stack.removeChild(object);
		setAlignment();
	}

	public function clear() {
		while (elements.length > 0)
			stack.removeChild(elements.pop());
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
			if (w != 0.) w += padding;
			w += c.getWidth();
		}
		return w;
	}
	
	public override function getHeight() : Float {
		var h = 0.;
		for (c in elements) if (c.getHeight() > h) h = c.getHeight();
		return h;
	}

	public function setChildrenAlignment(alignment : game.ui.alignment.Vertical) {
		childrenAlignment = alignment;
		alignChildren();
	}

	private function alignChildren() {
		var cx = 0.;
		var cy = switch(childrenAlignment) {
			case Top: 0;
			case Middle: getHeight() / 2;
			case Bottom: getHeight();
		}

		for (i in 0 ... elements.length) {
			elements[i].x = cx;
			elements[i].y = cy;
			elements[i].setAlignment(Left, childrenAlignment);

			cx += elements[i].getWidth() + padding;
		}
	}

}
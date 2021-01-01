package game.dialogue;

enum Style {
	Bold;
	Action;
	Italics;
	Dancing;
	None;
}

class TextMod extends h2d.Text {
	public var styleType : Style = None;
}
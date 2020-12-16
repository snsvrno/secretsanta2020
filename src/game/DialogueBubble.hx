package game;

enum TextStyled {
	Plain(t : String);
	Italic(t : String, pos : Int);
	Dancing(t : String, pos : Int);
}

class DialogueBubble extends h2d.Object {

	static private final padding : Int = 10;
	static private final cornerRadius : Int = 4;
	static private final maxWidth : Float = 300;

	private var text : h2d.Text;
	private var background : h2d.Graphics;

	private var lines : Array<Array<TextStyled>>;
	private var pos : Int = 0;

	public var height(get, null) : Float;
	private function get_height() : Float {
		return text.textHeight + 2 * padding;
	}

	public function new(dialogue : Data.Dialogue, parent : h2d.Object) {
		super(parent);

		background = new h2d.Graphics(this);

		// creates the dialogue text
		var font = hxd.res.DefaultFont.get();
		text = new h2d.Text(font, this);
		text.maxWidth = maxWidth;

		parse(dialogue.text);
		set();
	}

	/**
	 * Moves to the next dialogue sequence. Will return false if it was already at the last 
	 * sequence.
	 * @return Bool
	 */
	public function next() : Bool {

		if (pos == lines.length - 1) return false;
		else {
			pos++;
			set();
			return true;
		}
	}

	private function set() {

		// sets and positions the text.
		for (l in lines[pos]) switch(l) {
			case Plain(t): text.text = t;
			case Italic(t, pos):
				// we are making a fake italics, so we need to take each letter
				// and rotate it slightly.
				for (i in 0 ... t.length) {
					var nt = new h2d.Text(text.font, text);
					nt.text = t.charAt(i);
	
					var sub = text.text.substr(0,pos) + t.substr(0, i);
					nt.x = text.calcTextWidth(sub) + text.font.lineHeight * Math.sin(Const.TEXTITALICSANGLE)/2;
	
					nt.rotation = Const.TEXTITALICSANGLE;
				}

			case _:
		}

		if (pos != lines.length - 1) text.text += " >>"; 
		text.x = -text.textWidth/2;
		text.y = -text.textHeight/2;

		// creates the background
		var width = text.textWidth + 2 * padding;
		background.clear();
		background.beginFill(0xFF0000);
		background.drawRoundedRect(-width/2, -height/2, width, height, cornerRadius);
		background.endFill();
	}

	private function parse(string : String) {
		var rawLines : Array<String> = string.split("\\n");
		lines = new Array();

		// removes all the special things that we put in the text for
		// formatting and such...
		for (i in 0 ... rawLines.length) {
			// the new line.
			var line : Array<TextStyled> = new Array();

			var modifiedLine : String = "";

			var parts : Array<{ c : String, pos : Int }> = [];
			var word : String = "";
			var pos : Null<Int> = null;

			for (c in 0 ... rawLines[i].length) {
				var char = rawLines[i].charAt(c);
				if (char == "_") { 
					if (parts.length > 0 && parts[parts.length-1].c == char) {
						parts.pop();
						line.push(Italic(word, pos));

						word = "";
						pos = null;
					} else parts.push({ c : char, pos : c });
				} else { 
					if (parts.length > 0) {
						modifiedLine += " ";
						word += char;
						if (pos == null) pos = parts[parts.length-1].pos;
					} else {
						modifiedLine += char;
					}
				}
			}

			line.insert(0,Plain(modifiedLine));
			lines.push(line);
		}
	}
}
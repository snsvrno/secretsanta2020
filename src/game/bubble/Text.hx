package game.bubble;

import h3d.Vector;

private enum Style {
	Plain(t : String);
	Italic(t : String);
	Bold(t : String);
	Dancing(t : String);
}

class Text extends h2d.Object {

	static private var colorItalics : h3d.Vector = new h3d.Vector(1,1,0,1);
	static private var colorBold : h3d.Vector = new h3d.Vector(1,1,0,1);

	public var width(default, null) : Float = 0;

	public var height(default, null) : Float = 0;

	public var maxWidth(default, set) : Float;
	private function set_maxWidth(value : Float) : Float {
		maxWidth = value;
		rebuild();
		return maxWidth;
	}

	private var textObjects : Array<h2d.Text> = [];
	
	public function new(?parent : h2d.Object) {
		super(parent);

		/*
		text.text = content;
		text.x = -text.textWidth / 2;
		text.y = -text.textHeight / 2;

		textObjects.push(text);
		*/
		
		// super(font, parent);
	}

	/**
	 * Will rebuild the items in the text with respect to fontsize
	 * and defined maxwidth.
	 */
	private function rebuild() {

		// don't do anything if we don't have anything in here.
		if (textObjects.length == 0) return;

		// the working x and y positions, where to place the text.
		var x : Float = 0;
		var y : Float = 0;

		// positions everyone.
		for (i in 0 ... textObjects.length) {
			// we look at the angle because if we rotate the object then the postiion and width will change.
			textObjects[i].x = x + textObjects[i].textHeight * Math.sin(textObjects[i].rotation);
			textObjects[i].y = textObjects[i].textHeight * 1 / 4 * Math.sin(textObjects[i].rotation);

			// sets the working width.
			x += textObjects[i].textWidth * Math.cos(textObjects[i].rotation) + textObjects[i].textHeight * Math.sin(textObjects[i].rotation);

		}

		// sets the overall text properties.
		width = x;
		height = textObjects[0].textHeight;

		// centers everything, not the best maybe??
		for (t in textObjects) {
			t.x -= width / 2;
			t.y -= height / 2;
		}

	}

	static public function parse(string : String, ?maxLineWidth : Float) : Array<Text> {
		var newSections : Array<Text> = [];

		// splits the string into different sections.
		for (section in string.split("\\n")) {
			var text = new Text();

			// splits the section into different segments.
			var segments = splitSegments(section);
			// adds the segments to the text object.
		
			var font = hxd.res.DefaultFont.get();

			for (s in segments) {
				var tseg = new h2d.Text(font, text);

				switch(s) {
					case Bold(t):
						tseg.color = colorBold;
						tseg.text = t;
						text.textObjects.push(tseg);
					case Italic(t):
						tseg.color = colorItalics;
						tseg.text = t;

						var letters = splitText(tseg);
						for (l in letters) {
							l.rotation = 0.15;
							text.textObjects.push(l);
						}

					case Dancing(t):
						tseg.text = t;

						var letters = splitText(tseg);
						for (i in 0 ... letters.length) {
							var timer = new sn.Timer(1);
							timer.infinite = true;
							timer.updateCallback = function() { 
								// for movement
								letters[i].y += Math.sin((timer.timerPercent + i / letters.length) * 2 * Math.PI) * 0.10;
								// for rotation.
								// letters[i].rotation = Math.sin(timer.timerPercent * Math.PI * 2 - Math.PI) / 3;
							};
							text.textObjects.push(letters[i]);
						}
					case Plain(t): 
						tseg.text = t;
						text.textObjects.push(tseg);
				}
			}
		
			// called here because there is a hook that will
			// rebuild it.
			// text.maxWidth = maxLineWidth;
			text.rebuild();
			newSections.push(text);
		}

		return newSections;
	}

	/**
	 * A simple copy function, for cloning text.
	 * @param text 
	 * @return h2d.Text
	 */
	static private function copyText(text : h2d.Text) : h2d.Text {
		var newText = new h2d.Text(text.font, text.parent);

		newText.text = text.text;
		newText.color = text.color;

		return newText;
	}

	static private function splitText(text : h2d.Text, ?characters : Int = 1, ?repeat : Bool = true, ?breakWords : Bool = true) : Array<h2d.Text> {
		var splits : Array<h2d.Text> = new Array();

		var copy = copyText(text);
		copy.text = copy.text.substr(0, characters);
		splits.push(copy);

		if (!repeat) {
			text.text = text.text.substr(characters);
			splits.push(copy);
		} else {
			var c = characters;
			while ((c + characters) < text.text.length) {
				var copy = copyText(text);
				copy.text = copy.text.substr(c, characters);
				c += characters;
				splits.push(copy);
			}

			// capture the last bit.
			if (c < text.text.length) { 
				text.text = text.text.substr(c);
				splits.push(text);
			}
		}

		return splits;
	}

	static private function splitSegments(content : String) : Array<Style> {
		var segments : Array<Style> = new Array();
		
		var segment : String = "";
		var insideSpecial : Bool = false;
		for (i in 0 ... content.length) {
			switch(content.charAt(i)) {
				// italics
				case "_": 

					if (insideSpecial == true) {
						insideSpecial = false;
						segments.push(Italic(segment));
					} else {
						insideSpecial = true;
						if (segment.length > 0) segments.push(Plain(segment));
					}

					segment = "";
					
				// bold
				case "*":

					if (insideSpecial == true) {
						insideSpecial = false;
						segments.push(Bold(segment));
					} else {
						insideSpecial = true;
						if (segment.length > 0) segments.push(Plain(segment));
					}
					
					segment = "";
					
				// bold
				case "~":

					if (insideSpecial == true) {
						insideSpecial = false;
						segments.push(Dancing(segment));
					} else {
						insideSpecial = true;
						if (segment.length > 0) segments.push(Plain(segment));
					}
					
					segment = "";

				// no special character
				case c:
					segment += c;
			}
		}

		// catching the last one if it was normal.
		if (segment.length > 0) segments.push(Plain(segment));

		// we check if we actually split anything, maybe there weren't any 
		// of these special characters in the text, so then we just return
		// the entire content as a plain text.
		if (segments.length == 0) return [ Plain(content) ];
		else return segments;
	}
}
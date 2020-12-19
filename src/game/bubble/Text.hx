package game.bubble;

import h3d.Vector;

private enum Style {
	Plain(t : String);
	Italic(t : String);
	Bold(t : String);
	Dancing(t : String);
	Action(t : String);
	Variable(t : String);
}

class Text extends h2d.Object {

	static private var colorItalics : h3d.Vector = new h3d.Vector(1,1,0,1);
	static private var colorBold : h3d.Vector = new h3d.Vector(1,1,0,1);
	static private var colorAction : h3d.Vector = new h3d.Vector(0.5,0.5,0.5,1);
	static private var colorVariable : h3d.Vector = new h3d.Vector(0,0.5,1,1);

	public var width(default, null) : Float = 0;

	public var height(default, null) : Float = 0;

	public var maxWidth(default, set) : Null<Float>;
	private function set_maxWidth(value : Float) : Float {
		maxWidth = value;
		rebuild();
		return maxWidth;
	}

	override function onRemove() {
		super.onRemove();
		while (timers.length > 0) {
			var t = timers.pop();
			t.remove();
		}
	}

	private var textObjects : Array<h2d.Text> = [];
	// collecting the timers so we can destroy them when they are done.
	private var timers : Array<sn.Timer> = [];

	private static function calculateTextWidth(text : h2d.Text, ?overrideText : String) : Float {
		var content = if(overrideText != null) overrideText; else text.text;
		return text.calcTextWidth(content) * Math.cos(text.rotation) + text.textHeight * Math.sin(text.rotation);
	}

	public function asString():String {
		var string = "";

		for (t in textObjects) {
			string += t.text;
		}

		return string;
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
		var i = 0;
		while(i < textObjects.length) {

			var triggerBreak = false;
			if (maxWidth != null && 
				x + calculateTextWidth(textObjects[i]) > maxWidth) {
				
				triggerBreak = true;

				// determines how many characters are allowed, since this isn't a monospaced font we need to
				// check each character.
				var characters = textObjects[i].text.length;
				while (calculateTextWidth(textObjects[i], textObjects[i].text.substr(0,characters)) > maxWidth) {
					characters -= 1;
				}

				// removes the current item from the heirarchy.
				var parent = textObjects[i].parent;
				textObjects[i].remove();
				// make some new items.
				var items = splitText(textObjects[i], characters, false);
				// remove the item.
				textObjects.remove(textObjects[i]);
				// takes the new items and places them in the location of the older item.
				while(items.length > 0) { 
					var item = items.pop();

					// check to remove the leading space, only on all lines that aren't the first one.
					if (items.length > 0) while(item.text.length > 0 && item.text.substr(0,1) == " ") item.text = item.text.substr(1);

					parent.addChild(item);
					textObjects.insert(i, item);
				}
			}

			// we look at the angle because if we rotate the object then the postiion and width will change.
			textObjects[i].x = x + textObjects[i].textHeight * Math.sin(textObjects[i].rotation);
			textObjects[i].y = y + textObjects[i].textHeight * 1 / 4 * Math.sin(textObjects[i].rotation);

			// sets the working width.
			x += calculateTextWidth(textObjects[i]);
			
			// checks if we need a new line, set inside the area that breaks the text appart.
			if (triggerBreak) {

				// updates with width, checks if this is the maximum width and then sets it.
				if (x > width) width = x;

				x = 0;
				y += textObjects[i].textHeight;
			}

			i += 1;
		}

		// sets the overall text properties.
		height = textObjects[0].textHeight + y;
		// if we never set the width before then it will use the overall width.
		if (width == 0) width = x;

		// centers everything, not the best maybe??
		for (t in textObjects) {
			t.x -= width / 2;
			t.y -= height / 2;
		}

		trace('done');

	}

	/**
	 * Processess text in order to evaluate formatting and variables.
	 * @param string 
	 * @param maxLineWidth 
	 * @return Array<Text>
	 */
	static public function parse(string : String, ?maxLineWidth : Float) : Array<Text> {
		var newSections : Array<Text> = [];

		// splits the string into different sections.
		for (section in string.split("\\n")) {
			var text = new Text();

			// splits the section into different segments.
			var segments = splitSegments(section);
			// adds the segments to the text object.
		
			// loads the font.
			var font = hxd.res.DefaultFont.get();

			// splits the text into different segments and evaluating the styling
			// and the variables
			for (s in segments) {
				var tseg = new h2d.Text(font, text);

				switch(s) {
					case Variable(t):
						tseg.color = colorVariable;
						tseg.text = Game.variables.evalulate(t);
						tseg.dropShadow = { dx : 0.2, dy : 0.2, color: 0x000000, alpha: 0.85 };
						text.textObjects.push(tseg);

					case Bold(t):

						tseg.color = colorBold;
						tseg.text = t;
						text.textObjects.push(tseg);

					case Action(t):

						tseg.color = colorAction;
						tseg.text = t;

						var letters = splitText(tseg);
						for (l in letters) {
							l.rotation = 0.15;
							text.textObjects.push(l);
						}

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
							timer.updateCallback = function() letters[i].y += Math.sin((timer.timerPercent + i / letters.length) * 2 * Math.PI) * 0.10;
							text.textObjects.push(letters[i]);
							text.timers.push(timer);
						}

					case Plain(t): 

						tseg.text = t;
						text.textObjects.push(tseg);
				}
			}
		
			// called here because there is a hook that will
			// rebuild it.
			if (maxLineWidth != null) text.maxWidth = maxLineWidth;
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

	static private function splitText(text : h2d.Text, ?characters : Int = 1, ?breakWords : Bool = true) : Array<h2d.Text> {
		var splits : Array<h2d.Text> = new Array();

		var pos = 0;
		while ((pos + characters) < text.text.length) {
			var copy = copyText(text);

			var cutMarker = characters;
			while (breakWords == false && cutMarker > 1 && copy.text.substr(cutMarker,1) != " ") {
				cutMarker -= 1;
			}
			copy.text = copy.text.substr(pos, cutMarker);
			pos += cutMarker;
			splits.push(copy);
		}

		// capture the last bit.
		if (pos < text.text.length) { 
			text.text = text.text.substr(pos);
			splits.push(text);
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

				// variables
				case "$": 

					if (insideSpecial == true) {
						insideSpecial = false;
						segments.push(Variable(segment));
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
					
				// dancing
				case "~":

					if (insideSpecial == true) {
						insideSpecial = false;
						segments.push(Dancing(segment));
					} else {
						insideSpecial = true;
						if (segment.length > 0) segments.push(Plain(segment));
					}
					
					segment = "";
					
				// action
				case "/":

					if (insideSpecial == true) {
						insideSpecial = false;
						segments.push(Action(segment));
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
package game.bubble;

import h3d.Vector;

private enum Style {
	Plain(t : String);
	Italic(t : String);
	Bold(t : String);
	Dancing(t : String);
	Action(t : String);
	Variable(t : String);
	StringVariable(t : String);
}

class Text extends h2d.Object {

	//////////////////////////////////////////////////////////////////////////
	// style and colors

	static private var colorItalics : h3d.Vector = h3d.Vector.fromColor(Const.BUBBLE_TEXT_COLOR_ITALICS);
	static private var colorBold : h3d.Vector = h3d.Vector.fromColor(Const.BUBBLE_TEXT_COLOR_BOLD);
	static private var colorAction : h3d.Vector = h3d.Vector.fromColor(Const.BUBBLE_TEXT_COLOR_ACTION);
	static private var colorVariable : h3d.Vector = h3d.Vector.fromColor(Const.BUBBLE_TEXT_COLOR_VARIABLE);
	static private var colorRegular : h3d.Vector = h3d.Vector.fromColor(Const.BUBBLE_TEXT_COLOR_REGULAR);
	
	//////////////////////////////////////////////////////////////////////////
	// private members

	private var textObjects : Array<h2d.Text> = [];

	// collecting the timers so we can destroy them when they are done.
	private var timers : Array<sn.Timer> = [];

	private var rawInputString : String;

	private var variables : Null<Array<String>> = null;

	//////////////////////////////////////////////////////////////////////////
	// public members

	public var width(default, null) : Float = 0;
	public var height(default, null) : Float = 0;

	public var maxWidth : Null<Float>;

	//////////////////////////////////////////////////////////////////////////
	// initalization and creation functions
	
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

	/**
	 * Processess text in order to evaluate formatting and variables.
	 * @param string 
	 * @param maxLineWidth 
	 * @return Array<Text>
	 */
	static public function parse(string : String, ?variables : Array<String>, ?maxLineWidth : Float) : Array<Text> {
		var newSections : Array<Text> = [];

		// splits the string into different sections.
		for (section in string.split("\\n")) {
			var text = new Text();
			text.rawInputString = section;
			text.variables = variables;
			text.wrap(maxLineWidth);
			// text.build();
			newSections.push(text);
		}

		return newSections;
	}

	static private function parseSection(sectionText : String, ?variables : Array<String>) : { text: Array<h2d.Text>, timers: Array<sn.Timer> } {
		var textObjects : Array<h2d.Text> = [];
		var timers : Array<sn.Timer> = [];
	
		// splits the section into different segments.
		var segments = splitSegments(sectionText);
		// adds the segments to the text object.
	
		// splits the text into different segments and evaluating the styling
		// and the variables
		for (s in segments) {
			var tseg = new h2d.Text(Const.TEXT_FONT_NORMAL);

			switch(s) {
				case StringVariable(t):
					var textvalue = "<undefined>";

					// attempts to load the value from the passed array.
					var index = Std.parseInt(t);
					if (variables != null && index != null && variables.length > index) textvalue = variables[index];

					tseg.color = colorVariable;
					tseg.text = textvalue;
					tseg.dropShadow = { dx : 0.2, dy : 0.2, color: 0x000000, alpha: 0.85 };
					textObjects.push(tseg);

				case Variable(t):
					tseg.color = colorVariable;
					tseg.text = Game.variables.evalulate(t);
					tseg.dropShadow = { dx : 0.2, dy : 0.2, color: 0x000000, alpha: 0.85 };
					textObjects.push(tseg);

				case Bold(t):

					// change the font to the bold font
					tseg.font = Const.TEXT_FONT_BOLD;
					tseg.color = colorBold;
					tseg.text = t;
					tseg.y += Const.TEXT_FONT_BOLD_Y_OFFSET;
					textObjects.push(tseg);

				case Action(t):

					tseg.color = colorAction;
					tseg.text = t;

					var letters = splitText(tseg);
					for (l in letters) {
						l.rotation = Const.TEXT_ACTION_SLANT;
						textObjects.push(l);
					}

				case Italic(t):

					tseg.color = colorItalics;
					tseg.text = t;

					var letters = splitText(tseg);
					for (l in letters) {
						l.rotation = Const.TEXT_ITALICS_SLANT;
						textObjects.push(l);
					}

				case Dancing(t):

					tseg.text = t;
					tseg.color = colorRegular;

					var letters = splitText(tseg);
					for (i in 0 ... letters.length) {
						var timer = new sn.Timer(1);
						timer.infinite = true;
						timer.updateCallback = function() letters[i].y += Math.sin((timer.timerPercent + i / letters.length) * 2 * Math.PI) * 0.10;
						textObjects.push(letters[i]);
						timers.push(timer);
					}

				case Plain(t): 

					tseg.color = colorRegular;
					tseg.text = t;
					textObjects.push(tseg);
			}
		}

		return { text: textObjects, timers: timers };
	}

	//////////////////////////////////////////////////////////////////////////
	// private functions

	private static function calculateTextWidth(text : h2d.Text, ?overrideText : String) : Float {
		var content = if(overrideText != null) overrideText; else text.text;
		return text.calcTextWidth(content);// * Math.cos(text.rotation) + text.textHeight * Math.sin(text.rotation);
	}

	private function build() {
		
		// don't do anything if we don't have anything in here.
		if (textObjects.length == 0) return;

		// the working x and y positions, where to place the text.
		var x : Float = 0;
		var y : Float = 0;
	
		// positions everyone.
		var y = 0.;
		var h = 0.;
		var w = 0.;
		for (to in textObjects) {
			to.x = -to.textWidth / 2;
			to.y = y;
			y += to.textHeight;

			if (to.textWidth > w) w = to.textWidth;
			h += to.textHeight;
		}
		// setting the overall text dimensions.
		width = w;
		height = h;

		// moves the text so that it is centered at 0;
		for (to in textObjects) to.y -= h/2;
	}

	private function wrap(?wrapWidth : Float) {
		// set the value
		if (wrapWidth != null) maxWidth = wrapWidth;

		// used for splitting
		var workingtext = new h2d.Text(Const.TEXT_FONT_NORMAL);
		workingtext.maxWidth = maxWidth;
		var splitText = workingtext.splitText(rawInputString);

		// makes it
		var y = 0.;
		var w = 0.;
		for (s in splitText.split("\n")) {

			var x = 0.;
			var lineHeight = 0.;
			var lineWidth = 0.;
			var parsed = parseSection(s, variables);

			for (t in parsed.timers) timers.push(t);
			for (pt in parsed.text) { 
				textObjects.push(pt);
				addChild(pt);

				pt.x = x;
				pt.y = y;

				x += pt.textWidth;
				lineWidth += pt.textWidth;

				if (lineHeight < pt.textHeight) lineHeight = pt.textHeight;
			}

			y += lineHeight;
			if (w < lineWidth) w = lineWidth;
		}

		// setting the overall text dimensions.
		width = w;
		height = y;
		
		// moves the text so that it is centered at 0;
		for (to in textObjects) { 
			to.y -= height/2;
			to.x -= width/2;
		}
	}

	/**
	 * Will rebuild the items in the text with respect to fontsize
	 * and defined maxwidth.
	 */
	private function rebuildZ() {

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
		
		#if debug
		if (Debug.TEXTBOX_SHOW_BOUNDARIES) { 
			// a bounding box for debug to see what area is acceptable for the text.
			var bbox = new h2d.Graphics(this);
			bbox.lineStyle(1,0x0000FF,1.0);
			bbox.beginFill(0,0.);
			bbox.drawRect(0-width/2, -height/2, width, height);
			bbox.endFill();
		}

		if (Debug.TEXT_SHOW_BOUNDARIES) {
			// makes a box for every text object.
			for (t in textObjects) {
				var tt = new h2d.Graphics(t);
				tt.lineStyle(1,0x0000FF,1.0);
				tt.beginFill(0,0.);
				tt.drawRect(0, 0, t.textWidth, t.textHeight);
				tt.endFill();
			}
		}

		#end
	}

	//////////////////////////////////////////////////////////////////////////
	// public functions

	override function onRemove() {
		super.onRemove();
		while (timers.length > 0) {
			var t = timers.pop();
			t.remove();
		}
	}

	/**
	 * For getting the contents of this text object as a single continuous string.
	 * @return String
	 */
	public function asString():String {
		var string = "";

		for (t in textObjects) {
			string += t.text;
		}

		return string;
	}

	//////////////////////////////////////////////////////////////////////////
	// STATIC PRIVATE FUNCTIONS
	// helper functions used for parsing and instantation. 

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
					
				// bold
				case "`":

					if (insideSpecial == true) {
						insideSpecial = false;
						segments.push(StringVariable(segment));
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
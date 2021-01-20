package game.dialogue;

import sn.Timer;

private enum Style {
	Plain(t : String);
	Italic(t : String);
	Bold(t : String);
	Dancing(t : String);
	Action(t : String);
	Variable(t : String);
	StringVariable(t : String);
}

/**
 * Complex text object for dialogue.
 * 
 * Allows for complex formatting in a sentance, so multiple different colors and styles available
 * in one dialogue object.
 */
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

	private var textObjects : Array<TextMod> = [];

	// collecting the timers so we can destroy them when they are done.
	private var timers : Array<sn.Timer> = [];

	private var rawInputString : String;

	private var variables : Null<Array<String>> = null;

	private var font : h2d.Font;

	//////////////////////////////////////////////////////////////////////////
	// public members

	public var width(default, null) : Float = 0;
	public var height(default, null) : Float = 0;

	public var endX(default, null) : Float = 0;
	public var endY(default, null) : Float = 0;

	public var maxWidth : Null<Float>;

	//////////////////////////////////////////////////////////////////////////
	// initalization and creation functions
	
	public function new(?font : h2d.Font, ?parent : h2d.Object) {
		super(parent);
		
		if (font != null) this.font = font;
		else this.font = Const.TEXT_FONT_NORMAL;

		filter = new h2d.filter.Nothing();
	}

	/**
	 * A simple copy function, for cloning text.
	 * @param text 
	 * @return h2d.Text
	 */
	static private function copyText(text : TextMod) : TextMod {
		var newText = new TextMod(text.font, text.parent);

		newText.text = text.text;
		newText.color = text.color;
		newText.styleType = text.styleType;


		return newText;
	}

	/**
	 * Processess text in order to evaluate formatting and variables.
	 * @param string 
	 * @param maxLineWidth 
	 * @return Array<Text>
	 */
	static public function parse(string : String, ?font : h2d.Font, ?variables : Array<String>, ?maxLineWidth : Float) : Array<Text> {
		var newSections : Array<Text> = [];
	
		if (font == null) font = Const.TEXT_FONT_NORMAL;

		// splits the string into different sections.
		for (section in string.split("\\n")) {
			var text = new Text(font);
			text.rawInputString = section;
			text.variables = variables;
			text.wrap(maxLineWidth);
			// text.build();
			newSections.push(text);
		}

		return newSections;
	}

	static private function parseSection(sectionText : String, ?overridefont : h2d.Font, ?variables : Array<String>) : { text: Array<TextMod>, timers: Array<sn.Timer> } {
		var textObjects : Array<TextMod> = [];
		var timers : Array<sn.Timer> = [];
		
		var font : h2d.Font = if (overridefont == null) Const.TEXT_FONT_NORMAL;
		else overridefont;
	
		// splits the section into different segments.
		var segments = splitSegments(sectionText);
		// adds the segments to the text object.
	
		// splits the text into different segments and evaluating the styling
		// and the variables
		for (s in segments) {
			var tseg = new TextMod(font);

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

					// change the font to the bold font, if we don't define a font.
					if (overridefont == null) tseg.font = Const.TEXT_FONT_BOLD;
					tseg.color = colorBold;
					tseg.text = t;
					tseg.styleType = Bold;
					textObjects.push(tseg);

				case Action(t):

					tseg.color = colorAction;
					if (overridefont == null) tseg.font = Const.TEXT_FONT_ACTION;
					tseg.text = t;
					tseg.styleType = Action;

					var letters = splitText(tseg);
					for (l in letters) {
						l.rotation = Const.TEXT_ACTION_SLANT;
						textObjects.push(l);
					}

				case Italic(t):

					tseg.color = colorItalics;
					if (overridefont == null) tseg.font = Const.TEXT_FONT_ITALICS;
					tseg.text = t;
					tseg.styleType = Italics;

					var letters = splitText(tseg);
					for (l in letters) {
						l.rotation = Const.TEXT_ITALICS_SLANT;
						textObjects.push(l);
					}

				case Dancing(t):

					tseg.text = t;
					tseg.color = colorRegular;
					if (overridefont == null) tseg.font = Const.TEXT_FONT_DANCING;
					tseg.styleType = Dancing;

					var letters = splitText(tseg);
					for (i in 0 ... letters.length) {
						var timer = new sn.Timer(Const.TEXT_DANCING_SPEED);
						timer.infinite = true;

						var start : Null<Float> = null;
						timer.updateCallback = function() {
							if (start == null) start = letters[i].y; 
							letters[i].y += Math.sin((timer.timerPercent + i / letters.length) * 2 * Math.PI) * Const.TEXT_DANCING_INTENSITY;
						};
						timer.finalCallback = function() {
							letters[i].y = start;
							start = null;
						} 
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

	private function wrap(?wrapWidth : Float) {
		// set the value
		if (wrapWidth != null) maxWidth = wrapWidth;

		// removes children if we are wrapping for a second time.
		removeChildren();

		// used for splitting
		var workingtext = new h2d.Text(font);
		workingtext.maxWidth = maxWidth;
		var splitText = workingtext.splitText(rawInputString);

		// we need to make sure we don't split the style markers because then we wont'
		// style those areas that get line braked.

		splitText = game.utils.Quoted.throughLineBreaks(splitText);

		// makes it
		var y = 0.;
		var w = 0.;
		for (s in splitText.split("\n")) {

			var x = 0.;
			var lineHeight = 0.;
			var lineWidth = 0.;
			var parsed = parseSection(s, font, variables);

			for (t in parsed.timers) timers.push(t);
			for (pt in parsed.text) { 
				textObjects.push(pt);
				addChild(pt);

				pt.x = x;
				pt.y = y;

				if (font == null) switch(pt.styleType) {
					case Bold: pt.y += Const.TEXT_FONT_BOLD_Y_OFFSET;
					case Italics: pt.y += Const.TEXT_FONT_ITALICS_Y_OFFSET;
					case Action: pt.y += Const.TEXT_FONT_ACTION_Y_OFFSET;
					case Dancing: pt.y += Const.TEXT_FONT_DANCING_Y_OFFSET;
					case None:
				}

				x += pt.textWidth;
				lineWidth += pt.textWidth;

				if (lineHeight < pt.textHeight) lineHeight = pt.textHeight;
			
				#if debug
				if (Debug.displays.get(Debug.DISPLAYS_TEXT_BOUNDS) == true) {
					var outline = new h2d.Graphics(pt);
					outline.lineStyle(1, 0xF0FF0F);
					outline.drawRect(0,0,pt.textWidth, pt.textHeight);
				}
				#end
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

		var lastObject = textObjects[textObjects.length-1];
		endX = lastObject.x + lastObject.textWidth;
		endY = lastObject.y + lastObject.textHeight/2;
	}

	//////////////////////////////////////////////////////////////////////////
	// public functions

	public function enableShadow() {
		for (to in textObjects) {
			to.filter = new h2d.filter.Outline(0.5, 0xFF000000, 2);
			to.dropShadow = { dx: 0, dy: 1, color: 0x000000, alpha: 0.85 };
		}
	}

	public function setText(text : String) {
		// drains the existing text objects.
		while (textObjects.length > 0) textObjects.pop().remove();
		while (timers.length > 0) timers.pop();

		var parsed = parse(text, font, null, maxWidth);
		if (parsed.length != 1) throw("error, can't load into this multi-lines");

		textObjects = parsed[0].textObjects;
		timers = parsed[0].timers;
		rawInputString = parsed[0].rawInputString;
		variables = parsed[0].variables;

		width = parsed[0].width;
		height = parsed[0].height;

		// set as the correct parent.
		for (to in textObjects) {
			to.remove();
			addChild(to);
			#if debug
			if (Debug.displays.get(Debug.DISPLAYS_TEXT_BOUNDS) == true) {
				var outline = new h2d.Graphics(to);
				outline.lineStyle(1, 0xF0FF0F);
				outline.drawRect(0,0,to.textWidth, to.textHeight);
			}
			#end
		}

	}

	/**
	 *  add to the end of the text object
	 * @param test 
	 */
	public function push(test : String) {
		rawInputString += test;
		wrap();
	}

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

	static private function splitText(text : TextMod, ?characters : Int = 1, ?breakWords : Bool = true) : Array<TextMod> {
		var splits : Array<TextMod> = new Array();

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

		for (segs in game.utils.Quoted.parse(content)) switch(segs.quote) {
			case "_": segments.push(Italic(segs.text));
			case "$": segments.push(Variable(segs.text));
			case "*": segments.push(Bold(segs.text));
			case "~": segments.push(Dancing(segs.text));
			case "/": segments.push(Action(segs.text));
			case "`": segments.push(StringVariable(segs.text));
			case null: segments.push(Plain(segs.text));
			case _: throw("unhandled.");
		}

		return segments;
	}

}
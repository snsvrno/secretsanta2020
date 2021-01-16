package game.dialogue;

/**
 * The collection of choices. 
 * 
 * could be called a choice or dialogue wheel, but probably isn't in the shape of a wheel.
 */
class Wheel extends h2d.Object {

	public var length(get, null) : Int;
	private function get_length() : Int return choices.length;

	public var width(get, null) : Float;
	private function get_width() : Float {
		width = 0.;
		for (c in choices) {
			if (width < c.width) width = c.width;
		}
		return width;
	}

	public var height(get, null) : Float;
	private function get_height() : Float {
		height = 0;
		for (i in 0 ...choices.length) {
			height += choices[i].height;
			if (i < choices.length - 1) height += Const.CHOICE_PADDING;
		}
		return height;
	}

	private var choices : Array<Choice> = [];
	private var background : h2d.Graphics;
	private var radius : Int = Const.CHOICE_RADIUS;

	public var onLeave : Null<() -> Void>;
	public var onSelect : Null<(choice : Data.DialogueKind) -> Void>;

	public function new(?action : Data.DialogueActions, x : Float, y : Float, parent : h2d.Object) {
		super(parent);

		background = new h2d.Graphics(this);

		// creates the actions if defined.
		if (action != null) makeChoices(action);

		// draws the wheel & arranges the choices around the wheel.
		arrangeChoicesStack();

		var outInteractive = new h2d.Interactive(width + 2 * Const.WHEEL_FADE_PADDING, height + 2 * Const.WHEEL_FADE_PADDING, this);
		outInteractive.propagateEvents = true;
		outInteractive.x = -outInteractive.width / 2;
		outInteractive.y = -outInteractive.height / 2;
		outInteractive.onMove = function (e : hxd.Event) {
			// this calculates if the mouse is in the fade zone, and then fades the
			// choices the correct amount. chose to do this so that it tells the player
			// that as they move away from the wheel, it will destroy the wheel.

			var cx = outInteractive.width / 2;
			var cy = outInteractive.height / 2;
			var a = 1.0;

			if (e.relX < cx) {
				if (e.relX < Const.WHEEL_FADE_PADDING) a = e.relX / Const.WHEEL_FADE_PADDING;
			} else {
				var dx = outInteractive.width - Const.WHEEL_FADE_PADDING;
				if (dx < e.relX) a = 1 - (e.relX - dx) / Const.WHEEL_FADE_PADDING;
			}

			if (e.relY < cy) {
				if (e.relY < Const.WHEEL_FADE_PADDING) a = e.relY / Const.WHEEL_FADE_PADDING;
			} else {
				var dy = outInteractive.height - Const.WHEEL_FADE_PADDING;
				if (dy < e.relY) a = 1 - (e.relY - dy) / Const.WHEEL_FADE_PADDING;
			}
			
			alpha = a;
		}
		outInteractive.onOut = function(e:hxd.Event) {
			if(onLeave != null) onLeave();
			destroy();
		}
		
		#if debug
		var outline = new h2d.Graphics(outInteractive);
		outline.lineStyle(1, 0x00FFFF);
		outline.drawRect(0,0,outInteractive.width,outInteractive.height);
		outline.lineStyle(1, 0x0000FF);
		outline.drawRect(Const.WHEEL_FADE_PADDING,Const.WHEEL_FADE_PADDING,
			outInteractive.width - 2 * Const.WHEEL_FADE_PADDING,
			outInteractive.height - 2 * Const.WHEEL_FADE_PADDING);
		#end

		this.x = x;
		this.y = y;
	}

	static public function raw(x : Float, y : Float, parent : h2d.Object, ?onDestroy : () -> Void) : Wheel {
		var wheel = new Wheel(null, x, y, parent);

		// this always needs to be at the top of the stack for this to work correctly, so we need to
		// add the choices under this.

		var interactive = new h2d.Interactive(0,0,wheel, new h2d.col.Circle(0, 0, Const.CHOICE_RADIUS_OUT));
		interactive.propagateEvents = true;
		interactive.onOut = function(e : hxd.Event) {
			onDestroy();
			wheel.destroy();
		}

		return wheel;
	}

	/**
	 * Adds a simple text and response option, will remove the wheel when done.
	 * @param text 
	 * @param response 
	 */
	public function addDialogueChoice(text : String, response : String, ?onClick : () -> Void) {
		var newChoice = Choice.fromString(text);
		addChildAt(newChoice, children.length-1); 
		
		// sets the hook to display the response and remove the wheel.
		newChoice.onClick = function() {
			if (onClick != null) onClick();
			Game.createDialoge(response, parent.x, parent.y, 80);
			this.destroy();
		}

		choices.push(newChoice);
		//arrangeChoices();
		arrangeChoicesStack();
	}

	/**
	 * Performs some action on click, no response.
	 * @param text 
	 * @param onClick 
	 * @return -> Void)
	 */
	public function addDialogueAction(text : String, onClick : () -> Void) {
		var newChoice = Choice.fromString(text); 
		addChildAt(newChoice, children.length-1); 

		// sets the hook to display the response and remove the wheel.
		newChoice.onClick = function() {
			onClick();
			this.destroy();
		}

		choices.push(newChoice);
		//arrangeChoices();
		arrangeChoicesStack();
	}

	/**
	 * Creates the base graphic for the wheel.
	 */
	private function makeBaseWheel() {
		background.clear();
		background.lineStyle(2, 0x000000, 0.75);
		background.beginFill(0x000000, 0.75);
		background.drawCircle(0, 0, radius);
		background.endFill();
	}

	private function arrangeChoicesStack() {

		var y = -height/2;
		for (i in 0 ... choices.length) {
			y += choices[i].height/2;
			choices[i].setY(y);
			choices[i].setX(0);
			y += choices[i].height/2 + Const.CHOICE_PADDING;
		}
	}

	private function makeChoices(action : Data.DialogueActions) {

		var validChoices = getValidChoices(action);

		for (i in 0 ... validChoices.length) {

			// adds the text
			var text = new Choice(validChoices[i], this);
			text.onClick = function () {
				if (onSelect != null) { 
					var choice = validChoices[i].id;
					onSelect(choice);

					// sets the dialogue option as already used, just so that it is
					// obvious to the player that they already used it.
					Game.variables.addChosenOption(choice);
				}
			}

			choices.push(text);
		}
	}

	private function getValidChoices(action : Data.DialogueActions, ?importer : Bool = false) : Array<Data.Dialogue> {
		var validOptions : Array<Data.Dialogue> = new Array();

		// gets the options
		for (i in 0 ... action.options.length) {
			var d = action.options[i].option;
			
			var valid = true;
			if (d.condition != null) for (c in d.condition) {
				if (valid)
					switch(c.condition) {

						// forwarding, meaning we ignore what we did here and instead'
						// give it to forwardedAction
						case Forwarder(condition, forwardedAction):
							if (Conditions.check(condition))
								return getValidChoices(forwardedAction);
						
						// i don't really know how this is suppose to work?
						case InsertChoices(condition, insertAction, cont):
							throw("this probably doesn't work"); 
							if (Conditions.check(condition)) {
								var newOptions = getValidChoices(insertAction, true);
								for (n in newOptions) validOptions.push(n);
							}
							if (cont) valid = false;

						case other: if (!Conditions.check(other)) valid = false;
					}
			}

			if (valid) validOptions.push(d);
		}

		// checks if we have an imports
		if (action.imports != null) for (i in 0 ... action.imports.length) {
			var choices = getValidChoices(action.imports[i].action, true);
			for (c in choices){
				// checks if we already loaded this. 
				var alreadyLoaded = false;
				for (vo in validOptions) if (vo.id == c.id)  alreadyLoaded = true;
				
				if (!alreadyLoaded) validOptions.push(c);
			}
		}

		// safety check, adds a checker clause because only the final check should 
		// care if its empty.
		// if (importer == false && validOptions.length == 0) throw("no options!?! why are we here!");
		
		return validOptions;
	}

	/**
	 * Generates the position of the text, is really just doing the points
	 * around a circle, starting at the top middle and working clockwise.
	 * @param angle 
	 * @param radius 
	 */
	private function choicePosition(angle : Float, radius : Float) : { x : Float, y : Float } {
		var x = radius * Math.sin(angle);
		var y = -radius * Math.cos(angle);

		return { x : x, y : y };
	}

	public function destroy() {
		remove();
	}
}
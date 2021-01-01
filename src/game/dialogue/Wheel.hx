package game.dialogue;

/**
 * The collection of choices. 
 * 
 * could be called a choice or dialogue wheel, but probably isn't in the shape of a wheel.
 */
class Wheel extends h2d.Object {

	public var length(get, null) : Int;
	private function get_length() : Int return choices.length;

	private var choices : Array<Choice> = [];
	private var background : h2d.Graphics;
	private var radius : Int = Const.CHOICE_RADIUS;

	public var onSelect : Null<(choice : Data.DialogueKind) -> Void>;

	public function new(?action : Data.DialogueActions, x : Float, y : Float, parent : h2d.Object) {
		super(parent);

		background = new h2d.Graphics(this);

		// creates the actions if defined.
		if (action != null) makeChoices(action);

		// draws the wheel & arranges the choices around the wheel.
		//arrangeChoices();
		arrangeChoicesStack();
		// makeBaseWheel();

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
		newChoice.setHook(function(e : hxd.Event) {
			if (onClick != null) onClick();
			Game.createDialoge(response, parent.x, parent.y, 80);
			this.destroy();
		});

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
		newChoice.setHook(function(e : hxd.Event) {
			onClick();
			this.destroy();
		});

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
		var y = 0.;
		var height = 0.;
		for (i in 0 ... choices.length) {
			y += Const.CHOICE_PADDING + choices[i].height/2;
			choices[i].setX(0);
			choices[i].setY(y);

			y += Const.CHOICE_PADDING + choices[i].height/2;
			height += Const.CHOICE_PADDING * 2 + choices[i].height;
		}

		for (c in choices) c.setY(c.y - height/2);

	}

	/**
	 * Arranges the set choices in the wheel.
	 */
	private function arrangeChoices() {
		// if we only have one choice we will put him in the center.
		if (choices.length == 1) {

			choices[0].setX(0);
			choices[0].setY(0);

		// if we have more then we arrange it around the circle.
		} else {
			
			for (c in choices) {
				var r = Math.max(c.width, c.height) / 2 + Const.CHOICE_PADDING;
				if (r > radius) radius = Math.ceil(r);
			}

			for (i in 0 ... choices.length) {
				var pos = choicePosition(Math.PI * 2 / choices.length * i, radius);

				choices[i].setX(pos.x);
				choices[i].setY(pos.y);
			}


		}

	}

	private function makeChoices(action : Data.DialogueActions) {

		var validChoices = getValidChoices(action);

		for (i in 0 ... validChoices.length) {

			// adds the text
			var text = new Choice(validChoices[i], this);
			text.setHook(function (e:hxd.Event) {
				if (onSelect != null) { 
					var choice = validChoices[i].id;
					onSelect(choice);

					// sets the dialogue option as already used, just so that it is
					// obvious to the player that they already used it.
					Game.variables.addChosenOption(choice);
				}
			});

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
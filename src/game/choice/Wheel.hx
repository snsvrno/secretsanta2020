package game.choice;

class Wheel extends h2d.Object {

	private var choices : Array<Text> = [];

	public var onSelect : Null<(choice : Data.DialogueKind) -> Void>;

	public function new(?action : Data.DialogueActions, x : Float, y : Float, parent : h2d.Object) {
		super(parent);

		// draws the wheel.
		makeBaseWheel();

		// creates the actions if defined.
		if (action != null) makeChoices(action);

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
		var newChoice = game.choice.Text.fromString(text);
		addChildAt(newChoice, children.length-1); 
		
		// sets the hook to display the response and remove the wheel.
		newChoice.setHook(function(e : hxd.Event) {
			if (onClick != null) onClick();
			Game.createDialoge(response, parent.x, parent.y, 80);
			this.destroy();
		});

		choices.push(newChoice);
		arrangeChoices();
	}

	/**
	 * Performs some action on click, no response.
	 * @param text 
	 * @param onClick 
	 * @return -> Void)
	 */
	public function addDialogueAction(text : String, onClick : () -> Void) {
		var newChoice = game.choice.Text.fromString(text); 
		addChildAt(newChoice, children.length-1); 

		// sets the hook to display the response and remove the wheel.
		newChoice.setHook(function(e : hxd.Event) {
			onClick();
			this.destroy();
		});

		choices.push(newChoice);
		arrangeChoices();
	}

	/**
	 * Creates the base graphic for the wheel.
	 */
	private function makeBaseWheel() {
		var background = new h2d.Graphics(this);
		background.lineStyle(2, 0x000000, 0.75);
		background.beginFill(0x000000, 0.75);
		background.drawCircle(0, 0, Const.CHOICE_RADIUS);
		background.endFill();
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
		} else for (i in 0 ... choices.length) {
			
			var pos = choicePosition(Math.PI * 2 / choices.length * i, Const.CHOICE_RADIUS);

			choices[i].setX(pos.x);
			choices[i].setY(pos.y);

		}
	}

	private function makeChoices(action : Data.DialogueActions) {


		var validChoices = getValidChoices(action.options);

		for (i in 0 ... validChoices.length) {

			// adds the text
			var text = new Text(validChoices[i], this);
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

		arrangeChoices();
	}

	private function getValidChoices(options : cdb.Types.ArrayRead<Data.DialogueActions_options>) : Array<Data.Dialogue> {
		var validOptions : Array<Data.Dialogue> = new Array();

		for (i in 0 ... options.length) {
			var d = options[i].option;
			
			var valid = true;
			if (d.condition != null) for (c in d.condition) {
				if (valid)
					switch(c.condition) {
						case Forwarder(condition, action): if (Conditions.check(condition)) {
								var newOptions = getValidChoices(action.options);
								for (n in newOptions) validOptions.push(n);
								valid = false;
							}
						case other: if (!Conditions.check(other)) valid = false;
					}
			}

			if (valid) validOptions.push(d);

			/*
			switch (d.condition) {
				// checks if we have a forwarder option. which means that we check a certain 
				// condition, if we meet that condition then we should actually be skipping
				// the current dialogue option and forward to something else.
				case Forwarder(condition, action):
					
					if (Conditions.check(condition)) {
						var newOptions = getValidChoices(action.options);
						for (n in newOptions) validOptions.push(n);
					} else validOptions.push(d);

				// if no condition that we just add it and don't care.
				case null: 

				// we have a condition that isn't a forwarder, so we check it.
				case other: if (Conditions.check(other)) validOptions.push(d);
			}*/
		}

		if (validOptions.length == 0) throw("asd");
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
package game.choice;

class Wheel extends h2d.Object {

	private var choices : Array<Text> = [];

	public var onSelect : Null<(choice : Data.DialogueKind) -> Void>;

	public function new(action : Data.DialogueActions, x : Float, y : Float, parent : h2d.Object) {
		super(parent);

		makeChoices(action);

		this.x = x;
		this.y = y;
	}

	private function makeChoices(action : Data.DialogueActions) {

		var radius : Float = 40;

		// draws the wheel.
		var background = new h2d.Graphics(this);
		background.lineStyle(2, 0x000000, 0.75);
		background.beginFill(0x000000, 0.75);
		background.drawCircle(0, 0, radius);
		background.endFill();

		var validChoices = getValidChoices(action.options);

		for (i in 0 ... validChoices.length) {
			// gets the position, if the length of this loop is only one then
			// we will center the choice inside the wheel. otherwise it will be
			// around the radius of the wheel.
			var pos  = if (validChoices.length == 1) { { x : 0.0, y : 0.0 }; } 
			else { choicePosition(Math.PI * 2 / validChoices.length * i, radius); };

			// adds the text
			var text = new Text(validChoices[i], this);
			text.setX(pos.x);
			text.setY(pos.y);
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

	private function getValidChoices(options : cdb.Types.ArrayRead<Data.DialogueActions_options>) : Array<Data.Dialogue> {
		var validOptions : Array<Data.Dialogue> = new Array();

		for (i in 0 ... options.length) {
			var d = options[i].option;
			
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
				case null: validOptions.push(d);

				// we have a condition that isn't a forwarder, so we check it.
				case other: if (Conditions.check(other)) validOptions.push(d);
			}
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
package game;

class Scene extends h2d.Object {

	//////////////////////////////////////////////////////////////////////////
	// public member variables

	//////////////////////////////////////////////////////////////////////////
	// private members variables

	/**
	 * Layer object that contains all the actors and interactive
	 * props that the player can interact with. Keeping them on
	 * the same visual plane.
	 */
	private var layerActors : h2d.Object;

	/**
	 * An array of active actors in this scene.
	 */
	private var actors : Array<game.Actor>;

	/**
	 * The scene data, loaded directly from the CDB file.
	 */
	private var data : Null<Data.Scenes>;

	//////////////////////////////////////////////////////////////////////////
	// initalization functions

	public function new(parent: h2d.Scene) {
		super(parent);

		// initalizes all the members.
		init();
	}

	private function init() {

		data = null;

		layerActors = new h2d.Object(this);
		actors = new Array();

	}

	//////////////////////////////////////////////////////////////////////////
	// public functions

	/**
	 * Loads the scene data from the CDB file.
	 * @param sceneName 
	 */
	public function load(sceneName : Data.ScenesKind) {

		// preforms some cleanup of the scene, removing everything that
		// is scene specific.
		clean();

		// loads the data for the scene, saves it as a member so we can access
		// it later (which we will need for dialogue access).
		data = Data.scenes.get(sceneName);

		// loads the actors
		for (actor in data.actors) {
			// creates the new actor
			var newActor = new game.Actor(actor, this);
			// adds the actor to the actor's layer
			layerActors.addChild(newActor);
			actors.push(newActor);
		}
	}

	public function startDialogue(action : Data.DialogueActions) {
		
		for (a in actors) { 
			if (a.id == action.ownerId) {

				// makes an interactive for cancelling
				var interactive = new h2d.Interactive(Const.WORLDWIDTH, Const.WORLDHEIGHT, this);

				// creates the dialogue wheel and links it so that when the player chooses
				// something it will start the dialogue conversation.
				var choices = new game.choice.Wheel(action, a.x, a.y, this);
				choices.onSelect = function(choice : Data.DialogueKind) {
					choices.destroy();
					interactive.remove();

					// gets the dialogue
					var d = Data.dialogue.get(choice);

					// starts the conversation.
					displayDialogue(d);
				};

				// sets the action to cancel the dialogue
				interactive.enableRightButton = true;
				interactive.onClick = function(e : hxd.Event) {
					if (e.button == 1) {
						choices.destroy();

						for (a in actors) { 
							a.inBackground(false);
							a.enableInteractions();
						}

						interactive.remove();
					}
				}

			} else {
				a.inBackground(true);
			}
		}
	}

	/**
	 * Displays the dialogue in the correct actor's dialogue box.
	 * @param dialogue 
	 */
	private function displayDialogue(dialogue : Data.Dialogue) {

		// makes the text bubble.
		var bubble = new game.bubble.Bubble(dialogue, this);

		// checks if we need to set something when playing this dialogue.
		if (dialogue.set != null) for (set in dialogue.set) {
			switch(set.set) {

				// we are asked to set a switch.
				case Switch(name, state): Game.variables.setSwitch(name, state);
				
				// we are asking to increment a value by some amount
				case Add(name, value): Game.variables.incrementValue(name, value);

				// we are asked to sleep the game a certain amount of time, this is moving the 
				// clock forward.
				case Sleep(duration): throw("unimplemented");
			}
		}

		// moves it to the correct position based on who is the one talking.
		if (dialogue.speakerId == player) {

			// the bubble placement for player's conversation text.
			bubble.x = Const.WORLDWIDTH/2;
			bubble.y = Const.WORLDHEIGHT - bubble.height - 10;
		
		} else for (a in actors) if (a.id == dialogue.speakerId) {
			bubble.x = a.x;
			bubble.y = a.y;
		}

		// makes an interactive that will handle the skipping and nexting.
		var tempInteractive = new h2d.Interactive(Const.WORLDWIDTH, Const.WORLDHEIGHT, this);
		tempInteractive.onClick = function(e : hxd.Event) {

			if (bubble.next() == false) {
				bubble.remove();
				tempInteractive.remove();	

				if (dialogue.chain != null) displayDialogue(dialogue.chain);
				else {
					startDialogue(dialogue.action);
				}
			}
		}
		
	}

	//////////////////////////////////////////////////////////////////////////
	// private functions

	/**
	 * Removes the actors and cleans up the scene so it can
	 * be reused.
	 */
	private function clean() {

		// removes the actors from the actor array & the actor layer.
		while (actors.length > 0) actors.pop().remove();
	}
}
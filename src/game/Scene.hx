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

	/**
	 * This is a quick fix for a bug.
	 * 
	 * When you are in a conversation the scene makes adummy interactive that is used to catch
	 * right clicks, the UI is drawn over it, so if you click on the back button it will go back
	 * to the map but the cancel interactive will still be there, preventing you from doing anything.
	 * 
	 * this will hook into the disable to make sure all these interactives are removed.
	 * 
	 * modified this to include all objects, because we have lots of loos items.
	 */
	private var looseItems : Array<h2d.Object> = [];

	public var sceneName(get, null) : String;
	private function get_sceneName() : String return data.location.name;

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
			var makeCharacter = true;

			// checks if the loading condition is valid.
			if (actor.condition != null) for (c in actor.condition) {
				if (checkCondition(c.condition) == false) makeCharacter = false;
			}

			if (makeCharacter) {

				// creates the new actor
				var newActor = new game.Actor(actor, this);

				// adds the actor to the actor's layer
				layerActors.addChild(newActor);
				actors.push(newActor);

				// tracks that we have scene them here.
				if (actor.actor.icon != null) 
					Game.variables.saw(actor.actorId, data.locationId, Game.currentPeriod());
			}
		}
	}

	public function enable() {
		alpha = 1;
		if (layerActors.parent != this) addChild(layerActors);
	}

	public function disable() {
		alpha = 0;
		removeChild(layerActors);

		// cleans up interactives
		while (looseItems.length > 0) looseItems.pop().remove();
	}

	public function startDialogue(action : Data.DialogueActions) {
		
		for (a in actors) { 
			if (a.id == action.ownerId) {

				// makes an interactive for cancelling
				var interactive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, this);
				looseItems.push(interactive);

				// creates the dialogue wheel and links it so that when the player chooses
				// something it will start the dialogue conversation.
				var choices = new game.choice.Wheel(action, a.dialogueX, a.dialogueY, this);
				looseItems.push(choices);
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
		looseItems.push(bubble);

		// checks if we need to set something when playing this dialogue.
		if (dialogue.set != null) for (set in dialogue.set) {
			switch(set.set) {

				// we are asked to set a switch.
				case Switch(name, state): 

					// checks if this is an achievement.
					try { 
						var achievement = Data.achievements.resolve(name);
						if (achievement != null && !Game.variables.checkLifetime(name)) 
							Game.earnedAchievement(achievement);
					} catch (e) { }

					Game.variables.setSwitch(name, state);
				
				// we are asking to increment a value by some amount
				case Add(name, value): 
					var oldValue = Game.variables.value(name);
					if (oldValue == 0 && name == "money") Game.foundItem(money);

					Game.variables.incrementValue(name, value);

				case SetValueToPeriod(name):
					Game.variables.setValue(name, Game.currentPeriod());
				
				case Subtract(name, value):
					Game.variables.incrementValue(name, -value);

					var newValue = Game.variables.value(name);
					if (newValue == 0 && name == "money") Game.foundItem(money);

				// we found an item!
				case Get(item):
					Game.variables.gets(item.name);

				// we found an item!
				case Lose(item):
					Game.variables.loses(item.name);

				// we are asked to sleep the game a certain amount of time, this is moving the 
				// clock forward.
				case Sleep(duration):
					
					Game.toMap();
					Game.tickClockForwardPeriods(duration);
					Game.popup(dialogue.text, 3);

					// stop the processing.
					return;
			}
		}

		// moves it to the correct position based on who is the one talking.
		if (dialogue.speakerId == player) {

			// the bubble placement for player's conversation text.
			bubble.x = Const.WORLD_WIDTH/2;
			bubble.y = Const.WORLD_HEIGHT - bubble.height - 10;
		
		} else for (a in actors) if (a.id == dialogue.speakerId) {
			bubble.x = a.dialogueX;
			bubble.y = a.dialogueY;
		}

		// makes an interactive that will handle the skipping and nexting.
		var tempInteractive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, this);
		looseItems.push(tempInteractive);
		tempInteractive.onClick = function(e : hxd.Event) {

			if (bubble.next() == false) {
				bubble.remove();
				tempInteractive.remove();	

				if (dialogue.chain != null) displayDialogue(dialogue.chain);
				else if (dialogue.branch != null) { 
					for (b in dialogue.branch) { 
						if (Conditions.check(b.condition)) {
							if (b.dialogue != null && b.action != null) throw ("error, don't know where to go.")
							else if (b.dialogue != null) displayDialogue(b.dialogue);
							else if (b.action != null) startDialogue(b.action);
							else throw("don't know what to do!");

							return;
						}
					}
				} else { //if (dialogue.action != null) {
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

	/**
	 * Checks the actor inclusion condition
	 */
	private function checkCondition(c : Data.PeriodCondition) : Bool {
		switch(c) {
			case LTE(period):
				var result = Game.currentPeriod() <= period;
				return result;
			case GTE(period): return Game.currentPeriod() >= period;
			case E(period): return Game.currentPeriod() == period;
			case Exists(name): return Game.variables.check(name);
			case NotExists(name): return !Game.variables.check(name);
			case And(c1, c2): return checkCondition(c1) && checkCondition(c2);
		}
	}
}
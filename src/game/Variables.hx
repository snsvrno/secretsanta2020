package game;

private typedef Where = { actor : Data.CharactersKind, location : Data.LocationsKind };
private typedef DialoguePair = { c : Data.CharactersKind, t : String };

private enum Mod {
	Local(name : String);
	Lifetime(name : String);
	Either(name : String);
	Number(name : String);
}

class Variables {

	////////////////////////////////////////////////////////////////////////////////////////
	// STATIC

	static public function deleteLocalData() {
		#if js

		#else
		// delete the save file that we create
		if (sys.FileSystem.exists(Const.SAVE_FILE_NAME + ".sav"))
			sys.FileSystem.deleteFile(Const.SAVE_FILE_NAME + ".sav");
		#end
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// Private Members


	/**
	 * The history of all the conversations that have taken place, stored here
	 * so that the player can review them if he chooses.
	 */
	private var conversationLog : Array<DialoguePair> = [];

	private var metCharacters : Array<Data.CharactersKind> = [];

	/**
	 * The marker switches that are set during conversation, they are mainly used 
	 * in order to track conversational choices, these are only persistent in one 'cycle'
	 */
	private var switches : Map<String, Bool> = new Map();
	/**
	 * The same as the above switches, but are presistent forever until the player removes
	 * the save file. this is suppose to allow for more complex things because you know 
	 * things that you shouldn't really know.
	 */
	private var lifetimeSwitches : Array<String> = new Array();

	/**
	 * Collected and stored items for the current cycle
	 */
	private var items : Array<Data.ItemsKind> = [];

	private var lifetimeItems : Array<Data.ItemsKind> = [];

	/**
	 * Numberical values, mainly used for things like money.
	 */
	private var values : Map<String, Int> = new Map();
	private var lifetimeValues : Map<String, Int> = new Map();

	/**
	 * All the used dialogues during the current cycle.
	 */
	private var chosenOptions : Array<Data.DialogueKind> = new Array();
	private var lifetimeChosenOptions : Array<Data.DialogueKind> = new Array();

	/**
	 * Where you think (or know) where the characters are. This is populated as you
	 * encounter characters.
	 */
	private var whereAreThey : Map<Int, Array<Where>> = new Map();

	////////////////////////////////////////////////////////////////////////////////////////
	// Public Members
	public var loaded(default, null) : Bool = false;

	public var playerName : Null<String> = null;

	// all for tracking things fro the cycle end screen.
	/** List of all the locations that have been visited. */
	public var visitedLocations : Array<String> = [ ];
	/** List of all the locations that have been visited. */
	public var itemsFound : Array<Data.ItemsKind> = [ ];

	////////////////////////////////////////////////////////////////////////////////////////
	// initalization function

	public function new() { 
		// loads this from save.
		load();
	}	

	/**
	 * Clears everything that is tracked on a per-cycle basis.
	 */
	public function cycleReset() {

		// removes some end screen cycle progress variables.
		while (visitedLocations.length > 0) visitedLocations.pop();
		while (itemsFound.length > 0) itemsFound.pop();

		// other tracking
		while(chosenOptions.length > 0) chosenOptions.pop();
		while(metCharacters.length > 0) metCharacters.pop();
		while(conversationLog.length > 0) conversationLog.pop();
		for (nv in values.keys()) values.remove(nv);
		for (s in switches.keys()) switches.remove(s);

		// removes all items found
		while(items.length > 0) items.pop();
	}
	////////////////////////////////////////////////////////////////////////////////////////
	// CONVERSATION RELATED

	public function hasMet(character : Data.CharactersKind) : Bool {
		return metCharacters.contains(character);
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// SWITCHES RELATED

	/**
	 * Returns the status of the given switch.
	 * @param name 
	 * @return Bool
	 */
	public function check(name : String) : Bool {
		switch (checkModifiers(name)) {
			case Local(name): return checkLocal(name);
			case Lifetime(name): return checkLifetime(name);
			case Either(name): return checkLifetime(name) || checkLocal(name);
			case Number(name) : throw('number isnt a valid check.');
		}
	}

	public function setSwitch(name : String, state : Bool) {
		var modname = checkModifiers(name);
		switch(modname) {
			case Local(name):
				
				checkAchievement(name);

				switches.set(name, state);
				// adds to lifetime so we can check if we've ever set this switch before ever.
				if (!checkLifetime(name)) lifetimeSwitches.push(name);

			case _:

				throw('attempting to set the switch $name non locally, this can\'t happen');
		}

		save();
	}

	public function earnedAchievement(a : Data.Achievements) : Bool {
		if (a.triggers != null) {
			var valid = true;
			for (t in a.triggers) switch(t.trigger) {
				case Exists(name):
					if (!checkLifetime(name)) valid = false;
			}

			return valid;
		}
		return false;
	}

	private function checkAchievement(originatingName : String) {

		// first need to check if we already got this achievement before.
		if (checkLifetime(originatingName)) return;

		for (a in Data.achievements.all) if (a.enabled && a.triggers != null) {
			var valid = true;
			var hasThisName = false;
			for (t in a.triggers) switch(t.trigger) {
				case Exists(name):
					if (originatingName == name) hasThisName = true;
					else if (!checkLifetime(name)) valid = false;
			}

			if (hasThisName) {
				if (valid) Game.earnedAchievement(a);
				return;
			}
		}
	}
	
	private function checkLocal(name : String) : Bool {
		switch(switches.get(name)) {
			case null: return false;
			case bool: return bool;
		}
	}
	public function checkLifetime(name : String) : Bool return lifetimeSwitches.contains(name);

	public function value(name : String) : Int {
		if (name.substr(0,1) == "*") {
			switch(lifetimeValues.get(name.substr(1))) {
				case null: return 0;
				case n: return n;
			}
		} else {
			switch(values.get(name)) {
				case null: return 0;
				case n: return n;
			}
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// NAME RELATED
	
	public function evalulate(name : String) : Null<String>  {

		if (name == "player") return playerName;

		// we are assuming we want to know a certain characters name...
		for (c in Data.characters.all) {
			if (c.id.toString() == name) return c.name;
		}

		return 'name "$name" not a valid name';
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// NUMBER VARIABLE RELATED

	public function setValue(name : String, value : Int) { 
		if (name.substr(0,1) == "*") lifetimeValues.set(name.substr(1), value);
		else values.set(name, value);
		save();
	}

	public function getValue(name : String) : Int { 
		if (name.substr(0,1) == "*") return getLifeValue(name.substr(1));
		if (values.exists(name)) return values.get(name);
		else return 0;
	}

	public function getValues() : Iterator<String> return values.keys(); 

	public function incrementValue(name : String, value : Int) {

		if (name.substr(0,1) == "*") incrementLifeValue(name.substr(1), value);
		else {
			var currentValue = values.get(name);
			switch(currentValue) {
				case null: values.set(name, sn.Maths.clamp(value, 0, null));
				case n: values.set(name, sn.Maths.clamp(n + value, 0, null));
			}
		}
		save();
	}

	public function getLifeValue(name : String) : Int {
		if (lifetimeValues.exists(name)) return lifetimeValues.get(name);
		else return 0;
	}

	public function incrementLifeValue(name : String, value : Int) {
		var currentValue = lifetimeValues.get(name);
		switch(currentValue) {
			case null: lifetimeValues.set(name, sn.Maths.clamp(value, 0, null));
			case n: lifetimeValues.set(name, sn.Maths.clamp(n + value, 0, null));
		}
		save();
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// DIALOGE CHOICE RELATED

	/**
	 * Checks if the given chosen ID was every used.
	 * @param id 
	 * @return Bool
	 */
	public function isChosenOption(id : Data.DialogueKind) : Bool return chosenOptions.contains(id);
	/**
	 * Adds the chosen option to the list of already chosen options.
	 * @param id 
	 */
	public function addChosenOption(id : Data.DialogueKind) { 
		if (!isChosenOption(id)) chosenOptions.push(id);
		if (!lifetimeChosenOptions.contains(id)) lifetimeChosenOptions.push(id);
		save();
	}

	public function isLiftimeChosenOption(id : Data.DialogueKind) : Bool return lifetimeChosenOptions.contains(id);

	////////////////////////////////////////////////////////////////////////////////////////
	// ITEM RELATED

	public function gets(item : Data.ItemsKind, ?silent : Bool = false) {
		if (!items.contains(item)) { 
			items.push(item);
			if (silent == false) Game.foundItem(item);
		}

		if (!lifetimeItems.contains(item)) lifetimeItems.push(item);
	}

	public function loses(item : Data.ItemsKind) : Bool {
		if (items.remove(item)) {
			Game.lostItem(item);
			return true;
		} 
		return false;
	}

	public function has(item : Data.ItemsKind) : Bool return items.contains(item);

	public function hasLifetime(item : Data.ItemsKind) : Bool return lifetimeItems.contains(item);


	////////////////////////////////////////////////////////////////////////////////////////
	// WHO IS WHERE RELATED

	public function saw(actor : Data.CharactersKind, location : Data.LocationsKind, period : Int) {
		var sightings : Array<Where> = switch(whereAreThey.get(period)) {
			case null: new Array();
			case array: array;
		};

		var alreadySeen = false;
		for (entry in sightings) {
			if (entry.actor == actor && entry.location == location) alreadySeen = true;
		}

		if (!alreadySeen) {
			sightings.push({ actor : actor, location : location });
		}

		whereAreThey.set(period, sightings);
		save();
	}

	/**
	 * Checks if a player has seen a character at a specific location and looks at the 
	 * scenes and sees if that character is actually at that lopcation. Will only return 
	 * a character at a location if the player has seen them there and the character is
	 * actually in the location.
	 * @param location 
	 * @param period 
	 * @return Array<Data.CharactersKind>
	 */
	public function seen(location : Data.LocationsKind, period : Int) : Array<Data.CharactersKind> {
		var array : Array<Data.CharactersKind> = [];

		var sightings = whereAreThey.get(period);
		if (sightings != null) for (s in sightings) {
			if (s.location == location) {
				var locationData = Data.locations.get(location);
				for (locActor in locationData.scene.actors) {
					if (locActor.actorId == s.actor) {
						var isThere = true;
	
						for (condition in locActor.condition)
							if (!checkSeenScene(condition.condition, period)) isThere = false;
			
						if (isThere) array.push(s.actor);
					}
				}
			}
		}

		return array;
	}

	private function checkSeenScene(condition : Data.PeriodCondition, period : Int) : Bool {
		switch(condition) {
			case LTE(p): return period <= p;
			case GTE(p): return period >= p;
			case E(p): return period == p;
			case Exists(name): return check(name);
			case NotExists(name): return !check(name);
			case And(c1, c2): return checkSeenScene(c1, period) && checkSeenScene(c2, period);
		}

	}

	////////////////////////////////////////////////////////////////////////////////////////
	// SYSTEM TOOLS, LOADING, SAVING, ETC...

	/**
	 * Attempts to load all applicable aspects of the variables class
	 */
	private function load() {
		//#if js

		//#else
		var ll = hxd.Save.load(null, Const.SAVE_FILE_NAME, true);
		if (ll != null) {
			loaded = true;

			if (ll.values != null) lifetimeValues = ll.values;
			if (ll.lifetime != null) lifetimeSwitches = ll.lifetime;
			if (ll.where != null) whereAreThey = ll.where;
			if (ll.chosen != null) lifetimeChosenOptions = ll.chosen;
			if (ll.items != null) lifetimeItems = ll.items;
			if (ll.playername != null) playerName = ll.playername;
		}
		//#end
	}

	public function save() {
		//#if js


		//#else
		hxd.Save.save({
			lifetime : lifetimeSwitches,
			where : whereAreThey,
			values : lifetimeValues,
			chosen : lifetimeChosenOptions,
			items : lifetimeItems,
			playername : playerName,
		}, Const.SAVE_FILE_NAME, true);
		//#end
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE SHARED FUNCTONS

	/**
	 * Checks for any modifiers on the name that we got, to see if maybe
	 * we want lifetime vs local, etc..
	 * @param name 
	 * @return Mod
	 */
	private function checkModifiers(name : String) : Mod {
		switch(name.substr(0,1)) {
			case "*": return Lifetime(name.substr(1));
			case "+": return Either(name.substr(1));
			case "#": return Number(name.substr(1));
			case _: return Local(name);
		}
	}

}
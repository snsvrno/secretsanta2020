package game;

private enum Mod {
	Local(name : String);
	Lifetime(name : String);
	Either(name : String);
	Number(name : String);
}

class Variables {

	////////////////////////////////////////////////////////////////////////////////////////
	// STATIC

	////////////////////////////////////////////////////////////////////////////////////////
	// Private Members

	/**
	 * The history of all the conversations that have taken place, stored here
	 * so that the player can review them if he chooses.
	 */
	private var conversationLog : Array<String> = [];

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

	/**
	 * Numberical values, mainly used for things like money.
	 */
	private var values : Map<String, Int> = new Map();

	/**
	 * All the used dialogues during the current cycle.
	 */
	private var chosenOptions : Array<Data.DialogueKind> = new Array();



	////////////////////////////////////////////////////////////////////////////////////////
	// initalization function

	public function new() { 
		// loads this from save.
		load();
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

				switches.set(name, state);
				// adds to lifetime so we can check if we've ever set this switch before ever.
				if (!checkLifetime(name)) lifetimeSwitches.push(name);

			case _:

				throw('attempting to set the switch $name non locally, this can\'t happen');
		}

		save();
	}
	
	private function checkLocal(name : String) : Bool {
		switch(switches.get(name)) {
			case null: return false;
			case bool: return bool;
		}
	}
	private function checkLifetime(name : String) : Bool return lifetimeSwitches.contains(name);

	public function value(name : String) : Int {
		switch(values.get(name)) {
			case null: return 0;
			case n: return n;
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// NAME RELATED
	
	public function evalulate(name : String) : Null<String>  {
		// we are assuming we want to know a certain characters name...
		for (c in Data.characters.all) {
			if (c.id.toString() == name) return c.name;
		}

		return 'name "$name" not a valid name';
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// NUMBER VARIABLE RELATED

	public function setValue(name : String, value : Int) { 
		values.set(name, value);
		save();
	}

	public function getValue(name : String) : Int { 
		if (values.exists(name)) return values.get(name);
		else return 0;
	}

	public function incrementValue(name : String, value : Int) {
		var currentValue = values.get(name);
		switch(currentValue) {
			case null: values.set(name, sn.Math.clamp(value, 0, null));
			case n: values.set(name, sn.Math.clamp(n + value, 0, null));
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
		save();
	}

	////////////////////////////////////////////////////////////////////////////////////////
	// ITEM RELATED

	public function gets(item : Data.ItemsKind) {
		if (!items.contains(item)) { 
			items.push(item);
			Game.foundItem(item);
		}
	}

	public function has(item : Data.ItemsKind) : Bool return items.contains(item);

	////////////////////////////////////////////////////////////////////////////////////////
	// SYSTEM TOOLS, LOADING, SAVING, ETC...

	/**
	 * Attempts to load all applicable aspects of the variables class
	 */
	private function load() {
		var ll = hxd.Save.load(null);
		if (ll != null) {
			lifetimeSwitches = ll.lifetime; 
		}
	}

	private function save() {
		hxd.Save.save({
			lifetime : lifetimeSwitches
		});
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
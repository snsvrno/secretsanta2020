
class Game extends hxd.App {

	//////////////////////////////////////////////////////////////////////////
	// static variables

	static public var variables : game.Variables;
	static private var instance : Game;
	static public var is2d(get, null) : h2d.Scene;
	static private function get_is2d() : h2d.Scene return instance.s2d;

	//////////////////////////////////////////////////////////////////////////
	// static functions
	
	static public function changeScene(newScene : Data.ScenesKind) instance.changeToScene(newScene);
	static public function toMap() instance.changeToMap();
	static public function updateMapLighting() instance.updateAfterTick();
	static public function currentPeriod() : Int return instance.clock.period;
	static public function earnedAchievement(achievement : Data.Achievements) game.Popup.achievement(achievement, instance.s2d);
	static public function popup(text : String, ?duration : Float) game.Popup.text(text, duration, instance.s2d);
	static public function tickClockForward(slots : Int) instance.tickClock(slots); 
	static public function tickClockForwardPeriods(periods : Int) instance.tickClockPeriods(periods); 
	static public function currentScene() : String return instance.activeScene.sceneName;
	static public function nextPeriod() instance.onNextPeriod();

	static public function addSlot() {
		if (instance.clock.donePeriod) {
			instance.clock.stepBack();
			updateMapLighting();
		} else {
			// if the period hasn't been declared finished, then we
			// just bank it.
			instance.clock.addSlot(1);
		}
		popup("You feel invigorated");
	}

	static public function foundItem(item : Data.ItemsKind) { 
		game.Popup.item(item, true, instance.s2d);
	}

	static public function lostItem(item : Data.ItemsKind) { 
		game.Popup.item(item, false, instance.s2d);
	}

	static public function restartCycle(?carryOverItems : Array<Data.ItemsKind>) {
		
		Game.variables.save();

		// for the true_ending achievement
		var preloadBottle = false;
		if (Game.variables.check("thrownbottleinsea")) preloadBottle = true;
		
		// if this is true that means this is the very super first time, so we don't have
		// to do any of the standard stuff and instead show the tutorial / setup screen
		if (Game.variables.playerName == null) {

			Game.instance.add(new game.ui.screens.Help(Game.is2d, true));
			return;
		}

		// clear the popup queue
		game.Popup.clearQueue();
		
		while(instance.visits.length > 0) instance.visits.pop();

		variables.cycleReset();

		// silenty adds items if we kept them
		if (carryOverItems != null) for (i in carryOverItems) {
			variables.gets(i, true);	
		}

		// adds the money item
		variables.gets(money, true);

		// updates the time.
		instance.clock.restart();
		instance.updateAfterTick();

		// sets up the beginning.
		instance.changeToScene(towncenter);
		popup("You wake up on a bus, it is bright outside ~...~", 4);

		// sets any preload stuff
		if (preloadBottle) Game.variables.setSwitch("beach_floatingbottle", true);
	}

	static public function quit() {
		variables.save();
		hxd.System.exit();
	}

	/**
	 * Clears the save data and reloads it. Also resets the game back to the original cycle.
	 */
	static public function clearData() {
		game.Variables.deleteLocalData();
		variables = new game.Variables();

		instance.clock.restart();
		instance.updateAfterTick();
	}

	static public function createDialoge(text : String, x : Float, y : Float, ?wrap : Float) {
		var bubble = game.dialogue.Bubble.manual(text, x, y, wrap);
		instance.s2d.addChild(bubble);
	}

	//////////////////////////////////////////////////////////////////////////
	// member variables

	/**
	 * The object that contains all the actors and props
	 * for the current interactive scene. There might not be
	 * anything loaded though. The scene is like one of the
	 * "locations" on the map. The map isn't a scene.
	 */
	private var activeScene : game.Scene;

	/**
	 * The map
	 */
	private var map : game.map.Map;

	private var ui : game.ui.Interface;

	private var clock : game.Clock;

	private var visits : Array<String> = [];

	/**
	 * tracker for the first time you leave a location, so it doesn't count the
	 * towncenter as a travel the first time.
	 */
	private var firstVisit : Bool = true;

	override function init() {

		//////////////////////////////////////////////////////////////////////////
		// some presetup.

		Game.instance = this;

		// setup the resources
		sn.Window.initResources();
		Const.initalize();

		// initalizes the variables and loads saved status if applicable.
		Game.variables = new game.Variables();

		// setting some window options
		var window = hxd.Window.getInstance();
		// makes the window title.
		window.title = sn.Window.generateTitle(Const.GAMETITLE);
		// adds events, for keyboard presses
		window.addEventTarget(onEvent);

		// set the background color
		engine.backgroundColor = Const.BACKGROUND_COLOR;

		//////////////////////////////////////////////////////////////////////////
		// loads the components

		// creates the 'background' of the game
		var background = new h2d.Graphics(s2d);
		background.beginFill(Const.WORLD_BACKGROUND_COLOR);
		background.drawRect(0, 0, Const.WORLD_WIDTH, Const.WORLD_HEIGHT);
		background.endFill();

		map = new game.map.Map(s2d);

		// creates the clock object.
		clock = new game.Clock();
		map.addChild(clock);

		// creates the scene object, which contains all the actors.
		// and props
		activeScene = new game.Scene(s2d);
		activeScene.load(blank); // bug that this will not compile unless there is a load, not sure why...

		// add the interface UI
		ui = new game.ui.Interface(s2d);

		#if debug
		Debug.initalize(s2d);
		#end

		// creates the corner border thing.
		game.utils.Corners.make(s2d);

		//////////////////////////////////////////////////////////////////////////
		// setup the position of the scene so its centered
		onResize();

		// we start at the bus.
		updateAfterTick();

		// kind of a hack, setting up the start, but then resetting the popup.
		// the popup will then be redone whenever the splash finishes.
		// restartCycle();
		game.Popup.clearQueue();

		// starts the new game splash, which is the titlecard.
		var splash = new game.ui.Splash(s2d);
		splash.onFadeStart = () -> restartCycle();
	}

	/**
	 * Ensures the corners are always ontop.
	 * @param object 
	 */
	public function add(object : h2d.Object) {
		// not the best way to do it, but i need something that works right now,
		// not trying to do this the right way.

		var corners : Null<h2d.Object> = s2d.getObjectByName("corners");

		if (corners != null) s2d.removeChild(corners);
		s2d.addChild(object);
		if (corners != null) s2d.addChild(corners);
	}

	override function update(dt:Float) {
		super.update(dt);
		sn.Timer.update(dt);
	}

	override function onResize() {
		super.onResize();

		var window = hxd.Window.getInstance();

		//////////////////////////////////////////////////////////////////////////
		// calculating the s2d scene resize stuff.
		// gets the resize value, and adds padding on the edges.
		var scale = Math.min((window.width - 2 * Const.WORLD_SCREEN_PADDING) / Const.WORLD_WIDTH, (window.height - 2 * Const.WORLD_SCREEN_PADDING) / Const.WORLD_HEIGHT);
		s2d.setScale(scale);
		// offsets the scene so its in the center.
		s2d.x = window.width/2 - Const.WORLD_WIDTH/2 * scale;
		s2d.y = window.height/2 - Const.WORLD_HEIGHT/2 * scale;
	}

	private function onEvent(e : hxd.Event) {
		#if debug
		Debug.onEvent(e);
		#end
	}

	private function changeToScene(newScene : Data.ScenesKind) {

		var sceneName = Data.scenes.get(newScene).location.name;

		if (clock.donePeriod && !visits.contains(sceneName)) {
			game.Popup.text("I can't do anything else now, I'll have to wait ~...~", s2d);
			return;
		}

		// sets up the scene
		activeScene.load(newScene);
		activeScene.enable();

		// disables the background
		// map.disable();

		//ui.setLocationName(activeScene.sceneName);
		ui.onScene(activeScene.sceneName);
	}

	private function changeToMap() {
		ui.onMap();
		// map.enable();
		activeScene.disable();

		if (!firstVisit && !Game.variables.visitedLocations.contains(activeScene.sceneName)) 
			Game.variables.visitedLocations.push(activeScene.sceneName);

		if (!firstVisit && !visits.contains(activeScene.sceneName)) {
			visits.push(activeScene.sceneName);

			clock.step();

			// disables the rest of the locations on the map (visually) so
			// we get the idea that we can't go anywhere else.
			if (clock.donePeriod) map.disableInaccessableLocations(visits);

			updateAfterTick();
		}
		if (firstVisit) firstVisit = false;
	}

	/**
	 * Function to push the clock forward 1 slot.
	 */
	private function tickClock(?distance : Int = 1) {
		if (distance > 0) while (distance > 0) { clock.increment(); distance--; }
		else while(distance < 0) { clock.increment(-1); distance++; }
		updateAfterTick();
	}

	private function tickClockPeriods(periods) {
		while (periods > 0 && !clock.completeRevolution) {
			clock.nextPeriod();
			periods--;
		}

	// 	updateAfterTick();
	}

	private function onNextPeriod() {
		updateMapLighting();
		while(visits.length > 0) visits.pop();
	}

	private function onCycleEnd() {
		// resetting this switch so the first leaving done a cycle
		// (when you leave the town center) doesn't cost you.

		firstVisit = true;
		ui.setState(End);

		Game.variables.incrementLifeValue(Const.PROGRESS_CYCLES, 1);
	}

	private function updateAfterTick() {
		if (clock.completeRevolution) {
			onCycleEnd();
		} else {
			if(!clock.donePeriod) map.resetAllInaccessableLocations();
			map.setLighting(clock);
			map.updateLocationIcons();
		}
	}
}
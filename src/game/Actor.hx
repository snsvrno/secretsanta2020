package game;

import shader.Darken;
import shader.Highlight;

class Actor extends h2d.Object {

	/**
	 * The unique id for the character, from the CDB. This isn't unique to
	 * this instance, but unique to the definition of the character / actor
	 */
	public final id : Data.CharactersKind;

	/**
	 * The image of the actor.
	 */
	private final image : h2d.Bitmap;

	/**
	 * The mouseover interactive layer. Multiple interactives are here
	 * in order to allow for more complex shapes if needed.
	 */
	private final interactives : h2d.Object;

	/**
	 * The mouse over shader that is applied to this object.
	 */
	private var shaderOver : shader.Highlight;
	private var shaderBackground : shader.Darken;

	private final action : Data.DialogueActions;

	private final scene : game.Scene;

	public var dialogueX(get, null) : Float;
	private final dialoguex : Int;
	private function get_dialogueX() : Float {
		return x + dialoguex - image.tile.width/2;
	}

	public var dialogueY(get, null) : Float;
	private final dialoguey : Int;
	private function get_dialogueY() : Float {
		return y + dialoguey - image.tile.height/2;
	}

	/**
	 * Creates a new actor. It will not automatically be rendered because it
	 * will need to manually be added to the correct layer in the scene. By default
	 * it doesn't add itself as a child to anything. Do this using the respective
	 * `addChild(newActor)` function for the object you want to add this to.
	 * 
	 * @param definition the CDB definition for that actor
	 * @param parent the scene where that actor takes place in.
	 */
	public function new(definition : Data.Scenes_actors, scene : game.Scene) {
		super();
		// setup the connection between this character and the scene
		// that they occupy. it will be needed for callbacks.
		this.scene = scene;

		// sets the database unique id.
		id = definition.actorId;

		// sets the starting choice action when interactive with this character
		action = definition.action;

		// creates the image.
		var t = hxd.Res.load(definition.actor.image).toTile();
		image = new h2d.Bitmap(t, this);
		image.x = -t.width/2;
		image.y = -t.height/2;

		dialoguex = definition.actor.dialoguepoint.x;
		dialoguey = definition.actor.dialoguepoint.y;

		#if debug
		if (Debug.displays.get(Debug.DISPLAYS_DIALOGUE_POINT) == true) {
			var dialoguepoint = new h2d.Graphics(this);
			dialoguepoint.x = dialogueX;
			dialoguepoint.y = dialogueY;
			dialoguepoint.beginFill(0xFF00FF, 0.75);
			dialoguepoint.drawCircle(0,0, 10);
			dialoguepoint.endFill();
		}
		#end

		// creating an interactive that will be used for inital interaction.
		interactives = new h2d.Object(image);
		if (action != null) makeInteractives(definition.actor);

		// the mouseover shader, so we know when we are selecting something.
		shaderOver = new shader.Highlight(0.25);
		shaderBackground = new shader.Darken(0.75);

		// set up the world position of this actor.
		this.x = definition.x * Const.WORLD_WIDTH;
		this.y = definition.y * Const.WORLD_HEIGHT;
		this.setScale(definition.scale);
		if (definition.flipX) this.scaleX *= -1;
	}

	/**
	 * Makes complex shapes by using multiple interactive boxes. Uses the 
	 * definition in the CBD. If nothing is given then it will just use the
	 * image size.
	 * @param actor 
	 */
	private function makeInteractives(actor : Data.Characters) {

		// if we don't define one, the we just make one that is the same
		// size as the image.
		if (actor.interactives == null) {
			var inter = new h2d.Interactive(image.tile.width, image.tile.height, image);
			inter.cursor = hxd.Cursor.Button;
			interactives.addChild(inter);

			inter.onOver = mouseover;
			inter.onOut = mouseout;
			inter.onClick = mouseclick;

			#if debug
			// if we are in debug build, then it will draw the interactives as a graphic, so
			// we can see the coverage.
			if (Debug.displays.get(Debug.DISPLAYS_CHARACTER_INTERACTIVES) == true) {
				var interactiveBox = new h2d.Graphics(image);
				interactiveBox.beginFill(0xFF0000, 0.25);
				interactiveBox.drawRect(0, 0, image.tile.width, image.tile.height);
				interactiveBox.endFill();
			}
			#end

		// if we have an interactives defined, then we will use that stuff..
		// instead of the image size.
		} else {
			
			// for each interactive box definition we will make a new
			// interactive and set it up.
			for (i in actor.interactives) {
				var inter = new h2d.Interactive(i.box.w, i.box.h, image);
				inter.x = i.box.x;
				inter.y = i.box.y;
				inter.cursor = hxd.Cursor.Button;
				interactives.addChild(inter);
	
				inter.onOver = mouseover;
				inter.onOut = mouseout;
				inter.onClick = mouseclick;

				#if debug
				// if we are in debug build, then it will draw the interactives as a graphic, so
				// we can see the coverage.
				if (Debug.displays.get(Debug.DISPLAYS_CHARACTER_INTERACTIVES) == true) {
					var interactiveBox = new h2d.Graphics(image);
					interactiveBox.beginFill(0xFF0000, 0.25);
					interactiveBox.drawRect(i.box.x, i.box.y, i.box.w, i.box.h);
					interactiveBox.endFill();
				}
				#end
			}

		}
	}

	private function mouseover(e : hxd.Event) {
		var wheel = new game.dialogue.Wheel(action, 0, 0, this);
		if (wheel.length > 0) image.addShader(shaderOver);
		wheel.destroy();
	}

	private function mouseout(e : hxd.Event) {
		image.removeShader(shaderOver);
	}

	private function mouseclick(e : hxd.Event) {
		disableInteractions();
		scene.startDialogue(action);
	}

	/**
	 * Will remove the interactives from the actor so that
	 * the player can no longer interact with it.
	 */
	public function disableInteractions() {
		image.removeShader(shaderOver);
		interactives.remove();
	}

	/**
	 * Adds the interactives back to the player so now the
	 * character can be interacted with.
	 */
	 public function enableInteractions() {

		// first we check if the interactive is already added, we don't
		// want to add it twice for any reason.
		for (c in children) if (c == interactives) return;

		// adds the interactive
		addChild(interactives);
		// idk why, but i need to offset this ... but ok it works.
		interactives.x = -image.tile.width/2;
		interactives.y = -image.tile.height/2;
	}

	public function inBackground(status : Bool) {
		if (status) { 
			if (image.getShader(shader.Darken) == null) image.addShader(shaderBackground);
		}
		else image.removeShader(shaderBackground);
	}
}
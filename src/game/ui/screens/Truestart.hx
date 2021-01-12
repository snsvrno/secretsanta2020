package game.ui.screens;


/**
 * The screen that shows up the first time you ever play the game.
 */
class Truestart extends h2d.Object {

	private var  textEditEvent : (e : hxd.Event) -> Void;

	public function new(?parent : h2d.Object) {
		super(parent);

		var background = new h2d.Graphics(this);
		background.beginFill(0x000000, 0.85);
		background.drawRect(0,0,Const.WORLD_WIDTH, Const.WORLD_HEIGHT);
		background.endFill();
		
		// blocks all interactions to the world below.
		var dummyinteractive = new h2d.Interactive(Const.WORLD_WIDTH, Const.WORLD_HEIGHT, this);
		dummyinteractive.cursor = hxd.Cursor.Default;

		////////////////////////////////////////////////////////
		// the name text entry stuff
		var textEntryShadow = new game.ui.Text("<click to change name>", null, this);
		textEntryShadow.setColor(0x333333);
		var toline = new game.ui.HStack(this);
		textEntryShadow.x = toline.x = 25;
		textEntryShadow.y = toline.y = 25;
		var textEntry = new game.ui.Text(textEntryShadow.text);
		var comma = new game.ui.Text(",");
		toline.pushAll([textEntry, comma]);

		var editText = new h2d.Interactive(0,0, textEntry);

		var updateEditText = function() {
			editText.width = textEntry.getWidth();
			editText.height = textEntry.getHeight();
		};

		textEditEvent = function(e : hxd.Event) {
			if (e.kind == EKeyDown) { 
				switch(e.keyCode) {

					case hxd.Key.BACKSPACE: 
						textEntry.setText(textEntry.text.substr(0,textEntry.text.length-1));

					case hxd.Key.ENTER:
						var window = hxd.Window.getInstance();
						window.removeEventTarget(textEditEvent);
						textEntry.setText(textEntry.text.substr(0,1) + textEntry.text.substr(1).toLowerCase());
						textEntryShadow.setText(textEntry.text);
						toline.alignChildren();

					case letter:
						if (letter >= 65 && letter <= 90)
							textEntry.setText(textEntry.text + String.fromCharCode(letter));
				}
				updateEditText();
			}
		};

		editText.onClick = function(e : hxd.Event) {
			textEntry.setText("");

			var window = hxd.Window.getInstance();
			window.addEventTarget(textEditEvent);
		};

		updateEditText();
		////////////////////////////////////////////////////////
		
		
		////////////////////////////////////////////////////////
		// the description text.
		var text = new game.ui.Text("Welcome to our town. Please take your time and explore what we have to offer. Check out our sites and talk to our locals.", null, this);
		text.setWrapWidth(Const.WORLD_WIDTH - 40);
		text.x = textEntryShadow.x;
		text.y = 100;

		var beginbutton = new game.ui.Button("Lets Go!", null, this);
		beginbutton.x = Const.WORLD_WIDTH - 20;
		beginbutton.y = Const.WORLD_HEIGHT - 20;
		beginbutton.setAlignment(Right, Bottom);
		beginbutton.onClick = function() {
			Game.variables.playerName = textEntry.text;
			Game.variables.save();
			remove();
			Game.restartCycle();
		};

	}

	override function onRemove() {
		super.onRemove();

		var window = hxd.Window.getInstance();
		window.removeEventTarget(textEditEvent);
	}

}
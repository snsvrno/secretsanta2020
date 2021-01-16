package game.ui.screens;


/**
 * The screen that shows up the first time you ever play the game.
 */
class Truestart extends h2d.Object {

	private var  textEditEvent : (e : hxd.Event) -> Void;
	public var onRemoveChain : Null<() -> Void>;

	public function new(?parent : h2d.Object, ?firstTime : Bool = true) {
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
		var textEntryShadow = new game.ui.Text("Player", null, this);
		if (firstTime == false) textEntryShadow.setText('${Game.variables.playerName}');
		textEntryShadow.setColor(0x333333);
		var toline = new game.ui.HStack(this);
		textEntryShadow.x = toline.x = 25;
		textEntryShadow.y = toline.y = 25;
		var textEntry = new game.ui.Button(textEntryShadow.text);
		textEntry.overScale = textEntry.normalScale;
		var edit = new game.ui.Text(String.fromCharCode(0xf044), Const.ICON_FONT);
		edit.setColor(textEntry.normalColor);
		edit.setScale(0.33);
		var comma = new game.ui.Text(",");
		toline.pushAll([textEntry, edit, comma]);

		textEditEvent = function(e : hxd.Event) {
			if (e.kind == EKeyDown) { 
				switch(e.keyCode) {

					case hxd.Key.BACKSPACE: 
						textEntry.setText(textEntry.text.substr(0,textEntry.text.length-1));

					case hxd.Key.ENTER:

						// set the text
						var window = hxd.Window.getInstance();
						window.removeEventTarget(textEditEvent);
						textEntry.setText(textEntry.text.substr(0,1) + textEntry.text.substr(1).toLowerCase());
						textEntryShadow.setText(textEntry.text);
						toline.alignChildren();

						edit.alpha = 1;
						comma.alpha = 1;

					case letter:
						if (letter >= 65 && letter <= 90)
							textEntry.setText(textEntry.text + String.fromCharCode(letter));
				}
			}
		};

		textEntry.onClick = function() {
			textEntry.setText("");
			comma.alpha = 0;
			edit.alpha = 0;

			var window = hxd.Window.getInstance();
			window.addEventTarget(textEditEvent);
		};

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
			if (firstTime) Game.restartCycle();
		};

	}

	override function onRemove() {
		super.onRemove();

		if (onRemoveChain != null) onRemoveChain();

		var window = hxd.Window.getInstance();
		window.removeEventTarget(textEditEvent);
	}

}
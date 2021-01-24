package game.ui.screens;

import h3d.mat.TextureChannels;
import h2d.Interactive;

class Help extends game.Scene {

	private var  textEditEvent : (e : hxd.Event) -> Void;
	public var onRemoveChain : Null<() -> Void>;

	private var padding = 20;

	public function new(parent : h2d.Scene, ?firstTime : Bool = false) {
		super(parent);

		load(tutorialpage);
		enable();

		var dialoguepadding = 10;
		var starty = 20;

		/// TEXT INTERACTIVE STUFF ///////////////////////////////////////////
		
		var pretext = new game.ui.Text("Your name: ");
		var textEntryShadow = new game.ui.Text("Player", null, this);
		if (firstTime == false) textEntryShadow.setText('${Game.variables.playerName}');
		textEntryShadow.setColor(0x333333);
		var toline = new game.ui.HStack(this);
		textEntryShadow.x = toline.x = padding;
		textEntryShadow.x += pretext.getWidth();
		textEntryShadow.y = toline.y = Const.WORLD_HEIGHT - padding - textEntryShadow.getHeight();
		var textEntry = new game.ui.Button(textEntryShadow.text);
		textEntry.overScale = textEntry.normalScale;
		var edit = new game.ui.Text(String.fromCharCode(0xf044), Const.ICON_FONT);
		edit.setColor(textEntry.normalColor);
		edit.setScale(0.33);
		toline.pushAll([pretext, textEntry, edit]);

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
						pretext.alpha = 1;

					case letter:
						if (letter >= 65 && letter <= 90)
							textEntry.setText(textEntry.text + String.fromCharCode(letter));
				}
			}
		};

		textEntry.onClick = function() {
			textEntry.setText("");
			pretext.alpha = 0.25;
			edit.alpha = 0;

			var window = hxd.Window.getInstance();
			window.addEventTarget(textEditEvent);
		};

		/// FIRST BIT ////////////////////////////////////

		var textcontent = '*${Const.GAMETITLE}* is a narrative exploration game; talk to characters and help them.';
		var text1x = padding;
		var text1y = starty;
		var text1width = Const.WORLD_WIDTH - 2 * padding;
		var text1height = 0.;
		var text1 = game.dialogue.Text.parse(textcontent, Const.MENU_FONT_SMALL, null, text1width);
		for (t in text1) {
			t.x += text1x + text1width / 2;
			t.y += text1y + t.height / 2;
			addChild(t);
			
			if (t.y + t.height/2 > text1height) text1height = t.y + t.height/2;
		}
		text1height -= text1y;
		/*
		var textcontent = "This game is a narrative exploration game; talk to characters and help them.";
		var text1 = new game.ui.Text(textcontent, Const.MENU_FONT_SMALL, this);
		text1.setWrapWidth(Const.WORLD_WIDTH - 2 * padding);
		text1.x = padding;
		text1.y = starty;*/

		
		/// SECOND BIT, PART 1 ////////////////////////////////////
		//var pagescene = Data.scenes.get(tutorialpage);
		//var character = new game.Actor(pagescene.actors[0], this);
		//addChild(character);



		/// SECOND BIT ////////////////////////////////////
		// there is a lot of fudging to get things placed right .. very hacky
		// so any change will probably break everything.
		
		var dialoguebg = new h2d.Graphics();
		dialoguebg.y = text1y + padding + text1height;
		dialoguebg.x = text1x;

		var dialogue = game.dialogue.Choice.fromString("A Quest Line Option", tutorial);
		dialogue.setX(dialoguebg.x + dialoguepadding + dialogue.width / 2);
		dialogue.setY(dialoguebg.y + dialoguepadding + dialogue.height / 2);

		var dialogue2 = game.dialogue.Choice.fromString("A Standard Option");
		dialogue2.setX(dialogue.x + dialogue.width / 2);
		dialogue2.setY(dialogue.y + 40 + dialoguepadding / 2);
		
		var dialoguewidth = Math.max(dialogue.width, dialogue2.width) + 2 * Const.CHOICE_TEXT_PADDING + dialoguepadding;
		var dialogueheight = dialogue2.height + dialogue.height + 3 * dialoguepadding + 16;
		dialoguebg.beginFill(0xAAAAAA);
		dialoguebg.drawRoundedRect(0,0, 
			dialoguewidth,
			dialogueheight,
			4
		);

		var textcontent2 = "Click on *characters* and start conversations. Some dialogue options are *colored*, meaning they are part of a greater story. Others aren't and are there to better understand the characters";
		var text2x = dialoguebg.x + dialoguewidth + dialoguepadding;
		var text2y = text1y + text1height + padding;
		var text2width = Math.ceil(Const.WORLD_WIDTH - padding - text2x);
		var text2height = 0.;
		var text2 = game.dialogue.Text.parse(textcontent2, Const.MENU_FONT_SMALL, null, text2width);
		for (t in text2) {
			t.x += text2x + text2width/2;
			t.y += text2y + t.height/2;
			addChild(t);

			if (t.y + t.height/2 > text2height) text2height = t.y + t.height/2;
		}
		text2height -= text2y;

		/// THIRD BIT //////////////////////////////////////////

		var textcontent3 = "You may come across /actions/ in your journey, don't be afraid to take them. These /actions/ will help you achieve your quests, as well as find *items* and earn *money*.";
		var text3x = padding;
		var text3y = Math.max(text2y + text2height, dialogueheight + dialoguebg.y) + 2 * padding;
		var text3width = Const.WORLD_WIDTH - 2 * padding;
		var text3height = 0.;
		var text3 = game.dialogue.Text.parse(textcontent3, Const.MENU_FONT_SMALL, null, text3width);
		for (t in text3) {
			t.x += text3x + text3width/2;
			t.y += text3y;
			addChild(t);
			
			if (t.y + t.height/2 > text3height) text3height = t.y + t.height/2;
		}
		text3height -= text3y ;
	
		var iconstack = new game.ui.HStack(this);
		iconstack.padding = 20;
		iconstack.setAlignment(Center, Middle);
		iconstack.x = Const.WORLD_WIDTH / 2;
		iconstack.y = text3y + text3height + padding * 2;

		var textplaceholder = new h2d.Object(this);
		textplaceholder.x = Const.WORLD_WIDTH / 2;
		textplaceholder.y = iconstack.y + padding + Const.ICON_MAX_SIZE / 2;

		var money = makeItem(hxd.Res.items.money.toTile(), textplaceholder,
			"You can get *money* from people by helping them, and use it buy items.");
		var coffee = makeItem(hxd.Res.items.coffee.toTile(), textplaceholder,
			"Other items like *coffee* can be purchased and consumed for a benifit.");
		var classnotes = makeItem(hxd.Res.items.classnotes.toTile(), textplaceholder,
			"Other items can be found, such as these *Class Notes* and used for futher quests.");
		var backpack = makeItem(hxd.Res.props.backpack.toTile(), textplaceholder,
			"All *items* are stored in your *backpack*. Be sure to check it out for more information about them.");

		iconstack.pushAll([money, coffee, classnotes, backpack]);
		iconstack.setChildrenAlignment(Middle);

		/// END BIT //////////////////////////////////////////

		var buttontext = if(firstTime) "Lets Go!" else "Continue";
		var beginbutton = new game.ui.Button(buttontext, null, this);
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

	private function makeItem(tile : h2d.Tile, textcontainer : h2d.Object, text : String) : game.ui.Icon {

		var icon = new game.ui.Icon(tile);		
		var filter = new h2d.filter.Outline(2,0xFFFFFFFF);

		var interactive = new h2d.Interactive(tile.width, tile.height, icon);
		interactive.onOver = function(e : hxd.Event) {
			icon.filter = filter;
			textcontainer.removeChildren();
			var descriptiontext = game.dialogue.Text.parse(text, Const.MENU_FONT_SMALL, null, 
				Const.WORLD_WIDTH - 2 * padding);
			for (t in descriptiontext) textcontainer.addChild(t);
		}
		interactive.onOut = function(e : hxd.Event) {
			textcontainer.removeChildren();
			icon.filter = null;
		}
		// hack because of the alignment.
		interactive.y = - tile.height/2;

		return icon;
	}

	override function onRemove() {
		super.onRemove();

		if (onRemoveChain != null) onRemoveChain();

		var window = hxd.Window.getInstance();
		window.removeEventTarget(textEditEvent);
	}
}
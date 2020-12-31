package game.utils;

typedef QuotedText = { quote : Null<String>, text : String };
private typedef CharStack = { char : String, pos : Int };

class Quoted {
	static private var validCharacters = ["@","#","$","%","^","&","~","/","`","*","_"];

	static public function parse(string : String) : Array<QuotedText> {
		var parsed : Array<QuotedText> = [];

		var lastMatchInt : Int = 0;
		var lastMatchChar : Null<String> = null;

		// find all the matching characters
		for (i in 0 ... string.length) {
			var char = string.charAt(i);
			
			// first we check if we match one of the valid characters.
			for (vc in validCharacters) {
				if (char == vc) {
					if (lastMatchChar == null) { 
						
						lastMatchChar = char; lastMatchInt = i;
						if (i > 0) parsed.push({quote: null, text: string.substr(0, i)});

					} else {

						var currentChar : Null<String> = if (lastMatchChar == char) char else null;
						var currentPos : Int = if (lastMatchChar == char) lastMatchInt + 1 else lastMatchInt; 

						parsed.push({quote: currentChar, text: string.substr(currentPos, i - currentPos)});
						
						lastMatchChar = char;
						if (lastMatchChar == char) lastMatchInt = i + 1;
						else lastMatchInt = i;
					}

					break;
				}
			}

		}

		// capture the last thing
		parsed.push({quote: null, text: string.substr(lastMatchInt)});

		return parsed;
	}
}
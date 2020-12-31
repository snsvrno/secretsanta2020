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
						
						lastMatchChar = char; 
						lastMatchInt = i;
						if (i > 0) parsed.push({quote: null, text: string.substr(0, i)});

					} else {

						// we are checking if this character matches the last character, doing this because 
						// we need to know if we are keeping the character or not.
						// if they are the same character then we should not include it because it is just a quote / 
						// special character that we don't want to track.
						var currentChar : Null<String> = if (lastMatchChar == char) char else null;
						var currentPos : Int = if (lastMatchChar == char) lastMatchInt + 1 else lastMatchInt; 

						parsed.push({quote: currentChar, text: string.substr(currentPos, i - currentPos)});
						
						if (lastMatchChar == char) lastMatchChar = "z";
						else lastMatchChar = char;
						lastMatchInt = i;
					}

					break;
				}
			}

		}

		// capture the last thing
		var pos = if (lastMatchChar == "z") lastMatchInt + 1 else lastMatchInt;
		parsed.push({quote: null, text: string.substr(pos)});

		return parsed;
	}
}
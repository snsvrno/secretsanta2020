package game.utils;

typedef QuotedText = { quote : Null<String>, text : String };
private typedef CharStack = { char : String, pos : Int };

class Quoted {
	static private var validCharacters = ["@","#","$","%","^","&","~","/","`","*","_"];

	/**
	 * Will go through a block of text that has been line braked, and will surround 
	 * the line break with quoted characters if it notices the line break is in a 
	 * quoted section
	 * @param text 
	 * @return String
	 */
	static public function throughLineBreaks(text : String) : String {
		
		var parsed = parse(text);

		for (i in 0 ... parsed.length) {
			if (parsed[i].quote != null) {
				var split = parsed[i].text.split("\n");
				if (split.length > 1) {
					var quoted = parsed[i];
					parsed.remove(parsed[i]);
					for (j in 0 ...split.length) {
						var newText = if (j < split.length-1) split[j] + "\n" else split[j];
						parsed.insert(i + j, {
							quote: quoted.quote,
							text: newText,
						});
					}

				}
			}
		}

		var renderedText = "";
		for (p in parsed) {
			if (p.quote == null) renderedText += p.text;
			else {
				if (p.text.substr(p.text.length-1) == "\n")
					renderedText += p.quote + p.text.substr(0,p.text.length-1) + p.quote + "\n";
				else
					renderedText += p.quote + p.text + p.quote;
			}
		}

		return renderedText;
	}

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

						parsed.push({quote: currentChar, text: string.substr(lastMatchInt + 1, i - lastMatchInt - 1)});
						
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
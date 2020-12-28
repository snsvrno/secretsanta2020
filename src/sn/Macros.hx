/*
 * Copyright (c) 2020 snsvrno
 * 
 * Shared macros, compile-time stuff, primarly used to grab metadata from
 * the files and store it inside the compiled build.
 */

package sn;

class Macros {

	////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE MICRO ACTIONS

	#if !js
	/**
	 * Checks if the reposiotry is dirty or not (if there are any uncomitted changes)
	 * @return Bool
	 */
	 private static function isRepoDirty() : Bool {
		
		var process = new sys.io.Process('git', ['status', '--short']);
		var result : haxe.io.Bytes = process.stdout.readAll();

		if (result.length > 0) { return true; } 
		else { return false; }
	}

	/**
	 * Gets the latest applicable tag to the commit, this doesn't mean
	 * that the latest commit is actually tagged with this tag, it is just
	 * the closest tag (most recent tag)
	 * 
	 * @return String
	 */
	private static function getLatestTag() : String {

		var latestTag = new sys.io.Process('git', ['describe', '--abbrev=0']);

		var tag : String = if (latestTag.exitCode() != 0) {

			"";

		} else {

			latestTag.stdout.readLine();

		}

		return tag;
	}

	/**
	 * Gets the tag of the current commit (if it has one)
	 * 
	 * @return String
	 */
	private static function getCurrentCommitTag() : String {

		var latestTag = new sys.io.Process('git', ['describe', '--exact-match', '--abbrev=0']);

		var tag : String = "";
		if (latestTag.exitCode() == 0) tag = latestTag.stdout.readLine();

		return tag;
	}
	#end

	////////////////////////////////////////////////////////////////////////////////////////
	// THE MACROS

	/**
	 * Generates the Git Hash
	 * taken from https://code.haxe.org/category/macros/add-git-commit-hash-in-build.html
	 * 
	 * @return haxe.macro.Expr.ExprOf<String>
	 */
	public static macro function getGitCommitHash(?size : Int = 0) : haxe.macro.Expr.ExprOf<String> {
		
		#if display
		// this will be for code completion, we can just return an empty string so we don't
		// generate it everytime.

		var commitHash : String = "<commithash>";

		return macro $v{commitHash};
		
		#else

		var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);

		// there was an error, need to return that info to the user.
		if (process.exitCode() != 0) {
			var message = process.stderr.readAll().toString();
			var pos = haxe.macro.Context.currentPos();
			haxe.macro.Context.error("Cannot execute `git rev-parse HEAD`. " + message, pos);
		}

		var commitHash : String = process.stdout.readLine();

		// trims the hash if desired.
		if (size > 0) { commitHash = commitHash.substr(0,size); }

		return macro $v{commitHash};


		#end
	}

	public static macro function getVersionNumberFromGit() : haxe.macro.Expr.ExprOf<String> {

		#if display
		
		// we are running this for code completion, no need actually doing anything.
		return macro $v{""};
		
		#else

		var version : String = getLatestTag();

		// will append the version with a '*' to know that it isn't the full version,
		// that it has some additional changes to it.
		if (version != "" && version != getCurrentCommitTag()) version += "*";

		return macro $v{version};

		#end
	}

	/**
	 * Loads the version number from the file `version` in the root of the project.
	 * 
	 * @return haxe.macro.Expr.ExprOf<String>
	 */
	public static macro function getVersionNumberFromFile() : haxe.macro.Expr.ExprOf<String> {
		
		#if display
		// this will be for code completion, we can just return an empty string so we don't
		// generate it everytime.

		return macro $v{""};

		#else

		if (sys.FileSystem.exists("version")) {
			var version = sys.io.File.getContent("version");
			return macro $v{version};
		} else {
			var pos = haxe.macro.Context.currentPos();
			haxe.macro.Context.error("No version file in root of project.", pos);
			return macro $v{"-.-.-"};
		}

		#end
	}

	/**
	 * Generates a string of the date-time the build was made.
	 * 
	 * @return haxe.macro.Expr.ExprOf<String> the build-time in `yymmdd-hhmmss`
	 */
	public static macro function getBuildDateTime() : haxe.macro.Expr.ExprOf<String> {

		#if display
		// this will be for code completion, we can just return an empty string so we don't
		// generate it everytime.

		return macro $v{""};

		#else

		return macro $v{DateTools.format(Date.now(), "%Y%m%d-%H%M%S")};

		#end
	}
}
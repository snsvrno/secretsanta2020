package sn;

class Window {

	static public function initResources() : Void {
		// initalizes the resources.
		
		#if js
		hxd.Res.initEmbed();
		#else
		hxd.Res.initLocal();
		#end

		// loads the castledb resource file.
		Data.load(hxd.Res.data.entry.getText());
	}

	static public function generateTitle(gamename : String) : String {
		var title : String = gamename;

		#if debug

		// the base title with version
		title += " (" + sn.Macros.getVersionNumberFromGit() + ")";
		
		// the repository information
		title += " [" + sn.Macros.getGitCommitHash(7) + "][" + sn.Macros.getBuildDateTime() + "]";
	
		#else

		#end

		return title;
	}
}

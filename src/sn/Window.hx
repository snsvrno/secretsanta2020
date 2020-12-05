package sn;

class Window {

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

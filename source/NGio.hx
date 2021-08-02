package;

import io.newgrounds.NG;

/**
 * This class is CarTrip's version of Geokureli's NGio script
 */
class NGio
{
	/**
	 * This function initializes NG
	 * 
	 * @param GAMEID The ID of the game, if you don't have one you should check out the newgrounds tutorial page
	 * @param ENCKEY The encryption key of the game, is optional if you don't want a ENCKEY but is heavily recommended to use it.
	 * also the cipher is set to RC4 and the encryption format is set to BASE64 remember to save those on the page of your game 
	 * (Other ciphers and encryption formats aren't implemented yet)
	 * @param VERBOSE It makes the game run on verbose mode, opening the browser console you will see stuff like Medals, Scoreboards, 
	 * and User Logins, good for testing and debugging, but is recommended to when releasing the game always remember to turn verbose
	 * to false because verbose reveals API ID and maybe Encryption Key, if your game has scoreboards or "hard to get" medals
	 * you probably gonna have to be careful
	 */
	public function new(GAMEID:String, ENCKEY:String, VERBOSE:Bool = false)
	{
		NG.createAndCheckSession(GAMEID);
		NG.core.initEncryption(ENCKEY);
		NG.core.verbose = VERBOSE;
		NG.core.requestMedals(onMedalLoad);
		NG.core.requestScoreBoards(onScoreBoardLoad);
	}

	function onMedalLoad()
	{
		trace("MEDALS LOADED");
	}

	function onScoreBoardLoad()
	{
		trace("SCOREBOARDS LOADED");
	}

	/**
	 * This function unlock a medal but only works if the user is logged in
	 * @param MEDALID The ID of the medal
	 */
	public static function unlockMedal(MEDALID:Int)
	{
		if (NG.core.loggedIn)
		{
			var medal = NG.core.medals.get(MEDALID);

			if (!medal.unlocked)
				medal.sendUnlock();
		}
	}

	public static function sendScore(SCOREBOARDID:Int, POINTS:Int, ?TAG:String)
	{
		if (NG.core.loggedIn)
		{
			var ScoreBoard = NG.core.scoreBoards.get(SCOREBOARDID);

			// if there isn't tag then the value return null
			ScoreBoard.postScore(POINTS, if (TAG != null) TAG else null);
		}
	}

	/**
	 * This function gets the User's name, only works if the user is logged in
	 * instead of using this function you can use NG.core.user.name this is only a shortcut
	 */
	public static function getUsername():String
	{
		if (NG.core.loggedIn)
			return NG.core.user.name;
		else
			return null;
	}

	public static function isConnected():Bool
	{
		if (NG.core.loggedIn)
			return true;
		else
			return false;
	}
}

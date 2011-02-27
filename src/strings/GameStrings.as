package strings 
{
	import embed.Assets;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class GameStrings 
	{
		private var _languageXML:XML;
		
		public function GameStrings()
		{
			setLanguage("EN");
		}
		
		public function setLanguage(language:String):void
		{
			var obj:Object;
			switch (language)
			{
				case "EN":
				{
					obj = new Assets.EnglishXML();
				}
				break;
				default:
				{
					throw new Error("language " + language + " not supported");
				}
			}
			_languageXML = XML(obj);
		}
		
		public function get languageXML():XML
		{
			return _languageXML;
		}
	}
}
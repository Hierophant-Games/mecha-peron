package utils 
{
	/**
	 * ...
	 * @author 
	 */
	public class ColorUtils 
	{
		public static function getHex(r:Number, g:Number, b:Number):Number
		{
			var rgb:String = "0x" + (r<16?"0":"") + r.toString(16) + (g<16?"0":"") + g.toString(16) + (b<16?"0":"") + b.toString(16);
			return Number(rgb);
		}

		public static function getRGB(color:Number):Object
		{
			var r:uint = color >> 16 & 0xFF;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			return {r:r, g:g, b:b};
		}
	}
}
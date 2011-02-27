package collision 
{
	import flash.geom.*;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Fernando
	 */
	public class RotatedRectangle
	{
		private var _rect:Rectangle;
		private var _angle:Number;
		private var _origin:Point;
		
		public function RotatedRectangle(rectangle:Rectangle, angle:Number, origin:Point = null) 
		{
			_rect = rectangle;
			_angle = angle;
			
			if(origin == null)
				_origin = new Point(rectangle.width / 2, rectangle.height / 2);
			else
				_origin = origin;
		}
		
		public function collides(otherRect:RotatedRectangle):Boolean
		{
			var axis:Vector.<Point> = new Vector.<Point>();
			
			axis.push( upperRight().subtract(upperLeft()) );
			axis.push( upperRight().subtract(bottomRight()) );
			axis.push( otherRect.upperLeft().subtract(otherRect.bottomLeft()) );
			axis.push( otherRect.upperLeft().subtract(otherRect.upperRight()) );
			
			for (var i:uint = 0; i < axis.length; i++)
			{
				if (!isAxisColission(otherRect, axis[i]))
					return false;
			}
			
			return true;
		}
		
		public function collides2(otherRect:FlxObject):Boolean
		{
			return collides(new RotatedRectangle(new Rectangle(otherRect.x, otherRect.y, otherRect.width, otherRect.height), 0));
		}
		
		private function isAxisColission(otherRect:RotatedRectangle, axis:Point):Boolean
		{
			var scalars:Vector.<Number> = new Vector.<Number>();
			scalars.push(generateScalar(otherRect.upperLeft(), axis));
			scalars.push(generateScalar(otherRect.upperRight(), axis));
			scalars.push(generateScalar(otherRect.bottomLeft(), axis));
			scalars.push(generateScalar(otherRect.bottomRight(), axis));
			
			function compare(a:Number, b:Number):Number
			{
				if (a < b) return -1;
				if (a > b) return 1;
				return 0;
			}
			
			scalars.sort(compare);
			
			var minA:Number = scalars[0];
			var maxA:Number = scalars[3];
			
			scalars.splice(0, 4);
			
			scalars.push(generateScalar(upperLeft(), axis));
			scalars.push(generateScalar(upperRight(), axis));
			scalars.push(generateScalar(bottomLeft(), axis));
			scalars.push(generateScalar(bottomRight(), axis));
			
			scalars.sort(compare);
			
			var minB:Number = scalars[0];
			var maxB:Number = scalars[3];
			
			if (minB <= maxA && maxB >= maxA)
				return true;
			
			if (minA <= maxB && maxA >= maxB)
				return true;
			
			return false;
		}
		
		private function generateScalar(corner:Point, axis:Point):Number
		{
			var numerator:Number = (corner.x * axis.x) + (corner.y * axis.y);
			var denominator:Number = (axis.x * axis.x) + (axis.y * axis.y);
			var division:Number = numerator / denominator;
			
			var projected:Point = new Point(division * axis.x, division * axis.y);
			
			return (axis.x * projected.x) + (axis.y * projected.y);
		}
		
		private function rotatePoint(point:Point, origin:Point, angle:Number):Point
		{
			var rotatedPoint:Point = new Point();
			rotatedPoint.x = origin.x + (point.x - origin.x) * Math.cos(angle * (Math.PI / 180)) - (point.y - origin.y) * Math.sin(angle * (Math.PI / 180));
			rotatedPoint.y = origin.y + (point.y - origin.y) * Math.cos(angle * (Math.PI / 180)) + (point.x - origin.x) * Math.sin(angle * (Math.PI / 180));
			return rotatedPoint;
		}
		
		private function upperLeft():Point
		{
			var corner:Point = new Point(_rect.x, _rect.y);
			return rotatePoint(corner, getWorldOrigin(), _angle);
		}
		
		private function upperRight():Point
		{
			var corner:Point = new Point(_rect.x + _rect.width, _rect.y);
			return rotatePoint(corner, getWorldOrigin(), _angle);
		}
		
		private function bottomLeft():Point
		{
			var corner:Point = new Point(_rect.x, _rect.y + _rect.height);
			return rotatePoint(corner, getWorldOrigin(), _angle);
		}
		
		private function bottomRight():Point
		{
			var corner:Point = new Point(_rect.x + _rect.width, _rect.y + _rect.height);
			return rotatePoint(corner, getWorldOrigin(), _angle);
		}
		
		private function getWorldOrigin():Point
		{
			return new Point(_rect.x + _origin.x, _rect.y + _origin.y);
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function set rect(rect:Rectangle):void
		{
			_rect = rect;
		}
		
		public function get angle():Number
		{
			return _angle;
		}
		
		public function set angle(angle:Number):void
		{
			_angle = angle;
		}
		
		public function get origin():Point
		{
			return _origin;
		}
		
		public function set origin(origin:Point):void
		{
			_origin = origin;
		}
		
	}

}
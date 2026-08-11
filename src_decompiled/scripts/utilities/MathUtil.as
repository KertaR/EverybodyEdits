package utilities
{
   import flash.geom.Point;
   
   public class MathUtil
   {
      
      public function MathUtil()
      {
         super();
      }
      
      public static function distance(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return Math.sqrt(square(param1 - param3) + square(param2 - param4));
      }
      
      public static function distanceSqr(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return square(param1 - param3) + square(param2 - param4);
      }
      
      public static function distancePoint(param1:Point, param2:Point) : Number
      {
         return Math.sqrt(square(param1.x - param2.x) + square(param1.y - param2.y));
      }
      
      public static function distancePointSqr(param1:Point, param2:Point) : Number
      {
         return square(param1.x - param2.x) + square(param1.y - param2.y);
      }
      
      public static function inRange(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Boolean
      {
         return square(param3 - param1) + square(param4 - param2) < square(param5);
      }
      
      public static function inRangePoint(param1:Point, param2:Point, param3:Number) : Boolean
      {
         return inRange(param1.x,param1.y,param2.x,param2.y,param3);
      }
      
      private static function square(param1:Number) : Number
      {
         return param1 * param1;
      }
   }
}


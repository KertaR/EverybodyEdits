package utilities
{
   public class Random
   {
      
      public function Random()
      {
         super();
      }
      
      public static function nextInt(param1:int, param2:int) : int
      {
         return Math.floor(Math.random() * (param2 - param1) + param1);
      }
      
      public static function percent(param1:Number) : Boolean
      {
         return Math.random() * 100 < param1;
      }
   }
}


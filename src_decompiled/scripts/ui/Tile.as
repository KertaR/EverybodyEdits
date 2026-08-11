package ui
{
   public class Tile
   {
      
      public var layer:int;
      
      public var xo:int;
      
      public var yo:int;
      
      public var value:int;
      
      public var properties:Object;
      
      public function Tile(param1:int, param2:int, param3:int, param4:int, param5:Object)
      {
         super();
         this.layer = param1;
         this.xo = param2;
         this.yo = param3;
         this.value = param4;
         this.properties = param5;
      }
      
      public function equals(param1:Tile) : Boolean
      {
         return param1.layer == this.layer && param1.xo == this.xo && param1.yo == this.yo;
      }
   }
}


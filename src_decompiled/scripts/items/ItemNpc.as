package items
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemNpc
   {
      
      public var id:int;
      
      public var payvaultid:String;
      
      public var bmd:BitmapData;
      
      public var frames:int;
      
      public var rate:Number;
      
      public var bubbleOffset:Number;
      
      public function ItemNpc(param1:int, param2:String, param3:BitmapData, param4:int, param5:Number, param6:Number)
      {
         super();
         this.id = param1;
         this.payvaultid = param2;
         this.bmd = param3;
         this.frames = param4;
         this.rate = param5;
         this.bubbleOffset = param6;
      }
      
      public function drawTo(param1:BitmapData, param2:Point, param3:int = 0, param4:Boolean = false) : void
      {
         param1.copyPixels(this.bmd,new Rectangle(param3 * 16,0,16,32),new Point(param2.x,param2.y - 16));
      }
   }
}


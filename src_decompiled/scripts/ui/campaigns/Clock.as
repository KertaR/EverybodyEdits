package ui.campaigns
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Clock extends Bitmap
   {
      
      private static var Clocks:Class = Clock_Clocks;
      
      public static var clocksBMD:BitmapData = new Clocks().bitmapData;
      
      public static const size:int = 15;
      
      protected static const maxTier:int = clocksBMD.width / size - 1;
      
      protected static const tempRect:Rectangle = new Rectangle(0,0,size,size);
      
      protected static const tempPoint:Point = new Point();
      
      protected var bmd:BitmapData = new BitmapData(size,size,true,0);
      
      protected var _rank:int = -1;
      
      public function Clock(param1:int)
      {
         super(this.bmd);
         this.rank = param1;
      }
      
      public function get rank() : int
      {
         return this._rank;
      }
      
      public function set rank(param1:int) : void
      {
         param1 = param1 < 0 ? 0 : (param1 > maxTier ? maxTier : param1);
         if(param1 != this._rank)
         {
            tempRect.x = param1 * size;
            this.bmd.copyPixels(clocksBMD,tempRect,tempPoint);
            this._rank = param1;
         }
      }
   }
}


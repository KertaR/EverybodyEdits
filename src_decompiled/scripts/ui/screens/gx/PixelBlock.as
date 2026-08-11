package ui.screens.gx
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import items.ItemManager;
   
   public class PixelBlock extends Sprite
   {
      
      public static var blockids:Array = [1065,1066,1067,1068,1069,709,710,711,200,201];
      
      public var layer:int;
      
      public var speed:Number = 2;
      
      public var gx:DisplayObject;
      
      public function PixelBlock(param1:int)
      {
         super();
         this.layer = param1;
         this.speed = 2 + param1 * 2 + Math.random() / 2;
         var _loc2_:int = param1 + 1;
         var _loc3_:BitmapData = ItemManager.bmdBricks[blockids[Math.floor(Math.random() * blockids.length)]];
         var _loc4_:BitmapData = new BitmapData(_loc3_.width * _loc2_,_loc3_.height * _loc2_,true,0);
         var _loc5_:Matrix = new Matrix();
         _loc5_.scale(_loc2_,_loc2_);
         _loc4_.draw(_loc3_,_loc5_);
         this.gx = addChild(new Bitmap(_loc4_));
         this.gx.x = -this.gx.width / 2;
         this.alpha = this.speed / 10;
      }
      
      public function tick() : void
      {
         y += this.speed;
      }
   }
}


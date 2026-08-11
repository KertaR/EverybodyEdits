package ui.profile
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.geom.Matrix;
   
   public class FriendSmiley extends SynchronizedSprite
   {
      
      public function FriendSmiley(param1:BitmapData)
      {
         super(param1);
         size = 26;
         width = 26;
         height = 26;
         frames = param1.width / size;
      }
      
      public function getAsBitmap(param1:uint = 1) : Bitmap
      {
         var _loc2_:BitmapData = new BitmapData(width,height);
         draw(_loc2_,0,0);
         var _loc3_:BitmapData = new BitmapData(_loc2_.width * param1,_loc2_.height * param1,true,0);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(param1,param1);
         _loc3_.draw(_loc2_,_loc4_);
         var _loc5_:Bitmap = new Bitmap(_loc3_);
         _loc5_.smoothing = false;
         _loc5_.pixelSnapping = PixelSnapping.NEVER;
         return _loc5_;
      }
   }
}


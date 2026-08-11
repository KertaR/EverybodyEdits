package ui.ingame
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FavLikeButton extends MovieClip
   {
      
      private static var FavLike:Class = FavLikeButton_FavLike;
      
      private static var favLikeBMD:BitmapData = new FavLike().bitmapData;
      
      private var buttonImageBMD:BitmapData = new BitmapData(43,28,true,0);
      
      public function FavLikeButton()
      {
         super();
         var _loc1_:Bitmap = new Bitmap(this.buttonImageBMD);
         addChild(_loc1_);
         this.setState(0);
      }
      
      public function setState(param1:int) : void
      {
         this.buttonImageBMD.copyPixels(favLikeBMD,new Rectangle(param1 * 43,0,43,28),new Point(0,0));
      }
   }
}


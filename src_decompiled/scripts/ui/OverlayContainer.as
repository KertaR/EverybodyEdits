package ui
{
   import flash.display.Sprite;
   
   public class OverlayContainer extends Sprite
   {
      
      public function OverlayContainer()
      {
         super();
      }
      
      override public function get width() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:int = numChildren;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = Math.max(_loc1_,getChildAt(_loc3_).width);
            _loc3_++;
         }
         return _loc1_;
      }
   }
}


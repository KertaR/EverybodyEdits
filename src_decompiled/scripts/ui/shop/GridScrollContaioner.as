package ui.shop
{
   import sample.ui.components.scroll.ScrollContainer;
   
   public class GridScrollContaioner extends ScrollContainer
   {
      
      private var currentgrid:ShopGrid;
      
      public function GridScrollContaioner()
      {
         super();
      }
      
      override public function get height() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc1_ = Math.max(_loc1_,getChildAt(_loc2_).y + getChildAt(_loc2_).height);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}


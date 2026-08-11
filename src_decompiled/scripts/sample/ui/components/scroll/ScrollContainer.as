package sample.ui.components.scroll
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ScrollContainer extends Sprite
   {
      
      protected var componentWidth:Number = 0;
      
      public function ScrollContainer()
      {
         super();
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         mouseEnabled = true;
         if(this.componentWidth != param1)
         {
            _loc2_ = 0;
            while(_loc2_ < numChildren)
            {
               _loc3_ = getChildAt(_loc2_);
               _loc3_.width = param1 - 1;
               _loc2_++;
            }
            this.componentWidth = param1;
         }
      }
      
      override public function set height(param1:Number) : void
      {
      }
   }
}


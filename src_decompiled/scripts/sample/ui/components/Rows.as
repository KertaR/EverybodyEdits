package sample.ui.components
{
   import flash.display.DisplayObject;
   
   public class Rows extends Component
   {
      
      private var _spacing:Number = 10;
      
      private var _forceScale:Boolean = true;
      
      public function Rows(... rest)
      {
         var _loc2_:DisplayObject = null;
         super();
         for each(_loc2_ in rest)
         {
            this.addChild(_loc2_);
         }
      }
      
      public function set forceScale(param1:Boolean) : void
      {
         this._forceScale = param1;
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.addChild(param1);
         this.redraw();
         return _loc2_;
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         var _loc3_:DisplayObject = super.addChildAt(param1,param2);
         this.redraw();
         return _loc3_;
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = super.removeChild(param1);
         this.redraw();
         return _loc2_;
      }
      
      public function removeAllChildren() : void
      {
         while(numChildren)
         {
            super.removeChild(getChildAt(0));
         }
         this.redraw();
      }
      
      public function spacing(param1:Number) : *
      {
         this._spacing = param1;
         this.redraw();
         return this;
      }
      
      override protected function redraw() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_);
            _loc3_.y = _loc1_;
            if(this._forceScale)
            {
               _loc3_.width = _width;
            }
            _loc1_ += _loc3_.height + this._spacing;
            _loc2_++;
         }
         super.redraw();
         _height = _loc1_;
      }
   }
}


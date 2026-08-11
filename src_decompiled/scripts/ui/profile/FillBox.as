package ui.profile
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class FillBox extends Sprite
   {
      
      private var _width:Number = 100;
      
      private var _height:Number = 100;
      
      private var ss:int = 0;
      
      private var hs:int = 2;
      
      private var forcescale:Boolean = false;
      
      private var isHorizontal:Boolean = false;
      
      public function FillBox(param1:int, param2:int = 0)
      {
         super();
         this.ss = param1;
         this.hs = param2;
      }
      
      public function set horizontal(param1:Boolean) : void
      {
         this.isHorizontal = param1;
      }
      
      public function removeAllChildren() : void
      {
         while(numChildren)
         {
            super.removeChild(getChildAt(0));
         }
         this.redraw();
      }
      
      public function set forceScale(param1:Boolean) : void
      {
         this.forcescale = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this.redraw();
      }
      
      public function refresh() : void
      {
         this.redraw();
      }
      
      override public function set height(param1:Number) : void
      {
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         super.addChild(param1);
         this.redraw();
         return param1;
      }
      
      public function clear() : void
      {
         while(numChildren > 0)
         {
            super.removeChildAt(0);
         }
         this.redraw();
      }
      
      private function redraw() : void
      {
         var _loc5_:DisplayObject = null;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < numChildren)
         {
            _loc5_ = getChildAt(_loc4_);
            if(!this.isHorizontal)
            {
               if(_loc1_ + _loc5_.width + 2 > this._width)
               {
                  _loc1_ = 0;
                  _loc2_ += _loc3_ + this.ss;
                  _loc3_ = 0;
               }
            }
            if(this.forcescale && _loc1_ + _loc5_.width + 2 > this._width)
            {
               _loc5_.width = this._width - 2;
            }
            _loc5_.x = Math.round(_loc1_);
            _loc5_.y = Math.round(_loc2_);
            if(_loc5_.height > _loc3_)
            {
               _loc3_ = _loc5_.height;
            }
            _loc1_ += _loc5_.width + this.hs;
            _loc4_++;
         }
      }
   }
}


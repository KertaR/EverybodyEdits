package sample.ui.components
{
   import flash.display.DisplayObject;
   
   public class Box extends Component
   {
      
      protected var _top:Number = NaN;
      
      protected var _bottom:Number = NaN;
      
      protected var _left:Number = NaN;
      
      protected var _right:Number = NaN;
      
      protected var _color:int;
      
      protected var _corner:Number = 0;
      
      protected var _alpha:Number;
      
      protected var _strokeWidth:Number;
      
      protected var _strokeColor:Number;
      
      protected var _strokeAlpha:Number;
      
      protected var useFill:Boolean = false;
      
      private var _forceScale:Boolean = true;
      
      public function Box()
      {
         super();
         this.redraw();
      }
      
      public function margin(param1:Number = NaN, param2:Number = NaN, param3:Number = NaN, param4:Number = NaN) : *
      {
         this._top = param1;
         this._right = param2;
         this._bottom = param3;
         this._left = param4;
         this.redraw();
         return this;
      }
      
      public function fill(param1:int = 0, param2:Number = 1, param3:Number = 0) : *
      {
         _width = width;
         _height = height;
         this._color = param1;
         this._corner = param3;
         this._alpha = param2;
         this.useFill = true;
         this.redraw();
         return this;
      }
      
      public function set color(param1:uint) : void
      {
         this._color = param1;
         this.useFill = true;
         this.redraw();
      }
      
      public function border(param1:Number = 0, param2:Number = 0, param3:Number = 1) : *
      {
         this._strokeWidth = param1;
         this._strokeColor = param2;
         this._strokeAlpha = param3;
         this.redraw();
         return this;
      }
      
      public function minSize(param1:Number, param2:Number) : Box
      {
         this.minWidth = param1;
         this.minHeight = param2;
         this.redraw();
         return this;
      }
      
      public function add(... rest) : Box
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in rest)
         {
            addChild(_loc2_);
         }
         this.redraw();
         return this;
      }
      
      protected function get borderHeight() : Number
      {
         return (this._top ? this._top : 0) + (this._bottom ? this._bottom : 0);
      }
      
      protected function get borderWidth() : Number
      {
         return (this._left ? this._left : 0) + (this._right ? this._right : 0);
      }
      
      public function reset(param1:Boolean = true, param2:Array = null) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Function = null;
         if(param1)
         {
            param2 = [];
         }
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_);
            if(_loc4_ is Box)
            {
               (_loc4_ as Box).reset(false,param2);
            }
            _loc3_++;
         }
         param2.push(this.redraw);
         if(param1)
         {
            for each(_loc5_ in param2)
            {
               _loc5_();
               _loc5_();
            }
         }
      }
      
      public function set forceScale(param1:Boolean) : void
      {
         this._forceScale = param1;
      }
      
      override protected function redraw() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc1_:Number = _width;
         var _loc2_:Number = _height;
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_);
            _loc1_ = Math.max(_loc1_,_loc4_.width + this.borderWidth);
            _loc2_ = Math.max(_loc2_,_loc4_.height + this.borderHeight);
            if(!isNaN(this._left))
            {
               _loc4_.x = this._left;
               if(!isNaN(this._right))
               {
                  if(this._forceScale)
                  {
                     _loc4_.width = rwidth - this.borderWidth;
                  }
               }
            }
            else if(!isNaN(this._right))
            {
               _loc4_.x = _loc1_ - _loc4_.width - this._right;
            }
            else
            {
               _loc4_.x = (Math.max(rwidth,_loc1_) - _loc4_.width) / 2;
            }
            if(!isNaN(this._top))
            {
               _loc4_.y = this._top;
               if(!isNaN(this._bottom))
               {
                  if(this._forceScale)
                  {
                     _loc4_.height = rheight - this.borderHeight;
                  }
               }
            }
            else if(!isNaN(this._bottom))
            {
               _loc4_.y = _loc2_ - _loc4_.height - this._bottom;
            }
            else
            {
               _loc4_.y = (Math.max(rheight,_loc2_) - _loc4_.height) / 2;
            }
            _loc3_++;
         }
         if(!this._strokeWidth && !this.useFill)
         {
            return;
         }
         graphics.clear();
         if(this._strokeWidth)
         {
            graphics.lineStyle(this._strokeWidth,this._strokeColor,this._strokeAlpha,true);
            if(Boolean(_minWidth) || Boolean(_minHeight))
            {
               graphics.drawRoundRect(0,0,Math.max(rwidth,_loc1_),Math.max(rheight,_loc2_),this._corner);
            }
            else
            {
               graphics.drawRoundRect(0,0,Math.max(rwidth,_width),Math.max(rheight,_height),this._corner);
            }
         }
         if(this.useFill)
         {
            graphics.beginFill(this._color,this._alpha);
            if(Boolean(_minWidth) || Boolean(_minHeight))
            {
               graphics.drawRoundRect(0,0,Math.max(rwidth,_loc1_),Math.max(rheight,_loc2_),this._corner);
            }
            else
            {
               graphics.drawRoundRect(0,0,Math.max(rwidth,_width),Math.max(rheight,_height),this._corner);
            }
            graphics.endFill();
         }
      }
   }
}


package sample.ui.components.scroll
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sample.ui.components.Box;
   
   public class ScrollBox extends Box
   {
      
      private var _container:ScrollContainer;
      
      private var _mask:Sprite;
      
      private var _mouseoverlay:Sprite;
      
      private var _scrollX:Number = 0;
      
      private var _scrollY:Number = 0;
      
      private var _scrollMultiplier:Number = 1;
      
      private var _reversed:Boolean = false;
      
      private var _animated:Boolean = true;
      
      private var scrolldisabled:Boolean = false;
      
      private var scrollAmount:int = 0;
      
      private var hscroll:ScrollBar;
      
      private var isfirst:Boolean = true;
      
      public function ScrollBox(param1:Boolean = false, param2:ScrollContainer = null, param3:uint = 0)
      {
         var horizontal:Boolean = param1;
         var container:ScrollContainer = param2;
         var fill:uint = param3;
         this._mask = new Sprite();
         this._mouseoverlay = new Sprite();
         super();
         this._container = container || new ScrollContainer();
         this.hscroll = new ScrollBar(horizontal,fill);
         super.addChild(this._mouseoverlay);
         this._mouseoverlay.mouseEnabled = true;
         this._mouseoverlay.graphics.beginFill(0,0);
         this._mouseoverlay.graphics.drawRect(0,0,100,100);
         this._mouseoverlay.graphics.endFill();
         super.addChild(this._container);
         super.addChild(this._mask);
         super.addChild(this.hscroll);
         this._mask.graphics.beginFill(0,1);
         this._mask.graphics.drawRect(0,0,100,100);
         this._mask.graphics.endFill();
         this._container.mask = this._mask;
         mouseEnabled = true;
         this.hscroll.scroll(function(param1:Number):void
         {
            if(scrolldisabled == false)
            {
               if(!hscroll.horizontal)
               {
                  scrollY = param1;
               }
               else
               {
                  scrollX = param1;
               }
            }
         });
         addEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollWheel);
      }
      
      public function set scrollDisabled(param1:Boolean) : void
      {
         this.scrolldisabled = param1;
         this.hscroll.visible = !param1;
         this.refresh();
      }
      
      public function set horizontal(param1:Boolean) : void
      {
         this.hscroll.horizontal = param1;
         if(!this.hscroll.horizontal)
         {
            this.scrollY = 1;
         }
         else
         {
            this.scrollX = 1;
         }
      }
      
      public function set scrollMultiplier(param1:Number) : void
      {
         this._scrollMultiplier = param1;
      }
      
      private function handleScrollWheel(param1:MouseEvent) : void
      {
         if(this.scrolldisabled == false)
         {
            if(!this.hscroll.horizontal)
            {
               this.scrollY -= param1.delta * this._scrollMultiplier;
            }
            else
            {
               this.scrollX -= param1.delta * this._scrollMultiplier;
            }
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         }
      }
      
      public function reverse() : ScrollBox
      {
         this._reversed = !this._reversed;
         return this;
      }
      
      public function animated() : ScrollBox
      {
         this._animated = !this._animated;
         return this;
      }
      
      override public function add(... rest) : Box
      {
         var _loc2_:DisplayObject = null;
         for each(_loc2_ in rest)
         {
            this._container.addChild(_loc2_);
         }
         this.redraw();
         return this;
      }
      
      public function set scrollX(param1:Number) : void
      {
         if(this._scrollX != param1)
         {
            this._scrollX = param1;
            this.redraw();
            this.hscroll.scrollValue = param1;
         }
      }
      
      public function set scrollY(param1:Number) : void
      {
         if(this._scrollY != param1)
         {
            this._scrollY = param1;
            this.redraw();
            this.hscroll.scrollValue = param1;
         }
      }
      
      public function scrollPixelsX(param1:Number) : void
      {
         this.hscroll.refresh();
      }
      
      public function scrollPixelsY(param1:Number) : void
      {
         this.hscroll.refresh();
      }
      
      public function get scrollWidth() : Number
      {
         return this._container.width - this._mask.width;
      }
      
      public function get scrollHeight() : Number
      {
         return this._container.height - this._mask.height;
      }
      
      public function get scrollX() : Number
      {
         return this._scrollX;
      }
      
      public function get scrollY() : Number
      {
         return this._scrollY;
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         return this._container.addChild(param1);
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         return this._container.removeChild(param1);
      }
      
      public function refresh() : void
      {
         this.redraw();
      }
      
      override protected function redraw() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc8_:int = 0;
         var _loc9_:DisplayObject = null;
         var _loc10_:int = 0;
         var _loc11_:DisplayObject = null;
         if(this.hscroll != null)
         {
            if(this.scrolldisabled == false)
            {
               this.hscroll.visible = true;
            }
            if(dirty)
            {
               _loc2_ = 0;
               while(_loc2_ < numChildren)
               {
                  _loc3_ = getChildAt(_loc2_);
                  _loc3_.width = rwidth - borderWidth;
                  _loc3_.height = rheight - borderHeight;
                  _loc2_++;
               }
            }
            if(!this.hscroll.horizontal)
            {
               if(_height == 0)
               {
                  return;
               }
               _loc1_ = _width;
               _width -= 13;
               this.hscroll.scrollViewable = _height;
               this.hscroll.scrollSize = this._container.height + (_top || 0) + (_bottom || 0);
               if(this._container.height > _height)
               {
                  this.hscroll.focus();
                  _loc4_ = 0;
                  while(_loc4_ < numChildren)
                  {
                     _loc5_ = getChildAt(_loc4_);
                     _loc5_.width = rwidth - borderWidth;
                     _loc5_.height = rheight - borderHeight;
                     _loc4_++;
                  }
               }
               else
               {
                  this.hscroll.blur();
                  _width += 13;
                  _loc6_ = 0;
                  while(_loc6_ < numChildren)
                  {
                     _loc7_ = getChildAt(_loc6_);
                     _loc7_.width = rwidth - borderWidth;
                     _loc7_.height = rheight - borderHeight;
                     _loc6_++;
                  }
               }
               this._scrollX = Math.max(Math.min(this._scrollX,this.scrollWidth),0);
               this._scrollY = Math.max(Math.min(this._scrollY,this.scrollHeight),0);
               this._container.x = -this._scrollX;
               if(this._reversed && this._container.height < _height)
               {
                  this.setContainerY(_height - this._container.height);
               }
               else
               {
                  this.setContainerY(-this._scrollY + 1);
               }
               this.hscroll.x = _width + 1;
               this.hscroll.y = -1;
               this.hscroll.height = Math.ceil(_height) + 1;
               _width = _loc1_;
            }
            else
            {
               if(_width == 0)
               {
                  return;
               }
               _loc1_ = _height;
               _height -= 13;
               this.hscroll.scrollViewable = _width;
               this.hscroll.scrollSize = this._container.width + (_left || 0) + (_right || 0);
               if(this._container.width > _width)
               {
                  this.hscroll.focus();
                  _loc8_ = 0;
                  while(_loc8_ < numChildren)
                  {
                     _loc9_ = getChildAt(_loc8_);
                     _loc9_.width = rwidth - borderWidth;
                     _loc9_.height = rheight - borderHeight;
                     _loc8_++;
                  }
               }
               else
               {
                  this.hscroll.blur();
                  _height += 13;
                  _loc10_ = 0;
                  while(_loc10_ < numChildren)
                  {
                     _loc11_ = getChildAt(_loc10_);
                     _loc11_.width = rwidth - borderWidth;
                     _loc11_.height = rheight - borderHeight;
                     _loc10_++;
                  }
               }
               this._scrollX = Math.max(Math.min(this._scrollX,this.scrollWidth),0);
               this._scrollY = Math.max(Math.min(this._scrollY,this.scrollHeight),0);
               this._container.y = -this._scrollY;
               if(this._reversed && this._container.width < _width)
               {
                  this.setContainerX(_width - this._container.width);
               }
               else
               {
                  this.setContainerX(-this._scrollX + 1);
               }
               this.hscroll.x = -1;
               this.hscroll.y = _height - 3;
               this.hscroll.width = Math.ceil(_width) + 1;
               _height = _loc1_;
            }
            dirty = false;
            this.hscroll.refresh();
         }
      }
      
      public function setContainerY(param1:Number) : void
      {
         if(this._animated && !this.isfirst)
         {
            TweenMax.to(this._container,0.15,{"y":param1});
         }
         else
         {
            this._container.y = param1;
         }
         this.isfirst = false;
      }
      
      public function setContainerX(param1:Number) : void
      {
         if(this._animated && !this.isfirst)
         {
            TweenMax.to(this._container,0.15,{"x":param1});
         }
         else
         {
            this._container.x = param1;
         }
         this.isfirst = false;
      }
   }
}


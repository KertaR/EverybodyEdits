package sample.ui.components.scroll
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import sample.ui.components.Box;
   import sample.ui.components.Component;
   
   public class ScrollBar extends Component
   {
      
      private var decArrow:ScrollButton;
      
      private var incArrow:ScrollButton;
      
      private var scrollbg:Box;
      
      private var tracker:ScrollTracker;
      
      private var _scrollSize:Number = 1000;
      
      private var _scrollViewable:Number = 200;
      
      private var _scrollValue:Number = 0;
      
      private var scrollListener:Function;
      
      private var _mouseY:Number;
      
      private var _mouseX:Number;
      
      private var pixelSize:int = 10;
      
      private var _horizontal:Boolean = false;
      
      public function ScrollBar(param1:Boolean = false, param2:uint = 0)
      {
         var horizontal:Boolean = param1;
         var fill:uint = param2;
         super();
         this._horizontal = horizontal;
         this.decArrow = new ScrollButton(this._horizontal == true ? 2 : 1,this.pixelSize - 1,this.decScroll);
         this.incArrow = new ScrollButton(this._horizontal == true ? 0 : 3,this.pixelSize - 1,this.incScroll);
         this.scrollbg = new Box().fill(fill,1,3);
         this.tracker = new ScrollTracker();
         this.scrollbg.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            if(!_horizontal)
            {
               if(scrollbg.mouseY > tracker.y)
               {
                  incScrollJump();
               }
               else
               {
                  decScrollJump();
               }
            }
            else if(scrollbg.mouseX > tracker.x)
            {
               incScrollJump();
            }
            else
            {
               decScrollJump();
            }
         });
         this.tracker.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            var handleMove:Function = null;
            var e:MouseEvent = param1;
            handleMove = function(param1:Event):void
            {
               if(!_horizontal)
               {
                  changeByPx(tracker.mouseY - _mouseY);
               }
               else
               {
                  changeByPx(tracker.mouseX - _mouseX);
               }
               if(tracker.upState.parent)
               {
                  tracker.removeEventListener(Event.ENTER_FRAME,handleMove);
               }
            };
            if(!_horizontal)
            {
               _mouseY = tracker.mouseY;
            }
            else
            {
               _mouseX = tracker.mouseX;
            }
            tracker.addEventListener(Event.ENTER_FRAME,handleMove);
            stage.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void
            {
               tracker.removeEventListener(Event.ENTER_FRAME,handleMove);
               stage.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
            });
         });
         addChild(this.scrollbg);
         addChild(this.tracker);
         addChild(this.decArrow);
         addChild(this.incArrow);
         if(!this._horizontal)
         {
            this.tracker.width = this.pixelSize - 1;
            this.tracker.x = 0;
         }
         else
         {
            this.tracker.height = this.pixelSize - 1;
            this.tracker.y = 0;
         }
         this.redraw();
      }
      
      private function reInit(param1:Boolean) : void
      {
         this._horizontal = param1;
         this.decArrow.setDirection(this._horizontal == true ? 2 : 1,this.pixelSize - 1,this.decScroll);
         this.incArrow.setDirection(this._horizontal == true ? 0 : 3,this.pixelSize - 1,this.decScroll);
         if(!this._horizontal)
         {
            this.tracker.width = this.pixelSize - 1;
            this.tracker.x = 0;
         }
         else
         {
            this.tracker.height = this.pixelSize - 1;
            this.tracker.y = 0;
         }
         this.redraw();
      }
      
      public function get horizontal() : Boolean
      {
         return this._horizontal;
      }
      
      public function set horizontal(param1:Boolean) : void
      {
         this._horizontal = param1;
         this.reInit(param1);
      }
      
      public function changeByPx(param1:Number) : void
      {
         this.scrollValue += this._scrollSize / this.innerSize * param1;
      }
      
      public function decScroll() : void
      {
         this.scrollValue = this._scrollValue - 15;
      }
      
      public function incScroll() : void
      {
         this.scrollValue = this._scrollValue + 15;
      }
      
      public function decScrollJump() : void
      {
         this.scrollValue = this._scrollValue - this._scrollViewable;
      }
      
      public function incScrollJump() : void
      {
         this.scrollValue = this._scrollValue + this._scrollViewable;
      }
      
      public function set scrollSize(param1:Number) : void
      {
         this._scrollSize = param1;
         this._scrollValue = Math.max(Math.min(this._scrollValue,this._scrollSize - this._scrollViewable),0);
      }
      
      public function set scrollViewable(param1:Number) : void
      {
         this._scrollViewable = param1;
         this._scrollValue = Math.max(Math.min(this._scrollValue,this._scrollSize - this._scrollViewable),0);
      }
      
      public function set scrollValue(param1:Number) : void
      {
         if(param1 != this._scrollValue)
         {
            this._scrollValue = Math.max(Math.min(param1,this._scrollSize - this._scrollViewable),0);
            if(this.scrollListener != null)
            {
               this.scrollListener(this._scrollValue);
            }
            this.redraw();
         }
      }
      
      public function get scrollValue() : Number
      {
         return this._scrollValue;
      }
      
      public function scroll(param1:Function) : void
      {
         this.scrollListener = param1;
      }
      
      private function get innerSize() : Number
      {
         if(!this._horizontal)
         {
            return _height - this.pixelSize * 2;
         }
         return _width - this.pixelSize * 2;
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      public function blur() : void
      {
         this.tracker.visible = false;
         this.incArrow.visible = false;
         this.decArrow.visible = false;
         this.scrollbg.visible = false;
      }
      
      public function focus() : void
      {
         this.tracker.visible = true;
         this.incArrow.visible = true;
         this.decArrow.visible = true;
         this.scrollbg.visible = true;
      }
      
      public function refresh() : void
      {
         this.redraw();
      }
      
      override protected function redraw() : void
      {
         if(!this._horizontal)
         {
            this.tracker.height = Math.max(this.innerSize * this._scrollViewable / this._scrollSize,10);
            this.tracker.y = Math.ceil(this.pixelSize + this._scrollValue / (this._scrollSize - this._scrollViewable) * (this.innerSize - this.tracker.height + 2));
            this.scrollbg.width = this.pixelSize - 1;
            this.scrollbg.height = _height;
            this.incArrow.y = _height - this.pixelSize + 2;
            this.incArrow.x = 0;
         }
         else
         {
            this.tracker.width = Math.max(this.innerSize * this._scrollViewable / this._scrollSize,10);
            this.tracker.x = Math.ceil(this.pixelSize + this._scrollValue / (this._scrollSize - this._scrollViewable) * (this.innerSize - this.tracker.width + 2));
            this.scrollbg.height = this.pixelSize - 1;
            this.scrollbg.width = _width;
            this.incArrow.x = _width - this.pixelSize + 2;
            this.incArrow.y = 0;
         }
      }
   }
}


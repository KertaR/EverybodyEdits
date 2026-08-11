package sample.ui.components
{
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SampleButton extends SimpleButton
   {
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _clickHandler:Function;
      
      public function SampleButton(param1:Function = null)
      {
         var clickHandler:Function = param1;
         super();
         this._clickHandler = function():void
         {
            if(clickHandler != null)
            {
               clickHandler();
            }
         };
         if(this._clickHandler != null)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
            addEventListener(Event.REMOVED_FROM_STAGE,this.handleDetatch);
         }
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            var cache:DisplayObject = null;
            var e:MouseEvent = param1;
            cache = overState;
            overState = downState;
            stage.addEventListener(MouseEvent.MOUSE_UP,function(param1:Event):void
            {
               overState = cache;
               stage.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
            });
         });
         this.redraw();
      }
      
      public function handleAttach(param1:Event) : void
      {
         addEventListener(MouseEvent.CLICK,this._clickHandler);
      }
      
      public function handleDetatch(param1:Event) : void
      {
         removeEventListener(MouseEvent.CLICK,this._clickHandler);
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this.redraw();
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
         this.redraw();
      }
      
      protected function redraw() : void
      {
         if(this.upState)
         {
            this.upState.width = this._width;
            this.upState.height = this._height;
         }
         if(this.downState)
         {
            this.downState.width = this._width;
            this.downState.height = this._height;
         }
         if(this.overState)
         {
            this.overState.width = this._width;
            this.overState.height = this._height;
         }
         if(this.hitTestState)
         {
            this.hitTestState.width = this._width;
            this.hitTestState.height = this._height;
         }
      }
   }
}


package sample.ui.components.scroll
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import sample.ui.components.Box;
   import sample.ui.components.SampleButton;
   
   public class ScrollButton extends SampleButton
   {
      
      public function ScrollButton(param1:int = 0, param2:int = 20, param3:Function = null)
      {
         var direction:int = param1;
         var size:int = param2;
         var clickHandler:Function = param3;
         super();
         this.upState = new Box().margin(0,0,0,0).fill(0,1,3).minSize(size,size).add(new Box().add(this.drawArrow(16777215,size / 3,direction)));
         this.downState = new Box().margin(0,0,0,0).fill(16777215,1,3).minSize(size,size).add(new Box().add(this.drawArrow(8947848,size / 3,direction)));
         this.overState = new Box().margin(0,0,0,0).fill(16777215,1,3).minSize(size,size).add(new Box().add(this.drawArrow(0,size / 3,direction)));
         this.hitTestState = new Box().margin(0,0,0,0).fill(0,1,3).minSize(size,size).add(new Box().add(this.drawArrow(16777215,size / 3,direction)));
         if(clickHandler != null)
         {
            this.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               var n:int;
               var i:Number = NaN;
               var e:MouseEvent = param1;
               clickHandler();
               n = 0;
               i = setInterval(function():void
               {
                  if(e.target.upState.parent)
                  {
                     clearInterval(i);
                     return;
                  }
                  if(Boolean(e.target.downState.parent) && n++ > 5)
                  {
                     clickHandler();
                  }
               },50);
               e.target.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void
               {
                  clearInterval(i);
                  param1.target.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
               });
            });
         }
      }
      
      private function drawArrow(param1:int, param2:int, param3:int = 0) : Sprite
      {
         var _loc4_:Sprite = new Sprite();
         var _loc5_:Graphics = _loc4_.graphics;
         var _loc6_:Number = Math.PI / 2 * param3;
         _loc5_.beginFill(param1,1);
         _loc5_.moveTo(Math.cos(2.0943 - _loc6_) * param2 + param2,Math.sin(2.0943 - _loc6_) * param2 + param2);
         _loc5_.lineTo(Math.cos(4.18879 - _loc6_) * param2 + param2,Math.sin(4.18879 - _loc6_) * param2 + param2);
         _loc5_.lineTo(Math.cos(-_loc6_) * param2 + param2,Math.sin(-_loc6_) * param2 + param2);
         return _loc4_;
      }
      
      public function setDirection(param1:int = 0, param2:int = 20, param3:Function = null) : void
      {
         this.upState = new Box().margin(0,0,0,0).fill(0,1,3).minSize(param2,param2).add(new Box().add(this.drawArrow(16777215,param2 / 3,param1)));
         this.downState = new Box().margin(0,0,0,0).fill(16777215,1,3).minSize(param2,param2).add(new Box().add(this.drawArrow(8947848,param2 / 3,param1)));
         this.overState = new Box().margin(0,0,0,0).fill(16777215,1,3).minSize(param2,param2).add(new Box().add(this.drawArrow(0,param2 / 3,param1)));
         this.hitTestState = new Box().margin(0,0,0,0).fill(0,1,3).minSize(param2,param2).add(new Box().add(this.drawArrow(16777215,param2 / 3,param1)));
      }
   }
}


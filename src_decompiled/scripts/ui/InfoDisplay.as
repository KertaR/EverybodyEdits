package ui
{
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import sample.ui.components.Label;
   
   public class InfoDisplay extends Sprite
   {
      
      private var _timer:Timer;
      
      public function InfoDisplay(param1:String, param2:String)
      {
         super();
         var _loc3_:Label = new Label(param1,14,"left",16777215,false,"system");
         _loc3_.x = (400 - _loc3_.width) / 2;
         _loc3_.y = 10;
         addChild(_loc3_);
         var _loc4_:Label = new Label(param2,8,"center",16777215,true,"system");
         _loc4_.thickness = -200;
         _loc4_.sharpness = -400;
         _loc4_.width = 400 - 20;
         _loc4_.x = (400 - _loc4_.width) / 2;
         _loc4_.y = _loc3_.y + _loc3_.height;
         addChild(_loc4_);
         var _loc5_:int = _loc4_.y + _loc4_.height + 10;
         graphics.lineStyle(1,10066329);
         graphics.beginFill(3355443);
         graphics.drawRoundRect(0,0,400,_loc5_,5,5);
         graphics.endFill();
         this._timer = new Timer(5 * 1000,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timer.start();
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         Global.base.hideInfoDisplay();
         this._timer.stop();
      }
      
      public function get timer() : Timer
      {
         return this._timer;
      }
   }
}


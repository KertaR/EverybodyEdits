package ui.campaigns
{
   import flash.display.Sprite;
   
   public class TimesInfo extends Sprite
   {
      
      private static const SIDES:Number = 8;
      
      private static const SPACE:Number = 8;
      
      private static const ABOVE:Number = 7;
      
      public function TimesInfo()
      {
         super();
      }
      
      public function displayTimes(param1:Array, param2:int = -1, param3:int = 0) : void
      {
         removeChildren();
         graphics.clear();
         var _loc4_:Vector.<ClockTime> = ClockTime.pickFour(param1,param2,param3);
         _loc4_[0].x = SIDES;
         _loc4_[0].y = ABOVE;
         addChild(_loc4_[0]);
         _loc4_[1].x = Math.round(_loc4_[0].x + _loc4_[0].width) + SPACE;
         _loc4_[1].y = ABOVE;
         addChild(_loc4_[1]);
         _loc4_[2].x = Math.round(_loc4_[1].x + _loc4_[1].width) + SPACE;
         _loc4_[2].y = ABOVE;
         addChild(_loc4_[2]);
         _loc4_[3].x = Math.round(_loc4_[2].x + _loc4_[2].width) + SPACE;
         _loc4_[3].y = ABOVE;
         addChild(_loc4_[3]);
         graphics.beginFill(8092539);
         graphics.drawRect(Math.round(_loc4_[3].x + _loc4_[3].width) + SIDES,0,1,28);
      }
   }
}


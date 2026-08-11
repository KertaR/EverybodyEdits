package ui.campaigns
{
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import sample.ui.components.Label;
   
   public class ClockTime extends Sprite
   {
      
      public var clock:Clock;
      
      public var label:Label;
      
      private var _time:int;
      
      public function ClockTime(param1:Object)
      {
         super();
         this.clock = new Clock(param1.rank);
         addChild(this.clock);
         this.label = new Label("",8,"left",16777215,false,"system");
         this.label.x = this.clock.width + 2;
         this.label.y = 1;
         addChild(this.label);
         this.time = param1.time;
         this.rank = param1.rank;
      }
      
      public static function format(param1:int) : String
      {
         if(param1 < 0)
         {
            return "(not set)";
         }
         var _loc2_:Number = Math.floor(param1 / 100);
         var _loc3_:Number = Math.floor(_loc2_ / 60);
         var _loc4_:String = "";
         var _loc5_:Number = Math.floor(_loc3_ / 60);
         if(_loc5_ > 0)
         {
            _loc4_ += _loc5_ + ":";
         }
         var _loc6_:Number = _loc3_ % 60;
         if(_loc6_ < 10)
         {
            _loc4_ += "0";
         }
         _loc4_ += _loc6_ + ":";
         var _loc7_:Number = _loc2_ % 60;
         if(_loc7_ < 10)
         {
            _loc4_ += "0";
         }
         _loc4_ += _loc7_ + ".";
         var _loc8_:Number = param1 % 100;
         if(_loc8_ < 10)
         {
            _loc4_ += "0";
         }
         return _loc4_ + _loc8_;
      }
      
      public static function rankColor(param1:int) : uint
      {
         return param1 == 5 ? 16756214 : (param1 == 4 ? 12713215 : (param1 == 3 ? 16764525 : (param1 == 2 ? 16774383 : (param1 == 1 ? 16748937 : 4259648))));
      }
      
      public static function pickFour(param1:Array, param2:int = -1, param3:int = 0) : Vector.<ClockTime>
      {
         var clocks:Vector.<ClockTime>;
         var targetTimes:Array = param1;
         var time:int = param2;
         var rank:int = param3;
         var times:Array = targetTimes.map(function(param1:int, param2:int, param3:Array):Object
         {
            return {
               "rank":param2 + 1,
               "time":param1
            };
         });
         times.insertAt(rank,{
            "rank":0,
            "time":time
         });
         clocks = new Vector.<ClockTime>();
         clocks.push(new ClockTime(times[times.length - 4]));
         clocks.push(new ClockTime(times[times.length - 3]));
         clocks.push(new ClockTime(times[times.length - 2]));
         clocks.push(new ClockTime(times[times.length - 1]));
         return clocks;
      }
      
      public function get rank() : int
      {
         return this.clock.rank;
      }
      
      public function set rank(param1:int) : void
      {
         this.clock.rank = param1;
         this.label.textColor = rankColor(this.clock.rank);
         this.label.width = this.label.textWidth + 4;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(param1:int) : void
      {
         this._time = param1;
         this.label.text = format(param1);
      }
   }
}


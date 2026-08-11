package ui.ingame
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import items.ItemId;
   import items.ItemManager;
   
   public class EffectMarker extends Sprite
   {
      
      public static const HEIGHT:int = 24;
      
      public static const WIDTH_WITH_TIMER:int = 30;
      
      public static const WIDTH_WITHOUT_TIMER:int = 24;
      
      private static const TIMEBAR_MARGIN:int = 3;
      
      private static const TIMEBAR_WIDTH:int = 4;
      
      private static const TIMEBAR_HEIGHT:int = HEIGHT - 2 * TIMEBAR_MARGIN;
      
      private var WIDTH:int;
      
      private var _id:int;
      
      private var timer:Sprite;
      
      private var startDate:Date;
      
      private var duration:Number;
      
      public function EffectMarker(param1:BitmapData, param2:int, param3:Number = 0, param4:Number = 0)
      {
         var _loc5_:Bitmap = null;
         var _loc6_:BitmapData = null;
         var _loc7_:BitmapData = null;
         var _loc8_:BitmapData = null;
         super();
         this._id = param2;
         this.duration = param4;
         this.startDate = new Date();
         this.startDate.time -= (param4 - param3) * 1000;
         if(param2 == ItemId.EFFECT_GRAVITY)
         {
            _loc6_ = new BitmapData(16,16);
            ItemManager.sprGravityEffect.drawPoint(_loc6_,new Point(0,0),param3);
            _loc5_ = new Bitmap(_loc6_.clone());
         }
         else if(param2 == ItemId.EFFECT_JUMP)
         {
            _loc7_ = new BitmapData(16,16);
            ItemManager.sprEffect.drawPoint(_loc7_,new Point(0,0),[7,0,22][param3]);
            _loc5_ = new Bitmap(_loc7_.clone());
         }
         else if(param2 == ItemId.EFFECT_RUN)
         {
            _loc8_ = new BitmapData(16,16);
            ItemManager.sprEffect.drawPoint(_loc8_,new Point(0,0),[9,2,25][param3]);
            _loc5_ = new Bitmap(_loc8_.clone());
         }
         else
         {
            _loc5_ = new Bitmap(param1.clone());
         }
         _loc5_.x = _loc5_.y = (HEIGHT - _loc5_.width) / 2 >> 0;
         addChild(_loc5_);
         this.WIDTH = param4 == 0 ? WIDTH_WITHOUT_TIMER : WIDTH_WITH_TIMER;
         graphics.beginFill(13421772,0.75);
         graphics.drawRect(0,0,this.WIDTH,HEIGHT);
         graphics.beginFill(0,0.75);
         graphics.drawRect(1,1,this.WIDTH - 2,HEIGHT - 2);
         if(param4 > 0)
         {
            this.timer = new Sprite();
            addChild(this.timer);
         }
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get timeLeft() : Number
      {
         return new Date().time - (this.startDate.time + this.duration * 1000);
      }
      
      public function get progress() : Number
      {
         if(this.duration == 0)
         {
            return 0;
         }
         return Math.max(0,Math.min((new Date().time - this.startDate.time) / (this.duration * 1000),1));
      }
      
      public function refresh() : void
      {
         if(this.duration == 0)
         {
            return;
         }
         this.setProgress(this.progress);
      }
      
      private function setProgress(param1:Number) : void
      {
         this.timer.x = this.WIDTH - TIMEBAR_WIDTH - TIMEBAR_MARGIN;
         this.timer.y = TIMEBAR_MARGIN;
         this.timer.graphics.clear();
         this.timer.graphics.beginFill(13421772,1);
         this.timer.graphics.drawRect(0,0,TIMEBAR_WIDTH,TIMEBAR_HEIGHT);
         this.timer.graphics.beginFill(65280,1);
         this.timer.graphics.drawRect(1,1,TIMEBAR_WIDTH - 2,TIMEBAR_HEIGHT - 2);
         this.timer.graphics.beginFill(0,1);
         this.timer.graphics.drawRect(1,1,TIMEBAR_WIDTH - 2,TIMEBAR_HEIGHT - 2 - (TIMEBAR_HEIGHT - 2) * (1 - param1));
      }
   }
}


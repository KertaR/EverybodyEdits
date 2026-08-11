package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Timer;
   import playerio.DatabaseObject;
   
   public class WorldPortalHelpBubble
   {
      
      protected var helpimage:Class = WorldPortalHelpBubble_helpimage;
      
      private var BMDhelpimage:BitmapData = new this.helpimage().bitmapData;
      
      private var worldname_timer:Timer;
      
      private var bmd:BitmapData;
      
      private var cachedIDs:Object;
      
      private var id:String = "";
      
      private var text:String = "";
      
      private var target:int = 0;
      
      private var isGod:Boolean = false;
      
      public function WorldPortalHelpBubble()
      {
         super();
         this.worldname_timer = new Timer(1000,1);
         this.worldname_timer.addEventListener(TimerEvent.TIMER,this.loadWorldName,false,0,true);
         this.cachedIDs = new Object();
         this.cachedIDs[""] = "No such world";
         this.updateGraphic();
      }
      
      public function updateGraphic() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TextField = null;
         _loc1_ = new Sprite();
         _loc2_ = new TextField();
         _loc2_.y = this.BMDhelpimage.height + 10 + 4;
         _loc2_.multiline = true;
         _loc2_.selectable = false;
         _loc2_.wordWrap = false;
         _loc2_.width = 75;
         _loc2_.height = 50;
         _loc2_.antiAliasType = AntiAliasType.ADVANCED;
         _loc2_.autoSize = TextFieldAutoSize.CENTER;
         var _loc3_:TextFormat = new TextFormat("Tahoma",9,16777215);
         _loc3_.align = TextFormatAlign.CENTER;
         _loc2_.defaultTextFormat = _loc3_;
         if(this.text != "")
         {
            _loc2_.appendText(this.text + "\n");
         }
         if(this.isGod)
         {
            if(this.target == 0)
            {
               _loc2_.appendText("Default spawn\n");
            }
            else
            {
               _loc2_.appendText("Spawn " + this.target + "\n");
            }
         }
         _loc2_.appendText("Press Y to Enter");
         var _loc4_:Number = Math.max(_loc2_.width + 6,90);
         var _loc5_:Number = Math.max(_loc2_.y + _loc2_.height,30);
         _loc2_.x = (_loc4_ - _loc2_.width) / 2 >> 0;
         _loc1_.addChild(_loc2_);
         var _loc6_:Sprite = new Sprite();
         var _loc7_:String = GradientType.LINEAR;
         var _loc8_:Array = [0,0];
         var _loc9_:Array = [0.5,0.3];
         var _loc10_:Array = [0,255];
         var _loc11_:Matrix = new Matrix();
         _loc11_.createGradientBox(20,_loc5_ + 3,Math.PI / 2,0,0);
         var _loc12_:String = SpreadMethod.PAD;
         _loc6_.graphics.beginGradientFill(_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_);
         _loc6_.graphics.lineStyle(0,16777215);
         _loc6_.graphics.moveTo(0,0);
         _loc6_.graphics.lineTo(_loc4_,0);
         _loc6_.graphics.lineTo(_loc4_,_loc5_ + 3);
         _loc6_.graphics.lineTo(_loc4_ / 2 + 3,_loc5_ + 3);
         _loc6_.graphics.lineTo(_loc4_ / 2,_loc5_ + 10);
         _loc6_.graphics.lineTo(_loc4_ / 2 - 3,_loc5_ + 3);
         _loc6_.graphics.lineTo(0,_loc5_ + 3);
         _loc6_.graphics.lineTo(0,0);
         _loc6_.graphics.lineStyle(0,0);
         _loc1_.addChildAt(_loc6_,0);
         var _loc13_:Sprite = new Sprite();
         _loc13_.x = 1;
         var _loc14_:BitmapData = new BitmapData(_loc6_.width,_loc6_.height,true,0);
         _loc14_.draw(_loc6_);
         _loc13_.addChild(new Bitmap(_loc14_));
         var _loc15_:GlowFilter = new GlowFilter(0,0.5,4,4,3,3,false,true);
         _loc13_.filters = [_loc15_];
         _loc1_.addChildAt(_loc13_,0);
         this.bmd = new BitmapData(_loc1_.width + 4,_loc1_.height + 4,true,0);
         this.bmd.draw(_loc1_);
         var _loc16_:Matrix = new Matrix();
         _loc16_.translate((_loc4_ - this.BMDhelpimage.width) / 2,10);
         this.bmd.draw(this.BMDhelpimage,_loc16_);
      }
      
      private function loadWorldNameWithDelay() : void
      {
         if(this.worldname_timer.running)
         {
            this.worldname_timer.reset();
         }
         if(this.id != "")
         {
            this.text = "Loading...";
            this.worldname_timer.start();
         }
         else
         {
            this.text = "No such world";
         }
         this.updateGraphic();
      }
      
      private function loadWorldName(param1:Event = null) : void
      {
         var loadId:String = null;
         var e:Event = param1;
         if(this.id == "")
         {
            return;
         }
         loadId = this.id;
         Global.base.client.bigDB.load("Worlds",loadId,function(param1:DatabaseObject):void
         {
            var _loc2_:String = null;
            if(param1 == null)
            {
               _loc2_ = "No such world";
            }
            else if(param1.name == null)
            {
               _loc2_ = "Untitled world";
            }
            else
            {
               _loc2_ = param1.name;
            }
            cachedIDs[loadId] = _loc2_;
            if(loadId == id)
            {
               text = _loc2_;
               updateGraphic();
            }
         });
      }
      
      public function update(param1:WorldPortal, param2:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc3_:Boolean = false;
         if(param1.id != this.id)
         {
            this.id = param1.id;
            _loc4_ = this.cachedIDs[this.id];
            if(_loc4_ != null)
            {
               this.text = _loc4_;
               _loc3_ = true;
            }
            else
            {
               this.loadWorldNameWithDelay();
            }
         }
         if(param1.target != this.target)
         {
            this.target = param1.target;
            if(param2)
            {
               _loc3_ = true;
            }
         }
         if(this.isGod != param2)
         {
            this.isGod = param2;
            _loc3_ = true;
         }
         if(_loc3_)
         {
            this.updateGraphic();
         }
      }
      
      public function drawPoint(param1:BitmapData, param2:Point, param3:int = 0) : void
      {
         var _loc4_:int = this.bmd.rect.width;
         var _loc5_:int = this.bmd.rect.height;
         var _loc6_:int = (_loc4_ / 2 >> 0) - 12;
         var _loc7_:int = _loc5_ - 2;
         var _loc8_:Point = param2.subtract(new Point(_loc6_,_loc7_));
         param1.copyPixels(this.bmd,this.bmd.rect,_loc8_);
      }
   }
}


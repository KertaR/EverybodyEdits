package ui.campaigns
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import sample.ui.components.Box;
   import sample.ui.components.Label;
   
   public class CampaignWorld extends Sprite
   {
      
      public var worldImage:Bitmap;
      
      public var main:Box;
      
      private var wImage:Loader;
      
      private var _lock:Bitmap;
      
      public var _check:Bitmap;
      
      public var checkVisible:Boolean = true;
      
      private var _locked:Boolean;
      
      private var _complete:Boolean;
      
      private var _lockedCampaign:Boolean;
      
      private var _worldName:String;
      
      private var worldOwner:String;
      
      private var _worldId:String;
      
      private var tierInfo:String;
      
      private var _imageLink:String;
      
      private var worldWidth:int;
      
      private var worldHeight:int;
      
      private var difficulty:int;
      
      private var _tier:int;
      
      private var label:Label;
      
      private var byLabel:Label;
      
      private var tierLabel:Label;
      
      private var _rewards:Array;
      
      public var rewards:Box;
      
      public var trialsEnabled:Boolean;
      
      public var time:int;
      
      public var rank:int;
      
      public var targetTimes:Array;
      
      public var times:Sprite;
      
      private var imageLoaded:Function;
      
      public function CampaignWorld(param1:String, param2:String, param3:String, param4:int, param5:int, param6:int, param7:String, param8:Array, param9:Function, param10:Array = null, param11:int = -1, param12:int = 0)
      {
         var miniLoading:assets_miniloading = null;
         var loader:Loader = null;
         var worldId:String = param1;
         var name:String = param2;
         var owner:String = param3;
         var diff:int = param4;
         var tier:int = param5;
         var status:int = param6;
         var imageLink:String = param7;
         var rewards:Array = param8;
         var imageLoadedCallback:Function = param9;
         var targetTimes:Array = param10;
         var time:int = param11;
         var rank:int = param12;
         this.rewards = new Box();
         this.times = new Sprite();
         super();
         this.main = new Box();
         this.main.border(1,10066329,1);
         this.main.fill(1118481,1,5);
         this.main.buttonMode = true;
         addChild(this.main);
         this._locked = status == -1;
         this._complete = status == 1;
         this._lockedCampaign = status == 3;
         this._worldName = name;
         this._worldId = worldId;
         this.worldOwner = owner;
         this.difficulty = diff;
         this.worldWidth = 200;
         this.worldHeight = 200;
         this._imageLink = imageLink;
         this._tier = tier;
         this._rewards = rewards;
         this.trialsEnabled = this.trialsEnabled;
         this.time = time;
         this.rank = rank;
         this.targetTimes = targetTimes;
         this.label = new Label(this._worldName + "\nBy: " + this.worldOwner,12,"left",16777215,false,"visitor");
         this.label.x = 2;
         this.label.y = 3;
         this.main.width = this.label.width > this.worldWidth ? this.label.width : this.worldWidth + 6;
         this.main.height = this.worldHeight;
         this.main.addChild(this.label);
         miniLoading = new assets_miniloading();
         miniLoading.x = this.width - miniLoading.width + 10;
         miniLoading.y = this.height - miniLoading.height - 10;
         this.main.addChild(miniLoading);
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            main.removeChild(miniLoading);
            worldImage = new Bitmap(new BitmapData(loader.width > 305 ? 305 : int(loader.width),loader.height > 117 ? 117 : int(loader.height)));
            worldImage.bitmapData.draw(Bitmap(loader.content));
            main.removeChild(label);
            wImage = loader;
            worldWidth = wImage.width;
            worldHeight = wImage.height;
            main.width = label.width > wImage.width ? label.width : wImage.width + 6;
            main.height = wImage.height + 28;
            main.addChild(label);
            wImage.x = (main.width - wImage.width) / 2;
            wImage.y = (main.height - wImage.height) / 2 + label.height - 10;
            main.addChild(wImage);
            if(imageLoaded != null)
            {
               imageLoaded(worldImage);
            }
            if(_locked)
            {
               _lock = new Bitmap(CampaignItem.lockImage,"auto",true);
               _lock.height = wImage.height / 2 > 100 ? 100 : wImage.height / 2;
               _lock.width = _lock.height;
               _lock.x = wImage.x + (wImage.width - _lock.width) / 2;
               _lock.y = wImage.y + (wImage.height - _lock.height) / 2;
               main.addChild(_lock);
               wImage.alpha = 0.25;
            }
            if(_complete)
            {
               AddCheckMark(false);
            }
            drawRewards();
            positionTimes();
            imageLoadedCallback();
         });
         loader.load(new URLRequest(Config.site + "/Campaigns/" + worldId + ".png"));
         this.positionTimes();
      }
      
      public function positionTimes() : void
      {
         this.times.y = this.main.height + 2;
         this.times.x = Math.max(0,Math.round((this.main.width - this.times.width) / 2));
      }
      
      public function setImageLoadedCallback(param1:Function) : void
      {
         this.imageLoaded = param1;
      }
      
      private function drawRewards() : void
      {
         var _loc6_:CampaignReward = null;
         addChild(this.rewards);
         var _loc1_:int = this.main.height + 10;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._rewards.length)
         {
            if(this._rewards[_loc3_].type.substring(0,5) != "world")
            {
               _loc2_ += this._rewards[_loc3_].width;
            }
            _loc3_++;
         }
         var _loc4_:int = (this.width - _loc2_) / 2 + 6;
         var _loc5_:int = 0;
         while(_loc5_ < this._rewards.length)
         {
            _loc6_ = this._rewards[_loc5_];
            if(_loc6_ != null)
            {
               if(_loc6_.type.substring(0,5) != "world")
               {
                  _loc6_.y = _loc1_;
                  _loc6_.x = _loc4_ - _loc6_.getRect(_loc6_).left;
                  _loc4_ += _loc6_.width;
               }
               else
               {
                  _loc6_.y = _loc1_ + 55;
                  _loc6_.x = (this.width - _loc6_.width) / 2 + 5;
               }
               this.rewards.addChild(_loc6_);
            }
            _loc5_++;
         }
      }
      
      public function getFirstReward() : CampaignReward
      {
         if(this._rewards.length > 0)
         {
            return this._rewards[0] as CampaignReward;
         }
         return null;
      }
      
      private function AddCheckMark(param1:Boolean) : void
      {
         this._check = new Bitmap(CampaignItem.checkImage,"auto",true);
         this._check.width = param1 ? this.wImage.height : (this.wImage.height / 2 > 100 ? 100 : this.wImage.height / 2);
         this._check.height = param1 ? this.wImage.height : (this.wImage.height / 2 > 100 ? 100 : this.wImage.height / 2);
         this._check.x = this.wImage.x + (this.wImage.width - this._check.width) / 2;
         this._check.y = this.wImage.y + (this.wImage.height - this._check.height) / 2;
         this._check.alpha = param1 ? 0 : 1;
         this._check.visible = this.checkVisible;
         this.main.addChild(this._check);
         if(param1)
         {
            TweenMax.to(this._check,0.3,{
               "x":this.wImage.x + (this.wImage.width - this._check.width) / 2,
               "y":this.wImage.y + (this.wImage.height - this._check.height) / 2,
               "width":100,
               "height":100,
               "alpha":1
            });
         }
      }
      
      private function Unlock() : void
      {
         TweenMax.to(this._lock,0.3,{
            "x":this.wImage.x + (this.wImage.width - this._lock.width + 10) / 2,
            "y":this.wImage.y + (this.wImage.height - this._lock.height + 10) / 2,
            "width":this._lock.width + 10,
            "height":this._lock.height + 10,
            "onComplete":function():void
            {
               TweenMax.to(_lock,0.2,{
                  "x":wImage.x + (wImage.width - 10) / 2,
                  "y":wImage.y + (wImage.height - 10) / 2,
                  "width":10,
                  "height":10,
                  "alpha":0,
                  "onComplete":function():void
                  {
                     TweenMax.to(wImage,0.2,{"alpha":1});
                     main.removeChild(_lock);
                  }
               });
            }
         });
      }
      
      public function set complete(param1:Boolean) : void
      {
         this._complete = param1;
         if(this._complete)
         {
            this.AddCheckMark(true);
         }
      }
      
      public function get tier() : int
      {
         return this._tier;
      }
      
      public function get imageLink() : String
      {
         return this._imageLink;
      }
      
      public function get completed() : Boolean
      {
         return this._complete;
      }
      
      public function get worldName() : String
      {
         return this._worldName;
      }
      
      public function get worldId() : String
      {
         return this._worldId;
      }
      
      public function CampaignLocked() : Boolean
      {
         return this._lockedCampaign;
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         this._locked = param1;
         if(this._locked == false)
         {
            this.Unlock();
         }
      }
      
      override public function get width() : Number
      {
         return this.main.width;
      }
      
      override public function get height() : Number
      {
         return this.main.height;
      }
   }
}


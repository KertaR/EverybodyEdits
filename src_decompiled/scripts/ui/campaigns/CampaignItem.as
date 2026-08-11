package ui.campaigns
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.net.*;
   import flash.utils.setInterval;
   import sample.ui.components.Label;
   
   public class CampaignItem extends Sprite
   {
      
      protected static var Lock:Class = CampaignItem_Lock;
      
      public static var lockImage:BitmapData = new Lock().bitmapData;
      
      protected static var Check:Class = CampaignItem_Check;
      
      public static var checkImage:BitmapData = new Check().bitmapData;
      
      private var _campaignWorlds:Array = [];
      
      private var imageId:int;
      
      private var _title:String;
      
      private var _id:String;
      
      public var _check:Bitmap;
      
      private var _lock:Bitmap;
      
      private var image:Bitmap;
      
      private var _comp:Boolean;
      
      private var _diff:int;
      
      private var _locked:Boolean;
      
      private var _hidden:Boolean;
      
      private var _campaignName:Label;
      
      private var _campaignDescription:Label;
      
      private var tierLabel:Label;
      
      private var nameLabel:Label;
      
      private var mapContainer:Sprite;
      
      private var imageMask:Sprite = new Sprite();
      
      private var tierLabelContainer:Sprite;
      
      private var _difficulty:asset_difficulty = new asset_difficulty();
      
      private var innerGlow:GlowFilter;
      
      public var clock:Clock;
      
      public function CampaignItem(param1:String, param2:String, param3:String, param4:int, param5:Boolean, param6:Boolean, param7:Boolean)
      {
         super();
         graphics.lineStyle(1,10066329);
         graphics.beginFill(1118481,1);
         graphics.drawRoundRect(0,0,330,200,5,5);
         graphics.endFill();
         this.imageMask.graphics.beginFill(16777215,1);
         this.imageMask.graphics.drawRect(0,0,306,117);
         this.imageMask.graphics.endFill();
         this.mapContainer = new Sprite();
         this.mapContainer.x = 12;
         this.mapContainer.y = 70;
         this.mapContainer.graphics.lineStyle(1,10066329);
         this.mapContainer.graphics.beginFill(0,1);
         this.mapContainer.graphics.drawRoundRect(0,0,306,118,5,5);
         this.mapContainer.graphics.endFill();
         this.tierLabelContainer = new Sprite();
         this.tierLabelContainer.x = this.mapContainer.x + 1;
         this.tierLabelContainer.y = this.mapContainer.y + (this.mapContainer.height - 33) / 2;
         this.tierLabelContainer.graphics.beginFill(0,0.5);
         this.tierLabelContainer.graphics.drawRect(0,0,this.mapContainer.width - 2,33);
         this.tierLabelContainer.graphics.endFill();
         this.tierLabel = new Label("",8,"left",16777215,false,"system");
         this.tierLabel.width = this.tierLabelContainer.width;
         this.tierLabel.x = (this.tierLabelContainer.width - this.tierLabel.width) / 2;
         this.tierLabel.y = 4;
         this.tierLabelContainer.addChild(this.tierLabel);
         this.nameLabel = new Label("",8,"left",16777215,false,"system");
         this.nameLabel.width = this.tierLabelContainer.width;
         this.nameLabel.x = (this.tierLabelContainer.width - this.nameLabel.width) / 2;
         this.nameLabel.y = this.tierLabel.y + this.tierLabel.height - 3;
         this.tierLabelContainer.addChild(this.nameLabel);
         buttonMode = true;
         this._id = param1;
         this._title = param2;
         this._comp = param5;
         this._diff = param4;
         this._locked = !param6;
         this._hidden = param7;
         this._campaignName = new Label(param2,14,"left",16777215,false,"system");
         this._campaignName.x = (330 - this._campaignName.width) / 2;
         this._campaignName.y = 8;
         addChild(this._campaignName);
         this._campaignDescription = new Label(param3,8,"center",8947848,true,"system");
         this._campaignDescription.width = 320;
         this._campaignDescription.x = (330 - this._campaignDescription.width) / 2;
         this._campaignDescription.y = 27;
         addChild(this._campaignDescription);
         this._difficulty.gotoAndStop(param4 + 1);
         this._difficulty.y = this.mapContainer.y + this.mapContainer.height + this._difficulty.height - 1;
         this._difficulty.x = 330 / 2;
         addChild(this._difficulty);
         var _loc8_:Sprite = new Sprite();
         _loc8_.mouseChildren = false;
         _loc8_.buttonMode = true;
         _loc8_.addChild(this._campaignName);
         _loc8_.addChild(this._campaignDescription);
         _loc8_.addChild(this.mapContainer);
         _loc8_.addChild(this.tierLabelContainer);
         addChild(_loc8_);
         this.innerGlow = new GlowFilter();
         this.innerGlow.inner = true;
         this.innerGlow.color = 0;
         this.innerGlow.quality = BitmapFilterQuality.HIGH;
         this.innerGlow.blurX = 50;
         this.innerGlow.blurY = 50;
         this.innerGlow.strength = 1.5;
         if(param5)
         {
            this.AddCheckMark(false);
         }
         else if(this._locked)
         {
            this._lock = new Bitmap(lockImage,"auto",true);
            this._lock.width = 100;
            this._lock.height = 100;
            this._lock.x = (width - this._lock.width) / 2;
            this._lock.y = (height - this._lock.height) / 2 + 32;
            this.imageMask.alpha = 0.25;
            addChild(this._lock);
         }
         setInterval(this.StartSlideShow,4000);
      }
      
      public function getFirstWorld() : CampaignWorld
      {
         if(this.campaignWorlds.length > 0)
         {
            return this.campaignWorlds[0] as CampaignWorld;
         }
         return null;
      }
      
      private function StartSlideShow() : void
      {
         if(this.image == null)
         {
            return;
         }
         TweenMax.to(this.image,0.4,{
            "alpha":0,
            "onComplete":function():void
            {
               if(mapContainer.contains(image))
               {
                  mapContainer.removeChild(image);
               }
               if(mapContainer.contains(imageMask))
               {
                  mapContainer.removeChild(imageMask);
               }
               ++imageId;
               if(imageId >= campaignWorlds.length)
               {
                  imageId = 0;
               }
               setImage((campaignWorlds[imageId] as CampaignWorld).worldImage);
            }
         });
      }
      
      private function setImage(param1:Bitmap) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.image = param1;
         if(this.image.height < 100 && this.image.width < 100)
         {
            this.image.width = 100;
            this.image.height = 100;
         }
         this.image.alpha = 0;
         this.image.y = (this.mapContainer.height - this.image.height) / 2;
         this.image.x = (this.mapContainer.width - this.image.width) / 2;
         this.image.mask = this.imageMask;
         this.image.filters = [this.innerGlow];
         this.mapContainer.addChild(this.image);
         this.mapContainer.addChild(this.imageMask);
         this.tierLabel.text = "Tier " + this.campaignWorlds[this.imageId].tier;
         this.tierLabel.x = (this.tierLabelContainer.width - this.tierLabel.width) / 2;
         this.tierLabel.y = 4;
         this.nameLabel.text = this.campaignWorlds[this.imageId].worldName;
         this.nameLabel.x = (this.tierLabelContainer.width - this.nameLabel.width) / 2;
         this.nameLabel.y = this.tierLabel.y + this.tierLabel.height - 3;
         TweenMax.to(this.image,0.4,{"alpha":1});
      }
      
      private function AddCheckMark(param1:Boolean) : void
      {
         this._check = new Bitmap(checkImage,"auto",true);
         this._check.width = param1 ? 200 : 100;
         this._check.height = param1 ? 200 : 100;
         this._check.x = (width - this._check.width) / 2;
         this._check.y = this.mapContainer.y + (this.mapContainer.height - this._check.height) / 2;
         this._check.alpha = param1 ? 0 : 1;
         addChild(this._check);
         if(param1)
         {
            TweenMax.to(this._check,0.3,{
               "x":(width - 100) / 2,
               "y":this.mapContainer.y + (this.mapContainer.height - 100) / 2,
               "width":100,
               "height":100,
               "alpha":1
            });
         }
      }
      
      public function get campaignName() : Label
      {
         return this._campaignName;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get completed() : Boolean
      {
         return this._comp;
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function get hidden() : Boolean
      {
         return this._hidden;
      }
      
      public function get difficulty() : int
      {
         return this._diff;
      }
      
      public function addWorld(param1:CampaignWorld) : void
      {
         var id:int = 0;
         var cWorld:CampaignWorld = param1;
         this.campaignWorlds.push(cWorld);
         id = int(this.campaignWorlds.length);
         cWorld.setImageLoadedCallback(function(param1:Bitmap):void
         {
            if(id == 1)
            {
               setImage(param1);
            }
         });
      }
      
      public function clearWorlds() : void
      {
         this._campaignWorlds = [];
      }
      
      public function get campaignWorlds() : Array
      {
         return this._campaignWorlds;
      }
      
      public function set campaignWorlds(param1:Array) : void
      {
         this._campaignWorlds = param1;
      }
   }
}


package ui.shop
{
   import com.greensock.TweenMax;
   import com.greensock.easing.*;
   import com.greensock.plugins.*;
   import data.ShopItemData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import sample.ui.components.Label;
   import ui.ConfirmPrompt;
   
   public class ShopItem extends assets_newshopitem
   {
      
      private static var bfBM:Class = ShopItem_bfBM;
      
      private static var blackFriday:BitmapData = new bfBM().bitmapData;
      
      private var base_width:Number = 645;
      
      private var base_height:Number = 75;
      
      private var btn_energy:ButtonEnergy;
      
      private var btn_allenergy:ButtonEnergy;
      
      public var energybar:EnergyBar;
      
      private var btn_buy:ButtonBuy;
      
      private var btn_buymoney:ButtonBuy;
      
      private var header:Label;
      
      private var body:Label;
      
      private var count:Label;
      
      private var itemInfo:*;
      
      private var itemInfo2:Label;
      
      private var image:Sprite;
      
      private var imagemask:Sprite;
      
      private var imagebitmap:Sprite;
      
      public var itemdata:ShopItemData;
      
      private var getnow:assets_getnow;
      
      private var buynow:assets_getnow;
      
      private var energyicon:assets_energyicon;
      
      public function ShopItem(param1:ShopItemData, param2:Number, param3:Number)
      {
         super();
         this.itemdata = param1;
         mouseEnabled = false;
         mouseChildren = true;
         this.image = new Sprite();
         addChild(this.image);
         this.imagemask = new Sprite();
         this.imagemask.graphics.beginFill(0);
         this.imagemask.graphics.drawRect(0,0,191,70);
         addChild(this.imagemask);
         this.image.mask = this.imagemask;
         if(param1.image_bitmap != null)
         {
            var _loc4_:Bitmap = new Bitmap(param1.image_bitmap);
            this.imagebitmap = new Sprite();
            this.imagebitmap.addChild(_loc4_);
            this.image.addChild(this.imagebitmap);
         }
         this.image.alpha = 1;
         if(param1.type == ShopItemData.TYPE_SMILEY)
         {
            this.scaleImage(2,0);
            this.applyImageShadow();
            this.image.addEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick,false,0,true);
            this.image.buttonMode = true;
         }
         else if(param1.type == ShopItemData.TYPE_AURA_SHAPE)
         {
            this.scaleImage(2,0);
         }
         else if(param1.type == ShopItemData.TYPE_WORLD)
         {
            this.scaleImage(1,0);
            this.applyImageShadow();
         }
         else if(param1.type == ShopItemData.TYPE_GOLD)
         {
            this.scaleImage(1,0);
            this.applyImageShadow();
         }
         else if(param1.type == ShopItemData.TYPE_NPC)
         {
            this.scaleImage(2,0);
         }
         else
         {
            this.scaleImage(1,0);
         }
         this.image.x = (190 - this.image.width) / 2;
         this.image.y = (this.height - this.image.height) / 2;
         if(param1.priceEnergy > 0)
         {
            this.energybar = new EnergyBar(param1.priceEnergy);
            this.energybar.x = 403.25;
            this.energybar.y = 26.8;
            this.energybar.setEnergy(param1.energyUsed,false);
            addChild(this.energybar);
            this.btn_energy = new ButtonEnergy(param1.priceEnergyClick);
            this.btn_energy.gotoAndStop(1);
            this.btn_energy.addEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick,false,0,true);
            this.btn_energy.x = 416.4;
            this.btn_energy.y = 45.7;
            addChild(this.btn_energy);
            this.btn_allenergy = new ButtonEnergy(-1);
            this.btn_allenergy.gotoAndStop(2);
            this.btn_allenergy.addEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick,false,0,true);
            this.btn_allenergy.x = 495.4;
            this.btn_allenergy.y = 45.7;
            addChild(this.btn_allenergy);
            this.energyicon = new assets_energyicon();
            this.energyicon.x = 405.35;
            this.energyicon.y = 27.6;
            addChild(this.energyicon);
         }
         if(param1.priceGems > 0)
         {
            this.getnow = new assets_getnow();
            this.getnow.gotoAndStop(1);
            this.getnow.x = param1.priceUSD < 0 && param1.priceEnergy < 0 ? divider.x + (this.base_width - divider.x - this.getnow.width) / 2 - 5 : 548.25;
            this.getnow.y = 17.1;
            addChild(this.getnow);
            this.btn_buy = new ButtonBuy(param1.priceGems + " Gem" + (param1.priceGems > 1 ? "s" : ""));
            this.btn_buy.addEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick,false,0,true);
            if(param1.isDollars)
            {
               this.btn_buy.showAsDollars();
            }
            this.btn_buy.x = param1.priceUSD < 0 && param1.priceEnergy < 0 ? divider.x + (this.base_width - divider.x - this.btn_buy.width) / 2 : 557.25;
            this.btn_buy.y = 40.55;
            addChild(this.btn_buy);
         }
         if(param1.priceUSD > 0)
         {
            this.btn_buymoney = new ButtonBuy("" + (param1.priceUSD / 100).toFixed(2));
            this.btn_buymoney.addEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick,false,0,true);
            this.btn_buymoney.x = 436.4;
            this.btn_buymoney.y = this.btn_buy.y;
            this.btn_buymoney.showAsDollars();
            if(!Global.playing_on_kongregate)
            {
               addChild(this.btn_buymoney);
            }
            this.buynow = new assets_getnow();
            this.buynow.gotoAndStop(2);
            this.buynow.x = this.btn_buymoney.x + (this.btn_buymoney.width - this.buynow.width) / 2 - 5;
            this.buynow.y = 17.1;
            if(!Global.playing_on_kongregate)
            {
               addChild(this.buynow);
            }
         }
         if(param1.text_header)
         {
            this.header = new Label(param1.text_header,10,"left",16777215,false,"system");
            this.header.antiAliasType = AntiAliasType.NORMAL;
            this.header.x = 193;
            this.header.y = 2;
            this.header.width = 203;
            addChild(this.header);
         }
         if(param1.label)
         {
            if(param1.label == "blackfriday")
            {
               this.itemInfo = new Bitmap(blackFriday);
            }
            else
            {
               this.itemInfo = new Label(this.setLabelText(param1.label),8,"left",param1.label_color,false,"system");
               this.itemInfo.width = 210;
            }
            this.itemInfo.x = 193;
            this.itemInfo.y = this.header.y + this.header.height;
            addChild(this.itemInfo);
         }
         if(param1.text_body)
         {
            this.body = new Label(param1.text_body,8,"left",8947848,true,"system");
            this.body.x = 193;
            this.body.y = param1.label ? this.itemInfo.y + this.itemInfo.height : this.header.y + this.header.height;
            this.body.width = 203;
            addChild(this.body);
         }
         if(param1.owned_count > 0)
         {
            this.count = new Label("You have: " + param1.owned_count,9,"left",6710886,false,"system");
            if(this.energybar)
            {
               this.count.x = this.energybar.x + (this.energybar.width - this.count.width) / 2 + 15;
               this.count.y = 7;
            }
            else
            {
               this.count.x = this.getnow.x + (this.getnow.width - this.count.width) / 2 + 8;
               this.count.y = 4;
            }
            addChild(this.count);
         }
         if(param1.isPlayerWorldOnly)
         {
            this.itemInfo2 = new Label("(Only for your worlds)",10,"left",5592405,false,"Arial Bold");
            this.itemInfo2.x = this.energybar.x + (this.energybar.width - this.itemInfo2.width) / 2 + 15;
            this.itemInfo2.y = this.btn_energy.y + this.btn_energy.height - 4;
            addChild(this.itemInfo2);
         }
         this.setItemdata(param1);
         Shop.addEventListener(ShopEvent.ITEM_AQUIRED,this.onShopItemsAquired);
      }
      
      private function onShopItemsAquired(param1:ShopEvent) : void
      {
         if(this.itemdata.id == param1.payvaultId)
         {
            this.itemdata.owned = true;
            this.setItemdata(this.itemdata);
         }
      }
      
      public function setItemdata(param1:ShopItemData) : void
      {
         if(this.itemdata.owned)
         {
            param1.owned = true;
         }
         this.itemdata = param1;
         var _loc2_:Boolean = !(param1.owned && !param1.reusable || param1.maxPurchases > 0 && param1.owned_count == param1.maxPurchases);
         if(this.count != null)
         {
            this.count.text = "You have: " + param1.owned_count;
         }
         if(Boolean(this.btn_energy) && _loc2_)
         {
            this.btn_energy.title = "+" + this.itemdata.priceEnergyClick;
            this.btn_energy.alpha = 1;
            this.btn_energy.setEnergy(this.itemdata.energyUsed,this.energybar.getEnergy());
            this.btn_energy.buttonMode = true;
            this.btn_energy.mouseEnabled = true;
         }
         if(this.energybar)
         {
            this.energybar.setEnergy(this.itemdata.energyUsed);
         }
         if(Boolean(this.btn_allenergy) && _loc2_)
         {
            this.btn_allenergy.alpha = 1;
            this.btn_allenergy.buttonMode = true;
            this.btn_allenergy.mouseEnabled = true;
         }
         if(Boolean(this.btn_buy) && _loc2_)
         {
            this.btn_buy.alpha = 1;
            this.btn_buy.buttonMode = true;
            this.btn_buy.mouseEnabled = true;
         }
         if(Boolean(this.btn_buymoney) && _loc2_)
         {
            this.btn_buymoney.alpha = 1;
            this.btn_buymoney.buttonMode = true;
            this.btn_buymoney.mouseEnabled = true;
         }
         if(!_loc2_)
         {
            this.addOwnedLabel();
         }
         if(this.itemdata.priceEnergy > 0 && this.itemdata.energyUsed >= this.itemdata.priceEnergy)
         {
            if(this.btn_energy)
            {
               this.btn_energy.title = "Claim!";
            }
            if(this.btn_allenergy)
            {
               this.btn_allenergy.buttonMode = false;
               this.btn_allenergy.mouseEnabled = false;
               this.btn_allenergy.alpha = 0.5;
            }
            if(this.btn_buy)
            {
               this.btn_buy.buttonMode = false;
               this.btn_buy.mouseEnabled = false;
               this.btn_buy.alpha = 0.5;
            }
            if(this.btn_buymoney)
            {
               this.btn_buymoney.buttonMode = false;
               this.btn_buymoney.mouseEnabled = false;
               this.btn_buymoney.alpha = 0.5;
            }
         }
      }
      
      private function addOwnedLabel() : void
      {
         this.disableBuyButtons();
         var _loc1_:Label = new Label("You got it!",15,"left",16777215,false,"system");
         _loc1_.x = divider.x + (this.base_width - divider.x - _loc1_.width) / 2;
         _loc1_.y = (this.base_height - _loc1_.height) / 2;
         addChild(_loc1_);
      }
      
      protected function scaleImage(param1:Number, param2:Number = 0.2) : void
      {
         var scale:Number = param1;
         var time:Number = param2;
         TweenMax.to(this.image,time,{
            "alpha":1,
            "scaleX":scale,
            "scaleY":scale,
            "onUpdate":function():void
            {
               image.x = (190 - image.width) / 2;
               image.y = (height - image.height) / 2;
            },
            "ease":Back.easeOut
         });
      }
      
      protected function applyImageShadow(param1:Boolean = true) : void
      {
         TweenMax.to(this.image,0.2,{"dropShadowFilter":{
            "blurX":3,
            "blurY":3,
            "distance":3,
            "alpha":0.6
         }});
      }
      
      private function disableBuyButtons() : void
      {
         if(this.buynow)
         {
            this.buynow.alpha = 0.2;
         }
         if(this.energybar)
         {
            this.energybar.alpha = 0.2;
         }
         if(this.energyicon)
         {
            this.energyicon.alpha = 0.2;
         }
         if(this.getnow)
         {
            this.getnow.alpha = 0.2;
         }
         if(this.btn_buy)
         {
            this.btn_buy.alpha = 0.2;
            this.btn_buy.buttonMode = false;
            this.btn_buy.mouseEnabled = false;
            this.btn_buy.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick);
         }
         if(this.btn_allenergy)
         {
            this.btn_allenergy.alpha = this.itemdata.priceEnergy > 0 ? 0.2 : 0;
            this.btn_allenergy.buttonMode = false;
            this.btn_allenergy.mouseEnabled = false;
            this.btn_allenergy.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick);
         }
         if(this.btn_energy)
         {
            this.btn_energy.alpha = this.itemdata.priceEnergy > 0 ? 0.2 : 0;
            this.btn_energy.buttonMode = false;
            this.btn_energy.mouseEnabled = false;
            this.btn_energy.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick);
         }
         if(this.btn_buymoney)
         {
            this.btn_buymoney.alpha = 0.2;
            this.btn_buymoney.buttonMode = false;
            this.btn_buymoney.mouseEnabled = false;
            this.btn_buymoney.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleButtonClick);
         }
      }
      
      protected function handleButtonClick(param1:Event) : void
      {
         var confirm:ConfirmPrompt = null;
         var confirmPrompt:ConfirmPrompt = null;
         var event:Event = param1;
         if(event.target == this.btn_energy)
         {
            this.btn_energy.alpha = 0.2;
            this.btn_energy.buttonMode = false;
            this.btn_energy.mouseEnabled = false;
            dispatchEvent(new ShopItemEvent(ShopItemEvent.USE_ENERGY,true));
         }
         else if(event.target == this.btn_allenergy)
         {
            this.btn_allenergy.alpha = 0.2;
            this.btn_allenergy.buttonMode = false;
            this.btn_allenergy.mouseEnabled = false;
            dispatchEvent(new ShopItemEvent(ShopItemEvent.USE_ALL_ENERGY,true));
         }
         else if(event.target == this.btn_buy)
         {
            confirm = new ConfirmPrompt("Are you sure you want to buy\n" + this.itemdata.text_header + " with gems?",false,null,false);
            Global.base.showOnTop(confirm);
            confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               btn_buy.buttonMode = false;
               btn_buy.mouseEnabled = false;
               dispatchEvent(new ShopItemEvent(ShopItemEvent.BUY_ITEM,true));
               confirm.close();
            });
         }
         else if(event.target == this.btn_buymoney)
         {
            confirmPrompt = new ConfirmPrompt("Are you sure you want to buy\n" + this.itemdata.text_header + " with money?",false,null,false);
            Global.base.showOnTop(confirmPrompt);
            confirmPrompt.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               btn_buymoney.buttonMode = false;
               btn_buymoney.mouseEnabled = false;
               dispatchEvent(new ShopItemEvent(ShopItemEvent.BUY_ITEM_MONEY,true));
               confirmPrompt.close();
            });
         }
         else
         {
            dispatchEvent(new ShopItemEvent(ShopItemEvent.CLICK_ITEM,true));
            if(this.itemdata.type == ShopItemData.TYPE_SMILEY)
            {
               this.scaleImage(this.image.scaleX == 1 ? 2 : 1,0.3);
            }
         }
      }
      
      private function setLabelText(param1:String) : String
      {
         switch(param1)
         {
            case "new":
               return "NEW!";
            case "sale":
               return "SALE!";
            case "sale6":
               return "SAVE $6!";
            case "sale24":
               return "SAVE $24!";
            case "xmas_50":
               return "XMAS SALE SAVE 50%";
            case "xmas_60":
               return "XMAS SALE SAVE 60%";
            case "xmas_75":
               return "XMAS SALE SAVE 75%";
            case "xmas":
               return "XMAS SALE!";
            default:
               return param1;
         }
      }
      
      public function doAddEnergyAnim(param1:Number) : void
      {
         TweenMax.to(this.energybar.masker,0,{"colorTransform":{"brightness":1}});
         TweenMax.from(this.energybar.masker,1,{
            "ease":Sine.easeOut,
            "colorTransform":{"brightness":1.4}
         });
      }
      
      override public function get height() : Number
      {
         return this.base_height;
      }
      
      override public function get width() : Number
      {
         return this.base_width;
      }
   }
}


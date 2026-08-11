package ui.campaigns
{
   import blitter.Bl;
   import com.greensock.*;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import sample.ui.components.Label;
   import states.LobbyStatePage;
   
   public class CampaignComplete extends Sprite
   {
      
      private var currentTier:int;
      
      private var maxTier:int;
      
      private var footerTextSize:int = 17;
      
      private var words:Array = ["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth"];
      
      private var rewards:Array;
      
      private var campaignName:String;
      
      private var imageURL:String;
      
      private var badge:Loader;
      
      private var badge2:Loader;
      
      public function CampaignComplete(param1:String, param2:int, param3:int, param4:Array, param5:String)
      {
         super();
         this.campaignName = param1;
         this.currentTier = param2;
         this.maxTier = param3;
         this.rewards = param4;
         this.imageURL = param5;
         param1 = "CampaignCompleteScreen";
         this.redraw();
      }
      
      private function redraw() : void
      {
         var starburst:assets_lightrotation;
         var headerLabel:Label;
         var footerLabel:Label;
         var itemsUnlockedLabel:Label;
         var totalWidth:int;
         var i:int;
         var j:int;
         var dismissButton:assets_dismiss;
         var headerBox:Sprite = null;
         var footerBox:Sprite = null;
         var loader:Loader = null;
         var myReward:CampaignReward = null;
         var favoriteButton:assets_favorite = null;
         var likeButton:assets_like = null;
         var subButton:assets_subscribesmall = null;
         var blackBG:BlackBG = new BlackBG();
         blackBG.width = 660;
         addChild(blackBG);
         starburst = new assets_lightrotation();
         starburst.alpha = 0;
         starburst.x = (640 - starburst.width) / 2;
         starburst.y = (470 - starburst.height) / 2;
         addChild(starburst);
         this.alphaFade(starburst,0.5,0.75);
         headerBox = new Sprite();
         headerBox.y = -80;
         headerBox.graphics.clear();
         headerBox.graphics.beginFill(2236962,0.85);
         headerBox.graphics.drawRect(0,0,640,57);
         headerBox.graphics.endFill();
         addChild(headerBox);
         TweenMax.to(headerBox,0.5,{"y":27});
         headerLabel = new Label("Congratulations!",30,"left",16777215,false,"system");
         headerLabel.x = 168;
         headerLabel.y = -100;
         addChild(headerLabel);
         TweenMax.to(headerLabel,0.5,{"y":38});
         footerBox = new Sprite();
         footerBox.y = 510;
         footerBox.graphics.clear();
         footerBox.graphics.beginFill(2236962,0.85);
         footerBox.graphics.drawRect(0,0,640,57);
         footerBox.graphics.endFill();
         addChild(footerBox);
         TweenMax.to(footerBox,0.5,{"y":350});
         footerLabel = new Label(this.getFooterText(),14,"left",16777215,false,"system");
         footerLabel.x = (640 - footerLabel.width) / 2;
         footerLabel.y = 510;
         addChild(footerLabel);
         TweenMax.to(footerLabel,0.5,{"y":358});
         itemsUnlockedLabel = new Label("Here are your rewards:",12,"left",16777215,false,"system");
         itemsUnlockedLabel.x = (640 - itemsUnlockedLabel.width) / 2;
         itemsUnlockedLabel.y = 510;
         addChild(itemsUnlockedLabel);
         TweenMax.to(itemsUnlockedLabel,0.5,{"y":383});
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            var worldImage:Loader = null;
            var imageContainer:Sprite = null;
            var text:Label = null;
            var text2:Label = null;
            var e:Event = param1;
            if(currentTier == maxTier - 1)
            {
               badge = loader;
               badge.alpha = 1;
               badge.x = (640 - badge.width) / 2;
               badge.y = (470 - badge.height) / 2;
               addChild(badge);
            }
            else
            {
               worldImage = loader;
               imageContainer = new Sprite();
               imageContainer.graphics.lineStyle(1,16777215,1);
               imageContainer.graphics.drawRect(-1,-1,worldImage.width + 2,worldImage.height + 2);
               imageContainer.x = (640 - worldImage.width) / 2;
               imageContainer.y = headerBox.y + headerBox.height + (footerBox.y - worldImage.height) / 2 - 15;
               imageContainer.buttonMode = true;
               imageContainer.useHandCursor = true;
               imageContainer.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  Global.base.ShowLobby(LobbyStatePage.CAMPAIGN);
               });
               imageContainer.addChild(worldImage);
               addChild(imageContainer);
               text = new Label("You\'ve unlocked tier " + (currentTier + 2) + " of the " + campaignName + " campaign!",12,"left",16777215,false,"system");
               text.x = imageContainer.x + (imageContainer.width - text.width) / 2;
               text.y = imageContainer.y - text.height - 3;
               addChild(text);
               text2 = new Label("(Click to go back to the campaign menu)",8,"left",8947848,false,"system");
               text2.x = imageContainer.x + (imageContainer.width - text2.width) / 2;
               text2.y = imageContainer.y + imageContainer.height + 3;
               addChild(text2);
            }
         });
         loader.load(new URLRequest(Config.site + "/" + this.imageURL));
         totalWidth = 0;
         i = 0;
         while(i < this.rewards.length)
         {
            myReward = this.rewards[i] as CampaignReward;
            addChild(myReward);
            myReward.beginAnimation();
            totalWidth += myReward.width + 10;
            i++;
         }
         j = 0;
         while(j < this.rewards.length)
         {
            if(this.rewards[j] != null)
            {
               this.rewards[j].x = j * 50 + (640 - totalWidth) / 2;
            }
            j++;
         }
         dismissButton = new assets_dismiss();
         dismissButton.alpha = 0;
         dismissButton.x = 3;
         dismissButton.y = 446;
         dismissButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            Global.base.hideCampaignComplete();
         });
         addChild(dismissButton);
         this.alphaFade(dismissButton,0.2,1);
         if(!Bl.data.owner && !Global.player_is_guest)
         {
            favoriteButton = new assets_favorite();
            favoriteButton.buttonMode = true;
            favoriteButton.useHandCursor = true;
            favoriteButton.gotoAndStop(int(Bl.data.inFavorites) + 1);
            favoriteButton.alpha = 0;
            favoriteButton.x = 640 - favoriteButton.width - 5;
            favoriteButton.y = dismissButton.y + dismissButton.height - favoriteButton.height - 5;
            favoriteButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               if(Bl.data.inFavorites)
               {
                  Global.base.removeFromFavorites();
                  favoriteButton.gotoAndStop(1);
                  if(Global.base.favorited)
                  {
                     favoriteButton.buttonMode = false;
                     favoriteButton.useHandCursor = false;
                     favoriteButton.mouseEnabled = false;
                  }
               }
               else
               {
                  Global.base.addToFavorites();
                  favoriteButton.gotoAndStop(2);
               }
            });
            addChild(favoriteButton);
            this.alphaFade(favoriteButton,0.2,1);
            likeButton = new assets_like();
            likeButton.buttonMode = true;
            likeButton.useHandCursor = true;
            likeButton.gotoAndStop(int(Bl.data.liked) + 1);
            likeButton.alpha = 0;
            likeButton.x = favoriteButton.x - likeButton.width - 5;
            likeButton.y = favoriteButton.y;
            likeButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               if(Bl.data.liked)
               {
                  Global.base.removeLike();
                  likeButton.gotoAndStop(1);
                  if(Global.base.liked)
                  {
                     likeButton.buttonMode = false;
                     likeButton.useHandCursor = false;
                     likeButton.mouseEnabled = false;
                  }
               }
               else
               {
                  Global.base.giveLike();
                  likeButton.gotoAndStop(2);
               }
            });
            addChild(likeButton);
            this.alphaFade(likeButton,0.2,1);
            if(Global.currentLevelCrew != "")
            {
               subButton = new assets_subscribesmall();
               subButton.buttonMode = true;
               subButton.useHandCursor = true;
               subButton.gotoAndStop(int(Global.hasSubscribedToCrew) + 1);
               subButton.alpha = 0;
               subButton.x = likeButton.x - subButton.width - 5;
               subButton.y = likeButton.y;
               subButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  if(!Global.hasSubscribedToCrew)
                  {
                     Global.base.requestCrewLobbyMethod("crew" + Global.currentLevelCrew,"subscribe",null,null);
                     subButton.gotoAndStop(2);
                     subButton.buttonMode = false;
                     subButton.useHandCursor = false;
                  }
               });
               addChild(subButton);
               this.alphaFade(subButton,0.2,1);
            }
         }
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
      }
      
      private function getFooterText() : String
      {
         if(this.currentTier != this.maxTier)
         {
            return "You\'ve completed the " + this.words[this.currentTier] + " tier of the " + this.campaignName + " Campaign!";
         }
         return "You\'ve completed the " + this.campaignName + " Campaign!";
      }
      
      private function alphaFade(param1:*, param2:Number, param3:Number) : void
      {
         if(param1.alpha == param3)
         {
            return;
         }
         TweenMax.to(param1,param2,{"alpha":param3});
      }
      
      private function animateBadge() : void
      {
         TweenMax.to(this.badge,0.3,{
            "alpha":1,
            "scaleX":3,
            "scaleY":3,
            "x":(640 - 64 * 3) / 2,
            "y":(500 - 64 * 3) / 2 - 30,
            "onComplete":function():void
            {
               TweenMax.to(badge,0.3,{
                  "scaleX":2,
                  "scaleY":2,
                  "x":(640 - 64 * 2) / 2,
                  "y":(500 - 64 * 2) / 2 - 30,
                  "onComplete":function():void
                  {
                     badge2.alpha = 1;
                     badge2.scaleX = badge.scaleX;
                     badge2.scaleY = badge.scaleY;
                     badge2.x = badge.x;
                     badge2.y = badge.y;
                     TweenMax.to(badge2,0.3,{
                        "scaleX":5,
                        "scaleY":5,
                        "x":(640 - 64 * 5) / 2,
                        "y":(500 - 64 * 5) / 2 - 30,
                        "alpha":0,
                        "onComplete":function():void
                        {
                           removeChild(badge2);
                        }
                     });
                  }
               });
            }
         });
      }
   }
}


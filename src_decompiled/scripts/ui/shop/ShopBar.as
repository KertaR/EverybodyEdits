package ui.shop
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import states.LobbyState;
   import states.LobbyStatePage;
   
   public class ShopBar extends assets_shopbar
   {
      
      private var lastenergy:int = -1;
      
      private var lastgems:int = -1;
      
      public function ShopBar()
      {
         super();
         energy.timetonext.autoSize = TextFieldAutoSize.LEFT;
         energy.energy.autoSize = TextFieldAutoSize.LEFT;
         gem.gems.autoSize = TextFieldAutoSize.LEFT;
         username.tf_username.autoSize = TextFieldAutoSize.LEFT;
         crewname.tf_crewname.autoSize = TextFieldAutoSize.LEFT;
         logout_btn.visible = !Global.playing_on_kongregate;
         logout_btn.addEventListener(MouseEvent.CLICK,function():void
         {
            dispatchEvent(new NavigationEvent(NavigationEvent.LOGOUT,true,false));
         });
         if(Global.playing_on_kongregate)
         {
            info.x += Math.round(logout_btn.width + 10);
         }
         info.terms_btn.mouseChildren = false;
         info.terms_btn.buttonMode = true;
         info.terms_btn.addEventListener(MouseEvent.CLICK,function():void
         {
            dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_TERMS,true,false));
         });
         info.help_btn.mouseChildren = false;
         info.help_btn.buttonMode = true;
         info.help_btn.addEventListener(MouseEvent.CLICK,function():void
         {
            dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_HELP,true,false));
         });
         info.blog_btn.mouseChildren = false;
         info.blog_btn.buttonMode = true;
         info.blog_btn.addEventListener(MouseEvent.CLICK,function():void
         {
            dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_BLOG,true,false));
         });
         info.forums_btn.mouseChildren = false;
         info.forums_btn.buttonMode = true;
         info.forums_btn.addEventListener(MouseEvent.CLICK,function():void
         {
            dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_FORUMS,true,false));
         });
         lobbybtn.buttonMode = true;
         campaignbtn.buttonMode = true;
         socialbtn.buttonMode = true;
         socialbtn.mouseChildren = false;
         settingsbtn.buttonMode = true;
         settingsbtn.mouseChildren = false;
         shopbtn.buttonMode = true;
         shopbtn.mouseChildren = false;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
         this.setHighlight(LobbyStatePage.ROOMLIST);
      }
      
      public function resize() : void
      {
         bg.width = Config.maxwidth;
         if(Global.player_is_guest)
         {
            shopbtn.visible = false;
            energy.visible = false;
            gem.visible = false;
            username.x = Math.round(bg.width - username.width) - 10;
            if(crewname.visible)
            {
               crewname.div.x = Math.round(crewname.tf_crewname.width) + 5;
               crewname.x = Math.round(username.x - crewname.width) - 5;
            }
            return;
         }
         shopbtn.visible = true;
         energy.visible = true;
         gem.visible = true;
         shopbtn.x = Math.round(bg.width - shopbtn.width);
         energy.x = Math.round(shopbtn.x - energy.width) - 8;
         gem.div.x = Math.round(gem.gems.x + gem.gems.width) + 8;
         gem.x = Math.round(energy.x - gem.width) - 9;
         username.x = Math.round(gem.x - username.width) - 10;
         if(crewname.visible)
         {
            crewname.div.x = Math.round(crewname.tf_crewname.width) + 5;
            crewname.x = Math.round(username.x - crewname.width) - 5;
         }
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         var event:Event = param1;
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage,false,0,true);
         gem.addEventListener(MouseEvent.CLICK,function():void
         {
            Shop.getMoreGems();
         });
         username.gotoAndStop(1);
         username.buttonMode = true;
         username.mouseChildren = false;
         username.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_PROFILE,true);
            _loc2_.username = Global.playerObject.name;
            dispatchEvent(_loc2_);
         });
         username.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            username.gotoAndStop(2);
            username.highlight.width = username.tf_username.width - 3;
         });
         username.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
         {
            username.gotoAndStop(1);
         });
         crewname.gotoAndStop(1);
         crewname.buttonMode = true;
         crewname.mouseChildren = false;
         crewname.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_CREW_PROFILE,true);
            _loc2_.crewname = Global.currentCrew.substring(4);
            dispatchEvent(_loc2_);
         });
         crewname.addEventListener(MouseEvent.MOUSE_OVER,function(param1:MouseEvent):void
         {
            crewname.gotoAndStop(2);
            crewname.highlight.width = crewname.tf_crewname.width - 3;
         });
         crewname.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
         {
            crewname.gotoAndStop(1);
         });
         this.refreshTopBar();
         shopbtn.gotoAndStop(Shop.hasSeenNewest() ? 1 : 3);
         socialbtn.gotoAndStop(1);
         lobbybtn.addEventListener(MouseEvent.CLICK,function():void
         {
            (Global.base.state as LobbyState).setPage(LobbyStatePage.ROOMLIST);
         });
         campaignbtn.addEventListener(MouseEvent.CLICK,function():void
         {
            (Global.base.state as LobbyState).setPage(LobbyStatePage.CAMPAIGN);
         });
         socialbtn.addEventListener(MouseEvent.CLICK,function():void
         {
            (Global.base.state as LobbyState).setPage(LobbyStatePage.SOCIAL);
         });
         settingsbtn.addEventListener(MouseEvent.CLICK,function():void
         {
            (Global.base.state as LobbyState).setPage(LobbyStatePage.SETTINGS);
         });
         shopbtn.addEventListener(MouseEvent.CLICK,function():void
         {
            if(Global.player_is_guest) return;
            (Global.base.state as LobbyState).setPage(LobbyStatePage.ENERGY_SHOP);
         });
         shopbtn.addEventListener(MouseEvent.MOUSE_MOVE,function():void
         {
            if(shopbtn.highlight.currentFrame == 1)
            {
               shopbtn.highlight.gotoAndStop(2);
               shopbtn.gotoAndStop(shopbtn.currentFrame > 2 ? 4 : 2);
            }
         });
         shopbtn.addEventListener(MouseEvent.MOUSE_OUT,function():void
         {
            if(shopbtn.highlight.currentFrame == 2)
            {
               shopbtn.highlight.gotoAndStop(1);
               shopbtn.gotoAndStop(shopbtn.currentFrame > 2 ? 3 : 1);
            }
         });
         lobbybtn.addEventListener(MouseEvent.MOUSE_MOVE,function():void
         {
            if(lobbybtn.currentFrame == 1)
            {
               lobbybtn.gotoAndStop(2);
            }
         });
         lobbybtn.addEventListener(MouseEvent.MOUSE_OUT,function():void
         {
            if(lobbybtn.currentFrame == 2)
            {
               lobbybtn.gotoAndStop(1);
            }
         });
         campaignbtn.addEventListener(MouseEvent.MOUSE_MOVE,function():void
         {
            if(campaignbtn.currentFrame == 1)
            {
               campaignbtn.gotoAndStop(2);
            }
         });
         campaignbtn.addEventListener(MouseEvent.MOUSE_OUT,function():void
         {
            if(campaignbtn.currentFrame == 2)
            {
               campaignbtn.gotoAndStop(1);
            }
         });
         socialbtn.addEventListener(MouseEvent.MOUSE_MOVE,function():void
         {
            if(socialbtn.highlight.currentFrame == 1)
            {
               socialbtn.highlight.gotoAndStop(2);
               socialbtn.gotoAndStop(socialbtn.currentFrame > 2 ? 4 : 2);
            }
         });
         socialbtn.addEventListener(MouseEvent.MOUSE_OUT,function():void
         {
            if(socialbtn.highlight.currentFrame == 2)
            {
               socialbtn.highlight.gotoAndStop(1);
               socialbtn.gotoAndStop(socialbtn.currentFrame > 2 ? 3 : 1);
            }
         });
         settingsbtn.addEventListener(MouseEvent.MOUSE_MOVE,function():void
         {
            if(settingsbtn.currentFrame == 1)
            {
               settingsbtn.gotoAndStop(2);
            }
         });
         settingsbtn.addEventListener(MouseEvent.MOUSE_OUT,function():void
         {
            if(settingsbtn.currentFrame == 2)
            {
               settingsbtn.gotoAndStop(1);
            }
         });
         this.resize();
         addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
      }
      
      public function setHighlight(param1:String) : void
      {
         lobbybtn.gotoAndStop(param1 == LobbyStatePage.ROOMLIST ? 3 : 1);
         campaignbtn.gotoAndStop(param1 == LobbyStatePage.CAMPAIGN ? 3 : 1);
         settingsbtn.gotoAndStop(param1 == LobbyStatePage.SETTINGS ? 3 : 1);
         shopbtn.highlight.gotoAndStop(param1 == LobbyStatePage.ENERGY_SHOP ? 3 : 1);
         shopbtn.gotoAndStop(param1 == LobbyStatePage.ENERGY_SHOP ? 2 : (shopbtn.currentFrame > 2 ? 3 : 1));
         socialbtn.highlight.gotoAndStop(param1 == LobbyStatePage.SOCIAL ? 3 : 1);
         socialbtn.gotoAndStop(param1 == LobbyStatePage.SOCIAL ? (socialbtn.currentFrame > 2 ? 4 : 2) : (socialbtn.currentFrame > 2 ? 3 : 1));
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         this.refreshTopBar();
      }
      
      public function glowEnergy() : void
      {
         TweenMax.to(energy.bolt,0.7,{
            "glowFilter":{
               "color":16514925,
               "alpha":1,
               "blurX":10,
               "blurY":10
            },
            "onComplete":function():void
            {
               TweenMax.to(energy.bolt,0.7,{"glowFilter":{
                  "color":16514925,
                  "alpha":0,
                  "blurX":10,
                  "blurY":10,
                  "remove":true
               }});
            }
         });
      }
      
      public function glowGems() : void
      {
         TweenMax.to(gem.gem,0.7,{
            "glowFilter":{
               "color":16711680,
               "alpha":1,
               "blurX":10,
               "blurY":10
            },
            "onComplete":function():void
            {
               TweenMax.to(gem.gem,0.7,{"glowFilter":{
                  "color":16711680,
                  "alpha":0,
                  "blurX":10,
                  "blurY":10,
                  "remove":true
               }});
            }
         });
      }
      
      public function setCrewName(param1:String) : void
      {
         if(crewname)
         {
            if(!crewname.visible)
            {
               crewname.visible = true;
            }
            crewname.tf_crewname.text = param1;
         }
      }
      
      public function refreshTopBar() : void
      {
         if(Global.playerObject != null && Global.playerObject.name != null && Global.playerObject.name != "")
         {
            username.tf_username.text = Global.playerObject.name.toUpperCase();
         }
         else
         {
            username.tf_username.text = "GUEST";
         }
         crewname.visible = false;
         gem.gems.text = "Gems: " + Shop.gems;
         energy.energy.text = "Energy: " + Shop.energy + "/" + Shop.totalEnergy;
         if(energy.timetonext != null)
         {
            if(Shop.energy >= Shop.totalEnergy)
            {
               energy.timetonext.text = "Full";
            }
            else
            {
               energy.timetonext.text = "More in " + Shop.prettyTimeToNext;
            }
         }
         this.resize();
      }
   }
}

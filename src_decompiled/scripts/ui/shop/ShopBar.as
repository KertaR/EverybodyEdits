package ui.shop
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import states.LobbyState;
   import states.LobbyStatePage;
   
   public class ShopBar extends assets_shopbar
   {
      
      private var lastenergy:int = -1;
      
      private var lastgems:int = -1;
      
      public var questsbtn:Sprite;
      
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
         
         // Custom Quests Tab
         this.questsbtn = new Sprite();
         this.questsbtn.buttonMode = true;
         this.questsbtn.mouseChildren = false;
         
         var tabTf:TextField = new TextField();
         tabTf.text = "Quests";
         tabTf.width = 95;
         tabTf.height = 30;
         tabTf.selectable = false;
         var tabFmt:TextFormat = new TextFormat("system", 13, 0xffffff, false);
         tabFmt.align = TextFormatAlign.CENTER;
         tabTf.defaultTextFormat = tabFmt;
         tabTf.setTextFormat(tabFmt);
         tabTf.y = 5;
         
         var drawTab:Function = function(bg:uint, border:uint):void
         {
            questsbtn.graphics.clear();
            questsbtn.graphics.lineStyle(1, border, 1, true);
            questsbtn.graphics.beginFill(bg, 1);
            questsbtn.graphics.drawRoundRectComplex(0, 0, 95, 30, 4, 4, 0, 0);
            questsbtn.graphics.endFill();
         };
         
         drawTab(0x232323, 0x383838);
         this.questsbtn.addChild(tabTf);
         
         this.questsbtn.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void
         {
            drawTab(0x383838, 0x4f4f4f);
         });
         this.questsbtn.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void
         {
            drawTab(0x232323, 0x383838);
         });
         
         this.questsbtn.x = this.socialbtn.x + this.socialbtn.width + 2;
         this.questsbtn.y = 0;
         this.questsbtn.addEventListener(MouseEvent.CLICK, this.openQuestsModal);
         addChild(this.questsbtn);
         
         settingsbtn.x = this.questsbtn.x + 95 + 4;
         settingsbtn.y = 0;
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
      
      private function openQuestsModal(param1:MouseEvent = null) : void
      {
         var uname:String = "Guest";
         if (Global.playerObject != null && Global.playerObject.name != null && Global.playerObject.name != "")
         {
            uname = Global.playerObject.name;
         }
         var qLoader:URLLoader = new URLLoader();
         var qReq:URLRequest = new URLRequest("http://localhost:8080/api/quests?username=" + encodeURIComponent(uname));
         qLoader.addEventListener(Event.COMPLETE, function(e:Event):void
         {
            try
            {
               var res:Object = JSON.parse(String(qLoader.data));
               if (res != null && Boolean(res.success) && res.quests != null)
               {
                  var streak:int = int(res.quests.streak);
                  var qList:Array = res.quests.quests as Array;
                  
                  // Create Modal Overlay
                  var modal:Sprite = new Sprite();
                  
                  var bgOverlay:Sprite = new Sprite();
                  bgOverlay.graphics.beginFill(0x000000, 0.7);
                  bgOverlay.graphics.drawRect(-1000, -1000, 3000, 3000);
                  bgOverlay.graphics.endFill();
                  modal.addChild(bgOverlay);
                  
                  modal.addEventListener(MouseEvent.MOUSE_DOWN, function(evt:MouseEvent):void
                  {
                     evt.stopImmediatePropagation();
                     evt.stopPropagation();
                  });
                  
                  // Dialog Box (520x330)
                  var pw:Number = 520;
                  var ph:Number = 330;
                  var panel:Sprite = new Sprite();
                  panel.graphics.lineStyle(2, 0x3b82f6, 1);
                  panel.graphics.beginFill(0x1e293b, 0.98);
                  panel.graphics.drawRoundRect(0, 0, pw, ph, 14, 14);
                  panel.graphics.endFill();
                  
                  // Header Bar
                  panel.graphics.lineStyle(0, 0, 0);
                  panel.graphics.beginFill(0x0f172a, 0.85);
                  panel.graphics.drawRoundRectComplex(0, 0, pw, 42, 12, 12, 0, 0);
                  panel.graphics.endFill();
                  
                  // Title
                  var titleTf:TextField = new TextField();
                  titleTf.text = "Daily Quests & Missions";
                  titleTf.width = pw;
                  titleTf.height = 30;
                  titleTf.selectable = false;
                  var tFmt:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
                  tFmt.align = TextFormatAlign.CENTER;
                  titleTf.defaultTextFormat = tFmt;
                  titleTf.setTextFormat(tFmt);
                  titleTf.y = 10;
                  panel.addChild(titleTf);
                  
                  // Streak Banner
                  var streakTf:TextField = new TextField();
                  streakTf.text = "Login Streak: Day " + streak;
                  streakTf.width = pw;
                  streakTf.height = 24;
                  streakTf.selectable = false;
                  var sFmt:TextFormat = new TextFormat("Arial", 12, 0xf59e0b, true);
                  sFmt.align = TextFormatAlign.CENTER;
                  streakTf.defaultTextFormat = sFmt;
                  streakTf.setTextFormat(sFmt);
                  streakTf.y = 48;
                  panel.addChild(streakTf);
                  
                  // Quest Cards
                  var startY:Number = 74;
                  if (qList != null && qList.length > 0)
                  {
                     for (var i:int = 0; i < qList.length; i++)
                     {
                        var q:Object = qList[i];
                        var qCard:Sprite = new Sprite();
                        var cardY:Number = startY + i * 58;
                        
                        qCard.graphics.lineStyle(1, q.completed ? 0x22c55e : 0x334155, 0.9);
                        qCard.graphics.beginFill(q.completed ? 0x14532d : 0x0f172a, 0.75);
                        qCard.graphics.drawRoundRect(20, cardY, pw - 40, 52, 8, 8);
                        qCard.graphics.endFill();
                        panel.addChild(qCard);
                        
                        var qTitleTf:TextField = new TextField();
                        qTitleTf.text = (i + 1) + ". " + q.title + " (+" + q.rewardGems + " Gems, +" + q.rewardXP + " XP)";
                        qTitleTf.x = 30;
                        qTitleTf.y = cardY + 6;
                        qTitleTf.width = 330;
                        qTitleTf.height = 20;
                        qTitleTf.selectable = false;
                        var qtFmt:TextFormat = new TextFormat("Arial", 12, 0xffffff, true);
                        qTitleTf.defaultTextFormat = qtFmt;
                        qTitleTf.setTextFormat(qtFmt);
                        panel.addChild(qTitleTf);
                        
                        var qDescTf:TextField = new TextField();
                        qDescTf.text = String(q.desc || "");
                        qDescTf.x = 30;
                        qDescTf.y = cardY + 26;
                        qDescTf.width = 330;
                        qDescTf.height = 20;
                        qDescTf.selectable = false;
                        var qdFmt:TextFormat = new TextFormat("Arial", 11, 0x94a3b8, false);
                        qDescTf.defaultTextFormat = qdFmt;
                        qDescTf.setTextFormat(qdFmt);
                        panel.addChild(qDescTf);
                        
                        var progTf:TextField = new TextField();
                        progTf.text = q.completed ? "COMPLETED" : (q.current + " / " + q.target);
                        progTf.x = pw - 160;
                        progTf.y = cardY + 16;
                        progTf.width = 130;
                        progTf.height = 24;
                        progTf.selectable = false;
                        var prgFmt:TextFormat = new TextFormat("Arial", 12, q.completed ? 0x4ade80 : 0x38bdf8, true);
                        prgFmt.align = TextFormatAlign.RIGHT;
                        progTf.defaultTextFormat = prgFmt;
                        progTf.setTextFormat(prgFmt);
                        panel.addChild(progTf);
                     }
                  }
                  
                  // Close Button
                  var closeBtn:Sprite = new Sprite();
                  closeBtn.buttonMode = true;
                  closeBtn.mouseChildren = false;
                  closeBtn.graphics.lineStyle(1, 0x3b82f6);
                  closeBtn.graphics.beginFill(0x2563eb);
                  closeBtn.graphics.drawRoundRect(0, 0, 100, 30, 6, 6);
                  closeBtn.graphics.endFill();
                  
                  var closeTf:TextField = new TextField();
                  closeTf.text = "Close";
                  closeTf.width = 100;
                  closeTf.height = 30;
                  closeTf.selectable = false;
                  var cFmt:TextFormat = new TextFormat("Arial", 13, 0xffffff, true);
                  cFmt.align = TextFormatAlign.CENTER;
                  closeTf.defaultTextFormat = cFmt;
                  closeTf.setTextFormat(cFmt);
                  closeTf.y = 5;
                  closeBtn.addChild(closeTf);
                  
                  closeBtn.x = (pw - 100) / 2;
                  closeBtn.y = ph - 42;
                  closeBtn.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void
                  {
                     if (modal.parent != null)
                     {
                        modal.parent.removeChild(modal);
                     }
                  });
                  panel.addChild(closeBtn);
                  
                  panel.x = (Config.width - pw) / 2;
                  panel.y = (Config.height - ph) / 2;
                  modal.addChild(panel);
                  
                  if (Global.base != null && Global.base.overlayContainer != null)
                  {
                     Global.base.overlayContainer.addChild(modal);
                  }
                  else if (Global.base != null && Global.base.state != null)
                  {
                     Global.base.state.addChild(modal);
                  }
               }
            }
            catch (err:Error)
            {
               trace("Quests modal error: " + err.message);
            }
         });
         qLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
         {
            trace("Quests HTTP request error");
         });
         qLoader.load(qReq);
      }
   }
}

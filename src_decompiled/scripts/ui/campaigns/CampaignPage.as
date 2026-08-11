package ui.campaigns
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import playerio.Message;
   import sample.ui.components.*;
   import sample.ui.components.scroll.ScrollBox;
   import states.LobbyState;
   import states.LobbyStatePage;
   import ui.ConfirmPrompt;
   import ui.profile.FillBox;
   
   public class CampaignPage extends assets_CampaignPage
   {
      
      private static const PAGE_CAMPAIGNS:int = 0;
      
      private static const PAGE_WORLDS:int = 1;
      
      private static const PAGE_TT:int = 2;
      
      private static const PAGE_TTWORLDS:int = 3;
      
      private var content:Box;
      
      private var headerBox:Box;
      
      private var campaign_items:Rows;
      
      private var campaignsFillBox:FillBox;
      
      private var worldsFillBox:FillBox;
      
      private var campaignItemsScroll:ScrollBox;
      
      private var campaigns:Array;
      
      private var campaignItems:Array;
      
      private var campaignWorlds:Array;
      
      private var headerLabel:Label;
      
      private var backButton:assets_backbutton;
      
      private var timeTrialsButton:assets_btn_timetrials;
      
      private var lobbystate:LobbyState;
      
      private var currentPage:int = 0;
      
      private var loadingFinishedCallback:Function;
      
      public var currentCampaign:CampaignItem;
      
      public function CampaignPage(param1:LobbyState, param2:Function)
      {
         var lobbystate:LobbyState = param1;
         var loadingFinishedCallback:Function = param2;
         this.content = new Box();
         this.headerBox = new Box();
         this.campaign_items = new Rows();
         this.campaignsFillBox = new FillBox(20,20);
         this.worldsFillBox = new FillBox(0,20);
         this.campaignItemsScroll = new ScrollBox();
         this.campaigns = [];
         this.campaignItems = [];
         this.campaignWorlds = [];
         this.backButton = new assets_backbutton();
         this.timeTrialsButton = new assets_btn_timetrials();
         super();
         if(loadingFinishedCallback != null)
         {
            this.loadingFinishedCallback = loadingFinishedCallback;
         }
         this.lobbystate = lobbystate;
         this.worldsFillBox.horizontal = true;
         this.headerBox.margin(10,10,10,10);
         this.content.margin(40,10,5,10);
         this.campaign_items.spacing(30);
         this.campaignItemsScroll.scrollMultiplier = 15;
         this.backButton.x = 24;
         this.backButton.y = 8;
         this.backButton.addEventListener(MouseEvent.CLICK,function():void
         {
            switchTo(currentPage == PAGE_TTWORLDS ? PAGE_TT : PAGE_CAMPAIGNS);
         });
         this.backButton.visible = false;
         addChild(this.backButton);
         this.timeTrialsButton.x = bg.x + bg.width - 73 - this.timeTrialsButton.width;
         this.timeTrialsButton.y = bg.y + 7;
         this.timeTrialsButton.addEventListener(MouseEvent.CLICK,function():void
         {
            switchTo(PAGE_TT);
         });
         this.timeTrialsButton.visible = false;
         addChild(this.timeTrialsButton);
         this.content.add(new Box().margin(10,0,0,0).add(this.campaignItemsScroll.add(new Box().margin(0,0,0,0).add(this.campaign_items))));
         this.campaignsFillBox.forceScale = false;
         this.campaignsFillBox.x = 56;
         this.headerLabel = new Label("",15,"left",16777215,false,"system");
         this.headerLabel.autoSize = TextFieldAutoSize.LEFT;
         this.headerBox.add(new Box().margin(0,56,5,56).add(this.headerLabel));
         this.getCampaigns();
         this.content.add(this.campaignItemsScroll);
         this.headerBox.width = bg.width;
         this.headerBox.height = bg.height;
         addChild(this.headerBox);
         this.content.width = bg.width;
         this.content.height = bg.height;
         addChild(this.content);
      }
      
      private function getCampaigns() : void
      {
         if(this.lobbystate.currentPage == LobbyStatePage.CAMPAIGN)
         {
            Global.base.showLoadingScreen("Loading Campaigns");
         }
         Global.base.requestRemoteMethod("getCampaigns",function(param1:Message):void
         {
            var _loc5_:CampaignItem = null;
            var _loc6_:int = 0;
            var _loc7_:int = 0;
            var _loc8_:int = 0;
            var _loc9_:int = 0;
            var _loc10_:String = null;
            var _loc11_:String = null;
            var _loc12_:String = null;
            var _loc13_:int = 0;
            var _loc14_:int = 0;
            var _loc15_:String = null;
            var _loc16_:int = 0;
            var _loc17_:Boolean = false;
            var _loc18_:Array = null;
            var _loc19_:int = 0;
            var _loc20_:int = 0;
            var _loc21_:CampaignWorld = null;
            var _loc22_:int = 0;
            var _loc23_:int = 0;
            var _loc24_:Array = null;
            var _loc2_:* = 0;
            campaigns = [];
            var _loc3_:Array = [];
            var _loc4_:int = 0;
            while(_loc2_ < param1.length)
            {
               _loc5_ = new CampaignItem(param1.getString(_loc2_++),param1.getString(_loc2_++),param1.getString(_loc2_++),param1.getInt(_loc2_++),param1.getBoolean(_loc2_++),param1.getBoolean(_loc2_++),param1.getBoolean(_loc2_++));
               _loc5_.addEventListener(MouseEvent.CLICK,handleCampaignClick);
               campaigns.push(_loc5_);
               _loc6_ = param1.getInt(_loc2_++);
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc3_[_loc7_] = 0;
                  _loc7_++;
               }
               _loc8_ = 0;
               while(_loc8_ < _loc6_)
               {
                  _loc10_ = param1.getString(_loc2_++);
                  _loc11_ = param1.getString(_loc2_++);
                  _loc12_ = param1.getString(_loc2_++);
                  _loc13_ = param1.getInt(_loc2_++);
                  _loc14_ = param1.getInt(_loc2_++);
                  _loc15_ = Config.site + "/Campaigns/" + _loc10_ + ".png";
                  _loc16_ = param1.getInt(_loc2_++);
                  _loc17_ = param1.getBoolean(_loc2_++);
                  if(_loc17_)
                  {
                     _loc22_ = param1.getInt(_loc2_++);
                     _loc23_ = param1.getInt(_loc2_++);
                     _loc24_ = [];
                     _loc24_.push(param1.getInt(_loc2_++));
                     _loc24_.push(param1.getInt(_loc2_++));
                     _loc24_.push(param1.getInt(_loc2_++));
                     if(_loc23_ >= 3)
                     {
                        _loc24_.push(param1.getInt(_loc2_++));
                     }
                     if(_loc23_ >= 5)
                     {
                        _loc24_.push(param1.getInt(_loc2_++));
                     }
                     _loc3_[_loc8_] = _loc23_;
                  }
                  _loc18_ = [];
                  _loc19_ = param1.getInt(_loc2_++);
                  _loc20_ = 0;
                  while(_loc20_ < _loc19_)
                  {
                     _loc18_.push(new CampaignReward(param1.getString(_loc2_++),param1.getUInt(_loc2_++)));
                     _loc20_++;
                  }
                  _loc21_ = _loc17_ ? new CampaignWorld(_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc16_,_loc15_,_loc18_,refreshScrollBox,_loc24_,_loc22_,_loc23_) : new CampaignWorld(_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc16_,_loc15_,_loc18_,refreshScrollBox);
                  _loc21_.main.addEventListener(MouseEvent.CLICK,handleCampaignWorldClick);
                  _loc5_.addWorld(_loc21_);
                  _loc8_++;
               }
               _loc4_ = 5;
               _loc9_ = 0;
               while(_loc9_ < _loc6_)
               {
                  _loc4_ = _loc3_[_loc9_] < _loc4_ ? int(_loc3_[_loc9_]) : _loc4_;
                  _loc9_++;
               }
               if(_loc4_ > 0)
               {
                  _loc5_.clock = new Clock(_loc4_);
                  _loc5_.clock.x = _loc5_.width - _loc5_.clock.width - 10;
                  _loc5_.clock.y = 8;
                  _loc5_.addChild(_loc5_.clock);
               }
            }
            switchTo(PAGE_CAMPAIGNS);
            if(lobbystate.currentPage == LobbyStatePage.CAMPAIGN)
            {
               Global.base.hideLoadingScreen();
            }
            if(loadingFinishedCallback != null)
            {
               loadingFinishedCallback();
            }
         });
      }
      
      public function getCampaignByName(param1:String) : CampaignItem
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.campaigns.length)
         {
            if((this.campaigns[_loc2_] as CampaignItem).campaignName.text.toLowerCase() == param1)
            {
               return this.campaigns[_loc2_] as CampaignItem;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function showTutorialOnly() : void
      {
         this.campaignsFillBox.removeAllChildren();
         var _loc1_:int = 0;
         while(_loc1_ < this.campaigns.length)
         {
            if((this.campaigns[_loc1_] as CampaignItem).campaignName.text.toLowerCase() == "tutorials")
            {
               this.campaignItems.push(this.campaigns[_loc1_]);
               this.campaignsFillBox.addChild(this.campaigns[_loc1_]);
               this.campaigns[_loc1_].alpha = 0;
               TweenMax.to(this.campaigns[_loc1_],0.6 * (_loc1_ < 5 ? _loc1_ : 5),{"alpha":1});
            }
            _loc1_++;
         }
         this.campaignsFillBox.refresh();
         this.campaignItemsScroll.refresh();
      }
      
      public function openCampaign(param1:CampaignItem) : void
      {
         this.switchTo(PAGE_WORLDS,param1.campaignName.text,param1.id);
      }
      
      private function refreshScrollBox() : void
      {
         if(this.currentPage == PAGE_WORLDS || this.currentPage == PAGE_TTWORLDS)
         {
            this.campaignItemsScroll.refresh();
            this.worldsFillBox.refresh();
         }
      }
      
      private function initCampaignItems() : void
      {
         var i:int;
         var item:CampaignItem = null;
         this.campaignItems = [];
         this.campaignsFillBox.clear();
         this.campaigns.sort(function(param1:CampaignItem, param2:CampaignItem):int
         {
            if(param1.locked && !param2.locked)
            {
               return 1;
            }
            if(!param1.locked && param2.locked)
            {
               return -1;
            }
            if(param1.completed && !param2.completed)
            {
               return 1;
            }
            if(!param1.completed && param2.completed)
            {
               return -1;
            }
            if(param1.difficulty > param2.difficulty)
            {
               return 1;
            }
            if(param1.difficulty < param2.difficulty)
            {
               return -1;
            }
            return 0;
         });
         i = 0;
         for each(item in this.campaigns)
         {
            if(this.currentPage == PAGE_TT ? item.completed && item.campaignWorlds.some(function(param1:CampaignWorld, param2:int, param3:Array):Boolean
            {
               return param1.targetTimes !== null;
            }) : !item.hidden)
            {
               this.campaignItems.push(item);
               this.campaignsFillBox.addChild(item);
               if(item.completed && Boolean(item._check))
               {
                  item._check.visible = this.currentPage != PAGE_TT;
               }
               if(item.clock)
               {
                  item.clock.visible = this.currentPage == PAGE_TT;
               }
               item.alpha = 0;
               TweenMax.to(item,0.5,{
                  "delay":0.075 * i,
                  "alpha":1
               });
               i++;
            }
         }
         this.campaignItemsScroll.refresh();
      }
      
      private function initCampaignWorlds(param1:String) : void
      {
         var _loc3_:CampaignItem = null;
         var _loc4_:int = 0;
         var _loc5_:CampaignWorld = null;
         var _loc6_:Vector.<ClockTime> = null;
         this.campaignWorlds = [];
         this.worldsFillBox.clear();
         var _loc2_:int = 0;
         while(_loc2_ < this.campaigns.length)
         {
            _loc3_ = this.campaigns[_loc2_] as CampaignItem;
            if(_loc3_.id == param1)
            {
               _loc4_ = 0;
               for(; _loc4_ < _loc3_.campaignWorlds.length; _loc4_++)
               {
                  _loc5_ = _loc3_.campaignWorlds[_loc4_];
                  if(this.currentPage == PAGE_TTWORLDS)
                  {
                     if(_loc5_.targetTimes === null)
                     {
                        continue;
                     }
                     _loc5_.checkVisible = false;
                     if(_loc5_._check)
                     {
                        _loc5_._check.visible = false;
                     }
                     _loc5_.rewards.visible = false;
                     if(!_loc5_.times.parent)
                     {
                        _loc6_ = ClockTime.pickFour(_loc5_.targetTimes,_loc5_.time,_loc5_.rank);
                        _loc5_.times.addChild(_loc6_[0]);
                        _loc6_[1].y = Clock.size + 1;
                        _loc5_.times.addChild(_loc6_[1]);
                        _loc6_[2].y = _loc6_[1].y * 2;
                        _loc5_.times.addChild(_loc6_[2]);
                        _loc6_[3].y = _loc6_[1].y * 3;
                        _loc5_.times.addChild(_loc6_[3]);
                        _loc5_.addChild(_loc5_.times);
                        _loc5_.positionTimes();
                     }
                  }
                  else
                  {
                     _loc5_.checkVisible = true;
                     if(_loc5_._check)
                     {
                        _loc5_._check.visible = true;
                     }
                     if(_loc5_.times.parent)
                     {
                        _loc5_.removeChild(_loc5_.times);
                        _loc5_.times.removeChildren();
                     }
                     _loc5_.rewards.visible = true;
                  }
                  this.campaignWorlds.push(_loc5_);
                  this.worldsFillBox.addChild(_loc5_);
                  _loc5_.alpha = 0;
                  TweenMax.to(_loc5_,0.5,{
                     "delay":0.075 * _loc4_,
                     "alpha":1
                  });
               }
               break;
            }
            _loc2_++;
         }
      }
      
      private function handleCampaignClick(param1:MouseEvent) : void
      {
         var _loc2_:CampaignItem = param1.target as CampaignItem || param1.target.parent as CampaignItem;
         this.switchTo(this.currentPage == PAGE_TT ? PAGE_TTWORLDS : PAGE_WORLDS,_loc2_.campaignName.text,_loc2_.id);
         this.currentCampaign = _loc2_;
      }
      
      private function handleCampaignWorldClick(param1:MouseEvent) : void
      {
         var cont:Boolean;
         var cWorld:CampaignWorld = null;
         var conf:ConfirmPrompt = null;
         var e:MouseEvent = param1;
         var loadWorld:Function = function():void
         {
            var _loc1_:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD,true,false);
            _loc1_.world_id = cWorld.worldId;
            if(currentPage == PAGE_TTWORLDS)
            {
               _loc1_.joindata.trialsmode = "true";
            }
            Global.base.dispatchEvent(_loc1_);
         };
         var target:Object = e.target;
         while(!(target as CampaignWorld) && Boolean(target.parent))
         {
            target = target.parent;
         }
         cWorld = target as CampaignWorld;
         if(!cWorld)
         {
            return;
         }
         cont = !cWorld.locked;
         if(!cont)
         {
            conf = new ConfirmPrompt("Are you sure you want to join this world? Locked worlds will not track your progress and won\'t reward you!",true,"Join",false);
            conf.btn_yes.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               conf.close();
               loadWorld();
            });
            Global.base.showOnTop(conf);
         }
         else
         {
            loadWorld();
         }
      }
      
      public function switchTo(param1:int, param2:String = "", param3:String = null) : void
      {
         this.currentPage = param1;
         this.headerLabel.alpha = 0;
         TweenMax.to(this.headerLabel,1,{"alpha":1});
         this.headerLabel.text = param1 == PAGE_CAMPAIGNS ? "Select a campaign..." : (param1 == PAGE_TT ? "Time Trials" : param2);
         this.backButton.visible = this.timeTrialsButton.visible = false;
         switch(param1)
         {
            case PAGE_CAMPAIGNS:
            case PAGE_TT:
               if(this.campaign_items.contains(this.worldsFillBox))
               {
                  this.campaign_items.removeChild(this.worldsFillBox);
               }
               if(!this.campaign_items.contains(this.campaignsFillBox))
               {
                  this.campaign_items.addChild(this.campaignsFillBox);
               }
               this.initCampaignItems();
               if(param1 == PAGE_TT)
               {
                  this.backButton.visible = true;
               }
               else
               {
                  this.timeTrialsButton.visible = true;
               }
               this.campaignItemsScroll.horizontal = false;
               break;
            case PAGE_WORLDS:
            case PAGE_TTWORLDS:
               if(this.campaign_items.contains(this.campaignsFillBox))
               {
                  this.campaign_items.removeChild(this.campaignsFillBox);
               }
               if(!this.campaign_items.contains(this.worldsFillBox))
               {
                  this.campaign_items.addChild(this.worldsFillBox);
               }
               this.initCampaignWorlds(param3);
               this.backButton.visible = true;
               this.campaignItemsScroll.horizontal = true;
         }
         this.refreshSubtext();
      }
      
      public function refreshSubtext() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         switch(this.currentPage)
         {
            case PAGE_CAMPAIGNS:
            case PAGE_TT:
               _loc1_ = 0;
               _loc5_ = 0;
               while(_loc5_ < this.campaignItems.length)
               {
                  if(this.campaignItems[_loc5_].completed)
                  {
                     _loc1_++;
                  }
                  _loc5_++;
               }
               if(this.lobbystate.currentPage == LobbyStatePage.CAMPAIGN)
               {
                  this.lobbystate.setSubtextArray([this.campaignItems.length + " Campaign" + (this.campaignItems.length == 1 ? "" : "s") + " available",_loc1_ + " Campaign" + (_loc1_ == 1 ? "" : "s") + " completed"]);
               }
               break;
            case PAGE_TTWORLDS:
               this.lobbystate.setSubtextArray([""]);
               break;
            case PAGE_WORLDS:
               _loc2_ = 0;
               _loc3_ = 0;
               _loc6_ = 0;
               while(_loc6_ < this.campaignWorlds.length)
               {
                  if(this.campaignWorlds[_loc6_].completed)
                  {
                     _loc2_++;
                  }
                  if(this.campaignWorlds[_loc6_].locked)
                  {
                     _loc3_++;
                  }
                  _loc6_++;
               }
               _loc4_ = this.campaignWorlds.length - _loc3_;
               if(this.lobbystate.currentPage == LobbyStatePage.CAMPAIGN)
               {
                  this.lobbystate.setSubtextArray([_loc2_ + " World" + (_loc2_ == 1 ? "" : "s") + " completed",_loc3_ + " World" + (_loc3_ == 1 ? "" : "s") + " locked",_loc4_ + " World" + (_loc4_ == 1 ? "" : "s") + " available"]);
               }
         }
      }
   }
}


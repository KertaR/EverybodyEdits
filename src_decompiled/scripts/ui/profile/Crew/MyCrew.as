package ui.profile.Crew
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import playerio.DatabaseObject;
   import playerio.Message;
   import sample.ui.components.Box;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   import ui.ConfirmPrompt;
   import ui.crews.CrewMemberItem;
   import ui.crews.CrewRank;
   import ui.crews.CrewRanks;
   import ui.profile.FillBox;
   import ui.profile.NewAlert;
   import ui.profile.ProfileWorld;
   
   public class MyCrew extends Sprite
   {
      
      private static const UPDATE:int = 750;
      
      private var content:Box;
      
      private var crew:Box;
      
      private var crewList:Rows;
      
      private var worldList:FillBox;
      
      private var crewScrollBox:ScrollBox;
      
      private var crewRefreshDate:Date;
      
      private var isLoading:Boolean = false;
      
      private var hasCrewName:Boolean = false;
      
      private var invitationItems:Array;
      
      private var crewMembers:Array = [];
      
      private var pendingItems:Array;
      
      private var blockedItems:Array;
      
      private var crewWorlds:Array = [];
      
      private var crews:Array = [];
      
      private var crewNames:Array = [];
      
      private var btnNames:Array = ["invite","editranks","createalert","switchcrew","pending","members","worlds"];
      
      private var ranks:CrewRanks;
      
      private var crewId:String;
      
      private var myRank:int;
      
      private var tabbar:assets_crewtabbar = new assets_crewtabbar();
      
      private var callback:Function;
      
      private var currentBtnEvent:MouseEvent;
      
      private var currentTab:MovieClip;
      
      private var loadingWorldPreviews:Boolean = false;
      
      private var worldPreviews:Array = [];
      
      public function MyCrew()
      {
         super();
      }
      
      private function refreshContentCrew(param1:Function = null) : void
      {
         var _loc4_:MovieClip = null;
         if(param1 != null)
         {
            this.callback = param1;
         }
         this.crewRefreshDate = new Date();
         this.isLoading = true;
         if(this.content)
         {
            removeChild(this.content);
         }
         this.content = new Box();
         this.content.margin(0,0,0,0);
         addChild(this.content);
         var _loc2_:int = 0;
         while(_loc2_ < this.btnNames.length)
         {
            _loc4_ = this.tabbar.getChildByName("btn_" + this.btnNames[_loc2_]) as MovieClip;
            _loc4_.gotoAndStop(1);
            _loc4_.buttonMode = true;
            _loc4_.mouseChildren = false;
            _loc4_.addEventListener(MouseEvent.MOUSE_DOWN,this.handleTopBarButton,false,0,true);
            _loc2_++;
         }
         this.tabbar.visible = false;
         addChild(this.tabbar);
         this.crew = new Box();
         this.content.add(this.crew);
         this.crew.margin(0,0,0,0);
         this.crewList = new Rows();
         this.crewList.spacing(5);
         this.crewList.forceScale = false;
         this.crewScrollBox = new ScrollBox();
         this.crewScrollBox.scrollMultiplier = 8;
         this.crewScrollBox.add(this.crewList);
         var _loc3_:Box = new Box();
         _loc3_.margin(0,0,0,0);
         _loc3_.add(this.crewScrollBox);
         this.crew.add(_loc3_);
         this.worldList = new FillBox(2);
         this.invitationItems = [];
         this.crewMembers = [];
         this.pendingItems = [];
         this.blockedItems = [];
         this.crewWorlds = [];
         this.refreshCrew();
      }
      
      public function refreshCrew() : void
      {
         this.crewList.removeAllChildren();
         this.crew.margin(0,0,0,0);
         this.tabbar.visible = false;
         this.addLoadingAnim();
         Global.base.requestRemoteMethod("getMyCrews",this.handleMyCrews);
      }
      
      private function ready() : void
      {
         this.isLoading = false;
         if(this.callback != null)
         {
            this.callback();
         }
      }
      
      private function initTab() : void
      {
         var _loc4_:CrewRank = null;
         this.tabbar.visible = true;
         this.crewList.removeAllChildren();
         this.crewScrollBox.refresh();
         if(this.crews.length > 1)
         {
            this.tabbar.btn_switchcrew.gotoAndStop(1);
            this.tabbar.btn_switchcrew.mouseEnabled = true;
         }
         else
         {
            this.tabbar.btn_switchcrew.gotoAndStop(2);
            this.tabbar.btn_switchcrew.mouseEnabled = false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.crewMembers.length)
         {
            this.crewList.addChild(this.crewMembers[_loc1_]);
            _loc1_++;
         }
         this.crew.margin(60,0,0,256);
         var _loc2_:Array = this.ranks.ranks;
         var _loc3_:int = 1;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_] as CrewRank;
            this.tabbar.btn_editranks.gotoAndStop(this.ranks.myRank.canManageRanks ? 1 : 2);
            this.tabbar.btn_editranks.title.mouseEnabled = false;
            this.tabbar.btn_editranks.buttonMode = true;
            this.tabbar.btn_editranks.mouseEnabled = true;
            this.tabbar.btn_editranks.useHandCursor = true;
            if(this.ranks.myRank.canManageMembers)
            {
               this.tabbar.btn_invite.gotoAndStop(1);
               this.tabbar.btn_invite.mouseEnabled = true;
               this.tabbar.btn_pending.gotoAndStop(1);
               this.tabbar.btn_pending.mouseEnabled = true;
            }
            else
            {
               this.tabbar.btn_invite.gotoAndStop(2);
               this.tabbar.btn_invite.mouseEnabled = false;
               this.tabbar.btn_pending.gotoAndStop(2);
               this.tabbar.btn_pending.mouseEnabled = false;
            }
            if(this.ranks.myRank.canSendAlerts)
            {
               this.tabbar.btn_createalert.gotoAndStop(1);
               this.tabbar.btn_createalert.mouseEnabled = true;
            }
            else
            {
               this.tabbar.btn_createalert.gotoAndStop(2);
               this.tabbar.btn_createalert.mouseEnabled = false;
            }
            _loc3_++;
         }
      }
      
      private function handleTopBarButton(param1:MouseEvent) : void
      {
         var leavePrompt:ConfirmPrompt = null;
         var disbandPrompt:ConfirmPrompt = null;
         var i:int = 0;
         var e:MouseEvent = param1;
         this.currentBtnEvent = e;
         this.currentTab = e.target as MovieClip;
         if(e.target == this.tabbar.btn_worlds)
         {
            if(this.crewList.parent)
            {
               this.crewScrollBox.removeChild(this.crewList);
            }
            this.crewScrollBox.add(this.worldList);
         }
         else
         {
            if(this.worldList.parent)
            {
               this.crewScrollBox.removeChild(this.worldList);
            }
            this.crewScrollBox.add(this.crewList);
         }
         if((e.target as MovieClip).mouseEnabled)
         {
            if(this.currentTab != this.tabbar.btn_editranks && this.currentTab != this.tabbar.btn_leave)
            {
               this.crewList.removeAllChildren();
               this.crewScrollBox.refresh();
               this.crew.margin(60,0,0,246);
            }
         }
         if(e.target == this.tabbar.btn_editranks)
         {
            Global.base.showRankItem(this.crewId,this.ranks);
         }
         if(e.target == this.tabbar.btn_leave)
         {
            if(this.myRank != 0)
            {
               leavePrompt = new ConfirmPrompt("Are you sure you want to leave \'" + Global.currentCrewName + "\'?\nThis can\'t be undone.",true,"Leave",false);
               leavePrompt.btn_yes.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  var e:MouseEvent = param1;
                  Global.base.requestCrewLobbyMethod(Global.currentCrew,"leaveCrew",function(param1:Message):void
                  {
                     leavePrompt.close();
                     clearCrewData();
                     refreshCrew();
                  },null);
               });
               Global.base.showOnTop(leavePrompt);
            }
            else
            {
               disbandPrompt = new ConfirmPrompt("Are you sure you want to disband \'" + Global.currentCrewName + "\'?\nThis can\'t be undone.",true,"Disband",false);
               disbandPrompt.btn_yes.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  var e:MouseEvent = param1;
                  Global.base.requestCrewLobbyMethod(Global.currentCrew,"disband",function(param1:Message):void
                  {
                     disbandPrompt.close();
                     clearCrewData();
                     refreshCrew();
                  },null);
               });
               Global.base.showOnTop(disbandPrompt);
            }
         }
         if(e.target == this.tabbar.btn_switchcrew)
         {
            this.crewList.removeAllChildren();
            this.tabbar.visible = false;
            this.crew.margin(15,0,0,236);
            this.crewList.addChild(new CrewSelector(this.crews,this.crewNames,this.handleSelectCrew));
         }
         if(e.target == this.tabbar.btn_invite)
         {
            this.crew.margin(60,0,0,231);
            this.crewList.addChild(new SendInvite(this.crewId,function(param1:String):void
            {
               pendingItems.push(new InviteStatus(crewId,param1,0,removePendingInvite));
               crewList.removeAllChildren();
               showPending();
            }));
         }
         else if(e.target == this.tabbar.btn_pending)
         {
            this.showPending();
         }
         else if(e.target == this.tabbar.btn_members)
         {
            i = 0;
            while(i < this.crewMembers.length)
            {
               this.crewList.addChild(this.crewMembers[i]);
               i++;
            }
         }
         else if(e.target == this.tabbar.btn_createalert)
         {
            this.sendNewAlert();
         }
         else if(e.target == this.tabbar.btn_worlds)
         {
            this.displayWorlds();
         }
         this.crewScrollBox.refresh();
      }
      
      private function showPending() : void
      {
         var _loc1_:InviteStatus = null;
         this.crew.margin(60,0,0,226);
         for each(_loc1_ in this.pendingItems)
         {
            this.crewList.addChild(_loc1_);
         }
      }
      
      private function addLoadingAnim(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.crew.margin(0,0,0,0);
         }
         var _loc2_:Box = new Box().margin(150,NaN,NaN,401);
         _loc2_.add(new assets_miniloading());
         this.crewList.addChild(_loc2_);
      }
      
      private function handleMyCrews(param1:Message) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         this.crewList.removeAllChildren();
         if(param1.getBoolean(0))
         {
            this.crew.margin(0,0,0,236);
            this.crewList.addChild(new NoCrewName());
            this.ready();
            return;
         }
         this.crews = [];
         this.crewNames = [];
         var _loc2_:Boolean = false;
         var _loc3_:int = 1;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.getString(_loc3_);
            _loc5_ = param1.getString(_loc3_ + 1);
            this.crews.push(_loc4_);
            this.crewNames.push(_loc5_);
            if("crew" + _loc4_ == Global.currentCrew)
            {
               _loc2_ = true;
            }
            _loc3_ += 2;
         }
         if(this.crews.length > 1)
         {
            if(_loc2_)
            {
               this.addLoadingAnim();
               Global.base.requestCrewLobbyMethod(Global.currentCrew,"getCrew",this.handleCrew,this.handleCrewError);
            }
            else
            {
               this.crew.margin(15,0,0,236);
               this.crewList.addChild(new CrewSelector(this.crews,this.crewNames,this.handleSelectCrew));
               this.ready();
            }
         }
         else if(this.crews.length == 1)
         {
            Global.base.requestCrewLobbyMethod("crew" + this.crews[0],"getCrew",this.handleCrew,this.handleCrewError);
         }
         else
         {
            this.crew.margin(15,0,0,236);
            this.crewList.addChild(new NoCrew());
            this.ready();
         }
      }
      
      private function handleSelectCrew(param1:String) : void
      {
         this.crewList.removeAllChildren();
         this.addLoadingAnim(true);
         Global.base.requestCrewLobbyMethod("crew" + param1,"getCrew",this.handleCrew,this.handleCrewError);
      }
      
      private function handleCrewError() : void
      {
         this.crewList.removeAllChildren();
         this.tabbar.visible = false;
         this.crew.margin(15,0,0,236);
         this.crewList.addChild(new CrewSelector(this.crews,this.crewNames,this.handleSelectCrew));
         this.ready();
      }
      
      private function handleCrew(param1:Message) : void
      {
         var i:int;
         var crewname:String;
         var subscribers:uint;
         var logoWorldId:String;
         var myRank:int;
         var canEditDescriptions:Boolean;
         var canChangeColors:Boolean;
         var faceplatesCount:int;
         var ranksCount:int;
         var ranks:CrewRanks;
         var worldsCount:int;
         var c:int;
         var member:CrewMemberItem = null;
         var m:Message = param1;
         this.crewMembers = [];
         this.crewWorlds = [];
         i = 0;
         if(m.getBoolean(i++))
         {
            this.handleCrewError();
            return;
         }
         this.crewId = m.getString(i++);
         crewname = m.getString(i++);
         subscribers = m.getUInt(i++);
         logoWorldId = m.getString(i++);
         myRank = m.getInt(i++);
         this.myRank = myRank;
         this.tabbar.btn_leave.gotoAndStop(myRank == 0 ? 2 : 1);
         this.tabbar.btn_leave.buttonMode = true;
         this.tabbar.btn_leave.useHandCursor = true;
         this.tabbar.btn_leave.mouseEnabled = true;
         this.tabbar.btn_leave.addEventListener(MouseEvent.MOUSE_DOWN,this.handleTopBarButton,false,0,true);
         canEditDescriptions = false;
         canChangeColors = false;
         if(myRank >= 0)
         {
            canEditDescriptions = m.getBoolean(i++);
            canChangeColors = m.getBoolean(i++);
         }
         i += 5;
         faceplatesCount = m.getInt(i++);
         i += faceplatesCount;
         ranksCount = m.getInt(i++);
         ranks = new CrewRanks(m,i,ranksCount,myRank,canEditDescriptions);
         i += ranksCount * 2;
         worldsCount = m.getInt(i++);
         c = 0;
         while(c < worldsCount)
         {
            this.crewWorlds.push(m.getString(i++));
            c++;
         }
         this.worldPreviews = [];
         if(this.crewWorlds.length > 0)
         {
            this.loadingWorldPreviews = true;
            Global.client.bigDB.loadKeys("Worlds",this.crewWorlds,function(param1:Array):void
            {
               var _loc2_:DatabaseObject = null;
               worldPreviews = [];
               for each(_loc2_ in param1)
               {
                  worldPreviews.push(new ProfileWorld(_loc2_,true));
               }
               loadingWorldPreviews = false;
               displayWorlds();
            });
         }
         while(i < m.length)
         {
            member = new CrewMemberItem(m.getString(i),m.getInt(i + 2),m.getString(i + 1),m.getInt(i + 3),m.getBoolean(i + 4),this.crewId,ranks);
            this.crewMembers.push(member);
            member.startAnimations(0.2,this.crewMembers.length);
            i += 5;
         }
         this.ranks = ranks;
         this.initTab();
         Global.currentCrew = "crew" + this.crewId;
         Global.currentCrewName = crewname;
         Global.cookie.data.currentCrew = Global.currentCrew;
         Global.cookie.data.currentCrewName = Global.currentCrewName;
         Global.base.refreshCrewShop();
         Global.base.setCrewName(Global.currentCrewName);
         Global.base.requestCrewLobbyMethod(Global.currentCrew,"getPendingInvites",this.handlePending,null);
      }
      
      private function clearCrewData() : void
      {
         Global.currentCrew = "";
         Global.currentCrewName = "";
         Global.cookie.data.currentCrew = "";
         Global.cookie.data.currentCrewName = "";
         Global.base.setCrewName(Global.currentCrewName);
      }
      
      private function displayWorlds() : void
      {
         var _loc1_:ProfileWorld = null;
         if(this.currentBtnEvent == null || this.currentBtnEvent.target != this.tabbar.btn_worlds)
         {
            return;
         }
         this.crewList.removeAllChildren();
         if(this.loadingWorldPreviews)
         {
            this.addLoadingAnim(true);
            return;
         }
         this.crew.margin(60,0,0,0);
         for each(_loc1_ in this.worldPreviews)
         {
            this.worldList.addChild(_loc1_);
         }
         this.crewScrollBox.refresh();
      }
      
      private function handlePending(param1:Message) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.pendingItems = [];
         if(param1.getBoolean(0))
         {
            _loc2_ = 1;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1.getInt(_loc2_ + 1);
               this.pendingItems.push(new InviteStatus(this.crewId,param1.getString(_loc2_),_loc3_,this.removePendingInvite));
               _loc2_ += 2;
            }
         }
         this.ready();
      }
      
      private function removePendingInvite(param1:String) : void
      {
         var _loc3_:InviteStatus = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.pendingItems.length)
         {
            _loc3_ = this.pendingItems[_loc2_] as InviteStatus;
            if(_loc3_.username == param1)
            {
               if(this.crewList.contains(_loc3_))
               {
                  this.crewList.removeChild(_loc3_);
               }
               this.pendingItems.splice(_loc2_,1);
               return;
            }
            _loc2_++;
         }
      }
      
      public function sendNewAlert() : void
      {
         this.crewList.removeAllChildren();
         this.crew.margin(60,0,0,231);
         this.crewList.addChild(new NewAlert());
         this.crewScrollBox.refresh();
      }
      
      public function refresh(param1:Function = null) : void
      {
         if(!this.isLoading && this.crewRefreshDate == null || new Date().time - this.crewRefreshDate.time > UPDATE)
         {
            this.refreshContentCrew(param1);
         }
         else if(param1 != null)
         {
            param1();
         }
      }
      
      override public function set width(param1:Number) : void
      {
         this.content.width = param1;
         this.tabbar.x = Math.round(param1 / 2);
      }
      
      override public function set height(param1:Number) : void
      {
         this.content.height = param1;
      }
   }
}


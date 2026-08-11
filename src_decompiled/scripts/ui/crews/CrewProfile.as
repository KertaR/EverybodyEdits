package ui.crews
{
   import blitter.Bl;
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.*;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.*;
   import playerio.Client;
   import playerio.DatabaseObject;
   import playerio.Message;
   import playerio.PlayerIO;
   import sample.ui.components.Box;
   import sample.ui.components.Label;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   import ui.WorldPreview;
   import ui.profile.Crew.MiniColorPicker;
   import ui.profile.FillBox;
   import ui.profile.ProfileWorld;
   import utilities.AsyncTasks;
   
   public class CrewProfile extends Sprite
   {
      
      public static var MODE_STANDALONE:String = "standalone";
      
      public static var MODE_INGAME:String = "ingame";
      
      private var mode:String;
      
      private var crewname:String;
      
      private var crewId:String;
      
      private var currentState:String = "";
      
      private var subscribers:uint;
      
      private var loadingText:Box;
      
      private var base:Box;
      
      private var baseFillBox:Box;
      
      private var content:Box;
      
      private var closeButton:Box;
      
      private var subButtonBox:Box;
      
      private var leftFillBox:Box;
      
      private var rightFillBox:Box;
      
      private var faceplateBox:Box;
      
      private var crew_members:Rows;
      
      private var crew_levels:Rows;
      
      private var color_items:Rows;
      
      private var crewWorlds:FillBox;
      
      private var members:FillBox;
      
      private var closeProfile:ProfileCloseButton;
      
      private var rooms:Array;
      
      private var membersArray:Array;
      
      private var subscribeButton:assets_subscribebtn;
      
      private var unsubscribeButton:assets_unsubscribebtn;
      
      private var hasSubscribed:Boolean = false;
      
      private var logoWorldId:String;
      
      private var ranks:CrewRanks;
      
      private var crewBackgroundColor:uint = 3355443;
      
      private var crewBackground2ndColor:uint = 1118481;
      
      private var crewTextColor:uint = 16777215;
      
      private var crewnameLabel:Label;
      
      private var crewSubscriberLabel:Label;
      
      private var viewProfileLabel:Label;
      
      private var worldsHeader:Label;
      
      private var crewWorldsHeader:Label;
      
      private var crewInfo:Label;
      
      private var crewMembers:Label;
      
      private var dividersHeader:Label;
      
      private var colorsHeader:Label;
      
      private var changeStateBtn:assets_changeState;
      
      private var faceplate:Faceplate;
      
      private var faceplates:Array;
      
      private var isError:Boolean;
      
      private var abort:Boolean = false;
      
      private var canChangeColors:Boolean;
      
      private var headerBox:Box;
      
      private var worldsScroll:ScrollBox;
      
      private var worldsBox:Box;
      
      private var crewInfoBox:Box;
      
      private var crewInfoFillBox:Box;
      
      private var membersBox:Box;
      
      private var colorHeaderBox:Box;
      
      private var colorsBoxStuff:Box;
      
      private var colorsHeaderFillBox:Box;
      
      private var colorsFillBox:Box;
      
      private var colorPicker:MiniColorPicker;
      
      private var worldlist:Array;
      
      private var totalPlays:int = 0;
      
      public function CrewProfile(param1:String, param2:String = "", param3:uint = 3355443, param4:uint = 1118481, param5:uint = 16777215)
      {
         var blackBG:BlackBG;
         var load:assets_loading;
         var crewname:String = param1;
         var mode:String = param2;
         var color:uint = param3;
         var color2:uint = param4;
         var colortxt:uint = param5;
         this.loadingText = new Box();
         this.base = new Box();
         this.content = new Box();
         this.closeButton = new Box();
         this.crew_members = new Rows();
         this.crew_levels = new Rows();
         this.color_items = new Rows();
         this.crewWorlds = new FillBox(2);
         this.members = new FillBox(7);
         this.closeProfile = new ProfileCloseButton();
         this.rooms = [];
         this.membersArray = [];
         this.faceplates = [];
         this.worldlist = [];
         super();
         blackBG = new BlackBG();
         addChild(blackBG);
         if(mode == "")
         {
            mode = MODE_STANDALONE;
         }
         this.mode = mode;
         if(mode == MODE_INGAME)
         {
            this.closeProfile.addEventListener(MouseEvent.MOUSE_DOWN,this.handleCloseProfile,false,0,true);
            this.closeButton = new Box().margin(4,4,NaN,NaN).add(this.closeProfile);
            this.content.add(this.closeButton);
         }
         this.crewBackgroundColor = color;
         this.crewBackground2ndColor = color2;
         this.crewTextColor = colortxt;
         this.crewname = crewname;
         this.base.margin(10,0,0,0);
         this.faceplateBox = new Box().margin(0,0,NaN,0);
         this.baseFillBox = new Box().fill(this.crewBackgroundColor,1,10);
         this.baseFillBox.margin(0,0,0,0).add(this.faceplateBox);
         this.baseFillBox.add(this.content);
         this.base.add(this.baseFillBox);
         load = new assets_loading();
         this.loadingText.addChild(load);
         this.loadingText.x -= 100;
         this.loadingText.y -= 60;
         this.content.margin(0,0,0,0);
         addChild(this.base);
         this.content.addChild(this.loadingText);
         this.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         if(mode != MODE_INGAME)
         {
            Global.base.loadStoredCookie(function():void
            {
               if(Boolean(Global.cookie.data.username) && Boolean(Global.cookie.data.password))
               {
                  PlayerIO.authenticate(Bl.stage,Config.playerio_game_id,"simpleusers",{
                     "email":Global.cookie.data.username,
                     "password":Global.cookie.data.password
                  },null,function(param1:Client):void
                  {
                     initAfterAuth(param1);
                  });
               }
               else
               {
                  Global.base.authenticateAsGuest(function(param1:Client):void
                  {
                     initAfterAuth(param1);
                  });
               }
            });
         }
         else
         {
            this.initCrew();
         }
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
      }
      
      private function initAfterAuth(param1:Client) : void
      {
         var c:Client = param1;
         if(Config.use_debug_server)
         {
            c.multiplayer.developmentServer = Config.developer_server;
         }
         Global.base.client = c;
         Global.client = c;
         Badges.refresh(function():void
         {
            var tasks:AsyncTasks = null;
            tasks = new AsyncTasks(1,initCrew);
            if(!Bl.StaffObject)
            {
               tasks.addTask();
               Global.client.bigDB.load("Config","staff",function(param1:DatabaseObject):void
               {
                  Bl.StaffObject = param1;
                  tasks.next();
               });
            }
            if(!Bl.PatronsObject)
            {
               tasks.addTask();
               Global.client.bigDB.load("Config","patrons",function(param1:DatabaseObject):void
               {
                  Bl.PatronsObject = param1;
                  tasks.next();
               });
            }
            tasks.next();
         });
      }
      
      public function setState(param1:String) : void
      {
         this.currentState = param1;
      }
      
      public function initCrew() : void
      {
         Global.base.requestRemoteMethod("getCrew",this.handleCrew,this.crewname);
      }
      
      public function getMemberItemByUsername(param1:String) : CrewMemberItem
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.membersArray.length)
         {
            if((this.membersArray[_loc2_] as CrewMemberItem).username == param1)
            {
               return this.membersArray[_loc2_] as CrewMemberItem;
            }
            _loc2_++;
         }
         return null;
      }
      
      private function handleCrew(param1:Message) : void
      {
         var _loc11_:String = null;
         var _loc12_:CrewMemberItem = null;
         var _loc2_:* = 0;
         this.isError = param1.getBoolean(_loc2_++);
         if(this.isError)
         {
            if(this.content.contains(this.loadingText))
            {
               this.content.removeChild(this.loadingText);
            }
            this.content.addChild(new Box().add(new Label("Crew not found!",15,"center",16720418,false,"system")));
            ++this.base.height;
            this.handleResize();
            if(this.content.contains(this.closeButton))
            {
               this.content.removeChild(this.closeButton);
               this.content.add(this.closeButton);
            }
            return;
         }
         this.crewId = param1.getString(_loc2_++);
         this.crewname = param1.getString(_loc2_++);
         this.subscribers = param1.getUInt(_loc2_++);
         this.logoWorldId = param1.getString(_loc2_++);
         var _loc3_:int = param1.getInt(_loc2_++);
         var _loc4_:Boolean = false;
         if(_loc3_ >= 0)
         {
            _loc4_ = param1.getBoolean(_loc2_++);
            this.canChangeColors = param1.getBoolean(_loc2_++);
         }
         this.crewTextColor = param1.getUInt(_loc2_++);
         this.crewBackgroundColor = param1.getUInt(_loc2_++);
         this.crewBackground2ndColor = param1.getUInt(_loc2_++);
         var _loc5_:String = param1.getString(_loc2_++);
         _loc5_ = _loc5_.substring(0,1).toUpperCase() + _loc5_.substring(1);
         this.setFaceplate(_loc5_,param1.getUInt(_loc2_++));
         var _loc6_:int = param1.getInt(_loc2_++);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc11_ = param1.getString(_loc2_++);
            _loc11_ = _loc11_.substring(0,1).toUpperCase() + _loc11_.substring(1);
            this.faceplates.push(_loc11_);
            _loc7_++;
         }
         var _loc8_:int = param1.getInt(_loc2_++);
         this.ranks = new CrewRanks(param1,_loc2_,_loc8_,_loc3_,_loc4_);
         _loc2_ += _loc8_ * 2;
         var _loc9_:int = param1.getInt(_loc2_++);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            this.rooms.push(param1.getString(_loc2_++));
            _loc10_++;
         }
         while(_loc2_ < param1.length)
         {
            _loc12_ = new CrewMemberItem(param1.getString(_loc2_),param1.getInt(_loc2_ + 2),param1.getString(_loc2_ + 1),param1.getInt(_loc2_ + 3),param1.getBoolean(_loc2_ + 4),this.crewId,this.ranks);
            this.members.addChild(_loc12_);
            this.membersArray.push(_loc12_);
            _loc2_ += 5;
         }
         if(this.crewId != "everybodyeditsstaff")
         {
            Global.base.requestRemoteMethod("isSubscribedToCrew",this.handleSubscribeCheck,this.crewId);
         }
         this.showProfile();
      }
      
      private function handleSubscribeCheck(param1:Message) : void
      {
         if(!this.isError)
         {
            this.hasSubscribed = param1.getBoolean(0);
            if(!this.hasSubscribed)
            {
               this.subscribeButton = new assets_subscribebtn();
               this.subscribeButton.addEventListener(MouseEvent.CLICK,this.handleSubscribeButton);
               this.subButtonBox = new Box().margin(34,NaN,NaN,143).add(this.subscribeButton);
               this.content.add(this.subButtonBox);
            }
            else
            {
               this.unsubscribeButton = new assets_unsubscribebtn();
               this.unsubscribeButton.addEventListener(MouseEvent.CLICK,this.handleSubscribeButton);
               this.subButtonBox = new Box().margin(34,NaN,NaN,143).add(this.unsubscribeButton);
               this.content.add(this.subButtonBox);
            }
         }
      }
      
      private function showProfile() : void
      {
         var leftBox:Box;
         var rightBox:Box;
         var i:int;
         var viewProfile:Box = null;
         var box:Box = null;
         if(this.content.contains(this.loadingText))
         {
            this.content.removeChild(this.loadingText);
         }
         this.faceplateBox.add(new Box().margin(0,0,NaN,0).add(this.faceplate));
         this.crewnameLabel = new Label(this.crewname,23,"left",this.crewTextColor,false,"system");
         this.crewSubscriberLabel = new Label(this.subscribers + " Subscriber" + (this.subscribers != 1 ? "s" : ""),12,"left",this.crewTextColor,false,"system");
         if(this.crewId == "everybodyeditsstaff")
         {
            this.crewSubscriberLabel.text = "Subscribers: Everyone";
         }
         this.content.add(new Box().margin(5,5,5,5).add(this.crewnameLabel));
         this.content.add(new Box().margin(this.crewnameLabel.height + 3,5,5,10).add(this.crewSubscriberLabel));
         leftBox = new Box().margin(65,5,5,349);
         this.leftFillBox = new Box().margin(0,0,0,0);
         this.leftFillBox.fill(this.crewBackground2ndColor,1,10).margin(0,0,0,0);
         leftBox.add(this.leftFillBox);
         this.content.add(leftBox);
         rightBox = new Box().margin(65,486,5,5);
         this.rightFillBox = new Box().margin(0,0,0,0);
         this.rightFillBox.fill(this.crewBackground2ndColor,1,10).margin(0,0,0,0);
         rightBox.add(this.rightFillBox);
         this.content.add(rightBox);
         this.showNormalProfile(true);
         if(this.mode == MODE_INGAME)
         {
            this.viewProfileLabel = new Label("",10,"left",this.crewTextColor,false,"system");
            this.viewProfileLabel.htmlText = "<u>Show on homepage</u>";
            this.viewProfileLabel.mouseEnabled = false;
            viewProfile = new Box().margin(40,0,NaN,NaN).add(this.viewProfileLabel);
            viewProfile.mouseEnabled = true;
            viewProfile.buttonMode = true;
            viewProfile.addEventListener(MouseEvent.MOUSE_DOWN,this.handleShowProfilePage,false,0,true);
            this.content.add(viewProfile);
            if(this.content.contains(this.closeButton))
            {
               this.content.removeChild(this.closeButton);
               this.content.add(this.closeButton);
            }
         }
         if(this.ranks.myRank.canCustomizeProfile)
         {
            this.changeStateBtn = new assets_changeState();
            this.changeStateBtn.tf_text.textColor = this.crewTextColor;
            box = new Box().margin(39,viewProfile ? viewProfile.width + 8 : 8,NaN,NaN).add(this.changeStateBtn);
            box.buttonMode = true;
            box.useHandCursor = true;
            box.mouseChildren = false;
            this.content.add(box);
            this.changeStateBtn.gotoAndStop(1);
            box.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               switch(changeStateBtn.currentFrame)
               {
                  case 1:
                     showNormalProfile(false,true);
                     showColorCustomization(true);
                     changeStateBtn.gotoAndStop(2);
                     break;
                  case 2:
                     showNormalProfile(true);
                     showColorCustomization(false);
                     changeStateBtn.gotoAndStop(1);
               }
               changeStateBtn.tf_text.textColor = crewTextColor;
            });
         }
         i = 0;
         while(i < this.members.numChildren)
         {
            (this.members.getChildAt(i) as CrewMemberItem).startAnimations(0.2,i);
            i++;
         }
         this.loadNextLevel(Global.base.client);
         this.setColor("primary",this.crewBackgroundColor);
      }
      
      private function showNormalProfile(param1:Boolean, param2:Boolean = false) : void
      {
         var headerFillBox:Box = null;
         var worldsFillBox:Box = null;
         var membersScroll:ScrollBox = null;
         var membersFillBox:Box = null;
         var logo:Bitmap = null;
         var logoBox:Box = null;
         var noLogo:Label = null;
         var noLogoBox:Box = null;
         var worldBox:Box = null;
         var value:Boolean = param1;
         var membersOnly:Boolean = param2;
         if(!this.headerBox)
         {
            this.headerBox = new Box().margin(65,0,0,349);
            headerFillBox = new Box().margin(0,0,0,0);
            this.crewWorldsHeader = new Label("Levels by " + this.crewname + ", click to play!",12,"center",this.crewTextColor,true,"system");
            this.crewWorldsHeader.autoSize = TextFieldAutoSize.CENTER;
            headerFillBox.add(new Box().margin(3,0,0,0).add(this.crewWorldsHeader));
            this.headerBox.add(headerFillBox);
            this.worldsBox = new Box().margin(85,5,5,349);
            this.worldsScroll = new ScrollBox().margin(3,3,3,3);
            this.worldsScroll.scrollMultiplier = 6;
            this.worldsScroll.add(new Box().margin(0,0,0,5).add(this.crew_levels));
            this.crew_levels.addChild(this.crewWorlds);
            worldsFillBox = new Box().margin(3,3,3,3);
            worldsFillBox.add(this.worldsScroll);
            this.worldsBox.add(worldsFillBox);
            this.content.add(this.headerBox);
            this.content.add(this.worldsBox);
         }
         else
         {
            this.headerBox.visible = value;
            this.worldsBox.visible = value;
         }
         if(!this.crewInfoBox)
         {
            this.crewInfoBox = new Box().margin(65,479,262,0);
            this.crewInfoFillBox = new Box().margin(0,0,0,0);
            if(this.logoWorldId == "")
            {
               logo = new Bitmap(new BitmapData(100,100,false,10066329));
               logoBox = new Box().margin(15,230,NaN,15).add(logo);
               this.crewInfoFillBox.add(logoBox);
               noLogo = new Label("\nNo\nLogo",18,"center",16777215,true,"system");
               noLogoBox = new Box().margin(20,230,NaN,15).add(noLogo);
               this.crewInfoFillBox.add(noLogoBox);
            }
            else
            {
               worldBox = new Box().margin(15,230,NaN,15);
               this.crewInfoFillBox.add(worldBox);
               Global.base.client.bigDB.load("Worlds",this.logoWorldId,function(param1:DatabaseObject):void
               {
                  var o:DatabaseObject = param1;
                  worldBox.add(new WorldPreview(o,ranks.myRank.id >= 0,!Global.normalStart,function():void
                  {
                     handleCloseProfile(null);
                  }));
               });
            }
            this.crewInfo = new Label("",12.5,"left",this.crewTextColor,true,"system");
            this.setCrewInfoText();
            this.crewInfo.antiAliasType = AntiAliasType.ADVANCED;
            this.crewInfoFillBox.add(new Box().margin(20,11,62,142).add(this.crewInfo));
            this.crewMembers = new Label("Crew Members",17,"center",this.crewTextColor,false,"system");
            this.crewInfoFillBox.add(new Box().margin(91,4,27,110).add(this.crewMembers));
            this.crewInfoBox.add(this.crewInfoFillBox);
            this.membersBox = new Box().margin(192,494,8,20);
            membersScroll = new ScrollBox().margin(0,8,5,0);
            membersScroll.scrollMultiplier = 6;
            membersScroll.add(new Box().margin(0,0,0,0).add(this.crew_members));
            this.crew_members.addChild(this.members);
            membersFillBox = new Box().margin(0,0,0,0);
            membersFillBox.add(membersScroll);
            this.membersBox.add(membersFillBox);
            this.content.add(this.crewInfoBox);
            this.content.add(this.membersBox);
         }
         else
         {
            this.crewInfoBox.visible = value || membersOnly;
            this.crewInfoFillBox.visible = value || membersOnly;
            this.membersBox.visible = value || membersOnly;
         }
      }
      
      private function showColorCustomization(param1:Boolean) : void
      {
         if(!this.colorHeaderBox)
         {
            this.colorHeaderBox = new Box().margin(65,0,0,349);
            this.colorsHeaderFillBox = new Box().margin(0,0,0,0);
            this.colorsHeader = new Label("Change the look of your crew profile!",12,"center",this.crewTextColor,true,"system");
            this.colorsHeader.autoSize = TextFieldAutoSize.CENTER;
            this.colorsHeaderFillBox.add(new Box().margin(5,0,0,0).add(this.colorsHeader));
            this.colorHeaderBox.add(this.colorsHeaderFillBox);
            this.colorsBoxStuff = new Box().margin(85,5,5,349);
            this.colorsFillBox = new Box().margin(3,3,3,3);
            this.colorPicker = new MiniColorPicker(this.crewTextColor,this.crewBackgroundColor,this.crewBackground2ndColor,this.canChangeColors,this.setColor,this.saveColors);
            this.colorsFillBox.add(this.colorPicker);
            this.colorsFillBox.add(new FaceplateSelector(this.faceplate.type,this.faceplate.color,this.faceplates,this.faceplates.length > 0,this.setFaceplate,this.saveFaceplate));
            this.colorsFillBox.forceScale = false;
            this.colorsBoxStuff.add(this.colorsFillBox);
            this.content.add(this.colorHeaderBox);
            this.content.add(this.colorsBoxStuff);
         }
         else
         {
            this.colorHeaderBox.visible = param1;
            this.colorsBoxStuff.visible = param1;
         }
      }
      
      private function setFaceplate(param1:String, param2:int) : void
      {
         if(this.faceplate != null)
         {
            this.faceplate.setFaceplate(param1,param2);
         }
         else
         {
            this.faceplate = new Faceplate(param1,param2);
         }
      }
      
      private function saveColors() : void
      {
         Global.base.requestCrewLobbyMethod("crew" + this.crewId,"setColors",null,null,this.crewTextColor,this.crewBackgroundColor,this.crewBackground2ndColor);
         this.colorPicker.disabledOverlay.visible = true;
      }
      
      private function saveFaceplate() : void
      {
         Global.base.requestCrewLobbyMethod("crew" + this.crewId,"setFaceplate",null,null,this.faceplate.type,this.faceplate.color);
      }
      
      private function setColor(param1:String, param2:uint) : void
      {
         switch(param1)
         {
            case "text":
               this.crewTextColor = param2;
               if(this.crewnameLabel)
               {
                  this.crewnameLabel.textColor = this.crewTextColor;
               }
               if(this.crewSubscriberLabel)
               {
                  this.crewSubscriberLabel.textColor = this.crewTextColor;
               }
               if(this.viewProfileLabel)
               {
                  this.viewProfileLabel.textColor = this.crewTextColor;
               }
               if(this.worldsHeader)
               {
                  this.worldsHeader.textColor = this.crewTextColor;
               }
               if(this.crewWorldsHeader)
               {
                  this.crewWorldsHeader.textColor = this.crewTextColor;
               }
               if(this.crewInfo)
               {
                  this.crewInfo.textColor = this.crewTextColor;
               }
               if(this.crewMembers)
               {
                  this.crewMembers.textColor = this.crewTextColor;
               }
               if(this.worldsHeader)
               {
                  this.worldsHeader.textColor = this.crewTextColor;
               }
               if(this.dividersHeader)
               {
                  this.dividersHeader.textColor = this.crewTextColor;
               }
               if(this.colorsHeader)
               {
                  this.colorsHeader.textColor = this.crewTextColor;
               }
               if(this.changeStateBtn)
               {
                  this.changeStateBtn.tf_text.textColor = this.crewTextColor;
               }
               break;
            case "primary":
               this.crewBackgroundColor = param2;
               this.baseFillBox.color = this.crewBackgroundColor;
               break;
            case "secondary":
               this.crewBackground2ndColor = param2;
               this.leftFillBox.color = this.crewBackground2ndColor;
               this.rightFillBox.color = this.crewBackground2ndColor;
         }
      }
      
      private function handleSubscribeButton(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case this.subscribeButton:
               if(!this.hasSubscribed)
               {
                  this.content.removeChild(this.subButtonBox);
                  Global.base.requestCrewLobbyMethod("crew" + this.crewId,"subscribe",this.handleSubscribe,null);
               }
               break;
            case this.unsubscribeButton:
               if(this.hasSubscribed)
               {
                  this.content.removeChild(this.subButtonBox);
                  Global.base.requestCrewLobbyMethod("crew" + this.crewId,"unsubscribe",this.handleSubscribe,null);
               }
         }
      }
      
      private function handleSubscribe(param1:Message) : void
      {
         var _loc2_:uint = param1.getUInt(0);
         this.crewSubscriberLabel.text = _loc2_ + " Subscriber" + (_loc2_ != 1 ? "s" : "");
         if(!this.hasSubscribed)
         {
            this.unsubscribeButton = new assets_unsubscribebtn();
            this.unsubscribeButton.addEventListener(MouseEvent.CLICK,this.handleSubscribeButton);
            this.subButtonBox = new Box().margin(34,NaN,NaN,143).add(this.unsubscribeButton);
         }
         else
         {
            this.subscribeButton = new assets_subscribebtn();
            this.subscribeButton.addEventListener(MouseEvent.CLICK,this.handleSubscribeButton);
            this.subButtonBox = new Box().margin(34,NaN,NaN,143).add(this.subscribeButton);
         }
         this.hasSubscribed = !this.hasSubscribed;
         this.content.add(this.subButtonBox);
      }
      
      protected function handleShowProfilePage(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(Config.site + "/crews/" + this.crewId),"_blank");
      }
      
      protected function handleCloseProfile(param1:MouseEvent = null) : void
      {
         if(!Global.normalStart)
         {
            return;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this.abort = true;
      }
      
      private function loadNextLevel(param1:Client) : void
      {
         var toload:String;
         var c:Client = param1;
         if(this.rooms.length == 0 || this.abort)
         {
            return;
         }
         toload = this.rooms.pop();
         if(toload == "")
         {
            this.loadNextLevel(c);
            return;
         }
         c.bigDB.load("Worlds",toload,function(param1:DatabaseObject):void
         {
            renderWorld(param1);
            loadNextLevel(c);
         },this.handleError);
         this.handleResize();
         this.worldsScroll.refresh();
      }
      
      private function renderWorld(param1:DatabaseObject) : void
      {
         if(param1 == null || param1.worlddata == null)
         {
            return;
         }
         if(param1.hasOwnProperty("visible") && !param1["visible"])
         {
            return;
         }
         if(Boolean(param1.hasOwnProperty("hidelobby")) && Boolean(param1["hidelobby"]) && !param1.hasOwnProperty("HideLobby"))
         {
            return;
         }
         if(param1.hasOwnProperty("HideLobby") && Boolean(param1["HideLobby"]))
         {
            return;
         }
         var _loc2_:ProfileWorld = new ProfileWorld(param1,true,!Global.normalStart,this.handleCloseProfile);
         if(_loc2_.width >= 636)
         {
            _loc2_.width = 450;
         }
         this.worldlist.push(_loc2_);
         this.worldlist.sortOn(["plays"],Array.NUMERIC | Array.DESCENDING);
         var _loc3_:int = 0;
         while(_loc3_ < this.worldlist.length)
         {
            this.crewWorlds.addChild(this.worldlist[_loc3_]);
            _loc3_++;
         }
         this.totalPlays += _loc2_.plays;
         this.setCrewInfoText();
         ++this.base.height;
         this.handleResize();
      }
      
      private function setCrewInfoText() : void
      {
         this.crewInfo.text = "Crew Members:\t\t" + this.members.numChildren + "\nTotal Worlds:\t\t" + this.worldlist.length + "\nTotal Plays:\t\t" + this.totalPlays;
      }
      
      private function handleAttach(param1:Event) : void
      {
         this.handleResize();
         x = this.mode == MODE_STANDALONE ? 35 : 10;
         y = 5;
      }
      
      private function handleRemove(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
      }
      
      private function handleError(param1:Error) : void
      {
      }
      
      private function handleResize(param1:Event = null) : void
      {
         if(stage != null)
         {
            this.base.x = 0;
            this.base.y = 0;
            this.base.width = Global.width - 20;
            this.base.height = Global.height - 20;
         }
      }
   }
}


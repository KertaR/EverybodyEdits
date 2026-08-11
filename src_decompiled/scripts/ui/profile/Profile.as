package ui.profile
{
   import blitter.Bl;
   import data.SimpleProfileObject;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.*;
   import items.ItemBrick;
   import items.ItemBrickPackage;
   import items.ItemManager;
   import items.ItemSmiley;
   import playerio.Achievement;
   import playerio.Client;
   import playerio.DatabaseObject;
   import playerio.Message;
   import playerio.PlayerIO;
   import sample.ui.components.Box;
   import sample.ui.components.Label;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   import ui.profile.Information.*;
   import utilities.AsyncTasks;
   import utilities.ColorUtil;
   
   public class Profile extends Sprite
   {
      
      private static var Arrows:Class = Profile_Arrows;
      
      public static var arrowsBMD:BitmapData = new Arrows().bitmapData;
      
      public static var MODE_STANDALONE:String = "standalone";
      
      public static var MODE_INGAME:String = "ingame";
      
      private var maxPages:int = 5;
      
      private var mode:String;
      
      private var base:Box;
      
      private var content:Box;
      
      private var player_badges:Rows;
      
      private var player_items:Rows;
      
      private var player_levels:Rows;
      
      private var smilies:FillBox;
      
      private var badges:FillBox;
      
      private var blocks:FillBox;
      
      private var worlds:FillBox;
      
      private var information:FillBox;
      
      private var crews:FillBox;
      
      private var button:ProfileCloseButton;
      
      private var closebutton:Box;
      
      private var username:String;
      
      private var loadingText:Box;
      
      private var blackBG:BlackBG;
      
      private var pageNumber:int = 0;
      
      private var itemsScroll:ScrollBox;
      
      private var viewSwitch:assets_profileviewswitch;
      
      private var abort:Boolean = false;
      
      private var times:Object;
      
      private var colours:Object;
      
      private var toload:Array;
      
      private var waiting:Array;
      
      private var loaded:Array;
      
      private var started:int;
      
      private var finished:int;
      
      private const multiplex:int = 1;
      
      private var goldmember:Box;
      
      private var profileObject:SimpleProfileObject;
      
      public function Profile(param1:String, param2:String = "")
      {
         var load:assets_loading;
         var username:String = param1;
         var mode:String = param2;
         this.base = new Box();
         this.content = new Box();
         this.player_badges = new Rows();
         this.player_items = new Rows();
         this.player_levels = new Rows();
         this.smilies = new FillBox(0);
         this.badges = new FillBox(0);
         this.blocks = new FillBox(2);
         this.worlds = new FillBox(2);
         this.information = new FillBox(22);
         this.crews = new FillBox(10);
         this.button = new ProfileCloseButton();
         this.loadingText = new Box();
         this.viewSwitch = new assets_profileviewswitch();
         super();
         this.blackBG = new BlackBG();
         addChild(this.blackBG);
         if(mode == "")
         {
            mode = MODE_STANDALONE;
         }
         this.mode = mode;
         if(mode == MODE_INGAME)
         {
            this.button.addEventListener(MouseEvent.MOUSE_DOWN,this.handleCloseProfile,false,0,true);
            this.closebutton = new Box().margin(4,4,NaN,NaN).add(this.button);
            this.content.add(this.closebutton);
         }
         this.username = username;
         this.base.margin(10,0,0,0);
         this.base.add(new Box().fill(3355443,1,10).margin(5,5,5,5).add(this.content));
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
         this.base.filters = [new GlowFilter(0,1,6,6,1,10)];
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
         else if(!Badges.loaded)
         {
            this.init();
         }
         else
         {
            Global.base.requestRemoteMethod("getProfileObject",this.handleProfileObject,username);
         }
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         this.x += 10;
         this.y += 5;
      }
      
      private function initAfterAuth(param1:Client) : void
      {
         Global.base.client = param1;
         Global.client = param1;
         if(Config.use_debug_server)
         {
            param1.multiplayer.developmentServer = Config.developer_server;
         }
         this.init();
      }
      
      private function init() : void
      {
         Badges.refresh(function():void
         {
            var tasks:AsyncTasks = null;
            tasks = new AsyncTasks(1,function():void
            {
               Global.base.requestRemoteMethod("getProfileObject",handleProfileObject,username);
            });
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
      
      private function handleProfileObject(param1:Message) : void
      {
         var _loc3_:* = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         this.profileObject = new SimpleProfileObject();
         var _loc2_:* = 0;
         this.profileObject.status = param1.getString(_loc2_++);
         if(this.profileObject.status == "public")
         {
            this.profileObject.key = param1.getString(_loc2_++);
            this.profileObject.name = param1.getString(_loc2_++);
            this.profileObject.oldname = param1.getString(_loc2_++);
            this.profileObject.smiley = param1.getInt(_loc2_++);
            this.profileObject.maxEnergy = param1.getInt(_loc2_++);
            this.profileObject.isOldBeta = param1.getBoolean(_loc2_++);
            this.profileObject.isAdministrator = param1.getBoolean(_loc2_++);
            this.profileObject.goldmember = param1.getBoolean(_loc2_++);
            this.profileObject.goldremain = param1.getNumber(_loc2_++);
            this.profileObject.goldtime = param1.getNumber(_loc2_++);
            this.profileObject.room0 = param1.getString(_loc2_) != "" ? param1.getString(_loc2_) : null;
            _loc2_++;
            this.profileObject.betaonlyroom = param1.getString(_loc2_) != "" ? param1.getString(_loc2_) : null;
            _loc2_++;
            this.profileObject.setRooms(param1.getString(_loc2_++).split("᎙"),param1.getString(_loc2_++).split("᎙"),param1.getString(_loc2_++).split("᎙"));
            this.times = {};
            this.colours = {};
            _loc3_ = param1.getInt(_loc2_++);
            while(_loc3_ > 0)
            {
               _loc4_ = param1.getString(_loc2_++);
               this.colours[_loc4_] = param1.getInt(_loc2_++);
               _loc5_ = new Array(param1.getInt(_loc2_++));
               _loc6_ = 0;
               while(_loc6_ < _loc5_.length)
               {
                  if(param1.getBoolean(_loc2_++))
                  {
                     _loc7_ = param1.getInt(_loc2_++);
                     _loc8_ = param1.getInt(_loc2_++);
                     _loc9_ = [];
                     _loc9_.push(param1.getInt(_loc2_++));
                     _loc9_.push(param1.getInt(_loc2_++));
                     _loc9_.push(param1.getInt(_loc2_++));
                     if(_loc8_ >= 3)
                     {
                        _loc9_.push(param1.getInt(_loc2_++));
                     }
                     if(_loc8_ >= 5)
                     {
                        _loc9_.push(param1.getInt(_loc2_++));
                     }
                     _loc5_[_loc6_] = {
                        "enabled":true,
                        "time":_loc7_,
                        "rank":_loc8_,
                        "targets":_loc9_
                     };
                  }
                  else
                  {
                     _loc5_[_loc6_] = {"enabled":false};
                  }
                  _loc6_++;
               }
               this.times[_loc4_] = _loc5_;
               _loc3_--;
            }
         }
         this.showProfile();
      }
      
      private function showProfile() : void
      {
         var note:String = null;
         var usernameLabel:Label = null;
         var headerBox:Box = null;
         var headerFillBox:Box = null;
         var itemsBox:Box = null;
         var itemsFillBox:Box = null;
         var badgesHeaderBox:Box = null;
         var badgesHeaderFillBox:Box = null;
         var badgesHeader:Label = null;
         var badgesBox:Box = null;
         var badgesScroll:ScrollBox = null;
         var badgesFillBox:Box = null;
         var i:int = 0;
         var staffRole:String = null;
         var oldUsernameLabel:Label = null;
         var viewProfileLabel:Label = null;
         var viewProfile:Box = null;
         this.content.removeChild(this.loadingText);
         if(this.profileObject.status == "private")
         {
            this.content.addChild(new Box().add(new Label(this.username.toUpperCase() + "\'s profile is private!",15,"center",16720418,false,"system")));
            ++this.base.height;
            this.handleResize();
            if(this.mode == MODE_INGAME)
            {
               if(this.content.contains(this.closebutton))
               {
                  this.content.removeChild(this.closebutton);
                  this.content.add(this.closebutton);
               }
            }
         }
         else if(this.profileObject.status == "error")
         {
            this.content.addChild(new Box().add(new Label("Player not found!",15,"center",16720418,false,"system")));
            ++this.base.height;
            this.handleResize();
            if(this.mode == MODE_INGAME && this.content.contains(this.closebutton))
            {
               this.content.removeChild(this.closebutton);
               this.content.add(this.closebutton);
            }
         }
         else
         {
            note = "";
            if(Player.isStaffMember(this.profileObject.name))
            {
               staffRole = Player.isAdmin(this.profileObject.name) ? (this.profileObject.name.toLocaleLowerCase() == "xenonetix" ? "Owner" : "Development Team") : (Player.isModerator(this.profileObject.name) ? "Moderation Team" : (Player.isCampaignCurator(this.profileObject.name) ? "Campaign Team" : (Player.isDesigner(this.profileObject.name) ? "Design Team" : "")));
               if(staffRole != "")
               {
                  note = "Everybody Edits " + staffRole + "!";
               }
            }
            else if(Player.isPatron(this.profileObject.name))
            {
               note = Player.getPatronTier(this.profileObject.name) + " EE Patreon Supporter!";
            }
            usernameLabel = new Label(this.profileObject.name.toUpperCase(),25,"center",Player.getNameColor(this.profileObject.name),false,"system");
            ColorUtil.colorizeUsername(usernameLabel);
            this.content.add(new Box().margin(note != "" ? 5 : 10,0,0,0).add(usernameLabel));
            if(note != "")
            {
               this.content.add(new Box().margin(35,0,0,0).add(new Label(note,12,"center",Player.getNameColor(this.profileObject.name),false,"system")));
            }
            if(this.profileObject.oldname != "")
            {
               oldUsernameLabel = new Label("Previously known as: " + this.profileObject.oldname.toUpperCase(),12,"left",16777215,false,"system");
               this.content.add(new Box().margin(5,0,0,0).add(oldUsernameLabel));
            }
            headerBox = new Box().margin(60,0,0,350);
            headerFillBox = new Box();
            headerFillBox.fill(1118481,1,10).margin(3,3,3,3);
            this.viewSwitch.tf_text.text = "Worlds";
            this.viewSwitch.btn_left.visible = false;
            this.viewSwitch.btn_right.visible = false;
            headerFillBox.add(new Box().margin(0,NaN,NaN,NaN).add(this.viewSwitch));
            headerBox.add(headerFillBox);
            itemsBox = new Box().margin(85,0,0,350);
            this.itemsScroll = new ScrollBox().margin(3,3,3,3);
            this.itemsScroll.scrollMultiplier = 6;
            this.itemsScroll.add(new Box().margin(0,0,0,15).add(this.player_items));
            this.player_items.spacing(3);
            this.setItemsPage(0);
            itemsFillBox = new Box();
            itemsFillBox.fill(1118481,1,10).margin(3,3,3,3);
            itemsFillBox.add(this.itemsScroll);
            itemsBox.add(itemsFillBox);
            this.content.add(headerBox);
            this.content.add(itemsBox);
            badgesHeaderBox = new Box().margin(60,itemsFillBox.width,0,0);
            badgesHeaderFillBox = new Box();
            badgesHeaderFillBox.fill(1118481,1,10).margin(3,3,3,3);
            badgesHeader = new Label("Badges",15,"center",16777215,false,"system");
            badgesHeaderFillBox.add(badgesHeader);
            badgesHeaderBox.add(badgesHeaderFillBox);
            badgesBox = new Box().margin(85,itemsFillBox.width,0,0);
            badgesScroll = new ScrollBox().margin(3,3,3,3);
            badgesScroll.scrollMultiplier = 6;
            badgesScroll.add(new Box().margin(0,0,0,10).add(this.player_badges));
            this.player_badges.addChild(this.badges);
            badgesFillBox = new Box();
            badgesFillBox.fill(1118481,1,10).margin(3,3,3,3);
            badgesFillBox.add(badgesScroll);
            badgesBox.add(badgesFillBox);
            this.content.add(badgesHeaderBox);
            this.content.add(badgesBox);
            if(this.mode == MODE_INGAME)
            {
               viewProfileLabel = new Label("",10,"left",16777215,false,"system");
               viewProfileLabel.htmlText = "<u>Show on homepage</u>";
               viewProfileLabel.mouseEnabled = false;
               viewProfile = new Box().margin(40,0,NaN,NaN).add(viewProfileLabel);
               viewProfile.mouseEnabled = true;
               viewProfile.buttonMode = true;
               viewProfile.addEventListener(MouseEvent.MOUSE_DOWN,this.handleShowProfilePage,false,0,true);
               this.content.add(viewProfile);
               if(this.content.contains(this.closebutton))
               {
                  this.content.removeChild(this.closebutton);
                  this.content.add(this.closebutton);
               }
            }
            PlayerIO.authenticate(Global.stage,Config.playerio_game_id,"Public",{"userId":this.profileObject.key},null,this.handleLoadComplete,this.handleError);
            this.toload = this.profileObject.roomids.filter(function(param1:String, param2:int, param3:Array):Boolean
            {
               return profileObject.roomnamesid[param1] != "";
            }).sort(function(param1:String, param2:String):int
            {
               var _loc3_:* = profileObject.roomnamesid[param1].toUpperCase();
               var _loc4_:* = profileObject.roomnamesid[param2].toUpperCase();
               if(_loc3_ < _loc4_)
               {
                  return 1;
               }
               if(_loc3_ > _loc4_)
               {
                  return -1;
               }
               return 0;
            });
            this.waiting = [];
            this.loaded = [];
            this.started = 0;
            i = 0;
            while(i < this.multiplex)
            {
               this.loadNextLevel(Global.base.client);
               i++;
            }
         }
      }
      
      private function addArrows() : void
      {
         this.viewSwitch.btn_left.buttonMode = true;
         this.viewSwitch.btn_left.visible = true;
         this.viewSwitch.btn_left.addEventListener(MouseEvent.CLICK,function():void
         {
            switchPage(-1);
         });
         this.viewSwitch.btn_right.buttonMode = true;
         this.viewSwitch.btn_right.visible = true;
         this.viewSwitch.btn_right.addEventListener(MouseEvent.CLICK,function():void
         {
            switchPage(1);
         });
      }
      
      private function switchPage(param1:int) : void
      {
         this.pageNumber += param1;
         if(param1 < 0 && this.pageNumber < 0)
         {
            this.pageNumber = this.maxPages - 1;
         }
         if(param1 > 0 && this.pageNumber >= this.maxPages)
         {
            this.pageNumber = 0;
         }
         this.setItemsPage(this.pageNumber);
      }
      
      private function setItemsPage(param1:int) : void
      {
         if(this.player_items.numChildren > 0)
         {
            this.player_items.removeAllChildren();
         }
         switch(param1)
         {
            case 0:
               if(!this.player_items.contains(this.worlds))
               {
                  this.viewSwitch.tf_text.text = "Worlds";
                  this.player_items.addChild(this.worlds);
               }
               break;
            case 1:
               if(!this.player_items.contains(this.smilies))
               {
                  this.viewSwitch.tf_text.text = "Smileys";
                  this.player_items.addChild(this.smilies);
               }
               break;
            case 2:
               if(!this.player_items.contains(this.blocks))
               {
                  this.viewSwitch.tf_text.text = "Blocks";
                  this.player_items.addChild(this.blocks);
               }
               break;
            case 3:
               if(!this.player_items.contains(this.information))
               {
                  this.viewSwitch.tf_text.text = "Information";
                  this.player_items.addChild(this.information);
               }
               break;
            case 4:
               if(!this.player_items.contains(this.crews))
               {
                  this.viewSwitch.tf_text.text = "Crews";
                  this.player_items.addChild(this.crews);
               }
         }
         this.itemsScroll.refresh();
      }
      
      protected function handleShowProfilePage(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(Config.site + "/profiles/" + this.username),"_blank");
      }
      
      protected function handleCloseProfile(param1:Event = null) : void
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
         var next:String;
         var index:int = 0;
         var c:Client = param1;
         if(this.toload.length == 0 || this.abort)
         {
            return;
         }
         next = this.toload.pop();
         index = this.started++;
         this.waiting.push(undefined);
         c.bigDB.load("Worlds",next,function(param1:DatabaseObject):void
         {
            waiting[index - finished] = Boolean(param1 == null || param1.worlddata == null || param1.hasOwnProperty("visible") && !param1["visible"]) || Boolean(param1.hasOwnProperty("hidelobby") && param1["hidelobby"] && !param1.hasOwnProperty("HideLobby")) || Boolean(param1.hasOwnProperty("HideLobby")) && Boolean(param1["HideLobby"]) ? null : new ProfileWorld(param1,true,!Global.normalStart,handleCloseProfile);
            renderWorlds();
            loadNextLevel(c);
         },function handleError(param1:Error):void
         {
            waiting[index - finished - 1] = null;
            renderWorlds();
            loadNextLevel(c);
         });
      }
      
      private function renderWorlds() : void
      {
         var _loc1_:ProfileWorld = null;
         while(this.waiting[0] !== undefined)
         {
            _loc1_ = this.waiting.shift();
            this.finished += 1;
            if(_loc1_ !== null)
            {
               if(_loc1_.width >= 636)
               {
                  _loc1_.width = 415;
               }
               this.loaded.push(_loc1_);
               this.worlds.addChild(_loc1_);
            }
         }
         this.itemsScroll.refresh();
      }
      
      private function handleLoadComplete(param1:Client) : void
      {
         var c:Client = param1;
         c.payVault.refresh(function():void
         {
            c.achievements.refresh(function():void
            {
               renderItems(c);
               addArrows();
               Global.base.requestRemoteMethod("getCrews",function(param1:Message):void
               {
                  loadCrews(param1);
               },username);
            },handleError);
         },this.handleError);
         this.handleResize();
      }
      
      private function loadCrews(param1:Message) : void
      {
         if(param1.length == 0)
         {
            this.crews.addChild(new Label("This user is not in any crews.",12,"center",16777215,false,"system"));
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.crews.addChild(new ProfileCrew(param1.getString(_loc2_),param1.getString(_loc2_ + 1),param1.getString(_loc2_ + 2),this.refreshItemsScroll));
            _loc2_ += 3;
         }
         this.crews.addEventListener(NavigationEvent.SHOW_CREW_PROFILE,this.handleCloseProfile);
      }
      
      private function refreshItemsScroll() : void
      {
         if(this.pageNumber == 4)
         {
            if(this.player_items.numChildren > 0)
            {
               this.player_items.removeAllChildren();
            }
            this.player_items.addChild(this.crews);
            this.itemsScroll.refresh();
         }
      }
      
      private function renderItems(param1:Client) : void
      {
         var _loc2_:ItemSmiley = null;
         var _loc3_:int = 0;
         var _loc4_:Achievement = null;
         var _loc5_:ItemBrickPackage = null;
         var _loc6_:GoldInformation = null;
         var _loc7_:BetaInformation = null;
         var _loc8_:String = null;
         var _loc9_:Vector.<ItemBrick> = null;
         var _loc10_:int = 0;
         var _loc11_:ItemBrick = null;
         var _loc12_:int = 0;
         if(this.profileObject.goldmember)
         {
            _loc6_ = new GoldInformation(this.profileObject.name,Global.toPrettyDate(this.profileObject.goldexpire),Global.toPrettyDate(this.profileObject.goldjoin));
            this.information.addChild(_loc6_);
         }
         if(param1.payVault.has("pro"))
         {
            _loc7_ = new BetaInformation(this.profileObject.name);
            this.information.addChild(_loc7_);
         }
         this.information.x = 0;
         for each(_loc2_ in ItemManager.smilies)
         {
            if(_loc2_.payvaultid == "" || param1.payVault.has(_loc2_.payvaultid) || _loc2_.payvaultid == "pro" && this.profileObject.isOldBeta || this.profileObject.goldmember && _loc2_.payvaultid == "goldmember")
            {
               this.smilies.addChild(new ProfileSmiley(_loc2_));
            }
         }
         _loc3_ = 0;
         for each(_loc4_ in param1.achievements.myAchievements)
         {
            if(_loc4_.completed)
            {
               _loc8_ = _loc4_.id.toUpperCase();
               this.badges.addChild(new ProfileBadge(_loc4_,this.times[_loc8_],this.colours[_loc8_]));
               _loc3_++;
            }
         }
         if(_loc3_ == 0)
         {
            if(this.player_badges.contains(this.badges))
            {
               this.player_badges.removeChild(this.badges);
            }
            this.player_badges.addChild(new Label("This user doesn\'t have any badges.",12,"center",16777215,false,"system"));
         }
         for each(_loc5_ in ItemManager.brickPackages)
         {
            _loc9_ = new Vector.<ItemBrick>();
            _loc10_ = 0;
            while(_loc10_ < _loc5_.bricks.length)
            {
               _loc11_ = _loc5_.bricks[_loc10_];
               if(!_loc11_.requiresAdmin)
               {
                  if(_loc11_.payvaultid == "" || param1.payVault.has(_loc11_.payvaultid) || _loc11_.payvaultid == "pro" && this.profileObject.isOldBeta || _loc11_.payvaultid == "goldmember" && this.profileObject.goldmember)
                  {
                     _loc12_ = 0;
                     while(_loc12_ < (param1.payVault.count(_loc11_.payvaultid) || 1))
                     {
                        _loc9_.push(_loc11_);
                        if(_loc11_.payvaultid != "brickdiamond")
                        {
                           break;
                        }
                        _loc12_++;
                     }
                  }
               }
               _loc10_++;
            }
            if(_loc9_.length)
            {
               this.blocks.addChild(new ProfileBrickPackage(_loc5_,_loc9_));
            }
         }
         ++this.player_items.width;
         ++this.base.height;
         this.handleResize();
      }
      
      private function handleAttach(param1:Event) : void
      {
         stage.addEventListener(Event.RESIZE,this.handleResize);
         this.handleResize();
         x = this.mode == MODE_STANDALONE ? 35 : 10;
         y = 5;
      }
      
      private function handleRemove(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         stage.removeEventListener(Event.RESIZE,this.handleResize);
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


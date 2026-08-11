package states
{
   import blitter.Bl;
   import blitter.BlState;
   import blitter.BlText;
   import com.greensock.*;
   import com.greensock.easing.*;
   import data.SimplePlayerObjectEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.*;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import mx.utils.StringUtil;
   import playerio.Message;
   import playerio.PlayerIOError;
   import playerio.RoomInfo;
   import ui.PlayerWorlds;
   import ui.SettingsPage;
   import ui.campaigns.CampaignPage;
   import ui.lobby.Background;
   import ui.lobby.GuestPromo;
   import ui.lobby.LobbyFriends;
   import ui.lobby.News;
   import ui.lobby.UniverseInfo;
   import ui.roomlist.CreateOpenWorldPrompt;
   import ui.roomlist.RoomList;
   import ui.screens.WelcomeBack;
   import ui.screens.WelcomeGold;
   import ui.shop.MainShop;
   import ui.shop.ShopBar;
   import ui.social.SocialPage;
   import utilities.AsyncTasks;
   
   public class LobbyState extends BlState
   {
      
      protected static var worldScrollOverlay:Class = LobbyState_worldScrollOverlay;
      
      protected static var banner:Class = LobbyState_banner;
      
      protected var world_image_overlay:Bitmap;
      
      protected var world_image:Sprite;
      
      private var callback:Function;
      
      public var createCallback:Function;
      
      private var handleJoinSaved:Function;
      
      private var myroomsCallback:Function;
      
      private var container:Sprite;
      
      public var shopbar:ShopBar;
      
      private var pageLobby:Sprite;
      
      public var roomlist:RoomList;
      
      protected var createroom:CreateOpenWorldPrompt;
      
      private var universe:UniverseInfo;
      
      private var lobbyfriends:LobbyFriends;
      
      private var guestPromo:GuestPromo;
      
      private var pageCampaigns:Sprite;
      
      private var pageSocial:Sprite;
      
      private var pageSettings:Sprite;
      
      private var pageShop:Sprite;
      
      protected var lobby_banner:BitmapData;
      
      protected var loadroom:LoadRoom;
      
      protected var loadroomBG:BlackBG;
      
      protected var fbtextfield:TextField;
      
      private var announce:News;
      
      private var annbg:BlackBG;
      
      private var subtext:BlText;
      
      private var bm_subtext:Bitmap;
      
      private var bm_subtext_holder:Sprite;
      
      private var textTime:int = 0;
      
      private var texts:Array;
      
      private var curText:int = 0;
      
      private var online:Number;
      
      private var wonline:Number;
      
      private var last_world_reload:Object;
      
      private var loading_worlds:Boolean;
      
      private var refreshtimer:Timer;
      
      private var firstDailyLogin:Boolean;
      
      public var currentPage:String = "";
      
      protected var bannerimg:Sprite;
      
      public var social:SocialPage;
      
      private var settings:SettingsPage;
      
      private var campaigns:CampaignPage;
      
      private var shop:ShopUI;
      
      public var mainshop:MainShop;
      
      public function LobbyState(param1:Array, param2:Function, param3:Function, param4:Function, param5:Boolean, param6:EverybodyEdits, param7:Function, param8:WelcomeBack, param9:Boolean, param10:String)
      {
         var t:BlText;
         var bmt:Bitmap;
         var rooms:Array = param1;
         var callback:Function = param2;
         var createCallback:Function = param3;
         var myroomsCallback:Function = param4;
         var iseecom:Boolean = param5;
         var base:EverybodyEdits = param6;
         var handleJoinSaved:Function = param7;
         var welcomeBack:WelcomeBack = param8;
         var firstDailyLogin:Boolean = param9;
         var tab:String = param10;
         this.world_image_overlay = new Bitmap(new worldScrollOverlay().bitmapData);
         this.world_image = new Background();
         this.container = new Sprite();
         this.shopbar = new ShopBar();
         this.pageLobby = new Sprite();
         this.pageCampaigns = new Sprite();
         this.pageSocial = new Sprite();
         this.pageSettings = new Sprite();
         this.pageShop = new Sprite();
         this.lobby_banner = new banner().bitmapData;
         this.subtext = new BlText(11,300,14671839,"left","system",true);
         this.texts = [];
         this.bannerimg = new Sprite();
         super();
         if(Config.forceKongregate)
         {
            Global.playing_on_kongregate = true;
         }
         this.handleJoinSaved = handleJoinSaved;
         this.myroomsCallback = myroomsCallback;
         this.callback = callback;
         this.createCallback = createCallback;
         this.firstDailyLogin = firstDailyLogin;
         this.container.x = 0;
         Bl.stage.addChild(this.container);
         this.container.addChild(this.world_image);
         this.container.addChild(this.world_image_overlay);
         this.container.addChild(this.shopbar);
         t = new BlText(30,310,14179354);
         t.text = "Everybody Edits";
         bmt = new Bitmap(t.clone());
         bmt.x = 10;
         bmt.y = 35;
         this.container.addChild(bmt);
         this.bm_subtext_holder = new Sprite();
         if(!Global.player_is_guest)
         {
            this.social = new SocialPage(this.shopbar.socialbtn);
            this.social.x = 13;
            this.social.y = 95;
            this.pageSocial.addChild(this.social);
            this.lobbyfriends = new LobbyFriends(this.social.friends);
            this.lobbyfriends.x = 452;
            this.lobbyfriends.y = 95;
            this.pageLobby.addChild(this.lobbyfriends);
         }
         else
         {
            this.guestPromo = new GuestPromo();
            this.guestPromo.x = 452;
            this.guestPromo.y = 95;
            this.pageLobby.addChild(this.guestPromo);
         }
         this.container.addChild(this.bm_subtext_holder);
         /* SocialPage bypassed for offline server */
         this.roomlist = new RoomList(this.callback,this.reloadRooms);
         this.roomlist.x = 13;
         this.roomlist.y = 95;
         this.pageLobby.addChild(this.roomlist);
         this.roomlist.addEventListener(NavigationEvent.START_OPENWORLD,function(param1:Event):void
         {
            createroom = new CreateOpenWorldPrompt(createRoom);
            createroom.x = (Global.width - 327) / 2;
            pageLobby.addChild(createroom);
         });
         this.universe = new UniverseInfo();
         this.universe.x = 452;
         this.universe.y = 282;
         this.pageLobby.addChild(this.universe);
         this.container.addChild(this.pageLobby);
         this.reloadRooms();
         this.container.addChild(this.pageCampaigns);
         this.pageCampaigns.visible = false;
         this.container.addChild(this.pageSocial);
         this.pageSocial.visible = false;
         this.container.addChild(this.pageSettings);
         this.pageSettings.visible = false;
         this.container.addChild(this.pageShop);
         this.pageShop.visible = false;
         Shop.setContainer(this.container);
         Shop.addEventListener(ShopEvent.ITEM_AQUIRED,this.handleShopUpdate);
         if(Config.displayBanner)
         {
            this.bannerimg.x = 305;
            this.bannerimg.y = 35;
            this.bannerimg.addChild(new Bitmap(this.lobby_banner));
            this.container.addChildAt(this.bannerimg,1);
            this.bannerimg.mouseEnabled = this.bannerimg.buttonMode = true;
            this.bannerimg.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               Bl.stage.dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_MERCH,true,false));
            });
         }
         this.initNews();
         if(!Global.player_is_guest)
         {
            if(welcomeBack)
            {
               Global.base.overlayContainer.addChild(welcomeBack);
            }
            if(Global.playerObject.goldwelcome)
            {
               this.showWelcomeGold();
            }
            else
            {
               Global.stage.addEventListener(SimplePlayerObjectEvent.UPDATE,this.handlePlayerObjectUpdate,false,0,true);
            }
         }
         Global.stage.frameRate = Config.lobbyFrameRate;
         this.setPage(tab);
      }
      
      private function handlePlayerObjectUpdate(param1:Event) : void
      {
         if(Global.playerObject.goldwelcome)
         {
            this.showWelcomeGold();
         }
      }
      
      private function showWelcomeGold() : void
      {
         this.container.addChild(new WelcomeGold());
      }
      
      private function handleShopUpdate(param1:ShopEvent) : void
      {
         var e:ShopEvent = param1;
         if(e.type == ShopEvent.ITEM_AQUIRED)
         {
            Global.base.updatePlayerProperties(function():void
            {
               reloadRooms();
            });
         }
      }
      
      public function reloadRooms() : void
      {
         var all_rooms:Array = null;
         var all_normalRooms:Array = null;
         var tasks:AsyncTasks = null;
         var totalLoad:int = 0;
         var loadMoreRooms:Function = function(param1:int, param2:int):void
         {
            var count:int = param1;
            var offset:int = param2;
            Global.client.multiplayer.listRooms(Config.server_type_normalroom,{},count,offset,function(param1:Array):void
            {
               all_normalRooms = all_normalRooms.concat(param1);
               if(param1.length >= totalLoad - 1 && offset == 0 && param1.length > 0)
               {
                  loadMoreRooms(totalLoad,all_normalRooms.length);
               }
               else
               {
                  tasks.next();
               }
            },handleLoadRoomError);
         };
         this.roomlist.btn_reload.rotator.play();
         this.refreshtimer = new Timer(1000,1);
         this.refreshtimer.addEventListener(TimerEvent.TIMER_COMPLETE,function(param1:TimerEvent):void
         {
            if(refreshtimer != null)
            {
               refreshtimer.stop();
               refreshtimer = null;
            }
            enableRefreshButton();
         });
         this.refreshtimer.start();
         this.roomlist.enableRefreshButton(false);
         this.roomlist.loading = true;
         this.roomlist.setRooms([]);
         this.loading_worlds = true;
         this.last_world_reload = new Date();
         all_rooms = [];
         all_normalRooms = [];
         tasks = new AsyncTasks(1,function():void
         {
            var _loc3_:* = undefined;
            loading_worlds = false;
            all_rooms = all_rooms.concat(all_normalRooms);
            if(!Global.player_is_guest)
            {
               PlayerWorlds.addSavedWorlds(all_rooms,Global.base.client);
               PlayerWorlds.addFavorites(all_rooms,Global.base.client);
            }
            PlayerWorlds.getHistory(all_rooms);
            enableRefreshButton();
            var _loc1_:* = [];
            var _loc2_:* = 0;
            var seenIds:Object = {};
            while(_loc2_ < all_rooms.length)
            {
               _loc3_ = all_rooms[_loc2_];
               var roomId:String = _loc3_ is RoomInfo ? (_loc3_ as RoomInfo).id : (_loc3_ != null && _loc3_.id != null ? String(_loc3_.id) : "");
               if(roomId != "" && seenIds.hasOwnProperty(roomId))
               {
                  _loc2_++;
                  continue;
               }
               if(roomId != "")
               {
                  seenIds[roomId] = true;
               }
               if(_loc3_.data)
               {
                  if(!(_loc3_.data.owned == "true" && !_loc3_.data.name))
                  {
                     if(!(StringUtil.trim(_loc3_.data.name) == "" || _loc3_.data.name.length > 60))
                     {
                        if(_loc3_.data.plays < 1000000)
                        {
                           if(_loc3_.onlineUsers > 0 || _loc3_.data.myworld || _loc3_.data.inFavorites || _loc3_.data.isHistory)
                           {
                              _loc1_.push(_loc3_);
                           }
                        }
                     }
                  }
               }
               _loc2_++;
            }
            roomlist.btn_reload.rotator.gotoAndStop(1);
            redrawRooms(_loc1_);
         });
         if(Global.player_is_beta_member)
         {
            tasks.addTask();
            Global.client.multiplayer.listRooms(Config.server_type_betaroom,{},0,0,function(param1:Array):void
            {
               all_rooms = all_rooms.concat(param1);
               tasks.next();
            },this.handleLoadRoomError);
         }
         totalLoad = 300;
         loadMoreRooms(totalLoad,0);
      }
      
      private function enableRefreshButton() : void
      {
         this.roomlist.enableRefreshButton(this.refreshtimer == null && !this.loading_worlds);
      }
      
      private function handleLoadRoomError(param1:PlayerIOError) : void
      {
      }
      
      private function redrawRooms(param1:Array) : void
      {
         this.roomlist.loading = false;
         this.roomlist.setRooms(param1);
         this.refresh(param1);
      }
      
      private function initNews() : void
      {
         Global.base.requestRemoteMethod("getNews",function(param1:Message):void
         {
            var loader:Loader = null;
            var msg:Message = param1;
            announce = new News();
            annbg = new BlackBG();
            announce.tf_header.text = msg.getString(0);
            announce.tf_body.autoSize = TextFieldAutoSize.LEFT;
            announce.tf_body.htmlText = msg.getString(1);
            announce.tf_date.text = msg.getString(2);
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
            {
               announce.imageloader.visible = false;
               loader.y = announce.tf_body.y + announce.tf_body.textHeight + 10;
               loader.x = announce.bg.x + (announce.bg.width - loader.width) / 2;
               announce.addChild(loader);
            });
            loader.load(new URLRequest(Config.site + "/Images/" + msg.getString(3)));
            announce.cacheAsBitmap = true;
            announce.x = (Global.width - 300) / 2;
            announce.btnreadblog.useHandCursor = true;
            announce.btnreadblog.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               Bl.stage.dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_BLOG,true,false));
            });
            announce.btn_close.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               announce.visible = false;
               annbg.visible = false;
               if(!Global.sharedCookie.data.hasOwnProperty("news"))
               {
                  Global.sharedCookie.data.news = "";
               }
               if((Global.sharedCookie.data.news as String).search(announce.tf_date.text) == -1)
               {
                  Global.sharedCookie.data.news += "[" + announce.tf_date.text + "]";
                  if(!Global.noSave)
                  {
                     Global.sharedCookie.flush();
                  }
               }
            });
            if(!Global.sharedCookie.data.hasOwnProperty("news"))
            {
               Global.sharedCookie.data.news = "";
            }
            announce.visible = annbg.visible = firstDailyLogin && (Global.sharedCookie.data.news as String).search(announce.tf_date.text) == -1;
            container.addChild(annbg);
            container.addChild(announce);
         },Config.debug_news || "");
      }
      
      public function validateEmail(param1:String) : Boolean
      {
         var _loc2_:RegExp = /^[a-z0-9][-._a-z0-9]*@([a-z0-9][-_a-z0-9]*\.)+[a-z]{2,6}$/;
         return _loc2_.test(param1);
      }
      
      public function refresh(param1:Array) : void
      {
         var _loc3_:RoomInfo = null;
         this.online = 0;
         this.wonline = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_] as RoomInfo;
            if(_loc3_)
            {
               this.online += _loc3_.onlineUsers;
               if(_loc3_.onlineUsers > 0)
               {
                  ++this.wonline;
               }
            }
            _loc2_++;
         }
         this.setSubtextArray([this.online + " Players Online - " + this.wonline + " Worlds Online"]);
      }
      
      public function setSubtextArray(param1:Array) : void
      {
         this.texts = param1;
         this.curText = 0;
         if(this.texts.length > 0)
         {
            this.updateText();
         }
      }
      
      override public function draw(param1:BitmapData, param2:int, param3:int) : void
      {
         if(this.texts.length > 1 && this.textTime++ == 30 * 5)
         {
            this.updateText();
         }
      }
      
      public function updateText() : void
      {
         TweenMax.to(this.bm_subtext_holder,0.3,{
            "alpha":0,
            "onComplete":function():void
            {
               try
               {
                  subtext.text = texts[curText++];
                  if(bm_subtext != null)
                  {
                     bm_subtext_holder.removeChild(bm_subtext);
                  }
                  bm_subtext = new Bitmap(subtext.clone());
                  bm_subtext.y = 42 + 30 + 1;
                  bm_subtext.x = 10;
                  bm_subtext_holder.addChild(bm_subtext);
                  TweenMax.to(bm_subtext_holder,0.3,{"alpha":1});
               }
               catch(e:Error)
               {
               }
            }
         });
         this.textTime = 0;
         if(this.curText > this.texts.length - 1)
         {
            this.curText = 0;
         }
      }
      
      private function joinRoomDirectly(param1:String) : void
      {
         this.reset();
         this.callback(param1);
      }
      
      private function joinRoom(param1:String, param2:String, param3:Object) : void
      {
         var _loc4_:Array = null;
         this.reset();
         if(param3.data.myworld)
         {
            if(param1 == "savedworld")
            {
               this.myroomsCallback();
            }
            else if(param1 == "savedbetaworld")
            {
               this.myroomsCallback(true);
            }
            else if(param1.substring(0,2) == "PW" || param1.substring(0,2) == "BW")
            {
               Bl.data.roomname = param2;
               this.callback(param1);
            }
            else
            {
               _loc4_ = param1.split("x");
               this.handleJoinSaved(_loc4_[0],_loc4_[1]);
            }
         }
         else
         {
            Bl.data.roomname = param2;
            this.callback(param1);
         }
      }
      
      private function createRoom(param1:String, param2:String, param3:Boolean = false) : void
      {
         if(param2 != "")
         {
            Bl.data.createdOpenWorldWithKey = true;
         }
         this.reset();
         this.createCallback(param1,param2);
      }
      
      public function showLoadRoom() : void
      {
         var closeLoadRoom:Function;
         var submitLoadRoom:Function;
         if(!this.loadroom)
         {
            closeLoadRoom = function():void
            {
               TweenMax.to(loadroom,0.3,{
                  "alpha":0,
                  "onComplete":function():void
                  {
                     if(loadroom.parent)
                     {
                        loadroom.parent.removeChild(loadroom);
                     }
                  }
               });
               TweenMax.to(loadroomBG,0.3,{
                  "alpha":0,
                  "onComplete":function():void
                  {
                     if(loadroomBG.parent)
                     {
                        loadroomBG.parent.removeChild(loadroomBG);
                     }
                  }
               });
            };
            submitLoadRoom = function():void
            {
               var _loc1_:String = StringUtil.trim(loadroom.roomid.text);
               if(_loc1_ == "")
               {
                  closeLoadRoom();
               }
               else
               {
                  if(loadroom.parent)
                  {
                     loadroom.parent.removeChild(loadroom);
                  }
                  if(loadroomBG.parent)
                  {
                     loadroomBG.parent.removeChild(loadroomBG);
                  }
                  joinRoomDirectly(_loc1_);
               }
            };
            this.loadroom = new LoadRoom();
            if(!this.loadroomBG)
            {
               this.loadroomBG = new BlackBG();
            }
            this.loadroom.closebtn.addEventListener(MouseEvent.MOUSE_DOWN,closeLoadRoom);
            this.loadroom.btn_join.addEventListener(MouseEvent.MOUSE_DOWN,submitLoadRoom);
            this.loadroom.roomid.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
            {
               if(param1.keyCode == 13)
               {
                  submitLoadRoom();
               }
            });
         }
         this.loadroom.x = (Global.width - 327) / 2;
         this.loadroom.alpha = 0;
         this.loadroom.roomid.text = "";
         Bl.stage.focus = this.loadroom.roomid;
         this.loadroomBG.alpha = 0;
         this.container.addChild(this.loadroomBG);
         this.container.addChild(this.loadroom);
         TweenMax.to(this.loadroom,0.3,{"alpha":1});
         TweenMax.to(this.loadroomBG,0.3,{"alpha":1});
      }
      
      override public function resize() : void
      {
         var _loc1_:DisplayObject = this.container.getChildByName("GetGemsNow");
         if(_loc1_)
         {
            _loc1_.x = (Global.width - 606) / 2;
         }
         var _loc2_:DisplayObject = this.container.getChildByName("Thankyou");
         if(_loc2_)
         {
            _loc2_.x = (Global.width - 472) / 2;
         }
         if(this.announce)
         {
            this.announce.x = (Global.width - 300) / 2;
         }
         if(this.createroom)
         {
            this.createroom.x = (Global.width - 327) / 2;
         }
         this.container.x = Bl.stage.stageWidth != 0 ? Math.round((Bl.stage.stageWidth - Config.maxwidth) / 2) : 0;
      }
      
      public function reset() : void
      {
         Global.stage.frameRate = Config.lobbyFrameRate;
         if(Boolean(this.createroom) && Boolean(this.createroom.parent))
         {
            this.container.removeChild(this.createroom);
         }
         if(Boolean(this.container) && Boolean(this.container.parent))
         {
            this.container.parent.removeChild(this.container);
         }
      }
      
      public function setPage(param1:String) : void
      {
         if(this.currentPage == param1)
         {
            return;
         }
         this.currentPage = param1;
         switch(param1)
         {
            case LobbyStatePage.ROOMLIST:
               this.setSubtextArray([this.online + " Players Online - " + this.wonline + " Worlds Online"]);
               this.reloadRooms();
               this.universe.update();
               break;
            case LobbyStatePage.ENERGY_SHOP:
               if(!this.shop)
               {
                  this.shop = new ShopUI();
                  this.shop.x = 13;
                  this.shop.y = 116;
                  this.shop.gotoAndStop(1);
                  this.pageShop.addChild(this.shop);
               }
               if(!this.mainshop)
               {
                  this.mainshop = new MainShop();
                  this.mainshop.x = 10;
                  this.mainshop.y = -21;
                  this.shop.addChild(this.mainshop);
                  Bl.stage.addEventListener(ShopEvent.OPEN_MAINSHOP,this.handleOpenMainShopRequest,false,0,true);
               }
               this.mainshop.refreshSubtext();
               this.mainshop.refreshTab();
               Shop.setSeenNewest();
               break;
            case LobbyStatePage.CAMPAIGN:
               if(!this.campaigns)
               {
                  this.campaigns = new CampaignPage(this,null);
                  this.campaigns.x = 13;
                  this.campaigns.y = 95;
                  this.pageCampaigns.addChild(this.campaigns);
               }
               this.campaigns.refreshSubtext();
               break;
            case LobbyStatePage.SETTINGS:
               if(!this.settings)
               {
                  this.settings = new SettingsPage();
                  this.settings.x = 13;
                  this.settings.y = 95;
                  this.pageSettings.addChild(this.settings);
               }
               this.setSubtextArray(["Adjust the game\'s settings to your needs!"]);
               break;
            case LobbyStatePage.SOCIAL:
               this.setSubtextArray(["Manage friends, crews, and more!"]);
         }
         this.shopbar.setHighlight(param1);
         if(param1 != LobbyStatePage.SETTINGS && Boolean(this.settings))
         {
            this.settings.closeKeyBindings();
         }
         this.togglePage(this.pageLobby,LobbyStatePage.ROOMLIST);
         this.togglePage(this.pageCampaigns,LobbyStatePage.CAMPAIGN);
         this.togglePage(this.pageSocial,LobbyStatePage.SOCIAL);
         this.togglePage(this.pageSettings,LobbyStatePage.SETTINGS);
         this.togglePage(this.pageShop,LobbyStatePage.ENERGY_SHOP);
      }
      
      private function togglePage(param1:Object, param2:String) : void
      {
         if(!param1)
         {
            return;
         }
         param1.visible = this.currentPage == param2;
         if(param1.visible)
         {
            param1.alpha = 0;
            TweenMax.to(param1,0.5,{"alpha":1});
         }
      }
      
      private function handleOpenMainShopRequest(param1:ShopEvent) : void
      {
         this.mainshop.showTab(param1.tab);
      }
      
      override public function get align() : String
      {
         return STATE_ALIGN_LEFT;
      }
   }
}


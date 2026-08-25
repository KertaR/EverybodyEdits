package
{
   import animations.AnimationManager;
   import blitter.Bl;
   import blitter.BlGame;
   import com.greensock.*;
   import com.greensock.easing.*;
   import com.greensock.plugins.*;
   import com.jac.mouse.MouseWheelEnabler;
   import com.reygazu.anticheat.events.CheatManagerEvent;
   import com.reygazu.anticheat.managers.CheatManager;
   import data.SimplePlayerObject;
   import data.SimplePlayerObjectEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageScaleMode;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.ByteArray;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import input.KeyState;
   import io.player.tools.Badwords;
   import items.ItemBrick;
   import items.ItemManager;
   import items.ItemSmiley;
   import playerio.Client;
   import playerio.Connection;
   import playerio.DatabaseObject;
   import playerio.Message;
   import playerio.PlayerIO;
   import playerio.PlayerIOError;
   import playerio.PlayerIORegistrationError;
   import sounds.SoundManager;
   import states.JoinState;
   import states.LoadState;
   import states.LobbyState;
   import states.PlayState;
   import ui.ConfirmPrompt;
   import ui.CopyPrompt;
   import ui.InfoDisplay;
   import ui.LoadingScreen;
   import ui.RegisterWindow;
   import ui.campaigns.CampaignComplete;
   import ui.campaigns.CampaignTrialDone;
   import ui.chat.SideChat;
   import ui.crews.CrewProfile;
   import ui.crews.CrewRank;
   import ui.crews.CrewRanks;
   import ui.crews.MemberSettings;
   import ui.crews.RankItem;
   import ui.login.LoginWindow;
   import ui.login.MainLogin;
   import ui.login.ResetPassword;
   import ui.login.TermsWindow;
   import ui.login.UsernameWindow;
   import ui.profile.Profile;
   import ui.roomlist.MinimapPreview;
   import ui.screens.WelcomeBack;
   import utilities.AsyncTasks;
   
   public class EverybodyEdits extends BlGame
   {
      
      public var client:Client;
      
      public var ui2instance:UI2;
      
      public var ee_menu:ContextMenu;
      
      protected var iseecom:Boolean = false;
      
      private var mainlogin:MainLogin;
      
      private var showDisconnectedMessage:Boolean = true;
      
      protected var roomname:String = null;
      
      protected var forcejoin:String = null;
      
      protected var email_confirm_key:String = null;
      
      protected var kongregate:*;
      
      public var sidechat:SideChat;
      
      public var loading:LoadingScreen;
      
      public var filterbadwords:Boolean = false;
      
      private var eiw:ExternalInterfaceWrapper;
      
      private var memberSettings:MemberSettings;
      
      private var rankItem:RankItem;
      
      private var cc:CampaignComplete;
      
      private var ctd:CampaignTrialDone;
      
      public var crewProfile:CrewProfile;
      
      private var infoBox:InfoDisplay;
      
      private var fullscreenBlack:BlackBG;
      
      public var settings:SettingsManager;
      
      private var mapBG:BlackBG;
      
      private var mapPreview:MinimapPreview;
      
      public var rpcCon:Connection;
      
      private var crewLobbyCon:Connection;
      
      private var crewLobbyId:String;
      
      private var crewLobbyConnecting:Boolean = false;
      
      private var crewLobbyQueue:Vector.<Function>;
      
      private var rpcConnecting:Boolean = false;
      
      private var rpcConnectQueue:Vector.<Function>;
      
      private var loginwindow:LoginWindow;
      
      public var liked:Boolean;
      
      public var favorited:Boolean;
      
      public var connection:Connection;
      
      private var upgrade:Boolean = false;
      
      public function EverybodyEdits()
      {
         var version:ContextMenuItem;
         var help_cm:ContextMenuItem;
         var blog_cm:ContextMenuItem;
         var tac_cm:ContextMenuItem;
         var faq_cm:ContextMenuItem;
         var forums_cm:ContextMenuItem;
         var listenAndShow:Function;
         this.ee_menu = new ContextMenu();
         this.fullscreenBlack = new BlackBG();
         this.settings = new SettingsManager();
         this.crewLobbyQueue = new Vector.<Function>();
         this.rpcConnectQueue = new Vector.<Function>();
         listenAndShow = function(param1:ContextMenuItem, param2:String):void
         {
            var target:ContextMenuItem = param1;
            var path:String = param2;
            target.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(param1:ContextMenuEvent):void
            {
               navigateToURL(new URLRequest(path),"_blank");
            });
         };
         super(640,480,1);
         Global.base = this;
         PlayerIO.useSecureApiRequests = true;
         TweenPlugin.activate([BlurFilterPlugin,GlowFilterPlugin,ColorTransformPlugin,DropShadowFilterPlugin]);
         Bl.data.brick = 0;
         Bl.data.base = this;
         Bl.data.isbeta = Config.forceBeta;
         Bl.data.iskongregate = false;
         Bl.data.onsite = false;
         Bl.data.roomname = "";
         Bl.data.name = "";
         Bl.data.portal_id = 0;
         Bl.data.portal_target = 0;
         Bl.data.world_portal_id = "";
         Bl.data.world_portal_name = "";
         Bl.data.world_portal_target = 0;
         Bl.data.spawn_id = 1;
         Bl.data.npc_name = "";
         Bl.data.npc_mes1 = "";
         Bl.data.npc_mes2 = "";
         Bl.data.npc_mes3 = "";
         Bl.data.jumps = 2;
         Bl.data.coincount = 10;
         Bl.data.switchId = 0;
         Bl.data.wrapLength = 200;
         Bl.data.deathcount = 10;
         Bl.data.team = 0;
         Bl.data.direction = 0;
         Bl.data.effectDuration = 10;
         Bl.data.onStatus = true;
         Bl.data.mode = 1;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
         this.eiw = new ExternalInterfaceWrapper();
         this.eiw.addEventListener(NavigationEvent.SHOW_PROFILE,this.handleShowProfile,false,0,true);
         this.ee_menu.hideBuiltInItems();
         this.ee_menu.builtInItems.zoom = true;
         version = new ContextMenuItem("Everybody Edits v" + Config.client_type_version);
         help_cm = new ContextMenuItem("Help");
         blog_cm = new ContextMenuItem("Blog");
         tac_cm = new ContextMenuItem("Terms and Conditions");
         faq_cm = new ContextMenuItem("Frequently Asked Questions");
         forums_cm = new ContextMenuItem("Forums");
         version.enabled = false;
         help_cm.separatorBefore = true;
          try
          {
             var log_cm:ContextMenuItem = new ContextMenuItem("Toggle Log Console");
             log_cm.separatorBefore = true;
             this.ee_menu.customItems.push(version,help_cm,blog_cm,tac_cm,faq_cm,forums_cm,log_cm);
             listenAndShow(help_cm,Config.url_help_page);
             listenAndShow(blog_cm,Config.url_blog);
             listenAndShow(tac_cm,Config.url_terms_page);
             listenAndShow(faq_cm,Config.url_faq);
             listenAndShow(forums_cm,Config.url_forums);
             log_cm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(param1:ContextMenuEvent):void
             {
                if(Global.logField != null)
                {
                   Global.logField.visible = !Global.logField.visible;
                   if(Global.logField.visible)
                   {
                      if(Global.stage != null)
                      {
                         Global.stage.addChild(Global.logField);
                      }
                   }
                   else
                   {
                      if(Global.logField.parent != null)
                      {
                         Global.logField.parent.removeChild(Global.logField);
                      }
                   }
                }
             });
          }
          catch(eCM:Error)
          {
             this.ee_menu.customItems.push(version,help_cm,blog_cm,tac_cm,faq_cm,forums_cm);
             listenAndShow(help_cm,Config.url_help_page);
             listenAndShow(blog_cm,Config.url_blog);
             listenAndShow(tac_cm,Config.url_terms_page);
             listenAndShow(faq_cm,Config.url_faq);
             listenAndShow(forums_cm,Config.url_forums);
          }
       }
      
      private function onCheatDetected(param1:CheatManagerEvent) : void
      {
         if(Boolean(this.connection) && this.connection.connected)
         {
            this.connection.send("cheatDetected",param1.data.variableName);
         }
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         Bl.stage.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         Bl.stage.addEventListener(NavigationEvent.SHOW_PROFILE,this.handleShowProfile,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.JOIN_WORLD,this.handleJoinWorld,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.LOGOUT,this.handleLogout,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_GOLD_ABOUT,this.handleShowPage,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_BLOG,this.handleShowPage,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_HELP,this.handleShowPage,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_TERMS,this.handleShowPage,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_FORUMS,this.handleShowPage,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_MERCH,this.handleShowPage,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_PATREON,this.handleShowPage,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_CREW_PROFILE,this.handleShowCrewProfile,false,0,true);
         Bl.stage.addEventListener(NavigationEvent.SHOW_PLAYER_ACTIONS,this.showPlayerActions,false,0,true);
         Bl.stage.addEventListener(MouseEvent.CLICK,this.hidePlayerActions,false,0,true);
         KeyState.activate(Bl.stage);
         (Bl.stage.getChildAt(0) as MovieClip).contextMenu = this.ee_menu;
         MouseWheelEnabler.init(Bl.stage);
         CheatManager.getInstance().addEventListener(CheatManagerEvent.CHEAT_DETECTION,this.onCheatDetected);
         Global.EMBED_WIDTH = stage.stageWidth;
      }
      
      private function showPlayerActions(param1:NavigationEvent) : void
      {
         if(this.ui2instance != null)
         {
            this.ui2instance.showPlayerActions(param1.username,param1.userId,param1.extra.shift);
         }
      }
      
      private function hidePlayerActions(param1:MouseEvent) : void
      {
         if(this.ui2instance != null)
         {
            this.ui2instance.hidePlayerActions();
         }
      }
      
      protected function handleShowPage(param1:NavigationEvent) : void
      {
         switch(param1.type)
         {
            case NavigationEvent.SHOW_GOLD_ABOUT:
               if(Global.playing_on_com)
               {
                  navigateToURL(new URLRequest("#gold"),"_top");
               }
               else
               {
                  this.openNewPage(Config.url_goldmember_about_page);
               }
               break;
            case NavigationEvent.SHOW_BLOG:
               this.openNewPage(Config.url_blog);
               break;
            case NavigationEvent.SHOW_HELP:
               this.openNewPage(Config.url_help_page);
               break;
            case NavigationEvent.SHOW_TERMS:
               this.openNewPage(Config.url_terms_page);
               break;
            case NavigationEvent.SHOW_FORUMS:
               this.openNewPage(Config.url_forums);
               break;
            case NavigationEvent.SHOW_MERCH:
               this.openNewPage(Config.url_merch);
               break;
            case NavigationEvent.SHOW_PATREON:
               this.openNewPage(Config.url_patreon);
         }
      }
      
      public function openNewPage(param1:String) : void
      {
         var url:String = param1;
         try
         {
            navigateToURL(new URLRequest(url),"_new");
         }
         catch(e:Error)
         {
            client.errorLog.writeError("Error opening new page: " + e.name,e.message,e.getStackTrace(),e);
         }
      }
      
      public function openPage(param1:String) : void
      {
         var url:String = param1;
         try
         {
            navigateToURL(new URLRequest(url),"_top");
         }
         catch(e:Error)
         {
            client.errorLog.writeError("Error opening page: " + e.name,e.message,e.getStackTrace(),e);
         }
      }
      
      public function showMemberSettings(param1:String, param2:String, param3:CrewRank, param4:CrewRanks, param5:String) : void
      {
         this.memberSettings = new MemberSettings(param1,param2,param3,param4,param5);
         this.memberSettings.alpha = 0;
         overlayContainer.addChild(this.memberSettings);
         TweenMax.to(this.memberSettings,0.4,{"alpha":1});
      }
      
      public function hideMemberSettings() : void
      {
         if(overlayContainer.contains(this.memberSettings))
         {
            TweenMax.to(this.memberSettings,0.4,{
               "alpha":0,
               "onComplete":function():void
               {
                  overlayContainer.removeChild(memberSettings);
               }
            });
         }
      }
      
      public function showRankItem(param1:String, param2:CrewRanks) : void
      {
         this.rankItem = new RankItem(param1,param2);
         overlayContainer.addChild(this.rankItem);
      }
      
      public function hideRankItem() : void
      {
         overlayContainer.removeChild(this.rankItem);
      }
      
      protected function handleLogout(param1:NavigationEvent) : void
      {
         this.logout();
      }
      
      protected function handleShowProfile(param1:NavigationEvent) : void
      {
         this.showProfile(param1.username,Profile.MODE_INGAME);
      }
      
      private function showProfile(param1:String, param2:String = "") : void
      {
         var _loc3_:Profile = new Profile(param1,param2);
         overlayContainer.addChild(_loc3_);
      }
      
      private function handleShowCrewProfile(param1:NavigationEvent) : void
      {
         this.showCrewProfile(param1.crewname,CrewProfile.MODE_INGAME);
      }
      
      public function showCrewProfile(param1:String, param2:String = "") : void
      {
         this.crewProfile = new CrewProfile(param1,param2);
         overlayContainer.addChild(this.crewProfile);
      }
      
      public function updateMemberItems(param1:Boolean = true, param2:String = "", param3:String = "", param4:int = 0) : void
      {
         var _loc5_:LobbyState = null;
         if(param1)
         {
            if(this.crewProfile != null)
            {
               if(overlayContainer.contains(this.crewProfile))
               {
                  this.crewProfile.getMemberItemByUsername(param2).updateItem(param3,param4);
               }
            }
         }
         else if(state as LobbyState)
         {
            _loc5_ = state as LobbyState;
            if((state as LobbyState).social.myCrew)
            {
               (state as LobbyState).social.myCrew.refreshCrew();
            }
         }
      }
      
      public function showWorldPreview(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:BitmapData = null) : void
      {
         var roomId:String = param1;
         var roomName:String = param2;
         var roomDesc:String = param3;
         var owner:String = param4;
         var crew:String = param5;
         var minimapBMD:BitmapData = param6;
         if(!roomId)
         {
            return;
         }
         if(!this.mapBG)
         {
            this.mapBG = new BlackBG();
            this.mapBG.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               param1.preventDefault();
               param1.stopImmediatePropagation();
               param1.stopPropagation();
            });
         }
         this.mapPreview = new MinimapPreview(roomId,roomName,roomDesc,owner,crew,minimapBMD);
         overlayContainer.addChild(this.mapBG);
         overlayContainer.addChild(this.mapPreview);
         this.mapBG.alpha = 0;
         this.mapPreview.alpha = 0;
         TweenMax.to(this.mapBG,0.3,{"alpha":1});
         TweenMax.to(this.mapPreview,0.2,{"alpha":1});
      }
      
      public function removeWorldPreview() : void
      {
         if(!this.mapBG || !this.mapPreview)
         {
            return;
         }
         TweenMax.to(this.mapBG,0.25,{
            "alpha":0,
            "onComplete":function():void
            {
               if(mapBG.parent)
               {
                  overlayContainer.removeChild(mapBG);
               }
            }
         });
         TweenMax.to(this.mapPreview,0.2,{
            "alpha":0,
            "onComplete":function():void
            {
               if(mapPreview.parent)
               {
                  overlayContainer.removeChild(mapPreview);
               }
            }
         });
         stage.focus = stage;
      }
      
      protected function handleJoinWorld(param1:NavigationEvent) : void
      {
         clearOverlayContainer();
         this.cleanUIAndConnections();
         this.joinRoom(param1.world_id,false,param1.joindata);
      }
      
      private function handleFullScreen(param1:Event) : void
      {
         if(Bl.stage.displayState == StageDisplayState.NORMAL)
         {
            Bl.stage.scaleMode = StageScaleMode.NO_SCALE;
            setTimeout(this.hideInvisibleMask,100);
         }
         else
         {
            Bl.stage.scaleMode = StageScaleMode.SHOW_ALL;
            Bl.stage.dispatchEvent(new Event(Event.RESIZE,false,false));
            this.showInvisibleMask();
         }
         if(this.sidechat)
         {
            this.sidechat.refresh();
         }
      }
      
      private function initializeAd() : void
      {
         if(!Global.playerObject)
         {
            return;
         }
         if(!ExternalInterface.available)
         {
            return;
         }
         if(Global.playerObject.goldmember)
         {
            return;
         }
         ExternalInterface.call("showad");
      }
      
      public function updatePlayerProperties(param1:Function = null) : void
      {
         var callback:Function = param1;
         var spo:SimplePlayerObject = new SimplePlayerObject();
         spo.loaded = new Date();
         if(client != null && client.connectUserId != null && client.connectUserId.indexOf("simple") == 0 && client.connectUserId != "simpleguest")
         {
            spo.name = client.connectUserId.substr(6);
         }
          else
          {
             spo.name = "Guest";
          }
          spo.smiley = 0;
          spo.aura = 0;
          spo.auraColor = 0;
          spo.badge = "";
          var isGuestUser:Boolean = Global.player_is_guest || (spo.name && (spo.name.toLowerCase() == "guest" || spo.name.indexOf("Guest") == 0));
          spo.chatbanned = false;
          Global.canchat = !isGuestUser;
          spo.haveSmileyPackage = !isGuestUser;
          spo.isAdministrator = !isGuestUser && Boolean(Global.playerObject && Global.playerObject.isAdministrator);
          spo.isModerator = !isGuestUser && Boolean(Global.playerObject && Global.playerObject.isModerator);
          spo.goldmember = !isGuestUser && Boolean(Global.playerObject && Global.playerObject.goldmember);
          spo.homeworld = "PW_default";
          spo.accepted_terms = Config.termsVersion;
          Global.playerObject = spo;
          Global.player_is_beta_member = !isGuestUser && Boolean(Global.player_is_beta_member);
          Bl.data.isAdmin = spo.isAdministrator;
          Bl.data.isModerator = spo.isModerator;
          Bl.data.canUseAllItems = Bl.data.isAdmin || Bl.data.isStaffMember;
         KeyBinding.load();
         if(callback != null)
         {
            callback.call(this);
         }
         Global.stage.dispatchEvent(new SimplePlayerObjectEvent(SimplePlayerObjectEvent.UPDATE));
      }
      
      public function createShopMessage() : Message
      {
         var m:Message = new Message("getShop");
         var userGems:int = (Global.client != null && Global.client.payVault != null && Global.client.payVault.coins > 0) ? Global.client.payVault.coins : (Global.playerObject ? Global.playerObject.gems : 500);
         var userEnergy:int = Global.playerObject ? Global.playerObject.energy : 0;
         var userMaxEnergy:int = Global.playerObject ? Global.playerObject.maxEnergy : 200;
         m.add(userGems);
         m.add(userEnergy);
         m.add(60);
         m.add(userMaxEnergy);
         m.add(150);

         var items:Array = [
            ["bricksecrets", "brick", 0, 0, 0, 10, 0, 4, "Secret Bricks", "Secret blocks package", "bricksecrets", 0, false, true, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickglass", "brick", 0, 0, 0, 10, 0, 4, "Glass Bricks", "Transparent glass blocks", "brickglass", 0, false, true, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickminerals", "brick", 0, 0, 0, 10, 0, 4, "Mineral Bricks", "Shiny minerals and ores", "brickminerals", 0, false, true, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickcandy", "brick", 0, 0, 0, 10, 0, 4, "Candy Bricks", "Sweet candy blocks", "brickcandy", 0, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickscifi", "brick", 0, 0, 0, 10, 0, 4, "Sci-Fi Bricks", "Futuristic high-tech blocks", "brickscifi", 0, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickprison", "brick", 0, 0, 0, 10, 0, 4, "Prison Bricks", "Bars and concrete blocks", "brickprison", 0, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickconstruction", "brick", 0, 0, 0, 10, 0, 4, "Construction Bricks", "Scaffolding and hazard blocks", "brickconstruction", 0, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickmedieval", "brick", 0, 0, 0, 10, 0, 4, "Medieval Bricks", "Castle stone and wood", "brickmedieval", 0, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickpipe", "brick", 0, 0, 0, 10, 0, 4, "Pipes", "Metal pipe blocks", "brickpipe", 0, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickindustrial", "brick", 0, 0, 0, 10, 0, 4, "Industrial Bricks", "Industrial iron and steel", "brickindustrial", 0, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["brickninja", "brick", 0, 0, 0, 10, 0, 4, "Ninja Bricks", "Dojo and bamboo blocks", "brickninja", 0, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["smileyhappy", "smiley", 0, 0, 0, 50, 0, 4, "Happy Smiley", "Extra happy face", "smileyhappy", 1, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["smileysad", "smiley", 0, 0, 0, 50, 0, 4, "Sad Smiley", "Melancholy face", "smileysad", 2, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["smileyninja", "smiley", 0, 0, 0, 150, 0, 4, "Ninja Smiley", "Stealthy warrior", "smileyninja", 3, false, true, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["smileypirate", "smiley", 0, 0, 0, 150, 0, 4, "Pirate Smiley", "Ahoy matey!", "smileypirate", 4, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["smileyrobot", "smiley", 0, 0, 0, 150, 0, 4, "Robot Smiley", "Bleep bloop", "smileyrobot", 5, false, false, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["pro", "gold", 0, 0, 0, 500, 0, 4, "Beta Membership", "Unlock beta features", "pro", 0, false, true, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"],
            ["goldmember", "gold", 0, 0, 0, 1000, 0, 4, "Gold Membership", "Gold border and unlimited perks", "goldmember", 0, false, true, false, false, false, false, false, 0, false, 0, false, "", "#FFFFFF"]
         ];

         for each(var item:Array in items)
         {
            var itemId:String = item[0];
            var isOwned:Boolean = false;
            try
            {
               if(Global.client != null && Global.client.payVault != null)
               {
                  isOwned = Global.client.payVault.has(itemId);
               }
            }
            catch(eOwned:Error) {}
            item[6] = isOwned ? 1 : 0;
            for each(var val:* in item)
            {
               m.add(val);
            }
         }
         return m;
      }
      
      public function requestRemoteMethod(param1:String, param2:Function, ... rest) : void
      {
         var name:String = param1;
         var callback:Function = param2;
         var args:Array = rest;
         if(true)
         {
             if(name == "getShop")
             {
                Global.log("EE.requestRemoteMethod: fetching shop from http://localhost:8080/api/shop");
                var selfEE:EverybodyEdits = this;
                var shopLoader:URLLoader = new URLLoader();
                var shopReq:URLRequest = new URLRequest("http://localhost:8080/api/shop");
                shopLoader.addEventListener(Event.COMPLETE, function(e:Event):void
                {
                   try
                   {
                      var jsonItems:Array = JSON.parse(String(shopLoader.data)) as Array;
                      var m:Message = new Message("getShop");
                      var userGems:int = (Global.client != null && Global.client.payVault != null && Global.client.payVault.coins > 0) ? Global.client.payVault.coins : (Global.playerObject ? Global.playerObject.gems : 500);
                      var userEnergy:int = Global.playerObject ? Global.playerObject.energy : 100;
                      m.add(userGems);
                      m.add(userEnergy);
                      m.add(30);
                      m.add(userMaxEnergy);
                      m.add(30);

                      for each(var itemObj:Object in jsonItems)
                      {
                         if(itemObj == null || itemObj.id == null) continue;
                          var sId:String = String(itemObj.id);
                          var pvId:String = itemObj.payvaultid != null ? String(itemObj.payvaultid) : sId;
                          var isOwnedItem:Boolean = false;
                          try
                          {
                             if(Global.client != null && Global.client.payVault != null)
                             {
                                isOwnedItem = Global.client.payVault.has(sId) || Global.client.payVault.has(pvId);
                             }
                          }
                          catch(ePv:Error) {}

                          var isReusableItem:Boolean = Boolean(itemObj.reusable);
                          var maxPurchasesCount:int = (itemObj.max_count != null && int(itemObj.max_count) > 0) ? int(itemObj.max_count) : (isReusableItem ? 0 : 1);

                          var energyProgress:int = (Global.playerObject && Global.playerObject.itemEnergyProgress && Global.playerObject.itemEnergyProgress[sId] != null) ? int(Global.playerObject.itemEnergyProgress[sId]) : 0;

                          m.add(sId);
                          m.add(itemObj.type != null ? String(itemObj.type) : "brick");
                          m.add(itemObj.priceEnergy != null ? int(itemObj.priceEnergy) : 0);
                          m.add(itemObj.priceEnergyClick != null ? int(itemObj.priceEnergyClick) : 10);
                          m.add(energyProgress);
                          m.add(itemObj.priceGems != null ? int(itemObj.priceGems) : 10);
                          m.add(isOwnedItem ? 1 : 0);
                          m.add(4);
                          m.add(itemObj.name != null ? String(itemObj.name) : "");
                          m.add(itemObj.description != null ? String(itemObj.description) : "");
                          var sheetId:String = itemObj.bitmapsheet_id != null ? String(itemObj.bitmapsheet_id) : (itemObj.type == "smiley" ? "smilies" : String(itemObj.payvaultid != null ? itemObj.payvaultid : sId));
                          m.add(sheetId);
                          m.add(itemObj.offset != null ? int(itemObj.offset) : 0);
                          m.add(Boolean(itemObj.isOnSale));
                          m.add(Boolean(itemObj.isFeatured));
                          m.add(false); // 14: isClassic
                          m.add(false); // 15: isPlayerWorldOnly
                          m.add(false); // 16: isNew
                          m.add(false); // 17: isDevOnly
                          m.add(false); // 18: isGridFeatured
                          m.add(0);     // 19: priceUSD
                          m.add(isReusableItem);    // 20: reusable
                          m.add(maxPurchasesCount); // 21: max_count (1 for non-reusable items)
                          m.add(isOwnedItem);       // 22: ownedInPayvault
                          m.add("");    // 23: label
                          m.add("#FFFFFF"); // 24: label_color
                       }
                       Global.log("EE.requestRemoteMethod: HTTP shop loaded " + jsonItems.length + " items dynamically!");
                       if(callback != null) callback(m);
                    }
                    catch(eErr:Error)
                    {
                       Global.log("EE.requestRemoteMethod HTTP shop error: " + eErr.message + ", fallback to createShopMessage");
                       if(callback != null) callback(selfEE.createShopMessage());
                    }
                 });
                 shopLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
                 {
                    Global.log("EE.requestRemoteMethod HTTP shop IOError, fallback to createShopMessage");
                    if(callback != null) callback(selfEE.createShopMessage());
                 });
                 shopLoader.load(shopReq);
                 return;
              }
             if(name == "buyItemWithGems" || name == "useGems" || name == "useEnergy" || name == "useAllEnergy" || name == "buyItem")
             {
                 var targetItem:String = (args.length > 0) ? String(args[0]) : "";
                 var targetUser:String = "Player";
                 if(Global.playerObject != null && Global.playerObject.name != null && Global.playerObject.name != "" && Global.playerObject.name.toLowerCase() != "guest")
                 {
                    targetUser = Global.playerObject.name;
                 }
                 else if(Global.currentUsername != null && Global.currentUsername != "")
                 {
                    targetUser = Global.currentUsername;
                 }
                 else if(Global.client != null && Global.client.connectUserId != null && Global.client.connectUserId != "simpleguest")
                 {
                    targetUser = Global.client.connectUserId;
                 }
                 if(targetUser.indexOf("simple") == 0 && targetUser != "simpleguest")
                 {
                    targetUser = targetUser.substr(6);
                 }
                 var isEnergyReq:Boolean = (name == "useEnergy" || name == "useAllEnergy");
                
                var req:URLRequest = new URLRequest("http://localhost:8080/api/buy");
                req.method = "POST";
                req.contentType = "application/json";
                req.data = JSON.stringify({
                   "username": targetUser,
                   "itemId": targetItem,
                   "costGems": isEnergyReq ? 0 : 10,
                   "isEnergy": isEnergyReq,
                   "useAll": (name == "useAllEnergy")
                });
                var loader:URLLoader = new URLLoader();
                var selfRef:EverybodyEdits = this;
                loader.addEventListener(Event.COMPLETE, function(e:Event):void
                {
                   try
                   {
                      var res:Object = JSON.parse(loader.data);
                      if(res.success && res.user)
                      {
                         if(Global.playerObject)
                         {
                            Global.playerObject.gems = res.user.gems;
                            Global.playerObject.energy = res.user.energy;
                            Global.playerObject.maxEnergy = res.user.maxEnergy;
                            Global.playerObject.itemEnergyProgress = res.user.itemEnergyProgress != null ? res.user.itemEnergyProgress : {};
                         }
                      }
                      if(res.noEnergy)
                      {
                         var mErr:Message = new Message(name);
                         mErr.add("error");
                         mErr.add("Not Enough Energy!");
                         mErr.add("You don't have any energy left. Wait for it to recharge or buy more.");
                         if(callback != null) callback(mErr);
                         return;
                      }
                      var mEnergy:Message = new Message(name);
                      mEnergy.add(Boolean(res.unlocked));
                      if(callback != null) callback(mEnergy);
                      return;
                   }
                   catch(err:Error) {}
                   var mSuccess:Message = new Message(name);
                   mSuccess.add(true);
                   if(callback != null) callback(mSuccess);
                });
                loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
                {
                   var mErr:Message = new Message(name);
                   mErr.add("error");
                   mErr.add("Error");
                   mErr.add("Failed to complete purchase");
                   if(callback != null) callback(mErr);
                });
                loader.load(req);
                return;
             }
             if(name == "getMyCrews")
             {
                var crewListLoader:URLLoader = new URLLoader();
                var crewListReq:URLRequest = new URLRequest("http://localhost:8080/api/crews");
                crewListLoader.addEventListener(Event.COMPLETE, function(e:Event):void
                {
                   try
                   {
                      var resData:Object = JSON.parse(String(crewListLoader.data));
                      var mCrews:Message = new Message("getMyCrews");
                      mCrews.add(false); // hasNoName = false
                      var crewsArr:Array = resData.crews as Array;
                      if(crewsArr != null)
                      {
                         for each(var cObj:Object in crewsArr)
                         {
                            mCrews.add(String(cObj.id));
                            mCrews.add(String(cObj.name));
                         }
                      }
                      if(callback != null) callback(mCrews);
                   }
                   catch(eErr:Error)
                   {
                      var mFall:Message = new Message("getMyCrews");
                      mFall.add(false);
                      mFall.add("staff");
                      mFall.add("Staff Team");
                      if(callback != null) callback(mFall);
                   }
                });
                crewListLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
                {
                   var mFall:Message = new Message("getMyCrews");
                   mFall.add(false);
                   mFall.add("staff");
                   mFall.add("Staff Team");
                   if(callback != null) callback(mFall);
                });
                crewListLoader.load(crewListReq);
                return;
             }

              if(name == "getCrew")
              {
                 var cName:String = (args.length > 0 && args[0] != null) ? String(args[0]) : "eelegends";
                 var crewLoader:URLLoader = new URLLoader();
                 var crewReq:URLRequest = new URLRequest("http://localhost:8080/api/crew?name=" + encodeURIComponent(cName));
                 crewLoader.addEventListener(Event.COMPLETE, function(e:Event):void
                 {
                    try
                    {
                       var cRes:Object = JSON.parse(String(crewLoader.data));
                       var cData:Object = cRes.crew;
                       var mCrew:Message = new Message("getCrew");
                       if(cData == null)
                       {
                          mCrew.add(true); // isError = true
                          if(callback != null) callback(mCrew);
                          return;
                       }

                       mCrew.add(false); // isError = false
                       mCrew.add(String(cData.id || "eelegends"));
                       mCrew.add(String(cData.name || "EE Legends"));
                       mCrew.add(uint(cData.subscribers || 100));
                       mCrew.add(String(cData.logoWorldId || "PW_default"));

                       var isMember:Boolean = true;
                       var memberRank:int = 0; // Leader
                       mCrew.add(memberRank);

                       if(memberRank >= 0)
                       {
                          mCrew.add(true); // canEditRanks
                          mCrew.add(true); // canChangeColors
                       }

                       mCrew.add(uint(cData.crewTextColor != null ? cData.crewTextColor : 0xFFFFFF));
                       mCrew.add(uint(cData.crewBackgroundColor != null ? cData.crewBackgroundColor : 0x1E293B));
                       mCrew.add(uint(cData.crewBackground2ndColor != null ? cData.crewBackground2ndColor : 0x0F172A));
                       mCrew.add(String(cData.faceplate || "Castle"));
                       mCrew.add(uint(cData.faceplateColor || 0));

                       // Faceplates count
                       mCrew.add(0);

                       // Ranks
                       var rArr:Array = cData.ranks as Array;
                       if(rArr == null || rArr.length == 0)
                       {
                          mCrew.add(3);
                          mCrew.add(0); mCrew.add("Leader");
                          mCrew.add(1); mCrew.add("Officer");
                          mCrew.add(2); mCrew.add("Member");
                       }
                       else
                       {
                          mCrew.add(rArr.length);
                          for each(var rObj:Object in rArr)
                          {
                             mCrew.add(int(rObj.id));
                             mCrew.add(String(rObj.name));
                          }
                       }

                       // Rooms
                       var rmArr:Array = cData.rooms as Array;
                       if(rmArr == null || rmArr.length == 0)
                       {
                          mCrew.add(1);
                          mCrew.add("PW_default");
                       }
                       else
                       {
                          mCrew.add(rmArr.length);
                          for each(var rmStr:String in rmArr)
                          {
                             mCrew.add(String(rmStr));
                          }
                       }

                       // Members (5 items each)
                       var mArr:Array = cData.members as Array;
                       if(mArr != null)
                       {
                          for each(var mObj:Object in mArr)
                          {
                             mCrew.add(String(mObj.username));
                             mCrew.add(String(mObj.role || "Member"));
                             mCrew.add(int(mObj.rank != null ? mObj.rank : 2));
                             mCrew.add(int(mObj.face != null ? mObj.face : 0));
                             mCrew.add(Boolean(mObj.isOnline));
                          }
                       }
                       if(callback != null) callback(mCrew);
                    }
                    catch(eCrewErr:Error)
                    {
                       var mErrC:Message = new Message("getCrew");
                       mErrC.add(true);
                       if(callback != null) callback(mErrC);
                    }
                 });
                 crewLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
                 {
                    var mErrC2:Message = new Message("getCrew");
                    mErrC2.add(true);
                    if(callback != null) callback(mErrC2);
                 });
                 crewLoader.load(crewReq);
                 return;
              }

              if(name == "getProfileObject")
              {
                 var pUser:String = (args.length > 0 && args[0] != null && String(args[0]) != "") ? String(args[0]) : "Admin";
                 if(pUser.indexOf("simple") == 0 && pUser != "simpleguest") pUser = pUser.substr(6);
                 var profLoader:URLLoader = new URLLoader();
                 var profReq:URLRequest = new URLRequest("http://localhost:8080/api/profile?username=" + encodeURIComponent(pUser));
                 profLoader.addEventListener(Event.COMPLETE, function(e:Event):void
                 {
                    try
                    {
                       var profData:Object = JSON.parse(String(profLoader.data));
                       var mProf:Message = new Message("getProfileObject");
                       mProf.add(String(profData.status || "public"));
                       mProf.add(String(profData.key || pUser.toLowerCase()));
                       mProf.add(String(profData.name || pUser));
                       mProf.add(String(profData.oldname || ""));
                       mProf.add(int(profData.smiley != null ? profData.smiley : 0));
                       mProf.add(int(profData.maxEnergy != null ? profData.maxEnergy : 200));
                       mProf.add(Boolean(profData.isOldBeta != null ? profData.isOldBeta : true));
                       mProf.add(Boolean(profData.isAdmin != null ? profData.isAdmin : true));
                       mProf.add(Boolean(profData.isGold != null ? profData.isGold : true));
                       mProf.add(Number(profData.goldremain || 0));
                       mProf.add(Number(profData.goldtime || 0));
                       mProf.add(String(profData.room0 || "PW_default"));
                       mProf.add(String(profData.betaonlyroom || ""));
                       var rIds:String = (profData.roomids as Array) ? (profData.roomids as Array).join("᎙") : "";
                       var rNames:String = (profData.roomnames as Array) ? (profData.roomnames as Array).join("᎙") : "";
                       var rPlays:String = (profData.roomplays as Array) ? (profData.roomplays as Array).join("᎙") : "";
                       mProf.add(rIds);
                       mProf.add(rNames);
                       mProf.add(rPlays);
                       mProf.add(0); // timesCount = 0
                       if(callback != null) callback(mProf);
                    }
                    catch(eErr:Error)
                    {
                       var mErrProf:Message = new Message("getProfileObject");
                       mErrProf.add("public");
                       mErrProf.add(pUser.toLowerCase());
                       mErrProf.add(pUser);
                       mErrProf.add("");
                       mErrProf.add(0);
                       mErrProf.add(200);
                       mErrProf.add(true);
                       mErrProf.add(true);
                       mErrProf.add(true);
                       mErrProf.add(0);
                       mErrProf.add(0);
                       mErrProf.add("PW_default");
                       mErrProf.add("");
                       mErrProf.add("PW_default");
                       mErrProf.add("Home World");
                       mErrProf.add("1");
                       mErrProf.add(0);
                       if(callback != null) callback(mErrProf);
                    }
                 });
                 profLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
                 {
                    var mErrProf2:Message = new Message("getProfileObject");
                    mErrProf2.add("public");
                    mErrProf2.add(pUser.toLowerCase());
                    mErrProf2.add(pUser);
                    mErrProf2.add("");
                    mErrProf2.add(0);
                    mErrProf2.add(200);
                    mErrProf2.add(true);
                    mErrProf2.add(true);
                    mErrProf2.add(true);
                    mErrProf2.add(0);
                    mErrProf2.add(0);
                    mErrProf2.add("PW_default");
                    mErrProf2.add("");
                    mErrProf2.add("PW_default");
                    mErrProf2.add("Home World");
                    mErrProf2.add("1");
                    mErrProf2.add(0);
                    if(callback != null) callback(mErrProf2);
                 });
                 profLoader.load(profReq);
                 return;
              }

              if(name == "getCrews")
              {
                 var mUserCrews:Message = new Message("getCrews");
                 if(callback != null) callback(mUserCrews);
                 return;
              }

             if(callback != null)
             {
                var mDummy:Message = new Message("r");
                 if(name == "getProfile")
                 {
                    mDummy.add(false); // hideProfile = false
                 }
                 else if(name == "getBlockStatus")
                 {
                    mDummy.add(false); // blockInvites = false
                 }
                else if(name == "getLobbyProperties")
                {
                   mDummy.add(false);
                   mDummy.add(-1);
                }
                else if(name == "getNews")
                {
                   mDummy.add("Everybody Edits Private Server");
                   mDummy.add("Welcome to your local offline server!");
                   mDummy.add("Aug 4, 2026");
                   mDummy.add("news.png");
                }
                else if(name == "getNotifications")
                {
                   mDummy.add("notif_shop_01");
                   mDummy.add("news");
                   mDummy.add("SHOP UPDATE");
                   mDummy.add("The Shop has been updated! Buy all smileys, block packages, and auras using energy or gems!");
                   mDummy.add("2026-08-06");
                   mDummy.add("");
                   mDummy.add("");
                }
                callback(mDummy);
             }
             return;
          }
      }
      
      public function requestCrewLobbyMethod(param1:String, param2:String, param3:Function, param4:Function, ... rest) : void
      {
         var crewId:String = param1;
         var name:String = param2;
         var callback:Function = param3;
         var errorCallback:Function = param4;
         var args:Array = rest;

         var cleanId:String = crewId.toLowerCase();
         if(cleanId.indexOf("crew") == 0) cleanId = cleanId.substr(4);

         if(name == "getCrew")
         {
            var crewLoader:URLLoader = new URLLoader();
            var crewReq:URLRequest = new URLRequest("http://localhost:8080/api/crew?id=" + cleanId);
            crewLoader.addEventListener(Event.COMPLETE, function(e:Event):void
            {
               try
               {
                  var cData:Object = JSON.parse(String(crewLoader.data));
                  var cObj:Object = cData.crew;
                  var mC:Message = new Message("getCrew");
                  mC.add(false); // error flag = false
                  mC.add(String(cObj.id));
                  mC.add(String(cObj.name));
                  mC.add(cObj.subscribers != null ? uint(cObj.subscribers) : 1);
                  mC.add(cObj.logoWorldId != null ? String(cObj.logoWorldId) : "");
                   var membersArr:Array = cObj.members as Array;
                    var currentUsername:String = (Global.playerObject && Global.playerObject.name) ? Global.playerObject.name : (Global.currentUsername || "");
                   var myFoundRank:int = -1;
                   if(membersArr != null)
                   {
                      for each(var mCheck:Object in membersArr)
                      {
                         if(String(mCheck.username).toLowerCase() == currentUsername.toLowerCase())
                         {
                            myFoundRank = int(mCheck.rank != null ? mCheck.rank : 0);
                            break;
                         }
                      }
                   }
                   if(myFoundRank == -1 && membersArr != null && membersArr.length > 0)
                   {
                      myFoundRank = 0;
                   }

                   mC.add(myFoundRank); // myRank
                  mC.add(true); // canEditDescriptions
                  mC.add(true); // canChangeColors
                  mC.add(""); mC.add(""); mC.add(""); mC.add(""); mC.add(""); // 5 dummy settings
                  mC.add(0); // faceplatesCount = 0

                  var ranksArr:Array = cObj.ranks as Array;
                  var ranksCount:int = ranksArr != null ? ranksArr.length : 0;
                  mC.add(ranksCount);
                  if(ranksArr != null)
                  {
                     for each(var rObj:Object in ranksArr)
                     {
                        mC.add(String(rObj.name));
                        mC.add(String(rObj.perms != null ? rObj.perms : "111111"));
                     }
                  }

                  var worldsArr:Array = cObj.worlds as Array;
                  var worldsCount:int = worldsArr != null ? worldsArr.length : 0;
                  mC.add(worldsCount);
                  if(worldsArr != null)
                  {
                     for each(var wId:String in worldsArr)
                     {
                        mC.add(String(wId));
                     }
                  }

                  var membersArr:Array = cObj.members as Array;
                  if(membersArr != null)
                  {
                     for each(var mMember:Object in membersArr)
                     {
                        mC.add(String(mMember.username));
                        mC.add(String(mMember.role != null ? mMember.role : "Member"));
                        mC.add(int(mMember.rank != null ? mMember.rank : 0));
                        mC.add(int(mMember.face != null ? mMember.face : 0));
                        mC.add(Boolean(mMember.smileyGoldBorder != null ? mMember.smileyGoldBorder : false));
                     }
                  }

                  if(callback != null) callback(mC);
               }
               catch(eErr:Error)
               {
                  if(errorCallback != null) errorCallback();
               }
            });
            crewLoader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void
            {
               if(errorCallback != null) errorCallback();
            });
            crewLoader.load(crewReq);
            return;
         }

         if(name == "getPendingInvites")
         {
            var mPending:Message = new Message("getPendingInvites");
            mPending.add(false);
            if(callback != null) callback(mPending);
            return;
         }
         
         if(this.crewLobbyId != crewId && this.crewLobbyCon != null && this.crewLobbyCon.connected)
         {
            this.crewLobbyCon.disconnect();
         }
         this.getCrewLobbyConnection(crewId,function(param1:Connection):void
         {
            var con:Connection = param1;
            con.addMessageHandler(name,function(param1:Message):void
            {
               if(callback != null)
               {
                  callback.apply(this,[param1]);
               }
               con.removeMessageHandler(name,arguments.callee);
            });
            if(errorCallback != null)
            {
               con.addDisconnectHandler(errorCallback);
            }
            con.sendMessage(con.createMessage.apply(this,[name].concat(args)));
         });
      }
      
      private function getCrewLobbyConnection(param1:String, param2:Function) : void
      {
         var crewId:String = param1;
         var callback:Function = param2;
         if(crewId == this.crewLobbyId && this.crewLobbyCon != null && this.crewLobbyCon.connected)
         {
            callback(this.crewLobbyCon);
         }
         else
         {
            this.crewLobbyQueue.push(callback);
            this.crewLobbyId = crewId;
            if(this.crewLobbyConnecting)
            {
               return;
            }
            this.crewLobbyConnecting = true;
            this.client.multiplayer.createJoinRoom(crewId,Config.server_type_crewshop,true,{},{},function(param1:Connection):void
            {
               var con:Connection = param1;
               crewLobbyCon = con;
               con.addMessageHandler("info",function(param1:Message, param2:String, param3:String, param4:Boolean = false, param5:String = null, param6:String = null):void
               {
                  loadInfo(param2,param3,-1,param4,param5,param6);
               });
               con.addDisconnectHandler(function():void
               {
               });
               crewLobbyConnecting = false;
               while(crewLobbyQueue.length)
               {
                  crewLobbyQueue.shift()(crewLobbyCon);
               }
            });
         }
      }
      
      public function getRPCConnection(param1:Function, param2:Function = null) : void
      {
         if(true)
         {
            // Debug mode: use the main game connection as the RPC connection
            if(this.connection != null && this.connection.connected)
            {
               param1(this.connection);
            }
            else
            {
               // Queue it – will be flushed once the game connection is established
               this.rpcConnectQueue.push(param1);
            }
            return;
         }
         if(this.rpcCon != null && this.rpcCon.connected)
         {
            param1(this.rpcCon);
         }
         else
         {
            this.rpcConnectQueue.push(param1);
            if(this.rpcConnecting)
            {
               return;
            }
            this.rpcConnecting = true;
            this.tryLobbyConnect(this.client.connectUserId + "_" + this.generateRandomString(5));
         }
      }
      
      private function tryLobbyConnect(param1:String, param2:Function = null) : void
      {
         this.client.multiplayer.createJoinRoom(param1,Global.player_is_guest ? Config.server_type_guestserviceroom : Config.server_type_serviceroom,true,{},{},this.lobbyConnected,param2);
      }
      
      private function generateRandomString(param1:Number) : String
      {
         var _loc2_:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
         var _loc3_:String = "";
         var _loc4_:Number = 0;
         while(_loc4_ < param1)
         {
            _loc3_ += _loc2_.charAt(Math.floor(Math.random() * _loc2_.length));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function lobbyConnected(param1:Connection) : void
      {
         var con:Connection = param1;
         this.rpcCon = con;
         con.addMessageHandler("linked",function(param1:Message):void
         {
            var m:Message = param1;
            client.multiplayer.createJoinRoom("auth" + client.connectUserId,"AuthRoom",true,{},{"type":"Link"},function(param1:Connection):void
            {
               var authcon:Connection = param1;
               authcon.addMessageHandler("auth",function(param1:Message):void
               {
                  var _loc2_:Object = new Object();
                  _loc2_.userId = param1.getString(0);
                  _loc2_.auth = param1.getString(1);
                  PlayerIO.authenticate(Global.stage,Config.playerio_game_id,"connected",_loc2_,null,simpleConnect,null);
               });
            },null);
         });
         con.addMessageHandler("info",function(param1:Message, param2:String, param3:String, param4:Boolean = false, param5:String = null, param6:String = null):void
         {
            loadInfo(param2,param3,-1,param4,param5,param6);
         });
         con.addMessageHandler("LobbyTo",function(param1:Message, param2:String):void
         {
            tryLobbyConnect(param2);
         });
         con.addMessageHandler("upgrade",this.showUpgradeScreen);
         con.addMessageHandler("copyPrompt",function(param1:Message, param2:String, param3:String, param4:String = ""):void
         {
            showOnTop(new CopyPrompt(param2,param3,param4));
         });
         con.addDisconnectHandler(function():void
         {
            disconnectRPC();
         });
         con.addMessageHandler("connectioncomplete",function(param1:Message):void
         {
            rpcConnecting = false;
            while(rpcConnectQueue.length)
            {
               rpcConnectQueue.shift()(rpcCon);
            }
         });
      }
      
      public function disconnectRPC() : void
      {
         if(this.rpcCon != null)
         {
            if(this.rpcCon.connected)
            {
               this.rpcCon.disconnect();
            }
            this.rpcCon = null;
            this.rpcConnecting = false;
         }
      }
      
      private function cleanUIAndConnections() : void
      {
         this.showDisconnectedMessage = false;
         if(Boolean(this.ui2instance) && Boolean(this.ui2instance.parent))
         {
            overlayContainer.removeChild(this.ui2instance);
         }
         if(Boolean(this.sidechat) && Boolean(this.sidechat.parent))
         {
            overlayContainer.removeChild(this.sidechat);
         }
         if(Boolean(this.connection) && this.connection.connected)
         {
            this.connection.disconnect();
         }
         if(Boolean(state) && state is LobbyState)
         {
            try { Object(state).reset(); } catch(eReset1:Error) {}
         }
         if(Boolean(state) && state is PlayState)
         {
            try { Object(state).reset(); } catch(eReset2:Error) {}
         }
         this.showDisconnectedMessage = true;
      }
      
      public function ShowLobby(param1:String = "") : void
      {
         clearOverlayContainer();
         this.cleanUIAndConnections();
         this.showLobby(null,param1);
      }
      
      public function loadStoredCookie(param1:Function) : void
      {
         var callback:Function = param1;
         try
         {
            Global.cookie = SharedObject.getLocal("ssx");
            Global.sharedCookie = SharedObject.getLocal("ss");
         }
         catch(e:Error)
         {
            Global.noSave = true;
         }
         if(callback != null)
         {
            callback();
         }
      }
      
      private function configureBasedOnLoadvariabels() : void
      {
         Global.playing_on_kongregate = root.loaderInfo.parameters.kongregate ? true : false;
         Global.playing_on_playedonline = Global.affiliate == "playedonline";
      }
      
      private function handleAttach(param1:Event) : void
      {
         var loadUser:String;
         var loadCrew:String;
         var offset:int = 0;
         var e:Event = param1;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         Global.stage = stage;
         try
         {
            Global.logField = new TextField();
            Global.logField.width = 640;
            Global.logField.height = 500;
            Global.logField.background = true;
            Global.logField.backgroundColor = 0x000000;
            Global.logField.textColor = 0x00FF00;
            var tf:TextFormat = new TextFormat();
            tf.color = 0x00FF00;
            tf.size = 12;
            Global.logField.defaultTextFormat = tf;
            Global.logField.wordWrap = true;
            Global.logField.multiline = true;
            Global.logField.selectable = true;
            Global.logField.visible = false;
            
            Global.logField.text = "--- LOG CONSOLE INSTANTIATED ---\n";
            
            if(stage != null)
            {
               stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, function(param1:flash.events.KeyboardEvent):void
               {
                  if(param1.keyCode == 48 || param1.keyCode == 96)
                  {
                     if(Global.logField != null)
                     {
                        Global.logField.visible = !Global.logField.visible;
                        if(Global.logField.visible)
                        {
                           if(Global.stage != null)
                           {
                              Global.stage.addChild(Global.logField);
                           }
                        }
                        else
                        {
                           if(Global.logField.parent != null)
                           {
                              Global.logField.parent.removeChild(Global.logField);
                           }
                        }
                     }
                  }
               });
            }
            
            Global.log("Logging Console Initialized. Press '0' to show/hide this log overlay.");
            Global.log("Client version: 264. Server address: 127.0.0.1:8184");
         }
         catch(eLog:Error)
         {
            trace("Logger setup error: " + eLog.message);
         }
         try {
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
            Security.loadPolicyFile("xmlsocket://127.0.0.1:8184");
            Security.loadPolicyFile("xmlsocket://127.0.0.1:843");
         } catch(errSec:Error) {}
         ItemManager.init();
         AnimationManager.init();
         SoundManager.init();
         if(true)
         {
            setTimeout(function():void
            {
               loadStoredCookie(handleLoadCookie);
            },100);
            return;
         }
         loadUser = Config.debug_profile;
         loadCrew = Config.debug_crew_profile;
         if(ExternalInterface.available)
         {
            try
            {
               loadUser = ExternalInterface.call("load_user.toString") || loadUser;
               loadCrew = ExternalInterface.call("load_crew.toString") || loadCrew;
               this.email_confirm_key = ExternalInterface.call("ee_confirmkey.toString");
            }
            catch(e:Error)
            {
            }
         }
         if(loadUser != "")
         {
            Global.normalStart = false;
            this.showProfile(loadUser);
            return;
         }
         if(loadCrew != "")
         {
            Global.normalStart = false;
            this.showCrewProfile(loadCrew);
            return;
         }
         offset = 5;
         setInterval(function():void
         {
            offset += 5;
         },60 * 5 * 1000);
         this.loadStoredCookie(this.handleLoadCookie);
      }
      
      private function handleLoadCookie() : void
      {
         var lstate:LoadState;
         var parameters:Object;
         var username:String = null;
         var password:String = null;
         
         try
         {
            Global.log("handleLoadCookie() started");
         }
         catch(eLog:Error)
         {
            trace("Logger setup error: " + eLog.message);
         }
         
         stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.handleFullScreen);
         if(Capabilities.playerType == "PlugIn")
         {
            this.fullscreenBlack.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               param1.preventDefault();
               param1.stopImmediatePropagation();
               param1.stopPropagation();
            });
            this.fullscreenBlack.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               param1.preventDefault();
               param1.stopImmediatePropagation();
               param1.stopPropagation();
            });
            stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED,function(param1:FullScreenEvent):void
            {
               setTimeout(hideInvisibleMask,100);
            });
         }
         Bl.data.showMap = false;
         Bl.data.canEdit = false;
         Bl.data.canToggleGodMode = false;
         lstate = new LoadState();
         state = lstate;
         this.filterbadwords = true;
         this.configureBasedOnLoadvariabels();
         parameters = LoaderInfo(this.root.loaderInfo).parameters;
         this.iseecom = (parameters.nonoba$referer || "") + "".toLowerCase().indexOf("kongregate") == -1;
         Global.affiliate = Global.affiliate || Global.cookie.data.affiliate || null;
         if(ExternalInterface.available)
         {
            try
            {
               this.forcejoin = ExternalInterface.call("ee_forcejoin.toString");
               this.roomname = ExternalInterface.call("ee_roomname.toString");
               Bl.data.isbeta = ExternalInterface.call("isbeta.toString") == "true" || Config.forceBeta;
               Global.playing_on_com = Bl.data.onsite = ExternalInterface.call("iseecom.toString") == "true" && !Bl.data.isbeta || true;
               Global.affiliate = ExternalInterface.call("affiliate.toString") || Global.affiliate;
            }
            catch(e:Error)
            {
            }
         }
         if(!Global.cookie.data.affiliate && Boolean(Global.affiliate))
         {
            Global.cookie.data.affiliate = Global.affiliate;
            if(!Global.noSave)
            {
               Global.cookie.flush();
            }
         }
         this.roomname = parameters.worldId || this.roomname;
         if(false)
         {
            this.roomname = Config.development_mode_autojoin_room;
         }
         if(this.roomname != null)
         {
            if(this.roomname.substring(0,2) == "PW" || this.roomname.substring(0,2) == "BW" || this.roomname.substring(0,2) == "OW" || this.roomname.substring(0,2) == "CW")
            {
               this.roomname = this.roomname.split("-").join(" ");
            }
         }
          if(Global.cookie.data.username == "guest")
          {
             Global.cookie.data.username = "";
             Global.cookie.data.password = "";
          }
          if(Boolean(Global.cookie.data.username) && Boolean(Global.cookie.data.password) && !Global.playing_on_kongregate)
          {
             PlayerIO.authenticate(Bl.stage,Config.playerio_game_id,"simpleusers",{
                "email":Global.cookie.data.username,
                "password":Global.cookie.data.password
             },null,this.simpleConnect,this.handleFailedAuth);
          }
          else
          {
             this.authenticateUser();
          }
      }
      
      private function authenticateWithKongregate(param1:String) : void
      {
         var request:URLRequest;
         var loader:Loader;
         var apiPath:String = param1;
         Bl.data.iskongregate = true;
         Security.allowDomain(apiPath);
         request = new URLRequest(apiPath);
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            var isKongregateGuest:Boolean;
            var user_id:String = null;
            var token:String = null;
            var e:Event = param1;
            kongregate = e.target.content;
            kongregate.services.connect();
            isKongregateGuest = Boolean(kongregate.services.isGuest());
            if(isKongregateGuest)
            {
               baseInit();
               kongregate.services.addEventListener("login",function():void
               {
                  var _loc1_:String = kongregate.services.getUserId();
                  var _loc2_:String = kongregate.services.getGameAuthToken();
                  PlayerIO.authenticate(stage,Config.playerio_game_id,"kongregate",{
                     "userId":_loc1_,
                     "gameAuthToken":_loc2_
                  },null,simpleConnect,handleError);
               });
            }
            else
            {
               user_id = kongregate.services.getUserId();
               token = kongregate.services.getGameAuthToken();
               PlayerIO.authenticate(stage,Config.playerio_game_id,"kongregate",{
                  "userId":user_id,
                  "gameAuthToken":token
               },null,simpleConnect,handleError);
            }
         });
         loader.load(request);
         overlayContainer.addChild(loader);
      }
      
      private function handleReturnToLobbyError(param1:PlayerIOError) : void
      {
         Global.log("handleReturnToLobbyError called: " + (param1 ? param1.message : "unknown"));
         this.showLobby();
      }
      
      private function handleFailedAuth(param1:PlayerIOError) : void
      {
         this.authenticateUser();
      }
      
      private function authenticateUser() : void
      {
         showMainLogin();
      }
      
      public function authenticateAsGuest(param1:Function = null) : void
      {
         var callback:Function = param1;
         Global.log("authenticateAsGuest() called");
         if(true)
         {
            var dummyClient:Client = new Client(stage, null, Config.playerio_game_id, "", "", "simpleguest", false, null);
            dummyClient.multiplayer.developmentServer = "127.0.0.1:8184";
            Global.player_is_guest = true;
            if(callback != null)
            {
               callback(dummyClient);
               return;
            }
            simpleConnect(dummyClient, "");
            return;
         }
         PlayerIO.authenticate(stage,Config.playerio_game_id,"simpleusers",{
            "username":"guest",
            "password":"guest"
         },null,function(param1:Client):void
         {
            if(true)
            {
               param1.multiplayer.developmentServer = "127.0.0.1:8184";
            }
            Global.player_is_guest = true;
            if(callback != null)
            {
               callback(param1);
               return;
            }
            simpleConnect(param1);
         },this.handleError);
      }
      
      private function baseInit() : void
      {
         Global.log("baseInit() called");
         showMainLogin();
      }
      
      public function logout(param1:Function = null) : void
      {
         Bl.data.brick = 0;
         Bl.data.base = this;
         Bl.data.iskongregate = false;
         Bl.data.config = [0,9,10,11,16,17,18,29,32,2,100];
         Global.chatIsVisible = false;
         Global.player_is_beta_member = false;
         Bl.data.roomname = "";
         Bl.data.name = "";
         Global.currentCrew = "";
         Global.currentCrewName = "";
         Global.cleanCookie();
         if(Boolean(state) && state is LobbyState)
         {
            LobbyState(state).reset();
         }
         var _loc2_:LoadState = new LoadState();
         state = _loc2_;
         Global.client = this.client = null;
         Global.isFirstLogin = false;
         Global.player_is_guest = true;
         this.disconnectRPC();
         this.baseInit();
         if(param1 != null)
         {
            param1();
         }
      }
      
      public function showMainLogin() : void
      {
         clearOverlayContainer();
         this.mainlogin = new MainLogin();
         overlayContainer.addChild(this.mainlogin);
      }
      
      public function showLoginWindow() : void
      {
         clearOverlayContainer();
         this.loginwindow = new LoginWindow();
         overlayContainer.addChild(this.loginwindow);
      }
      
      public function showKongregateLoginWindow() : void
      {
         this.kongregate.services.showSignInBox();
      }
      
      public function setCrewName(param1:String) : void
      {
         if(state as LobbyState != null)
         {
            if((state as LobbyState).shopbar != null)
            {
               (state as LobbyState).shopbar.setCrewName(param1);
            }
         }
      }
      
      public function refresShop() : void
      {
         this.showLoadingScreen("Loading Shop");
         Shop.refresh(function():void
         {
            hideLoadingScreen();
         });
      }
      
      public function refreshCrewShop() : void
      {
         Shop.refreshCrewShop(function():void
         {
            hideLoadingScreen();
         });
      }
      
      public function buyGemsWithKongregate(param1:int, param2:Function) : void
      {
         var count:int = param1;
         var callback:Function = param2;
         this.kongregate.mtx.purchaseItems(["coins" + count],function(param1:Object):void
         {
            var result:Object = param1;
            setTimeout(function():void
            {
               Shop.refresh(callback(count));
            },1000);
         });
      }
      
      public function addToFavorites() : void
      {
         if(this.connection != null && !Bl.data.inFavorites)
         {
            this.connection.send("favorite");
         }
      }
      
      public function removeFromFavorites() : void
      {
         if(this.connection != null && Boolean(Bl.data.inFavorites))
         {
            this.connection.send("unfavorite");
         }
      }
      
      public function giveLike() : void
      {
         if(this.connection != null && !Bl.data.liked)
         {
            this.connection.send("like");
         }
      }
      
      public function removeLike() : void
      {
         if(this.connection != null && Boolean(Bl.data.liked))
         {
            this.connection.send("unlike");
         }
      }
      
      public function setGoldBorder(param1:Boolean) : void
      {
         if(this.connection != null && Global.playerObject.goldmember)
         {
            this.connection.send("smileyGoldBorder",param1);
         }
      }
      
      public function showRecoverPassword(param1:Boolean = false) : void
      {
         var r:ResetPassword = null;
         var bg:BlackBG = null;
         var loggedIn:Boolean = param1;
         if(!loggedIn)
         {
            clearOverlayContainer();
         }
         r = new ResetPassword();
         bg = new BlackBG();
         if(loggedIn)
         {
            overlayContainer.addChild(bg);
            r.x = Config.maxwidth / 2 - r.width / 2;
            r.y = 8;
         }
         overlayContainer.addChild(r);
         r.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         r.close.addEventListener(MouseEvent.CLICK,function():void
         {
            if(!loggedIn)
            {
               showMainLogin();
            }
            else
            {
               overlayContainer.removeChild(r);
            }
            overlayContainer.removeChild(bg);
         });
      }
      
      public function showRegister(param1:Number = -1) : void
      {
         var r:RegisterWindow = null;
         var captchaKeyStr:String = null;
         var ox:Number = param1;
         var getCaptcha:Function = function():void
         {
            PlayerIO.quickConnect.simpleGetCaptcha(Config.playerio_game_id,107,37,function(param1:String, param2:String):void
            {
               captchaKeyStr = param1;
               r.setCaptchaImage(param2);
            },function():void
            {
            });
         };
         clearOverlayContainer();
         if(Global.playing_on_kongregate)
         {
            Global.base.showKongregateLoginWindow();
            return;
         }
         r = new RegisterWindow();
         captchaKeyStr = "noKey";
         if(ox == -1)
         {
            r.x = (850 - r.width) / 2 - 35;
         }
         else
         {
            r.x = ox;
         }
         r.name = "RegisterWindow";
         r.stop();
         r.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         overlayContainer.addChild(r);
         getCaptcha();
         r.btnReloadCaptcha.addEventListener(MouseEvent.CLICK,function():void
         {
            getCaptcha();
         });
         r.close.tabEnabled = false;
         r.close.addEventListener(MouseEvent.CLICK,function():void
         {
            if(state is LobbyState)
            {
               clearOverlayContainer();
            }
            else
            {
               showMainLogin();
            }
         });
         var toggleTerms:Function = function():void
         {
            var isChecked:Boolean = r.termsbutton.currentFrame == 2;
            r.termsbutton.gotoAndStop(isChecked ? 1 : 2);
            r.registerbutton.gotoAndStop(isChecked ? 2 : 1);
            r.registerbutton.mouseEnabled = !isChecked;
         };
         r.termsbutton.buttonMode = true;
         r.termsbutton.useHandCursor = true;
         r.termsbutton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            toggleTerms();
         });
         if(r.termslink != null)
         {
            r.termslink.buttonMode = true;
            r.termslink.useHandCursor = true;
            r.termslink.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               toggleTerms();
            });
         }
         r.registerbutton.addEventListener(MouseEvent.CLICK,function():void
         {
            r.bg_mail.gotoAndStop(1);
            r.bg_password.gotoAndStop(1);
            r.bg_password2.gotoAndStop(1);
            r.bg_captcha.gotoAndStop(1);
            r.errors.text = "";
            if(r.hasEmptyFields())
            {
               r.errors.text = "All fields should be filled out";
               return;
            }
            if(r.inppassword.text != r.inppassword2.text)
            {
               r.bg_password.gotoAndStop(2);
               r.bg_password2.gotoAndStop(2);
               r.errors.text = "Passwords does not match";
               return;
            }
            r.lock(true);
            r.registerbutton.visible = false;
            PlayerIO.quickConnect.simpleRegister(Bl.stage,Config.playerio_game_id,r.inpemail.text,r.inppassword.text,r.inpemail.text,captchaKeyStr,r.inpcaptcha.text,Global.affiliate ? {"affiliate":Global.affiliate} : {},Global.affiliate,function(param1:Client):void
            {
               var c:Client = param1;
               disconnectRPC();
               client = c;
               Global.player_is_guest = false;
               if(true)
               {
                  client.multiplayer.developmentServer = "127.0.0.1:8184";
               }
               overlayContainer.removeChild(r);
               cleanUIAndConnections();
               Global.isFirstLogin = true;
               state = new LoadState();
               simpleConnect(c);
            },function(param1:PlayerIORegistrationError):void
            {
               r.errors.text = "";
               if(param1.usernameError != null)
               {
                  r.errors.appendText(param1.usernameError + "\n");
               }
               if(param1.emailError != null)
               {
                  r.errors.appendText(param1.emailError + "\n");
                  r.bg_mail.gotoAndStop(2);
               }
               if(param1.passwordError != null)
               {
                  r.errors.appendText(param1.passwordError + "\n");
                  r.bg_password.gotoAndStop(2);
                  r.bg_password2.gotoAndStop(2);
               }
               if(param1.captchaError != null)
               {
                  r.errors.appendText(param1.captchaError + "\n");
                  r.bg_captcha.gotoAndStop(2);
               }
               r.registerbutton.visible = true;
               r.lock(false);
            });
         });
      }
      
      private function setError(param1:TextField, param2:Boolean) : void
      {
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.color = param2 ? 16711680 : 16777215;
         param1.setTextFormat(_loc3_,-1,-1);
      }
      
      public function simpleConnect(param1:Client, param2:String = "") : void
      {
         var c:Client = param1;
         var id:String = param2;
         Global.log("simpleConnect() called: id='" + id + "', roomname='" + roomname + "'");
         clearOverlayContainer();
         this.loadAndInitPlayer(c,function():void
         {
            if(roomname)
            {
               setTimeout(function():void
               {
                  LoadState(state).fadeOut(function():void
                  {
                     joinRoom(roomname,true);
                  });
               },true ? 0 : 500);
            }
            else if(Global.isFirstLogin && c.connectUserId != "simpleguest")
            {
               joinRoom(Global.playerObject.homeworld,true);
            }
            else
            {
               showLobby(LoadState(state));
            }
         });
      }
      
      public function SystemSay(param1:String, param2:String = "* Warning") : void
      {
         if(!this.sidechat)
         {
            return;
         }
         this.sidechat.addLine(param2,param1,16777215);
      }
      
      private function acceptTermsAndConditions(param1:SimplePlayerObject, param2:Client, param3:Function) : void
      {
         var o:SimplePlayerObject = param1;
         var c:Client = param2;
         var callback:Function = param3;
         this.getRPCConnection(function(param1:Connection):void
         {
            var _loc2_:TermsWindow = null;
            if(o.accepted_terms != Config.termsVersion && c.connectUserId != "simpleguest")
            {
               clearOverlayContainer();
               _loc2_ = new TermsWindow(callback);
               overlayContainer.addChild(_loc2_);
            }
            else
            {
               callback();
            }
         },this.handleError);
      }
      
      private function migrateUsername(param1:SimplePlayerObject, param2:Client, param3:Function) : void
      {
         var o:SimplePlayerObject = param1;
         var c:Client = param2;
         var callback:Function = param3;
         this.getRPCConnection(function(param1:Connection):void
         {
            var _loc2_:UsernameWindow = null;
            if(!o.name && c.connectUserId != "simpleguest")
            {
               clearOverlayContainer();
               _loc2_ = new UsernameWindow(callback,false);
               overlayContainer.addChild(_loc2_);
            }
            else
            {
               callback();
            }
         },this.handleError);
      }
      
      public function checkChangeUsername(param1:SimplePlayerObject, param2:Client, param3:Function) : void
      {
         var o:SimplePlayerObject = param1;
         var c:Client = param2;
         var callback:Function = param3;
         this.getRPCConnection(function(param1:Connection):void
         {
            var _loc2_:UsernameWindow = null;
            var _loc3_:BlackBG = null;
            if(o.changename && c.connectUserId != "simpleguest")
            {
               clearOverlayContainer();
               _loc2_ = new UsernameWindow(callback,true);
               if(state is LobbyState)
               {
                  _loc3_ = new BlackBG();
                  _loc2_.x = Global.fullWidth / 2 - _loc2_.x / 2;
                  overlayContainer.addChild(_loc3_);
               }
               overlayContainer.addChild(_loc2_);
            }
            else
            {
               callback();
            }
         },this.handleError);
      }
      
      private function loadAndInitPlayer(param1:Client, param2:Function, param3:Boolean = true) : void
      {
         var c:Client = param1;
         Global.log("loadAndInitPlayer() called");
         var callback:Function = param2;
         var showlog:Boolean = param3;
         if(c == null)
         {
            c = new Client(stage, null, Config.playerio_game_id, "", "", "simpleguest", false, null);
         }
         this.client = c;
         Shop.setBase(this,c);
         Global.client = c;
         if(true)
         {
            this.client.multiplayer.developmentServer = "127.0.0.1:8184";
            var usernameStr:String = "Guest";
            if(c != null && c.connectUserId != null && c.connectUserId.indexOf("simple") == 0 && c.connectUserId != "simpleguest")
            {
               usernameStr = c.connectUserId.substr(6);
            }
            Global.player_is_guest = usernameStr.toLowerCase() == "guest" || usernameStr.indexOf("Guest") == 0;
             Global.log("loadAndInitPlayer: loading user properties for " + usernameStr);
             var loader:URLLoader = new URLLoader();
             var req:URLRequest = new URLRequest("http://localhost:8080/api/user/" + encodeURIComponent(usernameStr));

             var handleFail:Function = function(e:Event):void
             {
                Global.log("loadAndInitPlayer HTTP failed: " + (e != null ? e.type : "direct_fallback"));
                var spoDef:SimplePlayerObject = new SimplePlayerObject();
                spoDef.name = usernameStr;
                spoDef.isAdministrator = false;
                spoDef.isModerator = false;
                spoDef.isStaff = false;
                spoDef.goldmember = false;
                Global.playerObject = spoDef;
                Bl.data.isAdmin = false;
                Bl.data.isStaffMember = false;
                Bl.data.canUseAllItems = false;
                KeyBinding.load();
                if(callback != null)
                {
                   callback();
                }
             };

             loader.addEventListener(Event.COMPLETE, function(e:Event):void
             {
                Global.log("loadAndInitPlayer HTTP complete for " + usernameStr);
                try
                {
                   var json:Object = JSON.parse(String(loader.data));
                   if(json && json.success && json.user)
                   {
                      var u:Object = json.user;
                      var spo:SimplePlayerObject = new SimplePlayerObject();
                      spo.name = u.username;
                      spo.isAdministrator = Boolean(u.isAdmin || u.role == "admin");
                      spo.isModerator = Boolean(u.isMod || spo.isAdministrator);
                      spo.isStaff = Boolean(u.isStaff || spo.isAdministrator);
                      spo.goldmember = Boolean(u.goldmember);
                      spo.haveSmileyPackage = Boolean(u.haveSmileyPackage);
                      spo.smiley = u.face != null ? int(u.face) : (u.smiley != null ? int(u.smiley) : 0);
                      spo.aura = u.aura != null ? int(u.aura) : 0;
                      spo.auraColor = u.auraColor != null ? int(u.auraColor) : 0;
                      spo.badge = u.badge || "";
                      spo.gems = u.gems != null ? Number(u.gems) : 500;
                      spo.energy = u.energy != null ? int(u.energy) : 100;
                      spo.maxEnergy = u.maxEnergy != null ? int(u.maxEnergy) : 200;
                      spo.itemEnergyProgress = u.itemEnergyProgress != null ? u.itemEnergyProgress : {};
                      Global.player_is_beta_member = Boolean(u.player_is_beta_member);

                      spo.homeworld = "PW_default";
                      spo.setRooms(["homeworld"], ["PW_default"], ["Home World"]);
                      spo.accepted_terms = Config.termsVersion;
                      Global.playerObject = spo;

                      Bl.data.isAdmin = spo.isAdministrator;
                      Bl.data.isModerator = spo.isModerator;
                      Bl.data.isStaffMember = spo.isStaff || spo.isAdministrator || spo.isModerator || Player.isStaffMember(spo.name);
                      Bl.data.canUseAllItems = Bl.data.isAdmin || Bl.data.isStaffMember;

                      if(Bl.StaffObject == null)
                      {
                         Bl.StaffObject = new DatabaseObject("Config", "staff", "", 0, false, null);
                      }
                      if(Bl.data.isStaffMember)
                      {
                         Bl.StaffObject[spo.name.toLowerCase()] = spo.isAdministrator ? "Admin" : "Mod";
                      }
                      Global.log("loadAndInitPlayer: user " + spo.name + " loaded, isAdmin=" + Bl.data.isAdmin);
                      try { Shop.reset(null); } catch(eShop:Error) {}
                   }
                }
                catch(err:Error)
                {
                   Global.log("loadAndInitPlayer error: " + err.message);
                }
                KeyBinding.load();
                if(callback != null)
                {
                   callback();
                }
             });

             loader.addEventListener(IOErrorEvent.IO_ERROR, handleFail);
             loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleFail);

             try
             {
                loader.load(req);
             }
             catch(loadErr:Error)
             {
                Global.log("loadAndInitPlayer load catch error: " + loadErr.message);
                handleFail(null);
             }
             return;
         }
         c.bigDB.load("Config","staff",function(param1:DatabaseObject):void
         {
            Bl.StaffObject = param1;
         });
         c.bigDB.load("Config","patrons",function(param1:DatabaseObject):void
         {
            Bl.PatronsObject = param1;
         });
         Global.player_is_guest = c.connectUserId == "simpleguest";
         c.payVault.refresh(function():void
         {
            updatePlayerProperties(function():void
            {
               acceptTermsAndConditions(Global.playerObject,c,function():void
               {
                  checkChangeUsername(Global.playerObject,c,function():void
                  {
                     migrateUsername(Global.playerObject,c,callback);
                  });
               });
               if(!Global.player_is_guest)
               {
                  setTimezone();
               }
               try
               {
                  initializeAd();
               }
               catch(error:Error)
               {
               }
            });
         });
      }
      
      public function canUseBlock(param1:ItemBrick) : Boolean
      {
         if(Bl.data.isAdmin || Bl.data.isStaffMember)
         {
            return true;
         }
         if(param1.id == 1000 && Boolean(Global.playerObject && Global.playerObject.isStaff))
         {
            return true;
         }
         if(param1.payvaultid == "" || this.client.payVault.has(param1.payvaultid) || (param1.payvaultid.indexOf("brickeffect") == 0 && this.client.payVault.has("brickeffect")) || param1.payvaultid == "pro" && Global.player_is_beta_member || param1.payvaultid == "goldmember" && Boolean(Global.playerObject && Global.playerObject.goldmember))
         {
            if((param1.id == 77 || param1.id == 83 || param1.id == 1520) && !Global.hasOwner)
            {
               return false;
            }
            if(!param1.requiresAdmin && (Boolean(!param1.requiresOwnership) || Boolean(Bl.data.owner)))
            {
               return true;
            }
         }
         return false;
      }
      
      private function setTimezone() : void
      {
         this.requestRemoteMethod("timezone",null,new Date().timezoneOffset);
      }
      
      private function showLobby(param1:LoadState = null, param2:String = "") : void
      {
         var tasks:AsyncTasks = null;
         var self:EverybodyEdits = null;
         var rooms1:Array = null;
         var rooms2:Array = null;
         var welcomeBack:WelcomeBack = null;
         var firstDailyLogin:Boolean = false;
         var lstate:LoadState = param1;
         var tab:String = param2;
         Global.log("showLobby() called, initializing async tasks...");
         Global.setPath("Everybody Edits","/");
         Global.getPlacer = false;
         this.cleanUIAndConnections();
         state = lstate = lstate || new LoadState();
         if(this.upgrade)
         {
            return;
         }
         tasks = new AsyncTasks(4,function():void
         {
            Global.log("All lobby async tasks loaded successfully!");
            lstate.fadeOut(function():void
            {
               Global.log("Transitioning to LobbyState...");
               try
               {
                  Global.log("Creating LobbyState instance...");
                  state = new LobbyState(rooms1.concat(rooms2),joinRoom,createRoom,joinMyRoom,iseecom,self,handleJoinSaved,welcomeBack,firstDailyLogin,tab);
                  Global.log("LobbyState created successfully!");
               }
                catch(eLobby:Error)
                {
                   Global.log("ERROR instantiating LobbyState: " + (eLobby ? eLobby.message : "unknown"));
                }
             });
         });
         self = this;
         rooms1 = [];
         rooms2 = [];
         Badges.refresh(function():void
         {
            Global.log("Lobby Task: Badges refreshed");
            tasks.next();
         });
         this.updatePlayerProperties(function():void
         {
            Global.log("Lobby Task: Player properties updated");
            tasks.next();
         });
         this.client.bigDB.load("Config","patrons",function(param1:DatabaseObject):void
         {
            Bl.PatronsObject = param1;
            Global.log("Lobby Task: BigDBConfig loaded");
            tasks.next();
         },function(param1:Error):void
         {
            Global.log("Lobby Task: BigDBConfig failed, skipping");
            tasks.next();
         });
          try
          {
             Shop.reset(function():void
             {
                Global.log("Lobby Task: Shop reset completed");
                tasks.next();
             });
          }
          catch(eShop:Error)
          {
             Global.log("Lobby Task: Shop reset error: " + (eShop ? eShop.message : "unknown"));
             tasks.next();
          }
         welcomeBack = null;
         firstDailyLogin = false;
      }
      
      private function getBetaRooms(param1:Function) : void
      {
         if(Global.player_is_beta_member)
         {
            this.client.multiplayer.listRooms(Config.server_type_betaroom,{},0,0,param1);
         }
         else
         {
            param1([]);
         }
      }
      
      private function joinRoom(param1:String, param2:Boolean = false, param3:Object = null) : void
      {
         var rid:String = param1;
         var direct:Boolean = param2;
         var joindata:Object = param3;
         Global.log("joinRoom() called: rid='" + rid + "' direct=" + direct);
         try
         {
            this.cleanUIAndConnections();
         }
         catch(eClean:Error)
         {
            Global.log("joinRoom ERROR in cleanUIAndConnections: " + eClean.message);
         }
         try
         {
            state = new JoinState();
         }
         catch(eJoinState:Error)
         {
            Global.log("joinRoom ERROR in JoinState: " + eJoinState.message);
         }
         var isTrials:Boolean = false;
         if(joindata != null)
         {
            try
            {
               if(joindata.hasOwnProperty("trialsmode") && String(joindata.trialsmode) == "true")
               {
                  isTrials = true;
               }
            }
            catch(eTr:Error) {}
         }
         try
         {
            this.joinSaved(rid,joindata,isTrials);
         }
         catch(eJoinSaved:Error)
         {
            Global.log("joinRoom ERROR in joinSaved: " + eJoinSaved.message);
         }
      }
      
      private function joinSaved(param1:String, param2:Object = null, param3:Boolean = false) : void
      {
         var roomid:String = param1;
         var joindata:Object = param2;
         var trialsMode:Boolean = param3;
         Global.log("joinSaved() called: roomid='" + roomid + "'");
         try
         {
            this.cleanUIAndConnections();
         }
         catch(eClean2:Error)
         {
            Global.log("joinSaved ERROR in cleanUIAndConnections: " + eClean2.message);
         }
         roomid = roomid.split(" ").join("-");
         var cleanJoinData:Object = {};
         if(joindata != null)
         {
            try
            {
               if(joindata.hasOwnProperty("editkey") && joindata.editkey != null) cleanJoinData["editkey"] = String(joindata.editkey);
               if(joindata.hasOwnProperty("trialsmode") && joindata.trialsmode != null) cleanJoinData["trialsmode"] = String(joindata.trialsmode);
            }
            catch(eData:Error) {}
         }
         Global.log("joinSaved: calling createJoinRoom for roomid='" + roomid + "'...");
         try
         {
            this.client.multiplayer.createJoinRoom(roomid,roomid.substring(0,2) == "BW" ? Config.server_type_betaroom : Config.server_type_normalroom,true,{"owned":"true"},cleanJoinData,function(param1:Connection):void
            {
               Global.log("joinSaved: createJoinRoom success callback for roomid='" + roomid + "'");
               try
               {
                  handleJoin(param1,roomid,false,true,trialsMode);
               }
               catch(eHJoin:Error)
               {
                  Global.log("joinSaved ERROR in handleJoin: " + eHJoin.message);
               }
            },function(eErr:*):void {
               Global.log("joinSaved createJoinRoom ERROR: " + (eErr != null ? (eErr.message || eErr.toString()) : "unknown error"));
               handleReturnToLobbyError(eErr as PlayerIOError);
            });
         }
         catch(eCreateJoin:Error)
         {
            Global.log("joinSaved ERROR calling createJoinRoom: " + eCreateJoin.message);
         }
      }
      
      private function handleJoinSaved(param1:int, param2:int) : void
      {
         var type:int = param1;
         var offset:int = param2;
         state = new JoinState();
         this.getRPCConnection(function(param1:Connection):void
         {
            var con:Connection = param1;
            con.addMessageHandler("r",function(param1:Message, param2:String):void
            {
               joinSaved(param2);
               con.removeMessageHandler("r",arguments.callee);
            });
            con.send("getSavedLevel",type,offset);
         },this.handleReturnToLobbyError);
      }
      
      private function joinMyRoom(param1:Boolean = false) : void
      {
         var isbetaroom:Boolean = param1;
         if(!Global.player_is_beta_member)
         {
            return;
         }
         state = new JoinState();
         this.getRPCConnection(function(param1:Connection):void
         {
            var con:Connection = param1;
            con.addMessageHandler("r",function(param1:Message, param2:String):void
            {
               joinSaved(param2);
               con.removeMessageHandler("r",arguments.callee);
            });
            con.send(isbetaroom ? "getBetaRoom" : "getRoom");
         },this.handleReturnToLobbyError);
      }
      
      private function showUpgradeScreen(param1:Message) : void
      {
         var upg:Upgrade;
         var m:Message = param1;
         this.showDisconnectedMessage = false;
         if(this.upgrade)
         {
            return;
         }
         upg = new Upgrade();
         upg.blog.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            openNewPage(Config.url_blog);
         });
         upg.reload.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            openPage(Config.site);
         });
         upg.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopPropagation();
            param1.stopImmediatePropagation();
         });
         overlayContainer.addChild(upg);
         this.upgrade = true;
      }
      
      private function handleJoin(param1:Connection, param2:String, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         var self:EverybodyEdits = null;
         var connection:Connection = param1;
         var roomid:String = param2;
         var direct:Boolean = param3;
         var isLockedRoom:Boolean = param4;
         var trialsMode:Boolean = param5;
         Global.log("handleJoin() called for room: " + roomid);
         try
         {
         Global.roomid = roomid;
         if(Boolean(Bl.data.isbeta) || Boolean(Bl.data.onsite) || Bl.stage.stageWidth > 700)
         {
            Global.log("handleJoin: creating SideChat...");
            this.sidechat = new SideChat(connection);
            this.sidechat.x = 640 - 1;
            Global.log("handleJoin: SideChat created OK");
         }
         self = this;
         this.connection = connection;
         if(true)
         {
            // Flush any queued getRPCConnection callbacks with the game connection
            while(rpcConnectQueue.length > 0)
            {
               rpcConnectQueue.shift()(connection);
            }
         }
         connection.addMessageHandler("upgrade",this.showUpgradeScreen);
         connection.addMessageHandler("info",function(param1:Message, param2:String, param3:String, param4:Boolean = false, param5:String = null, param6:String = null):void
         {
            loadInfo(param2,param3,-1,param4,param5,param6);
         });
         connection.addMessageHandler("info2",function(param1:Message, param2:String, param3:String, param4:String = null):void
         {
            showInfo2(param2,param3,param4);
         });
         connection.addMessageHandler("image",function(param1:Message, param2:String):void
         {
            loadImage(param2);
         });
         connection.addMessageHandler("notice",function(param1:Message, param2:String, param3:String):void
         {
            sidechat.addLine("* " + param2,param3,16777215);
         });
         connection.addMessageHandler("copyPrompt",function(param1:Message, param2:String, param3:String, param4:String = ""):void
         {
            showOnTop(new CopyPrompt(param2,param3,param4));
         });
         connection.addMessageHandler("confirm",function(param1:Message, param2:String, param3:String):void
         {
            var conf:ConfirmPrompt = null;
            var m:Message = param1;
            var type:String = param2;
            var message:String = param3;
            conf = new ConfirmPrompt(message,true,type,true,false);
            conf.x = 512;
            conf.btn_yes.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               conf.close();
               connection.send("confirm",type);
            });
            conf.btn_no.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               ShowLobby();
            });
            showOnTop(conf);
         });
         connection.addMessageHandler("init",function(param1:Message, param2:String, param3:String, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:Boolean, param12:int, param13:int, param14:uint, param15:String, param16:Boolean, param17:Boolean, param18:Boolean, param19:Boolean, param20:int, param21:int, param22:Number, param23:uint, param24:Boolean, param25:Boolean, param26:Boolean, param27:String, param28:int, param29:int, param30:Boolean, param31:String, param32:String, param33:Boolean, param34:int, param35:String, param36:Boolean, param37:Boolean, param38:Boolean, param39:ByteArray, param40:Boolean, param41:String, param42:Boolean):void
         {
            Global.log("Init handler CALLED! msgLen=" + param1.length + " w=" + param20 + " h=" + param21);
            try
            {
               Global.log("Init: setting up globals...");
               if(sidechat)
               {
                  sidechat.setMe(param7.toString(),param15,Global.canchat,0,Global.playerObject != null ? Global.playerObject.goldmember : true,param14);
                  sidechat.setMetaData(param2,param3,param4,param5,param6);
               }
               Bl.data.showPlayer = true;
               Bl.data.isAdmin = Boolean(Global.playerObject && Global.playerObject.isAdministrator);
               Bl.data.isModerator = Boolean(Global.playerObject && Global.playerObject.isModerator);
               Bl.data.isStaffMember = Player.isStaffMember(param15) || Boolean(Global.playerObject && Global.playerObject.isStaff) || Bl.data.isAdmin || Bl.data.isModerator;
               Bl.data.canUseAllItems = Bl.data.isAdmin || Bl.data.isStaffMember;
               Bl.data.isLockedRoom = isLockedRoom || !param16 || param17 || Bl.data.createdOpenWorldWithKey;
               Bl.data.createdOpenWorldWithKey = false;
               Bl.data.isOpenWorld = !isLockedRoom;
               Bl.data.isCampaignRoom = param30;
               Bl.data.owner = param17;
               Bl.data.inFavorites = param18;
               Bl.data.liked = param19;
               Bl.data.canChangeWorldOptions = param33;
               Global.hasOwner = param2 != "";
               Global.currentLevelname = param3;
               Global.worldOwner = param2;
               Global.ownerID = param41;
               Global.currentLevelCrew = param31;
               Global.currentLevelCrewName = param32;
               Global.currentLevelStatus = param34;
               Global.currentLevelVisibility = param24 ? (param40 ? 1 : 2) : 0;
               if(Bl.data.canChangeWorldOptions)
               {
                  Global.bgColor = param23;
                  Global.backgroundEnabled = (param23 >> 24 & 0xFF) == 255;
               }
               Global.hasSubscribedToCrew = true;
               Global.log("Init: creating PlayState w=" + param20 + " h=" + param21);
               state = new PlayState(connection,param1,param7,param15,param8,param9,param10,param11,param12,param13,param14,param35,param20,param21,param22,param23,param36,param39);
               Global.log("Init: PlayState created OK, creating UI2...");
               Bl.data.canEdit = Global.playerInstance.canEdit = param16;
               Bl.data.canToggleGodMode = Global.playerInstance.canToggleGodMode = param42;
               ui2instance = new UI2(self,connection,param1,param7,param16,roomid,sidechat,param24,param25,param26,param27,param28,param29,param37,param38,trialsMode);
               Global.log("Init: UI2 created OK, adding to overlay...");
               ui2instance.y = 500;
               overlayContainer.addChild(ui2instance);
               if(sidechat)
               {
                  overlayContainer.addChild(sidechat);
               }
               Global.log("Init: ALL DONE - PlayState should be visible now!");
            }
            catch(eInit:Error)
            {
               Global.log("ERROR inside init handler: " + eInit.message);
               Global.log(eInit.getStackTrace());
            }
         });
         connection.addDisconnectHandler(function():void
         {
            if(showDisconnectedMessage)
            {
               showInfo("Disconnected","Lost connection with Everybody Edits :(");
            }
            showLobby();
            if(Boolean(ui2instance) && Boolean(ui2instance.parent))
            {
               overlayContainer.removeChild(ui2instance);
            }
            if(Boolean(sidechat) && Boolean(sidechat.parent))
            {
               overlayContainer.removeChild(sidechat);
            }
         });
         Global.log("handleJoin: sending init request to server...");
         connection.send("init");
         Global.log("handleJoin: completed successfully!");
         }
         catch(eJoin:Error)
         {
            Global.log("ERROR in handleJoin before init handler: " + eJoin.message);
            Global.log(eJoin.getStackTrace());
         }
      }
      
      private function handleSubscribeCheck(param1:Message) : void
      {
         Global.hasSubscribedToCrew = param1.getBoolean(0);
      }
      
      public function showOnTop(param1:Sprite) : void
      {
         overlayContainer.addChild(param1);
         TweenMax.to(param1,0,{"alpha":0});
         TweenMax.to(param1,0.2,{"alpha":1});
      }
      
      public function showCampaignComplete(param1:CampaignComplete) : void
      {
         if(overlayContainer.getChildByName("CampaignCompleteScreen"))
         {
            return;
         }
         this.cc = param1;
         this.showOnTop(this.cc);
      }
      
      public function hideCampaignComplete() : void
      {
         if(!this.cc)
         {
            return;
         }
         TweenMax.to(this.cc,0.5,{
            "alpha":0,
            "onComplete":function():void
            {
               if(cc.parent)
               {
                  overlayContainer.removeChild(cc);
               }
               cc = null;
            }
         });
         stage.focus = stage;
      }
      
      public function showCampaignTrialDone(param1:CampaignTrialDone) : void
      {
         if(overlayContainer.getChildByName("CampaignTrialDoneScreen"))
         {
            return;
         }
         this.ctd = param1;
         this.showOnTop(param1);
      }
      
      public function hideCampaignTrialDone() : void
      {
         if(!this.ctd)
         {
            return;
         }
         TweenMax.to(this.ctd,0.5,{
            "alpha":0,
            "onComplete":function():void
            {
               if(ctd.parent)
               {
                  overlayContainer.removeChild(ctd);
               }
               ctd = null;
            }
         });
         stage.focus = stage;
      }
      
      public function toggleUI() : void
      {
         Global.showUI = !Global.showUI;
         Global.base.ui2instance.toggleVisible(Global.showUI);
         Global.base.sidechat.toggleVisible(Global.showUI);
      }
      
      public function showInfo2(param1:String, param2:String, param3:String = null) : void
      {
         var pullDownY:Number;
         var mouseDown:Boolean = false;
         var title:String = param1;
         var body:String = param2;
         var sound:String = param3;
         if(this.infoBox != null)
         {
            if(overlayContainer.contains(this.infoBox))
            {
               if(this.infoBox.timer.running)
               {
                  this.infoBox.timer.stop();
               }
               overlayContainer.removeChild(this.infoBox);
            }
         }
         mouseDown = false;
         this.infoBox = new InfoDisplay(title,body);
         this.infoBox.alpha = 0;
         this.infoBox.x = (640 - this.infoBox.width) / 2;
         this.infoBox.y = -this.infoBox.height - 10;
         overlayContainer.addChild(this.infoBox);
         pullDownY = this.infoBox.y + 10;
         TweenMax.to(this.infoBox,0.4,{
            "alpha":1,
            "y":10,
            "ease":Back.easeOut
         });
         TweenPlugin.activate([GlowFilterPlugin]);
         TweenMax.to(this.infoBox,1,{
            "repeat":3,
            "yoyo":true,
            "glowFilter":{
               "color":11184810,
               "blurX":7,
               "blurY":7,
               "strength":1,
               "alpha":1
            }
         });
         this.infoBox.buttonMode = true;
         this.infoBox.useHandCursor = true;
         this.infoBox.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            if(infoBox.timer.running)
            {
               infoBox.timer.stop();
            }
            mouseDown = true;
            TweenMax.to(infoBox,0.4,{"y":infoBox.y + 10});
         });
         this.infoBox.addEventListener(MouseEvent.MOUSE_UP,function(param1:MouseEvent):void
         {
            mouseDown = false;
            hideInfoDisplay();
         });
         this.infoBox.addEventListener(MouseEvent.MOUSE_OUT,function(param1:MouseEvent):void
         {
            if(mouseDown)
            {
               if(!infoBox.timer.running)
               {
                  infoBox.timer.start();
               }
               mouseDown = false;
               TweenMax.to(infoBox,0.4,{"y":infoBox.y - 10});
            }
         });
         if(sound)
         {
            SoundManager.playAnySound(sound);
         }
      }
      
      public function hideInfoDisplay() : void
      {
         TweenMax.to(this.infoBox,0.2,{
            "y":-this.infoBox.height - 10,
            "alpha":0,
            "onComplete":function():void
            {
               if(overlayContainer.contains(infoBox))
               {
                  overlayContainer.removeChild(infoBox);
               }
            },
            "ease":Back.easeIn
         });
      }
      
      public function showInvisibleMask() : void
      {
         if(Capabilities.playerType == "PlugIn")
         {
            overlayContainer.addChild(this.fullscreenBlack);
         }
      }
      
      public function hideInvisibleMask() : void
      {
         if(Capabilities.playerType == "PlugIn")
         {
            overlayContainer.removeChild(this.fullscreenBlack);
         }
      }
      
      public function loadImage(param1:String) : void
      {
         var loader:Loader = null;
         var image:String = param1;
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            showImage(Bitmap(loader.content));
         });
         loader.load(new URLRequest(Config.site + "/Images/" + image));
      }
      
      public function showImage(param1:Bitmap) : void
      {
         var bg:BlackBG = null;
         var closeImage:Function = null;
         var img:Bitmap = param1;
         closeImage = function():void
         {
            TweenMax.to(img,0.2,{
               "alpha":0,
               "onComplete":function():void
               {
                  TweenMax.to(bg,0.25,{
                     "alpha":0,
                     "onComplete":function():void
                     {
                        overlayContainer.removeChild(bg);
                        overlayContainer.removeChild(img);
                     }
                  });
               }
            });
         };
         bg = new BlackBG();
         img.x = Config.width / 2 - img.width / 2;
         img.y = Config.height / 2 - img.height / 2;
         overlayContainer.addChild(bg);
         overlayContainer.addChild(img);
         TweenMax.to(img,0,{"alpha":0});
         TweenMax.to(bg,0,{"alpha":0});
         TweenMax.to(img,0.2,{"alpha":1});
         TweenMax.to(bg,0.3,{"alpha":1});
         bg.addEventListener(MouseEvent.CLICK,closeImage);
         img.addEventListener(MouseEvent.CLICK,closeImage);
      }
      
      public function loadInfo(param1:String, param2:String, param3:Number = -1, param4:Boolean = false, param5:String = null, param6:String = null) : void
      {
         var loader:Loader = null;
         var title:String = param1;
         var body:String = param2;
         var prefferedWidth:Number = param3;
         var modal:Boolean = param4;
         var image:String = param5;
         var sound:String = param6;
         if(!image)
         {
            this.showInfo(title,body,prefferedWidth,modal,null,sound);
            return;
         }
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            showInfo(title,body,prefferedWidth,modal,Bitmap(loader.content),sound);
         });
         loader.load(new URLRequest(Config.site + "/Images/" + image));
      }
      
      public function showInfo(param1:String, param2:String, param3:Number = -1, param4:Boolean = false, param5:Bitmap = null, param6:String = null) : void
      {
         var newwidth:int;
         var offset_x:Number;
         var bg:BlackBG = null;
         var inf:InfoBox = null;
         var title:String = param1;
         var body:String = param2;
         var prefferedWidth:Number = param3;
         var modal:Boolean = param4;
         var image:Bitmap = param5;
         var sound:String = param6;
         this.showDisconnectedMessage = false;
         bg = new BlackBG();
         inf = new InfoBox();
         inf.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         bg.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         inf.ttitle.autoSize = TextFieldAutoSize.LEFT;
         inf.ttitle.text = Badwords.Filter(title);
         inf.tbody.autoSize = TextFieldAutoSize.LEFT;
         inf.tbody.text = Badwords.Filter(body);
         if(prefferedWidth != -1)
         {
            inf.tbody.width = prefferedWidth;
         }
         newwidth = Math.max(inf.ttitle.width,inf.tbody.width,image ? image.width : 0) + 30;
         offset_x = (newwidth - inf.bg.width) / 2;
         inf.bg.x -= offset_x;
         inf.ttitle.x -= offset_x;
         inf.ttitle.y -= 5;
         inf.tbody.x -= offset_x;
         if(image)
         {
            image.x = inf.bg.x + newwidth / 2 - image.width / 2;
            image.y = inf.tbody.y + inf.tbody.height + 5;
            inf.addChild(image);
         }
         inf.bg.width = newwidth;
         inf.bg.height = inf.tbody.y - inf.bg.y + inf.tbody.height + (image ? image.height + 20 : 40);
         inf.closebtn.x = inf.bg.x + inf.bg.width;
         inf.closebtn.addEventListener(MouseEvent.CLICK,function():void
         {
            TweenMax.to(inf,0.2,{
               "alpha":0,
               "onComplete":function():void
               {
                  TweenMax.to(bg,0.25,{
                     "alpha":0,
                     "onComplete":function():void
                     {
                        overlayContainer.removeChild(bg);
                        overlayContainer.removeChild(inf);
                     }
                  });
               }
            });
            showDisconnectedMessage = true;
         });
         if(modal)
         {
            inf.closebtn.visible = false;
         }
         overlayContainer.addChild(bg);
         overlayContainer.addChild(inf);
         TweenMax.to(inf,0,{"alpha":0});
         TweenMax.to(bg,0,{"alpha":0});
         TweenMax.to(inf,0.2,{"alpha":1});
         TweenMax.to(bg,0.3,{"alpha":1});
         if(sound)
         {
            SoundManager.playAnySound(sound);
         }
      }
      
      public function showLoadingScreen(param1:String) : void
      {
         if(this.loading != null)
         {
            overlayContainer.removeChild(this.loading);
         }
         var _loc2_:Boolean = this.loading == null;
         this.loading = new LoadingScreen(param1);
         this.loading.alpha = 0;
         overlayContainer.addChild(this.loading);
         if(_loc2_)
         {
            TweenMax.to(this.loading,0.4,{"alpha":1});
         }
         else
         {
            this.loading.alpha = 1;
         }
      }
      
      public function hideLoadingScreen() : void
      {
         if(this.loading != null)
         {
            this.loading.close();
         }
      }
      
      private function createRoom(param1:String, param2:String = "") : void
      {
         var roomid:String = null;
         var rid:String = param1;
         var editkey:String = param2;
         Bl.data.roomname = rid;
         state = new JoinState();
         roomid = "OW" + this.generateUniqueRoomId(rid);
         this.client.multiplayer.createJoinRoom(roomid,Config.server_type_normalroom,true,editkey == "" ? {"name":rid} : {
            "editkey":editkey,
            "name":rid
         },editkey == "" ? {} : {"editkey":editkey},function(param1:Connection):void
         {
            handleJoin(param1,roomid,false,false);
         },this.handleReturnToLobbyError);
      }
      
      private function generateUniqueRoomId(param1:String) : String
      {
         return (new Date().getTime().toString(36) + (Math.random() * 1000 >> 0).toString(36)).toUpperCase();
      }
      
      private function handleError(param1:Object) : void
      {
         var _loc2_:String = param1.hasOwnProperty("message") ? param1.message : (param1.hasOwnProperty("text") ? param1.text : param1.toString());
         "We saved the error to our servers and are working on fixing it already!\n\n\nHorrible Error:\n" + _loc2_;
      }
   }
}


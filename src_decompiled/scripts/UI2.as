package
{
   import blitter.Bl;
   import com.greensock.*;
   import com.greensock.easing.*;
   import data.SimplePlayerObjectEvent;
   import flash.display.BitmapData;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.System;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import items.ItemAuraColor;
   import items.ItemAuraShape;
   import items.ItemBrick;
   import items.ItemBrickPackage;
   import items.ItemId;
   import items.ItemManager;
   import items.ItemSmiley;
   import items.ItemTab;
   import mx.utils.StringUtil;
   import playerio.Connection;
   import playerio.Message;
   import sample.ui.components.Label;
   import states.PlayState;
   import ui.BrickContainer;
   import ui.ConfirmPrompt;
   import ui.LevelComplete;
   import ui.button.Button;
   import ui.button.ButtonColorType;
   import ui.Prompts.ConfirmRulesPrompt;
   import ui.ReportPrompt;
   import ui.Share;
   import ui.brickoverlays.*;
   import ui.brickselector.BrickPackage;
   import ui.brickselector.BrickSelector;
   import ui.campaigns.CampaignComplete;
   import ui.campaigns.CampaignInfo;
   import ui.campaigns.CampaignReward;
   import ui.campaigns.CampaignTrialDone;
   import ui.campaigns.ClockTime;
   import ui.campaigns.TimesInfo;
   import ui.chat.SideChat;
   import ui.chat.TabTextField;
   import ui.crews.CrewPrompt;
   import ui.ingame.EffectDisplay;
   import ui.ingame.FavLikeButton;
   import ui.ingame.FavLikeSelector;
   import ui.ingame.pam.PlayerActionsMenu;
   import ui.ingame.sam.*;
   import ui.ingame.settings.SettingsButton;
   import ui.ingame.settings.SettingsMenu;
   import ui2.ui2chatbtn;
   import ui2.ui2chatinput;
   import ui2.ui2downloadbtn;
   import ui2.ui2entereditkeybox;
   import ui2.ui2godmodebtn;
   import ui2.ui2lobbybtn;
   import ui2.ui2sharebtn;
   import ui2.ui2toggleminimapbtn;
   
   public class UI2 extends Sprite
   {
      
      private var sidechat:SideChat;
      
      private var timeLabel:Label;
      
      private var lobby:ui2lobbybtn;
      
      private var godmode:ui2godmodebtn;
      
      private var toggleminimap:ui2toggleminimapbtn;
      
      private var share:ui2sharebtn;
      
      private var enterkey:ui2entereditkeybox;
      
      private var campaignInfo:CampaignInfo;
      
      private var timesInfo:TimesInfo;
      
      private var bmd:BitmapData;
      
      private var bmd2:BitmapData;
      
      private var smiliesbmd:BitmapData;
      
      private var chatbtn:ui2chatbtn;
      
      private var chatinput:ui2chatinput;
      
      private var download:ui2downloadbtn;
      
      public var questsBtn:Button;
      
      public var favoriteBricks:BrickContainer;
      
      public var bselector:BrickSelector;
      
      public var base:EverybodyEdits;
      
      private var downloadconfirm:ConfirmPrompt;
      
      private var brickPackagePopup:BrickPackage;
      
      private var roomid:String;
      
      public var settingsMenu:SettingsMenu;
      
      public var above:Sprite;
      
      public var connection:Connection;
      
      public var roomVisible:Boolean = false;
      
      public var roomHiddenFromLobby:Boolean = false;
      
      public var lobbyPreviewEnabled:Boolean = true;
      
      public var allowSpectating:Boolean = false;
      
      public var curseLimit:int = 0;
      
      public var zombieLimit:int = 0;
      
      public var description:String = "";
      
      public var smileyMenu:SmileyMenu;
      
      public var smileyButton:SmileyButton;
      
      public var auraMenu:AuraMenu;
      
      public var auraButton:AuraButton;
      
      private var favLikeSelector:FavLikeSelector;
      
      private var favLikeButton:FavLikeButton;
      
      private var effectDisplay:EffectDisplay;
      
      private var specialproperties:PropertiesBackground;
      
      public var hasPropertyOpen:Boolean = false;
      
      private var reqS:Boolean = false;
      
      private var latestPM:String = "";
      
      public var editKey:String = "";
      
      public var commandHelp:Object;
      
      public var crewPrompt:CrewPrompt;
      
      private var playerActions:PlayerActionsMenu;
      
      public var worldMapEnabled:Boolean = true;
      
      public var playerMapEnabled:Boolean = false;
      
      public var trialsAvailable:Boolean = false;
      
      public var validRun:Boolean = true;
      
      public var trialsMode:Boolean;
      
      public var goodTicks:int;
      
      private var lastSmileyKeyTime:int = -2147483648;
      
      private var lastIncrementTime:int = -2147483648;
      
      private var lastIncrementDir:int = 0;
      
      private var usedXLeft:int = 0;
      
      private var usedXRight:int = 0;
      
      private var timerArray:Array;
      
      private var textArray:Array;
      
      private var lastMessageTime:Number;
      
      private var chatHistory:int = 10;
      
      private var _keyDown:Object;
      
      public function UI2(param1:EverybodyEdits, param2:Connection, param3:Message, param4:int, param5:Boolean, param6:String, param7:SideChat, param8:Boolean, param9:Boolean, param10:Boolean, param11:String, param12:int, param13:int, param14:Boolean, param15:Boolean, param16:Boolean)
      {
         var blocks:Vector.<ItemBrick>;
         var ui2BG:SettingsButton;
         var def:Vector.<ItemBrick>;
         var moveInputCursorToEnd:Function = null;
         var that:UI2 = null;
         var base:EverybodyEdits = param1;
         var connection:Connection = param2;
         var m:Message = param3;
         var myid:int = param4;
         var canEdit:Boolean = param5;
         var roomid:String = param6;
         var sidechat:SideChat = param7;
         var roomOpen:Boolean = param8;
         var roomHideLobby:Boolean = param9;
         var allowSpect:Boolean = param10;
         var description:String = param11;
         var curseLim:int = param12;
         var zombieLim:int = param13;
         var mapEnabled:Boolean = param14;
         var lobbyPreviewEnabled:Boolean = param15;
         var trialsEnabled:Boolean = param16;
         this.lobby = new ui2lobbybtn();
         this.godmode = new ui2godmodebtn();
         this.toggleminimap = new ui2toggleminimapbtn();
         this.share = new ui2sharebtn();
         this.enterkey = new ui2entereditkeybox();
         this.campaignInfo = new CampaignInfo();
         this.timesInfo = new TimesInfo();
         this.chatbtn = new ui2chatbtn();
         this.chatinput = new ui2chatinput();
         this.download = new ui2downloadbtn();
         this.above = new Sprite();
         this.favLikeButton = new FavLikeButton();
         this.commandHelp = {
            "/bgcolor":true,
            "/clear":true,
            "/clearchat":true,
            "/cleareffects":true,
            "/endtrial":true,
            "/forcefly":true,
            "/forgive":true,
            "/fps":true,
            "/gedit":true,
            "/geffect":true,
            "/getpos":true,
            "/givecrown":true,
            "/giveedit":true,
            "/giveeffect":true,
            "/givegod":true,
            "/help":true,
            "/hide":true,
            "/hidelobby":true,
            "/info":true,
            "/inspect":true,
            "/kick":true,
            "/kill":true,
            "/killall":true,
            "/listportals":true,
            "/loadlevel":true,
            "/mute":true,
            "/name":true,
            "/pm":true,
            "/redit":true,
            "/reffect":true,
            "/removecrown":true,
            "/removeedit":true,
            "/removeeffect":true,
            "/removegod":true,
            "/report":true,
            "/reset":true,
            "/resetall":true,
            "/resetswitches":true,
            "/respawn":true,
            "/respawnall":true,
            "/roomid":true,
            "/save":true,
            "/setteam":true,
            "/show":true,
            "/spectate":true,
            "/starttrial":true,
            "/teleport":true,
            "/unmute":true,
            "/visible":true
         };
         this.timerArray = [5000,5000,5000,5000,5000];
         this.textArray = ["","","","","","","","","",""];
         this.lastMessageTime = new Date().time;
         this._keyDown = {};
         super();
         moveInputCursorToEnd = function(param1:Event):void
         {
            var _loc2_:int = int(chatinput.text.field.length);
            chatinput.text.field.setSelection(_loc2_,_loc2_);
            stage.removeEventListener(Event.RENDER,moveInputCursorToEnd);
         };
         Global.chatIsVisible = false;
         this.sidechat = sidechat;
         this.trialsMode = trialsEnabled;
         Bl.data.moreisvisible = false;
         this.roomVisible = roomOpen;
         this.roomHiddenFromLobby = roomHideLobby;
         this.allowSpectating = allowSpect;
         this.worldMapEnabled = mapEnabled;
         this.lobbyPreviewEnabled = lobbyPreviewEnabled;
         this.description = description;
         this.curseLimit = curseLim;
         this.zombieLimit = zombieLim;
         blocks = new Vector.<ItemBrick>();
         blocks.push(ItemManager.bricks[0]);
         this.brickPackagePopup = new BrickPackage("empty",blocks,this,ItemTab.BLOCK,[],false,0,true);
         this.brickPackagePopup.x = 20;
         this.brickPackagePopup.y = -200;
         this.bselector = new BrickSelector(this);
         Bl.data.bselector = this.bselector;
         Bl.data.showingproperties = false;
         Bl.data.world_portal_id = roomid;
         Bl.data.world_portal_name = Bl.data.roomname;
         this.roomid = roomid;
         this.smiliesbmd = ItemManager.smileysBMD;
         this.base = base;
         this.connection = connection;
         Global.base.favorited = false;
         Global.base.liked = false;
         addChild(this.bselector);
         ui2BG = new SettingsButton("",null,null);
         ui2BG.setSize(641,29);
         ui2BG.y = -ui2BG.HEIGHT;
         addChild(ui2BG);
         addChild(this.brickPackagePopup);
         if(!Bl.data.owner && !Global.player_is_guest)
         {
            this.favLikeButton.buttonMode = true;
            this.favLikeButton.useHandCursor = true;
         }
         this.smileyMenu = new SmileyMenu(this);
         this.above.addChild(this.smileyMenu);
         this.auraMenu = new AuraMenu(this);
         this.above.addChild(this.auraMenu);
         this.smileyButton = new SmileyButton();
         this.auraButton = new AuraButton();
         this.favLikeSelector = new FavLikeSelector(0,0);
         this.favLikeSelector.visible = false;
         this.above.addChild(this.favLikeSelector);
         this.effectDisplay = new EffectDisplay(this.curseLimit,this.zombieLimit);
         this.effectDisplay.x = 2;
         this.effectDisplay.y = -498;
         addChild(this.effectDisplay);
         def = new Vector.<ItemBrick>();
         def.push(ItemManager.getBrickById(0),ItemManager.getBrickById(9),ItemManager.getBrickById(10),ItemManager.getBrickById(11),ItemManager.getBrickById(16),ItemManager.getBrickById(17),ItemManager.getBrickById(18),ItemManager.getBrickById(29),ItemManager.getBrickById(32),ItemManager.getBrickById(2),ItemManager.getBrickById(100));
         this.favoriteBricks = new BrickContainer(def,this);
         this.configureInterface();
         this.toggleMinimap(this.minimapEnabled && Boolean(Bl.data.showMap));
         this.auraMenu.x = this.auraButton.x - this.auraMenu.width / 2 + this.auraButton.width / 2 >> 0;
         this.bselector.x = 640 - this.bselector.width >> 1;
         this.bselector.visible = false;
         addChild(this.chatinput);
         this.chatinput.y = -59;
         this.chatinput.x = 65;
         this.chatinput.visible = false;
         this.chatinput.text = new TabTextField();
         if(Bl.data.isAdmin)
         {
            this.chatinput.text.field.maxChars = int.MAX_VALUE;
         }
         this.chatinput.addChild(this.chatinput.text);
         this.chatinput.text.x = 37;
         this.chatinput.text.y = 6;
         this.chatinput.text.width = 445;
         this.chatinput.quicksay0.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",0);
            hideAll();
         });
         this.chatinput.quicksay1.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",1);
            hideAll();
         });
         this.chatinput.quicksay2.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",2);
            hideAll();
         });
         this.chatinput.quicksay3.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",3);
            hideAll();
         });
         this.chatinput.quicksay4.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",4);
            hideAll();
         });
         this.chatinput.quicksay5.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",5);
            hideAll();
         });
         this.chatinput.quicksay6.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",6);
            hideAll();
         });
         this.chatinput.quicksay7.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",7);
            hideAll();
         });
         this.chatinput.quicksay8.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",8);
            hideAll();
         });
         this.chatinput.quicksay9.addEventListener(MouseEvent.CLICK,function():void
         {
            connection.send("autosay",9);
            hideAll();
         });
         if(sidechat != null)
         {
            this.chatinput.text.SetWordFunction(sidechat.getUsers);
            this.chatinput.text.AddCheckWords(this.commandHelp);
         }
         this.chatinput.text.field.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            if(param1.keyCode == Keyboard.ESCAPE)
            {
               hideAll();
            }
            else if(param1.keyCode == Keyboard.ENTER)
            {
               if(chatinput.text.field.text.length > 0)
               {
                  sendChat();
               }
               else
               {
                  hideAll();
               }
            }
            else if(param1.keyCode == Keyboard.UP)
            {
               --chatHistory;
               previousChatInput();
               stage.addEventListener(Event.RENDER,moveInputCursorToEnd,false,0,true);
               stage.invalidate();
            }
            else if(param1.keyCode == Keyboard.DOWN)
            {
               ++chatHistory;
               previousChatInput();
               stage.addEventListener(Event.RENDER,moveInputCursorToEnd,false,0,true);
               stage.invalidate();
            }
         });
         this.chatinput.text.field.addEventListener(KeyboardEvent.KEY_UP,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.chatinput.say.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            sendChat();
         });
         this.chatinput.text.field.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.setSmiliesData();
         this.smileyMenu.redraw();
         this.auraMenu.redraw();
         this.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            if(Boolean(stage) && !(param1.target is TextField))
            {
               stage.focus = Global.base;
            }
         });
         this.lobby.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            var confirmLobby:ConfirmPrompt = null;
            if(Boolean(Bl.data.owner) && (base.state as PlayState).unsavedChanges)
            {
               confirmLobby = new ConfirmPrompt("Are you sure you want to leave?\nYou have unsaved changes in the world!",true,"Leave");
               Global.base.showOnTop(confirmLobby);
               confirmLobby.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  base.ShowLobby();
                  confirmLobby.close();
               });
               confirmLobby.btn_no.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  confirmLobby.close();
               });
            }
            else
            {
               base.ShowLobby();
            }
         });
         this.godmode.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            connection.send("god",godmode.currentFrame == 1);
         });
         connection.addMessageHandler("toggleGod",function(param1:Message, param2:int, param3:Boolean):void
         {
            if(param2 == myid)
            {
               Bl.data.canToggleGodMode = param3;
               auraMenu.redraw();
               configureInterface();
            }
         });
         connection.addMessageHandler("god",function(param1:Message, param2:int, param3:Boolean):void
         {
            if(param2 == myid)
            {
               auraMenu.redraw();
               toggleGodMode(param3);
               if(!Bl.data.canToggleGodMode)
               {
                  configureInterface(param3);
               }
            }
         });
         connection.addMessageHandler("worldReleased",function(param1:Message):void
         {
            Bl.data.canChangeWorldOptions = Bl.data.owner;
            configureInterface();
         });
         connection.addMessageHandler("add",function(param1:Message, param2:int):void
         {
            effectDisplay.update();
         });
         connection.addMessageHandler("left",function(param1:Message, param2:int):void
         {
            if(param2 != myid)
            {
               effectDisplay.update();
            }
         });
         that = this;
         connection.addMessageHandler("givemagicsmiley",function(param1:Message, param2:String):void
         {
            var m:Message = param1;
            var payvaultid:String = param2;
            Global.client.payVault.refresh(function():void
            {
               var _loc1_:ItemSmiley = ItemManager.getSmileyByPayvaultId(payvaultid);
               smileyMenu.addSmiley(new SmileyInstance(_loc1_,that,Global.playerInstance.wearsGoldSmiley));
               smileyMenu.redraw();
               setSelectedSmiley(_loc1_.id);
            });
         });
         connection.addMessageHandler("givemagicbrickpackage",function(param1:Message, param2:String):void
         {
            var m:Message = param1;
            var packagename:String = param2;
            Global.client.payVault.refresh(function():void
            {
               updateSelectorBricks();
            });
         });
         connection.addMessageHandler("favorited",function(param1:Message):void
         {
            Bl.data.inFavorites = true;
            Global.base.favorited = true;
            setFavLikeStates();
            sidechat.addFavorite();
         });
         connection.addMessageHandler("liked",function(param1:Message):void
         {
            Bl.data.liked = true;
            Global.base.liked = true;
            setFavLikeStates();
            sidechat.addLike();
         });
         connection.addMessageHandler("unfavorited",function(param1:Message):void
         {
            Bl.data.inFavorites = false;
            setFavLikeStates();
            sidechat.addFavorite(-1);
         });
         connection.addMessageHandler("unliked",function(param1:Message):void
         {
            Bl.data.liked = false;
            setFavLikeStates();
            sidechat.addLike(-1);
         });
         this.chatbtn.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            toggleChat(chatbtn.currentFrame == 1);
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.toggleminimap.buttonMode = true;
         this.toggleminimap.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            toggleMinimap(toggleminimap.currentFrame == 1);
            if(stage)
            {
               stage.focus = Global.base;
            }
         });
         this.download.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            if(!downloadconfirm)
            {
               downloadconfirm = new ConfirmPrompt("Do you want to download this level?",false);
               downloadconfirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  downloadconfirm.close();
                  DownloadLevel.SaveLevel(param1);
               });
               downloadconfirm.onAnyClose = function():void
               {
                  downloadconfirm = null;
               };
               Global.base.showOnTop(downloadconfirm);
            }
         });
         connection.addMessageHandler("saving",function():void
         {
            Global.base.showLoadingScreen("Saving World");
         });
         connection.addMessageHandler("saved",function():void
         {
            setTimeout(function():void
            {
               settingsMenu.toggleVisible(false);
               Global.base.hideLoadingScreen();
               (base.state as PlayState).unsavedChanges = false;
            },500);
         });
         this.smileyButton.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            toggleSmileyMenu(!smileyMenu.visible);
         });
         this.auraButton.addEventListener(MouseEvent.CLICK,function():void
         {
            toggleAuraMenu(!auraMenu.visible);
         });
         if(!Bl.data.owner && !Global.player_is_guest)
         {
            this.favLikeButton.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               favLikeSelector.x = favLikeButton.x - favLikeSelector.basiswidth / 2 + favLikeButton.width / 2 >> 0;
               if(favLikeSelector.parent.localToGlobal(new Point(favLikeSelector.x,0)).x + favLikeSelector.width >= 640)
               {
                  favLikeSelector.x = 640 - favLikeSelector.width;
               }
               toggleFavLike(!favLikeSelector.visible);
            });
         }
         this.share.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            var copyText:String = null;
            var shr:Share = null;
            if(Boolean(_keyDown[16]) || Boolean(_keyDown[17]))
            {
               copyText = (_keyDown[16] ? "" : Config.site + "/games/") + roomid.split(" ").join("-");
               base.showInfo2("Share Level","Copied \'" + copyText + "\' to your clipboard!");
               System.setClipboard(copyText);
            }
            else
            {
               shr = new Share("Direct URL to this level!",Config.site + "/games/" + roomid.split(" ").join("-"));
               Bl.overlayContainer.addChild(shr);
               TweenMax.to(shr,0,{"alpha":0});
               TweenMax.to(shr,0.2,{"alpha":1});
               shr.closebtn.addEventListener(MouseEvent.CLICK,function():void
               {
                  TweenMax.to(shr,0.2,{
                     "alpha":0,
                     "onComplete":function():void
                     {
                        if(stage)
                        {
                           stage.focus = Global.base;
                        }
                        Bl.overlayContainer.removeChild(shr);
                     }
                  });
               });
            }
         });
         this.favoriteBricks.more.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            toggleMore(favoriteBricks.more.currentFrame == 1);
         });
         this.enterkey.key.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            param1.preventDefault();
         });
         this.enterkey.key.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            param1.preventDefault();
         });
         this.enterkey.send.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            connection.send("access",enterkey.key.text);
         });
         connection.addMessageHandler("access",function(param1:Message):void
         {
            Bl.data.canEdit = true;
            Bl.data.canToggleGodMode = !Bl.data.isOpenWorld || Bl.data.canEdit && Bl.data.isLockedRoom;
            auraMenu.redraw();
            configureInterface();
         });
         connection.addMessageHandler("lostaccess",function(param1:Message):void
         {
            toggleMore(false);
            toggleGodMode(false);
            Bl.data.canEdit = false;
            Bl.data.canToggleGodMode = false;
            auraMenu.redraw();
            configureInterface();
         });
         connection.addMessageHandler("roomLocked",function(param1:Message, isLocked:Boolean):void
         {
            Bl.data.isStaffLocked = isLocked;
            if(enterkey)
            {
               if(isLocked)
               {
                  enterkey.key.text = "Locked by Staff";
                  enterkey.key.type = "dynamic";
                  enterkey.key.selectable = false;
                  enterkey.send.visible = false;
               }
               else
               {
                  if(enterkey.key.text == "Locked by Staff")
                  {
                     enterkey.key.text = "";
                  }
                  enterkey.key.type = "input";
                  enterkey.key.selectable = true;
                  enterkey.send.visible = true;
               }
            }
            configureInterface();
         });
         connection.addMessageHandler("toggleOwner",function(param1:Message, param2:Boolean):void
         {
            Bl.data.owner = param2;
            configureInterface();
         });
         connection.addMessageHandler("toggleOptions",function(param1:Message, param2:Boolean):void
         {
            Bl.data.canChangeWorldOptions = param2;
            configureInterface();
         });
         connection.addMessageHandler("roomVisible",function(param1:Message):void
         {
            roomVisible = param1.getBoolean(0);
         });
         connection.addMessageHandler("hideLobby",function(param1:Message):void
         {
            roomHiddenFromLobby = param1.getBoolean(0);
         });
         connection.addMessageHandler("allowSpectating",function(param1:Message):void
         {
            var _loc2_:PlayState = null;
            allowSpectating = param1.getBoolean(0);
            if(!allowSpectating)
            {
               _loc2_ = base.state as PlayState;
               _loc2_.stopSpectating();
            }
         });
         connection.addMessageHandler("minimapEnabled",function(param1:Message, param2:Boolean):void
         {
            worldMapEnabled = param2;
            configureInterface();
         });
         connection.addMessageHandler("lobbyPreviewEnabled",function(param1:Message, param2:Boolean):void
         {
            lobbyPreviewEnabled = param2;
         });
         connection.addMessageHandler("roomDescription",function(param1:Message):void
         {
            that.description = param1.getString(0);
         });
         connection.addMessageHandler("effectLimits",function(param1:Message, param2:int, param3:int):void
         {
            curseLimit = param2;
            zombieLimit = param3;
            effectDisplay.setLimits(curseLimit,zombieLimit);
         });
         connection.addMessageHandler("pm",function(param1:Message, param2:int, param3:String, param4:Boolean):void
         {
            var _loc5_:Player = (base.state as PlayState).getPlayers()[param2];
            if(!_loc5_)
            {
               return;
            }
            latestPM = _loc5_.name;
         });
         connection.addMessageHandler("joinCampaign",function(param1:Message, param2:String, param3:int):void
         {
            var _loc4_:* = 0;
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc7_:Array = null;
            if(Global.player_is_guest)
            {
               campaignInfo.displayGuestInfo(param2);
            }
            else if(param3 == -1)
            {
               campaignInfo.displayLockedInfo(param2);
            }
            else if(param3 == 2)
            {
               campaignInfo.displayBetaOnlyInfo(param2);
            }
            else if(param3 == 3)
            {
               campaignInfo.displayLockedCampaignInfo(param2);
            }
            else
            {
               _loc4_ = 2;
               campaignInfo.displayInfo(param2,param1.getInt(_loc4_++),param1.getInt(_loc4_++),param1.getInt(_loc4_++),param3 == 1);
               if(param3 == 1)
               {
                  if(param1.getBoolean(_loc4_++))
                  {
                     trialsAvailable = true;
                     _loc5_ = param1.getInt(_loc4_++);
                     _loc6_ = param1.getInt(_loc4_++);
                     _loc7_ = new Array();
                     _loc7_.push(param1.getInt(_loc4_++));
                     _loc7_.push(param1.getInt(_loc4_++));
                     _loc7_.push(param1.getInt(_loc4_++));
                     if(_loc6_ >= 3)
                     {
                        _loc7_.push(param1.getInt(_loc4_++));
                     }
                     if(_loc6_ >= 5)
                     {
                        _loc7_.push(param1.getInt(_loc4_++));
                     }
                     timesInfo.displayTimes(_loc7_,_loc5_,_loc6_);
                     goodTicks = _loc5_ < 0 ? int.MAX_VALUE : _loc5_;
                     configureInterface();
                  }
               }
            }
         });
         connection.addMessageHandler("lockCampaign",function(param1:Message, param2:String):void
         {
            campaignInfo.displayLockedInfo(param2);
         });
         connection.addMessageHandler("stoprun",function(param1:Message, param2:Boolean = false):void
         {
            validRun = false;
            if(param2)
            {
               trialsAvailable = false;
            }
            if(trialsMode)
            {
               Global.base.SystemSay("You left time trials mode.","* System");
               trialsMode = false;
               configureInterface();
            }
         });
         connection.addMessageHandler("campaignRewards",function(param1:Message):void
         {
            var i:int;
            var showBadge:Boolean;
            var rewards:Array;
            var badgeTitle:String = null;
            var badgeDescription:String = null;
            var badgeId:String = null;
            var badgeImageName:String = null;
            var worldId:String = null;
            var worldImageName:String = null;
            var rewardType:String = null;
            var reward:CampaignReward = null;
            var m:Message = param1;
            campaignInfo.updateStatus(true);
            i = 0;
            showBadge = m.getBoolean(i++);
            if(showBadge)
            {
               badgeTitle = m.getString(i++);
               badgeDescription = m.getString(i++);
               badgeId = m.getString(i++);
               badgeImageName = "Achievements/" + (badgeId == "adv" ? "avd" : badgeId) + ".png";
            }
            else
            {
               worldId = m.getString(i++);
               worldImageName = "Campaigns/" + worldId + ".png";
            }
            rewards = [];
            while(i < m.length)
            {
               rewardType = m.getString(i++);
               reward = new CampaignReward(rewardType,m.getUInt(i++));
               rewards.push(reward);
               if(rewardType.substring(0,6) == "smiley")
               {
                  Global.client.payVault.refresh(function():void
                  {
                     var _loc1_:ItemSmiley = ItemManager.getSmileyByPayvaultId(rewardType);
                     smileyMenu.addSmiley(new SmileyInstance(_loc1_,that,Global.playerInstance.wearsGoldSmiley));
                     smileyMenu.redraw();
                     setSelectedSmiley(_loc1_.id);
                  });
               }
            }
            Global.base.showCampaignComplete(new CampaignComplete(campaignInfo.campaignName,campaignInfo.tier,campaignInfo.maxTier,rewards,showBadge ? badgeImageName : worldImageName));
         });
         connection.addMessageHandler("completedLevel",function(param1:Message):void
         {
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc7_:int = 0;
            var _loc8_:int = 0;
            var _loc9_:Array = null;
            if(Global.base.overlayContainer.getChildByName("LevelCompleteScreen"))
            {
               return;
            }
            var _loc2_:* = 0;
            if(param1.getBoolean(_loc2_++) && trialsMode)
            {
               _loc3_ = param1.getInt(_loc2_++);
               _loc4_ = param1.getInt(_loc2_++);
               _loc5_ = param1.getInt(_loc2_++);
               _loc6_ = param1.getInt(_loc2_++);
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
               timesInfo.displayTimes(_loc9_,_loc7_,_loc8_);
               goodTicks = _loc7_ < 0 ? int.MAX_VALUE : _loc7_;
               configureInterface();
               Global.base.showCampaignTrialDone(new CampaignTrialDone(_loc6_,_loc5_,_loc4_,_loc3_,_loc8_ < _loc9_.length ? int(_loc9_[_loc8_]) : -1));
            }
            else
            {
               Global.base.showOnTop(new LevelComplete());
            }
         });
         connection.addMessageHandler("canAddToCrews",function(param1:Message):void
         {
            var _loc2_:Array = [];
            var _loc3_:Array = [];
            var _loc4_:int = 0;
            while(_loc4_ < param1.length)
            {
               _loc2_.push(param1.getString(_loc4_));
               _loc3_.push(param1.getString(_loc4_ + 1));
               _loc4_ += 2;
            }
            crewPrompt = new CrewPrompt(connection,_loc2_,_loc3_);
            configureInterface();
         });
         connection.addMessageHandler("addedToCrew",function(param1:Message):void
         {
            if(crewPrompt != null)
            {
               crewPrompt.close();
               crewPrompt = null;
            }
            configureInterface();
            Global.currentLevelCrew = param1.getString(0);
            Global.currentLevelCrewName = param1.getString(1);
            sidechat.updateBy();
         });
         connection.addMessageHandler("crewAddRequest",function(param1:Message):void
         {
            var confirm:ConfirmPrompt = null;
            var reject:Function = null;
            var m:Message = param1;
            reject = function(param1:MouseEvent):void
            {
               connection.send("rejectAddToCrew");
               confirm.close();
            };
            confirm = new ConfirmPrompt(m.getString(0) + " wants to add this world to " + m.getString(1) + ". Do you agree? WARNING: This cannot be undone!",true);
            Global.base.showOnTop(confirm);
            confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               var confirm2:ConfirmPrompt = null;
               var ev:MouseEvent = param1;
               confirm2 = new ConfirmPrompt("Are you sure?",true);
               Global.base.showOnTop(confirm2);
               confirm2.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  connection.send("addToCrew");
                  confirm2.close();
                  confirm.close();
               });
               confirm2.btn_no.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  reject(param1);
                  confirm2.close();
               });
            });
            confirm.btn_no.addEventListener(MouseEvent.MOUSE_DOWN,reject);
            confirm.closebtn.addEventListener(MouseEvent.MOUSE_DOWN,reject);
         });
         this.setSelectedSmiley(Global.playerObject ? Global.playerObject.smiley || 0 : 0);
         this.setSelectedAura(Global.playerObject ? Global.playerObject.aura || 0 : 0);
         this.setFavLikeStates();
         this.toggleSmileyMenu(false);
         this.settingsMenu.toggleVisible(false);
         this.updateSelectorBricks();
         this.setSelected(0);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleDetatch);
         Global.stage.addEventListener(SimplePlayerObjectEvent.UPDATE,this.handlePlayerObjectUpdate,false,0,true);
      }
      
      public function get playerActionsVisible() : Boolean
      {
         return this.playerActions != null && !this.playerActions.closed;
      }
      
      public function get minimapEnabled() : Boolean
      {
         return this.worldMapEnabled || this.playerMapEnabled || Boolean(Bl.data.canEdit) || Boolean(Bl.data.canToggleGodMode);
      }
      
      public function setEffectIcon(param1:int, param2:Boolean, param3:int, param4:int) : void
      {
         var _loc5_:ItemBrick = ItemManager.getEffectBrickById(param1);
         var _loc6_:BitmapData = _loc5_.bmd;
         if(param1 == Config.effectMultijump)
         {
            return;
         }
         this.effectDisplay.removeEffect(_loc5_.id);
         if(param2)
         {
            this.effectDisplay.addEffect(_loc6_,_loc5_.id,param3,param4);
         }
         this.effectDisplay.update();
      }
      
      public function showPlayerActions(param1:String, param2:String, param3:Boolean = false) : void
      {
         if(this.playerActionsVisible)
         {
            this.playerActions.close();
            if(this.playerActions.targetPlayer.name == param1 && this.playerActions.debug == param3)
            {
               return;
            }
         }
         this.playerActions = new PlayerActionsMenu(param1,param2,this.connection,param3);
         this.playerActions.x = 491;
         this.playerActions.y = -450;
         addChild(this.playerActions);
      }
      
      public function hidePlayerActions(param1:String = "") : void
      {
         if(this.playerActionsVisible)
         {
            if(param1 != "" && this.playerActions.targetPlayer.name != param1)
            {
               return;
            }
            this.playerActions.close();
            this.playerActions = null;
         }
      }
      
      private function handlePlayerObjectUpdate(param1:Event = null) : void
      {
         this.smileyMenu.doEmpty();
         this.smileyMenu.redraw();
      }
      
      private function setSmiliesData() : void
      {
         var _loc6_:ItemSmiley = null;
         var _loc7_:ItemAuraShape = null;
         var _loc8_:ItemAuraColor = null;
         var _loc1_:Vector.<ItemSmiley> = ItemManager.smilies;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc6_ = _loc1_[_loc2_];
            if(Boolean(Bl.data.canUseAllItems || _loc6_.payvaultid == "" || this.base.client.payVault.has(_loc6_.payvaultid)) || Boolean(_loc6_.payvaultid == "pro" && Global.player_is_beta_member) || Global.playerObject.goldmember && _loc6_.payvaultid == "goldmember")
            {
               this.smileyMenu.addSmiley(new SmileyInstance(_loc6_,this,Global.playerInstance.wearsGoldSmiley));
            }
            _loc2_++;
         }
         var _loc3_:Vector.<ItemAuraShape> = ItemManager.auraShapes;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc4_];
            if(Boolean(Bl.data.canUseAllItems || _loc7_.payvaultid == "") || Boolean(this.base.client.payVault.has(_loc7_.payvaultid)) || _loc7_.payvaultid == "goldmember" && Global.playerObject.goldmember)
            {
               this.auraMenu.addShape(_loc7_);
            }
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < ItemManager.auraColors.length)
         {
            _loc8_ = ItemManager.auraColors[_loc5_];
            if(Boolean(Bl.data.canUseAllItems || _loc8_.payVaultId == "") || Boolean(this.base.client.payVault.has(_loc8_.payVaultId)) || _loc8_.payVaultId == "goldmember" && Global.playerObject.goldmember)
            {
               this.auraMenu.addColor(_loc8_);
            }
            _loc5_++;
         }
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
      }
      
      public function updateSelectorBricks() : void
      {
         var _loc1_:Vector.<ItemBrick> = null;
         var _loc2_:Vector.<ItemBrickPackage> = null;
         var _loc4_:ItemBrickPackage = null;
         var _loc5_:Vector.<ItemBrick> = null;
         var _loc6_:Vector.<ItemBrick> = null;
         var _loc7_:Vector.<ItemBrick> = null;
         var _loc8_:Vector.<ItemBrick> = null;
         var _loc9_:int = 0;
         var _loc10_:BrickPackage = null;
         var _loc11_:ItemBrick = null;
         this.bselector.removeAllPackages();
         _loc1_ = ItemManager.getOpenWorldAntiSubset();
         _loc2_ = ItemManager.brickPackages;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = new Vector.<ItemBrick>();
            _loc6_ = new Vector.<ItemBrick>();
            _loc7_ = new Vector.<ItemBrick>();
            _loc8_ = new Vector.<ItemBrick>();
            _loc9_ = 0;
            for(; _loc9_ < _loc4_.bricks.length; _loc9_++)
            {
               _loc11_ = _loc4_.bricks[_loc9_];
               if(Boolean(Bl.data.isOpenWorld) && !Bl.data.isAdmin)
               {
                  if(_loc1_.indexOf(_loc11_) > -1)
                  {
                     continue;
                  }
               }
               if(!(Boolean(Bl.data.canUseAllItems || _loc11_.payvaultid == "" || this.base.client.payVault.has(_loc11_.payvaultid) || (_loc11_.payvaultid.indexOf("brickeffect") == 0 && this.base.client.payVault.has("brickeffect"))) || Boolean(_loc11_.payvaultid == "pro" && Global.player_is_beta_member) || _loc11_.payvaultid == "goldmember" && Global.playerObject.goldmember))
               {
                  continue;
               }
               if((_loc11_.id == 77 || _loc11_.id == 83 || _loc11_.id == 1520) && !Global.hasOwner)
               {
                  continue;
               }
               if(!(!_loc11_.requiresAdmin || Boolean(Bl.data.isStaffMember)))
               {
                  continue;
               }
               if(!(!_loc11_.requiresOwnership || (Boolean(Bl.data.owner) || Boolean(Bl.data.isAdmin))))
               {
                  continue;
               }
               switch(_loc11_.tab)
               {
                  case ItemTab.BLOCK:
                     _loc5_.push(_loc11_);
                     break;
                  case ItemTab.ACTION:
                     _loc6_.push(_loc11_);
                     break;
                  case ItemTab.DECORATIVE:
                     _loc7_.push(_loc11_);
                     break;
                  case ItemTab.BACKGROUND:
                     _loc8_.push(_loc11_);
               }
            }
            if(_loc5_.length > 0)
            {
               _loc10_ = new BrickPackage(_loc4_.name,_loc5_,this,ItemTab.BLOCK,_loc4_.tags,Global.base.settings.showPackageNames,Global.base.settings.collapsed ? 1 : 0);
               this.bselector.addPackage(_loc10_);
            }
            if(_loc6_.length > 0)
            {
               _loc10_ = new BrickPackage(_loc4_.name,_loc6_,this,ItemTab.ACTION,_loc4_.tags,Global.base.settings.showPackageNames,Global.base.settings.collapsed ? 1 : 0);
               this.bselector.addPackage(_loc10_);
            }
            if(_loc7_.length > 0)
            {
               _loc10_ = new BrickPackage(_loc4_.name,_loc7_,this,ItemTab.DECORATIVE,_loc4_.tags,Global.base.settings.showPackageNames,Global.base.settings.collapsed ? 1 : 0);
               this.bselector.addPackage(_loc10_);
            }
            if(_loc8_.length > 0)
            {
               _loc10_ = new BrickPackage(_loc4_.name,_loc8_,this,ItemTab.BACKGROUND,_loc4_.tags,Global.base.settings.showPackageNames,Global.base.settings.collapsed ? 1 : 0);
               this.bselector.addPackage(_loc10_);
            }
            _loc3_++;
         }
         this.bselector.search.textfield.text = "";
         this.bselector.redraw();
      }
      
      public function toggleSmileyMenu(param1:Boolean) : void
      {
         if(param1)
         {
            this.hideAll();
         }
         this.smileyMenu.visible = param1;
         this.smileyButton.setActive(param1);
      }
      
      public function toggleAuraMenu(param1:Boolean) : void
      {
         if(param1)
         {
            this.hideAll();
         }
         this.auraMenu.visible = param1;
         this.auraButton.setActive(param1);
      }
      
      public function toggleFavLike(param1:Boolean) : void
      {
         if(param1)
         {
            this.hideAll();
         }
         this.favLikeSelector.visible = param1;
      }
      
      public function dragIt(param1:ItemBrick) : void
      {
         this.favoriteBricks.dragIt(param1);
      }
      
      public function setDefault(param1:int, param2:ItemBrick) : void
      {
         this.favoriteBricks.setDefault(param1,param2);
      }
      
      public function toggleGodMode(param1:Boolean) : void
      {
         this.godmode.gotoAndStop(param1 ? 2 : 1);
      }
      
      public function toggleMinimap(param1:Boolean) : void
      {
         this.toggleminimap.gotoAndStop(param1 ? 2 : 1);
         Bl.data.showMap = param1;
      }
      
      public function setSelected(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:Boolean = Boolean(Bl.data.showingproperties);
         this.hideAllProperties();
         if(param1 != Bl.data.brick || !_loc3_)
         {
            switch(param1)
            {
               case ItemId.COINDOOR:
               case ItemId.COINGATE:
               case ItemId.BLUECOINDOOR:
               case ItemId.BLUECOINGATE:
               case 77:
               case 83:
               case 242:
               case ItemId.WORLD_PORTAL:
               case ItemId.WORLD_PORTAL_SPAWN:
               case ItemId.PORTAL_INVISIBLE:
               case ItemId.TEXT_SIGN:
               case ItemId.SWITCH_PURPLE:
               case ItemId.RESET_PURPLE:
               case ItemId.DOOR_PURPLE:
               case ItemId.GATE_PURPLE:
               case ItemId.DEATH_DOOR:
               case ItemId.DEATH_GATE:
               case ItemId.EFFECT_TEAM:
               case ItemId.TEAM_DOOR:
               case ItemId.TEAM_GATE:
               case ItemId.EFFECT_CURSE:
               case ItemId.EFFECT_FLY:
               case ItemId.EFFECT_JUMP:
               case ItemId.EFFECT_PROTECTION:
               case ItemId.EFFECT_RUN:
               case ItemId.EFFECT_ZOMBIE:
               case ItemId.EFFECT_LOW_GRAVITY:
               case ItemId.EFFECT_MULTIJUMP:
               case ItemId.EFFECT_GRAVITY:
               case ItemId.EFFECT_POISON:
               case ItemId.SWITCH_ORANGE:
               case ItemId.RESET_ORANGE:
               case ItemId.DOOR_ORANGE:
               case ItemId.GATE_ORANGE:
               case 1520:
               case 1000:
                  this.showSpecialProperties(param1,!this.bselector.visible || !this.bselector.currentPageHasBlock(param1),param2);
            }
            if(ItemId.isNPC(param1))
            {
               this.showSpecialProperties(param1,!this.bselector.visible || !this.bselector.currentPageHasBlock(param1),param2);
            }
         }
         if(param1 == -1)
         {
            param1 = 243;
         }
         Bl.data.brick = param1;
         this.favoriteBricks.setSelected(param1);
         this.bselector.setSelected(param1);
      }
      
      public function hideBrickPackagePopup() : void
      {
         if(this.brickPackagePopup.visible)
         {
            this.hideAllProperties();
         }
         this.brickPackagePopup.visible = false;
      }
      
      public function toggleBrickPackagePopup(param1:String, param2:Vector.<ItemBrick>, param3:Boolean) : void
      {
         var _loc4_:int = param2[0].id;
         if(this.brickPackagePopup.visible && this.brickPackagePopup.content[0].id == _loc4_ && param3)
         {
            this.brickPackagePopup.visible = false;
            return;
         }
         var _loc5_:Point = this.bselector.getPosition(_loc4_);
         this.brickPackagePopup.visible = _loc5_ != null;
         if(_loc5_ == null)
         {
            return;
         }
         this.brickPackagePopup.updateContent(param1,param2,true);
         this.brickPackagePopup.x = _loc5_.x + this.bselector.x - this.brickPackagePopup.content.length * 16 / 2 - 2;
         this.brickPackagePopup.y = _loc5_.y + this.bselector.y - 33;
         if(this.brickPackagePopup.x < 0)
         {
            this.brickPackagePopup.x = 5;
         }
         else if(this.brickPackagePopup.x + this.brickPackagePopup.content.length * 16 > 635)
         {
            this.brickPackagePopup.x = 635 - this.brickPackagePopup.width;
         }
         this.hideAllProperties();
      }
      
      public function showSpecialProperties(param1:int, param2:Boolean = false, param3:Boolean = false) : void
      {
         this.hideAllProperties();
         var _loc4_:Point = this.brickPackagePopup.getPosition(param1);
         if(_loc4_ == null)
         {
            if(!param2)
            {
               _loc4_ = this.bselector.getPosition(param1);
            }
            else
            {
               _loc4_ = this.favoriteBricks.getPosWithID(param1);
            }
         }
         else
         {
            _loc4_.x -= this.bselector.x;
            _loc4_.y -= this.bselector.y;
         }
         Bl.data.showingproperties = true;
         this.specialproperties = null;
         switch(param1)
         {
            case ItemId.COINDOOR:
            case ItemId.COINGATE:
            case ItemId.BLUECOINDOOR:
            case ItemId.BLUECOINGATE:
               this.specialproperties = new CoinProperties(param1);
               break;
            case 1000:
               this.specialproperties = new LabelProperties();
               break;
            case 242:
            case ItemId.PORTAL_INVISIBLE:
               this.specialproperties = new PortalProperties(param1);
               break;
            case ItemId.WORLD_PORTAL:
               this.specialproperties = new WorldPortalProperties();
               break;
            case ItemId.WORLD_PORTAL_SPAWN:
               this.specialproperties = new WorldPortalSpawnProperties();
               break;
            case 83:
               this.specialproperties = new DrumProperties();
               break;
            case 77:
               this.specialproperties = new PianoProperties();
               break;
            case ItemId.TEXT_SIGN:
               this.specialproperties = new TextSignProperties();
               break;
            case ItemId.SWITCH_PURPLE:
            case ItemId.RESET_PURPLE:
            case ItemId.DOOR_PURPLE:
            case ItemId.GATE_PURPLE:
            case ItemId.SWITCH_ORANGE:
            case ItemId.RESET_ORANGE:
            case ItemId.DOOR_ORANGE:
            case ItemId.GATE_ORANGE:
               this.specialproperties = new SwitchProperties(param1);
               break;
            case ItemId.DEATH_DOOR:
            case ItemId.DEATH_GATE:
               this.specialproperties = new DeathProperties(param1);
               break;
            case ItemId.EFFECT_TEAM:
            case ItemId.TEAM_DOOR:
            case ItemId.TEAM_GATE:
               this.specialproperties = new TeamProperties();
               break;
            case ItemId.EFFECT_CURSE:
            case ItemId.EFFECT_ZOMBIE:
            case ItemId.EFFECT_POISON:
               this.specialproperties = new TimeProperties();
               break;
            case ItemId.EFFECT_FLY:
            case ItemId.EFFECT_PROTECTION:
            case ItemId.EFFECT_LOW_GRAVITY:
               this.specialproperties = new OnOffProperties();
               break;
            case ItemId.EFFECT_JUMP:
            case ItemId.EFFECT_RUN:
               this.specialproperties = new HighLowProperties();
               break;
            case ItemId.EFFECT_MULTIJUMP:
               this.specialproperties = new MultijumpProperties();
               break;
            case ItemId.EFFECT_GRAVITY:
               this.specialproperties = new GravityProperties();
               break;
            case 1520:
               this.specialproperties = new GuitarProperties();
         }
         if(ItemId.isNPC(param1))
         {
            this.specialproperties = new NpcProperties(param1,this,param2);
         }
         if(_loc4_ == null || this.specialproperties == null)
         {
            return;
         }
         this.above.addChild(this.specialproperties);
         var _loc5_:int = param2 ? int(this.favoriteBricks.x) : int(this.bselector.x);
         var _loc6_:int = param2 ? int(this.favoriteBricks.y) : int(this.bselector.y);
         this.specialproperties.x = _loc4_.x + _loc5_;
         this.specialproperties.y = _loc4_.y + _loc6_;
         if(this.specialproperties.x - this.specialproperties.width / 2 < 0)
         {
            this.specialproperties.arrow.x += this.specialproperties.x - this.specialproperties.width / 2;
            this.specialproperties.x = this.specialproperties.width / 2;
         }
         else if(this.specialproperties.x + this.specialproperties.width / 2 > 640)
         {
            this.specialproperties.arrow.x -= 640 - (this.specialproperties.x + this.specialproperties.width / 2);
            this.specialproperties.x = 640 - this.specialproperties.width / 2;
         }
         this.specialproperties.x = Math.round(this.specialproperties.x);
      }
      
      public function hideAllProperties() : void
      {
         Bl.data.showingproperties = false;
         if(this.specialproperties != null && this.above.contains(this.specialproperties))
         {
            this.above.removeChild(this.specialproperties);
         }
      }
      
      public function setFavLikeStates() : void
      {
         if(!this.favLikeButton)
         {
            return;
         }
         var _loc1_:int = 0;
         var _loc2_:Boolean = Boolean(Bl.data.inFavorites);
         var _loc3_:Boolean = Boolean(Bl.data.liked);
         if(_loc3_)
         {
            _loc1_ += 1;
         }
         if(_loc2_)
         {
            _loc1_ += 2;
         }
         this.favLikeButton.setState(_loc1_);
         if(!this.favLikeSelector)
         {
            return;
         }
         this.favLikeSelector.setFavoriteState(int(!_loc2_));
         this.favLikeSelector.setLikeState(int(!_loc3_));
         if(!_loc2_ && Global.base.favorited)
         {
            this.favLikeSelector.disableFavoriteButton();
         }
         if(!_loc3_ && Global.base.liked)
         {
            this.favLikeSelector.disableLikeButton();
         }
      }
      
      public function setSelectedAura(param1:int = 0) : void
      {
         this.connection.send("aura",param1,Global.playerObject.auraColor);
         Global.playerObject.aura = param1;
         this.auraMenu.auraSelector.setSelectedAura(param1);
      }
      
      public function setSelectedAuraColor(param1:int = 0) : void
      {
         this.connection.send("aura",Global.playerObject.aura,param1);
         Global.playerObject.auraColor = param1;
         this.auraMenu.auraSelector.setSelectedAura(Global.playerObject.aura);
      }
      
      public function setSelectedSmiley(param1:int = 0) : void
      {
         var _loc2_:int = param1;
         var _loc3_:SmileyInstance = this.smileyMenu.getSmileyInstanceByItemId(_loc2_);
         this.connection.send("smiley",_loc2_);
         Global.playerObject.smiley = _loc2_;
         if(Global.playerInstance != null)
         {
            Global.playerInstance.frame = _loc2_;
         }
         this.smileyMenu.setSelectedSmiley(_loc2_);
         this.smileyButton.setSelectedSmiley(_loc2_);
      }
      
      public function toggleMore(param1:Boolean) : void
      {
         if(this.favoriteBricks.parent == null)
         {
            return;
         }
         if(param1)
         {
            this.hideAll(false);
         }
         this.hideAllProperties();
         this.favoriteBricks.more.gotoAndStop(param1 ? 2 : 1);
         this.bselector.visible = param1;
         Bl.data.moreisvisible = param1;
         this.hideBrickPackagePopup();
      }
      
      public function toggleChat(param1:Boolean, param2:String = "") : void
      {
         var _loc3_:int = 0;
         this.chatHistory = 10;
         if(param1)
         {
            this.hideAll();
            Global.chatIsVisible = true;
            this.chatbtn.gotoAndStop(2);
            this.chatinput.visible = true;
            this.chatinput.text.field.text = param2;
            _loc3_ = param2.length;
            if(stage)
            {
               this.chatinput.text.field.setSelection(_loc3_,_loc3_);
               stage.focus = this.chatinput.text.field;
            }
         }
         else
         {
            this.chatbtn.gotoAndStop(1);
            this.chatinput.visible = false;
            Global.chatIsVisible = false;
         }
      }
      
      public function hideAll(param1:Boolean = true) : void
      {
         this.toggleSmileyMenu(false);
         this.toggleAuraMenu(false);
         this.settingsMenu.toggleVisible(false);
         this.toggleChat(false);
         if(!param1 || this.bselector.isLocked)
         {
            this.toggleMore(false);
         }
         this.toggleFavLike(false);
         this.hideAllProperties();
         this.hideBrickPackagePopup();
      }
      
      public function configureInterface(param1:Boolean = false) : void
      {
         this.usedXLeft = 0;
         this.usedXRight = 0;
         if(this.godmode.parent)
         {
            removeChild(this.godmode);
         }
         if(this.smileyButton.parent)
         {
            removeChild(this.smileyButton);
         }
         if(this.auraButton.parent)
         {
            removeChild(this.auraButton);
         }
         if(this.favoriteBricks.parent)
         {
            removeChild(this.favoriteBricks);
         }
         if(this.favLikeButton.parent)
         {
            removeChild(this.favLikeButton);
         }
         if(this.settingsMenu != null && Boolean(this.settingsMenu.parent))
         {
            this.settingsMenu.remove();
            removeChild(this.settingsMenu);
         }
         if(this.enterkey.parent)
         {
            removeChild(this.enterkey);
         }
         if(this.campaignInfo.parent)
         {
            removeChild(this.campaignInfo);
         }
         if(this.timesInfo.parent)
         {
            removeChild(this.timesInfo);
         }
         if(this.toggleminimap.parent)
         {
            removeChild(this.toggleminimap);
         }
         if(Boolean(this.timeLabel) && Boolean(this.timeLabel.parent))
         {
            this.timeLabel.parent.removeChild(this.timeLabel);
            this.timeLabel = null;
         }
         if(!this.minimapEnabled)
         {
            this.toggleMinimap(false);
         }
         this.add(this.lobby);
         this.add(this.share);
         if(Bl.data.canEdit)
         {
            if(Bl.data.isLockedRoom)
            {
               this.add(this.godmode);
            }
            this.add(this.smileyButton);
            if(Bl.data.isLockedRoom)
            {
               this.add(this.auraButton);
            }
            this.add(this.chatbtn);
            this.add(this.favoriteBricks);
         }
         else
         {
            if(Boolean(Bl.data.canToggleGodMode) && !Bl.data.isCampaignRoom)
            {
               this.add(this.godmode);
            }
            this.add(this.smileyButton);
            if(Boolean(Bl.data.canToggleGodMode) && !Bl.data.isCampaignRoom)
            {
               this.add(this.auraButton);
            }
            this.add(this.chatbtn);
            if(!Bl.data.isCampaignRoom)
            {
               if(Bl.data.isStaffLocked)
               {
                  this.enterkey.key.text = "Locked by Staff";
                  this.enterkey.key.type = "dynamic";
                  this.enterkey.key.selectable = false;
                  this.enterkey.send.visible = false;
               }
               else
               {
                  if(this.enterkey.key.text == "Locked by Staff")
                  {
                     this.enterkey.key.text = "";
                  }
                  this.enterkey.key.type = "input";
                  this.enterkey.key.selectable = true;
                  this.enterkey.send.visible = true;
               }
               this.add(this.enterkey);
            }
         }
         this.settingsMenu = new SettingsMenu("Options",this);
         this.add(this.settingsMenu);
         var _loc2_:Number = this.sidechat.chatbox.height;
         if(Bl.data.isCampaignRoom)
         {
            if(this.trialsMode && !Bl.data.canEdit)
            {
               this.add(this.timesInfo);
               this.sidechat.chatbox.height = Global.height - this.sidechat.chatbox.y - 30;
               this.timeLabel = new Label("",11,"left",16777215,false,"system");
               this.timeLabel.x = 10;
               this.timeLabel.y = Global.height - 30 + 7;
               this.sidechat.addChild(this.timeLabel);
            }
            else
            {
               if(!Bl.data.canEdit)
               {
                  this.add(this.campaignInfo);
               }
               this.sidechat.chatbox.height = Global.height - this.sidechat.chatbox.y;
            }
         }
         if(this.sidechat.chatbox.height != _loc2_)
         {
            this.sidechat.chatbox.refresh();
         }
         this.settingsMenu.redraw();
         if(this.minimapEnabled)
         {
            this.add(this.toggleminimap,true);
         }
         if(!Bl.data.owner && !Bl.data.isOpenWorld && !Global.player_is_guest)
         {
            this.add(this.favLikeButton,true);
         }
         if(!Bl.data.isCampaignRoom)
         {
            this.add(this.download,true);
         }
         addChild(this.above);
      }
      
      public function enterFrame() : void
      {
         var _loc1_:int = 0;
         if(this.trialsMode && Boolean(this.timeLabel))
         {
            _loc1_ = (this.base.state as PlayState).player.ticks;
            this.timeLabel.text = "Time: " + ClockTime.format(_loc1_);
            this.timeLabel.textColor = _loc1_ == 0 ? 16777215 : (_loc1_ <= this.goodTicks ? 4259648 : 16728128);
         }
      }
      
      private function add(param1:InteractiveObject, param2:Boolean = false) : void
      {
         param1.y = -29;
         if(param2)
         {
            param1.x = Config.width - param1.width - this.usedXRight;
            this.usedXRight += param1.width;
         }
         else
         {
            param1.x = this.usedXLeft;
            this.usedXLeft += param1.width - 1;
         }
         addChild(param1);
      }
      
      private function handleAttach(param1:Event) : void
      {
         stage.stageFocusRect = false;
         stage.focus = stage;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
      }
      
      private function handleDetatch(param1:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
      }
      
      private function previousChatInput() : void
      {
         if(this.chatHistory > 9)
         {
            this.chatHistory = 9;
         }
         else if(this.chatHistory < 0)
         {
            this.chatHistory = 0;
         }
         var _loc1_:String = this.textArray[this.chatHistory];
         if(_loc1_ == null)
         {
            _loc1_ = "";
         }
         this.chatinput.text.field.text = _loc1_;
      }
      
      private function sendChat() : void
      {
         var totalTime:int;
         var a:int;
         var ps:PlayState;
         var cmd:Array;
         var cmdName:String;
         var players:Object;
         var next:String = null;
         var targetid:int = 0;
         var guyname:String = null;
         var guy:Player = null;
         var show:Boolean = false;
         var q:String = null;
         var pl:Player = null;
         var i:String = null;
         var p:Player = null;
         var user:String = null;
         var reason:String = null;
         var reportPrompt:ReportPrompt = null;
         var playState:PlayState = null;
         var targetName:String = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var pls:Object = null;
         var j:String = null;
         var player:Player = null;
         var text:String = this.chatinput.text.field.text;
         var ltext:String = text.toLocaleLowerCase();
         var iscommand:Boolean = text.charAt(0) == "/";
         this.textArray.push(text);
         this.textArray.shift();
         this.timerArray.push(new Date().time - this.lastMessageTime);
         this.timerArray.shift();
         totalTime = 0;
         a = 0;
         while(a < this.timerArray.length)
         {
            totalTime += this.timerArray[a];
            a++;
         }
         if(!iscommand)
         {
            text = text.replace(/([\?\!]{2})[\?\!]+/gi,"$1");
            text = text.replace(/\.{4,}/gi,"...");
            next = text.replace(/(:?.+)\1{5,}/gi,"$1$1$1$1$1");
            while(next != text)
            {
               text = next;
               next = text.replace(/(:?.+)\1{5,}/gi,"$1$1$1$1$1");
            }
            if(text.length > 13 && text.match(/[A-Z]/g).length > text.length / 2 + 7)
            {
               text = text.substr(0,1).toUpperCase() + text.substr(1).toLowerCase();
            }
         }
         this.hideAll();
         if(!iscommand)
         {
            if(Global.player_is_guest || (Global.playerObject && Global.playerObject.name && Global.playerObject.name.toLowerCase().indexOf("guest") == 0))
            {
               Global.base.SystemSay("If you want to chat, you should register an account!");
               return;
            }
            if(text.replace(/\s/gi,"").length > 0)
            {
               this.lastMessageTime = new Date().time;
               if(totalTime < 5000)
               {
                  Global.base.SystemSay("Easy now, you don\'t want the other players mistaking you for a spammer!");
                  return;
               }
               this.connection.send("say",text);
            }
            return;
         }
         ps = this.base.state as PlayState;
         cmd = StringUtil.trim(text).split(" ");
         cmdName = cmd[0].toString().toLowerCase();
         players = ps.getPlayers();
         if(text == "/killroom")
         {
            this.connection.send("kill");
         }
         else if(cmdName == "/summon" && Boolean(Bl.data.isAdmin))
         {
            if(cmd.length < 2)
            {
               this.base.SystemSay("Usage: /summon <name>","* System");
               return;
            }
            ps.addFakePlayer(0,0,cmd[1],ps.player.x,ps.player.y,true);
         }
         else if(cmdName == "pm")
         {
            if(cmd.length < 3)
            {
               this.base.SystemSay("Usage: /pm <player> <message>","* System");
               return;
            }
            targetid = -1;
            for(guyname in players)
            {
               guy = players[guyname] as Player;
               if(guy.name.toLowerCase() == cmd[1].toLowerCase())
               {
                  targetid = guy.id;
                  break;
               }
            }
            this.connection.send("pm",targetid,cmd.splice(0,2).join(" "));
         }
         else if(cmdName == "/inspect")
         {
            Global.getPlacer = !Global.getPlacer;
            this.base.SystemSay("Inspect tool active: " + Global.getPlacer.toString().toUpperCase(),"* System");
         }
         else if(cmdName == "/hide" || cmdName == "/show")
         {
            if(cmd.length < 2)
            {
               return;
            }
            show = cmdName.toString().toLowerCase() == "/show";
            if(cmd[1].toString().toLowerCase() == "secrets")
            {
               if(Bl.data.canEdit)
               {
                  ps.world.setShowAllSecrets(show);
                  if(!ps.world.showAllSecrets)
                  {
                     ps.world.lookup.resetSecrets();
                  }
                  this.base.SystemSay("Secrets are now " + (show ? "visible" : "hidden") + "!");
               }
               else
               {
                  this.base.showInfo2("System Message","Unknown command or you don\'t have command access.");
               }
            }
            else if(cmd[1].toString().toLowerCase() == "players")
            {
               Bl.data.showPlayer = show;
               for(q in players)
               {
                  pl = players[q] as Player;
                  pl.render = show;
               }
               this.base.SystemSay("Players are now " + (show ? "visible" : "hidden") + "!");
            }
         }
         else if(cmdName == "/clearchat")
         {
            this.base.sidechat.clearChat();
            this.base.SystemSay("Chat cleared.","* System");
         }
         else if(cmdName == "/roomid")
         {
            this.base.SystemSay("Room ID: " + Global.roomid,"* System");
         }
         else if(cmdName == "/spec" || cmdName == "/spectate")
         {
            if(this.allowSpectating && cmd.length >= 2 && cmd[1].toString().toLowerCase() != ps.player.name.toLowerCase())
            {
               for(i in players)
               {
                  p = players[i] as Player;
                  if(p.name.toLowerCase() == cmd[1].toString().toLowerCase())
                  {
                     ps.spectate(p);
                     break;
                  }
               }
            }
            else if(!this.allowSpectating && cmd.length >= 2)
            {
               Global.base.SystemSay("Spectating is not allowed in this world.","* SYSTEM");
            }
            else
            {
               ps.stopSpectating();
            }
         }
         else if((cmdName == "/rep" || cmdName == "/report" || cmdName == "/reportabuse") && cmd.length >= 2)
         {
            user = cmd[1].toString();
            cmd.splice(0,2);
            reason = cmd.join(" ");
            reportPrompt = new ReportPrompt(user,reason);
            reportPrompt.confirmButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               var confirmRules:ConfirmRulesPrompt = null;
               var e:MouseEvent = param1;
               confirmRules = new ConfirmRulesPrompt();
               confirmRules.continueButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  connection.send("say","/report " + user + " " + reportPrompt.reportText);
                  confirmRules.close();
                  reportPrompt.close();
               });
               Global.base.overlayContainer.addChild(confirmRules);
            });
            Global.base.overlayContainer.addChild(reportPrompt);
         }
         else if(cmdName == "/teleport" || Boolean(cmdName == "/tp") && (Boolean(Bl.data.owner || Bl.data.canChangeWorldOptions || Bl.data.isAdmin || Bl.data.isModerator)))
         {
            this.teleport(cmd);
         }
         else if(cmdName == "/getpos" || cmdName == "/getposition")
         {
            playState = this.base.state as PlayState;
            targetName = playState.player.name;
            x = Math.round(playState.player.x / 16);
            y = Math.round(playState.player.y / 16);
            if(cmd.length >= 2 && StringUtil.trim(cmd[1].toString()) != "")
            {
               pls = playState.getPlayers();
               targetName = cmd[1].toString().toLowerCase();
               for(j in pls)
               {
                  player = pls[j] as Player;
                  if(player.name.toLowerCase() == targetName)
                  {
                     x = Math.round(player.x / 16);
                     y = Math.round(player.y / 16);
                     Global.base.SystemSay(targetName.toUpperCase() + " is located at " + x + "x" + y,"* System");
                     return;
                  }
               }
               Global.base.SystemSay("Player not found.","* System");
               return;
            }
            Global.base.SystemSay(targetName.toUpperCase() + " is located at " + x + "x" + y,"* System");
         }
         else if(cmdName == "/fps" || cmdName == "/info")
         {
            if(Global.debug_stats)
            {
               Global.debug_stats.visible = !Global.debug_stats.visible;
            }
         }
         else if(cmdName == "/starttrial")
         {
            if(this.trialsMode)
            {
               Global.base.SystemSay("You are already in time trials mode.","* System");
            }
            else if(!this.trialsAvailable)
            {
               Global.base.SystemSay("Time trials are not available in this world.","* System");
            }
            else if(!this.validRun)
            {
               Global.base.SystemSay("You must /reset before you can enable time trials mode.","* System");
            }
            else
            {
               Global.base.SystemSay("You entered time trials mode.","* System");
               this.trialsMode = true;
               this.configureInterface();
            }
         }
         else if(cmdName == "/endtrial")
         {
            if(!this.trialsMode)
            {
               Global.base.SystemSay("You are not currently in time trials mode.","* System");
            }
            else
            {
               Global.base.SystemSay("You left time trials mode.","* System");
               this.trialsMode = false;
               this.configureInterface();
            }
         }
         else
         {
            this.connection.send("say",text);
         }
      }
      
      private function teleport(param1:Array) : void
      {
         var _loc6_:String = null;
         var _loc7_:Player = null;
         var _loc8_:String = null;
         var _loc9_:Player = null;
         var _loc10_:String = null;
         var _loc11_:Player = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         if(param1.length < 2)
         {
            Global.base.SystemSay("Please specify a player to teleport.","* System");
            return;
         }
         var _loc2_:PlayState = this.base.state as PlayState;
         var _loc3_:Object = _loc2_.getPlayers();
         var _loc4_:String = param1[1].toString().toLowerCase();
         var _loc5_:Player = null;
         for(_loc6_ in _loc3_)
         {
            _loc7_ = _loc3_[_loc6_] as Player;
            if(_loc7_.name.toLowerCase() == _loc4_)
            {
               _loc5_ = _loc7_;
               break;
            }
         }
         if(_loc5_ == null)
         {
            Global.base.SystemSay("Player not found.","* System");
            return;
         }
         if(param1.length == 2 || StringUtil.trim(param1[2].toString()) == "")
         {
            this.connection.send("say","/teleport " + _loc5_.name + " " + _loc2_.player.x / 16 + " " + _loc2_.player.y / 16);
         }
         else if(param1.length == 3 || StringUtil.trim(param1[3].toString()) == "")
         {
            _loc8_ = param1[2].toString().toLowerCase();
            _loc9_ = null;
            for(_loc10_ in _loc3_)
            {
               _loc11_ = _loc3_[_loc10_] as Player;
               if(_loc11_.name.toLowerCase() == _loc8_)
               {
                  _loc9_ = _loc11_;
                  break;
               }
            }
            if(_loc9_ == null)
            {
               Global.base.SystemSay("Target not found.","* System");
               return;
            }
            this.connection.send("say","/teleport " + _loc5_.name + " " + _loc9_.x / 16 + " " + _loc9_.y / 16);
         }
         else
         {
            _loc12_ = parseFloat(param1[2]);
            _loc13_ = parseFloat(param1[3]);
            if(isNaN(_loc12_) || isNaN(_loc13_))
            {
               Global.base.SystemSay("Invalid target.","* System");
               return;
            }
            this.connection.send("say","/teleport " + _loc5_.name + " " + _loc12_ + " " + _loc13_);
         }
      }
      
      public function toggleVisible(param1:Boolean) : void
      {
         this.visible = param1;
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Global.inGameSettings)
         {
            return;
         }
         this._keyDown[param1.keyCode] = true;
         if(param1.keyCode == 16)
         {
            Global.chatIsVisible = true;
         }
         if(param1.keyCode == 9)
         {
            if(this.bselector.visible)
            {
               this.bselector.cyclePagesAndTabs(Bl.isKeyDown(Keyboard.SHIFT) ? -1 : 1);
            }
            this.toggleMore(true);
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         }
         if(param1.keyCode == 70 && param1.ctrlKey)
         {
            if(Bl.data.canEdit)
            {
               this.toggleMore(true);
               stage.focus = this.bselector.search.textfield;
            }
         }
         if(param1.keyCode == 13 && !Config.isMobile || param1.keyCode == 191 || param1.keyCode == 8)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
            this.toggleChat(true,param1.keyCode == 8 ? "/pm " + (this.latestPM == "" ? "" : this.latestPM + " ") + " " : "");
         }
         if(param1.keyCode == 27 && !(Global.base.state as PlayState).isPlayerSpectating)
         {
            this.hideAll();
         }
         if(param1.altKey)
         {
            if(param1.keyCode >= 48 && param1.keyCode <= 57)
            {
               param1.preventDefault();
               param1.stopImmediatePropagation();
               param1.stopPropagation();
               this.connection.send("autosay",param1.keyCode - 48);
               this.toggleChat(false);
            }
         }
         if(param1.shiftKey && !param1.altKey && !param1.ctrlKey)
         {
            if(param1.keyCode >= 48 && param1.keyCode <= 57)
            {
               param1.preventDefault();
               param1.stopImmediatePropagation();
               param1.stopPropagation();
               _loc2_ = getTimer();
               if(_loc2_ - this.lastSmileyKeyTime >= 100)
               {
                  _loc3_ = param1.keyCode == 48 ? 9 : int(param1.keyCode - 49);
                  if(this.smileyMenu.hotbar.hotbarSmileys[_loc3_] != null)
                  {
                     this.setSelectedSmiley(this.smileyMenu.hotbar.hotbarSmileys[_loc3_]);
                     this.lastSmileyKeyTime = _loc2_;
                  }
               }
            }
         }
      }
      
      private function handleKeyUp(param1:KeyboardEvent) : void
      {
         if(Global.inGameSettings)
         {
            return;
         }
         this._keyDown[param1.keyCode] = false;
         if(param1.keyCode == 16)
         {
            Global.chatIsVisible = this.chatbtn.currentFrame != 1;
         }
      }
      
      public function tick() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Player = null;
         if(this.minimapEnabled && KeyBinding.minimap.isJustPressed())
         {
            this.toggleMinimap(this.toggleminimap.currentFrame == 1);
         }
         if(this.specialproperties != null && Boolean(Bl.data.showingproperties))
         {
            _loc1_ = (KeyBinding.decrement.isDown() ? -1 : 0) + (KeyBinding.increment.isDown() ? 1 : 0);
            if(_loc1_ != this.lastIncrementDir)
            {
               this.lastIncrementTime = int.MIN_VALUE;
               this.lastIncrementDir = _loc1_;
            }
            if(_loc1_ != 0)
            {
               _loc2_ = getTimer();
               if(_loc2_ - this.lastIncrementTime > 500)
               {
                  if(_loc1_ > 0)
                  {
                     this.specialproperties.incrementValue(1);
                  }
                  else
                  {
                     this.specialproperties.decrementValue(1);
                  }
                  if(this.lastIncrementTime == int.MIN_VALUE)
                  {
                     this.lastIncrementTime = _loc2_;
                  }
               }
            }
            else
            {
               this.lastIncrementTime = int.MIN_VALUE;
            }
         }
         if(!this.bselector.visible && KeyBinding.blockbar.isJustPressed())
         {
            this.toggleMore(true);
         }
         else if(this.bselector.visible && KeyBinding.blockbar.isJustReleased())
         {
            this.toggleMore(false);
         }
         if(KeyBinding.chat.isJustReleased())
         {
            this.toggleChat(true);
         }
         if(KeyBinding.modmode.isJustPressed())
         {
            _loc3_ = (this.base.state as PlayState).player;
            if(Player.isStaffMember(_loc3_.name))
            {
               if(_loc3_.isInGodMode)
               {
                  this.connection.send("god",false);
               }
               this.connection.send("mod");
            }
         }
      }
   }
}


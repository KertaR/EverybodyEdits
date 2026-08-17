package states
{
   import animations.AnimatedSprite;
   import animations.AnimationManager;
   import blitter.Bl;
   import blitter.BlContainer;
   import blitter.BlObject;
   import blitter.BlockSprite;
   import blitter.BlSprite;
   import blitter.BlState;
   import blitter.BlText;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import flash.display.BitmapData;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import io.player.tools.Badwords;
   import items.ItemId;
   import items.ItemManager;
   import playerio.Connection;
   import playerio.Message;
   import sounds.SoundId;
   import sounds.SoundManager;
   import ui.BrickContainer;
   import ui.ConfirmPrompt;
   import ui.DebugStats;
   import ui.Tile;
   import ui.chat.UserlistItem;
   import utilities.MathUtil;
   
   public class PlayState extends BlState
   {
      
      private static var DeathIcon:Class = PlayState_DeathIcon;
      
      private static var deathIconBMD:BitmapData = new DeathIcon().bitmapData;
      
      public var player:Me;
      
      public var world:World;
      
      protected var connection:Connection;
      
      protected var players:Object;
      
      public var minimap:MiniMap;
      
      protected var totalCoins:int = 0;
      
      protected var bonusCoins:int = 0;
      
      protected var gravityMultiplier:Number = 1;
      
      protected var cointext:BlText;
      
      protected var cointextcontainer:BlContainer;
      
      protected var worldowner:String;
      
      protected var saidOver9000:Boolean = false;
      
      private var touchCooldown:int = 100;
      
      public var lastframe:BitmapData;
      
      public var unsavedChanges:Boolean = false;
      
      private var spectatingText:BlText;
      
      private var stopSpectatingText:BlText;
      
      protected var particles:Array;
      
      protected var bcointext:BlText;
      
      protected var bcointextcontainer:BlContainer;
      
      protected var rw:int = 0;
      
      protected var rh:int = 0;
      
      protected var deathcounttext:BlText;
      
      protected var deathcountcontainer:BlContainer;
      
      protected var eraserLayerLock:int;
      
      protected var confirm:ConfirmPrompt;
      
      private var lastRetry:int = -1;
      
      private var clips:Dictionary;
      
      private var queue:Array;
      
      private var keysquene:Array;
      
      private var tilequeue:Array;
      
      private var pastX:uint = 0;
      
      private var pastY:uint = 0;
      
      private var pastT:Number;
      
      private var chatTime:Number;
      
      private var starty:Number = 0;
      
      private var startx:Number = 0;
      
      private var endy:Number = 0;
      
      private var endx:Number = 0;
      
      private var fPid_:int = 1000000;
      
      private var lockPlacement:Boolean = false;
      
      private var _isPlayerSpectating:Boolean = false;
      
      public function PlayState(param1:Connection, param2:Message, param3:int, param4:String, param5:int, param6:int, param7:int, param8:Boolean, param9:int, param10:int, param11:uint, param12:String, param13:int, param14:int, param15:Number, param16:uint, param17:Boolean, param18:ByteArray)
      {
         var activeOrangeSwitches:Array;
         var i:int;
         var tcoin:BlSprite;
         var btcoin:BlSprite;
         var skull:BlSprite;
         var s:PlayState = null;
         var shadowDebug:Boolean = false;
         var history:Array = null;
         var info:Object = null;
         var c:Connection = param1;
         var m:Message = param2;
         var myid:int = param3;
         var name:String = param4;
         var face:int = param5;
         var aura:int = param6;
         var auraColor:int = param7;
         var smileyGoldBorder:Boolean = param8;
         var x:int = param9;
         var y:int = param10;
         var ChatColor:uint = param11;
         var badge:String = param12;
         var rw:int = param13;
         var rh:int = param14;
         var gravityMultiplier:Number = param15;
         var bgColor:uint = param16;
         var isCrewMember:Boolean = param17;
         var orangeSwitches:ByteArray = param18;
         this.players = {};
         this.cointextcontainer = new BlContainer();
         this.particles = [];
         this.bcointextcontainer = new BlContainer();
         this.deathcountcontainer = new BlContainer();
         this.clips = new Dictionary();
         this.queue = [];
         this.keysquene = [];
         this.tilequeue = [];
         this.pastT = new Date().time;
         this.chatTime = new Date().time;
         super();
         Global.cachedImages = new Vector.<ImageBlock>();
         if((Global.roomid.indexOf("PW") == 0 || Global.roomid.indexOf("BW") == 0) && !Config.disableCookie)
         {
            history = [];
            if(Global.cookie.data.history != null)
            {
               history = Global.cookie.data.history;
            }
            info = {
               "id":Global.roomid,
               "name":Global.currentLevelname,
               "time":new Date()
            };
            history.reverse();
            history.push(info);
            history.reverse();
            if(history.length > Global.base.settings.historyLimit)
            {
               history = history.slice(0,Global.base.settings.historyLimit);
            }
            Global.cookie.data.history = history;
            if(!Global.noSave)
            {
               Global.cookie.flush();
            }
         }
         if(Config.forceKongregate)
         {
            Global.playing_on_kongregate = true;
         }
         this.rw = width;
         this.rh = height;
         this.connection = c;
         this.gravityMultiplier = gravityMultiplier;
         this.world = new World();
         this.world.deserializeFromMessage(rw,rh,m);
         this.world.setBackgroundColor(bgColor);
         add(this.world);
         this.world.orangeSwitches = {};
         activeOrangeSwitches = this.getIntArrayFromVarint(orangeSwitches);
         i = 0;
         while(i < activeOrangeSwitches.length)
         {
            this.world.orangeSwitches[activeOrangeSwitches[i]] = true;
            i++;
         }
         this.totalCoins = this.world.getTypeCount(100);
         this.bonusCoins = this.world.getTypeCount(101);
         this.player = new Me(this.world,name,c,this);
         this.player.worldGravityMultiplier = gravityMultiplier;
         this.player.x = x;
         this.player.y = y;
         this.player.frame = face;
         this.player.aura = aura;
         this.player.auraColor = auraColor;
         if(Global.playerObject != null)
         {
            Global.playerObject.smiley = face;
            Global.playerObject.aura = aura;
            Global.playerObject.auraColor = auraColor;
         }
         this.player.isgoldmember = Global.playerObject.goldmember;
         if(ChatColor != 0)
         {
            this.player.nameColor = ChatColor;
         }
         this.player.wearsGoldSmiley = smileyGoldBorder;
         this.player.badge = badge;
         this.player.isCrewMember = isCrewMember;
         this.x = -x;
         this.y = -y;
         add(this.player);
         Global.playerInstance = this.player;
         this.world.setPlayer(this.player);
         target = this.player;
         Bl.data.npc_name = this.player.name;
         if(Global.roomid == "PWhhGENdqja0I")
         {
            this.addFakePlayer(16,0,"mrvoid",-(13.2 * 16),-(9.2 * 16),false,true,Config.admin_color);
         }
         if(Global.roomid == "PWZsXY5zABcUI")
         {
            this.addFakePlayer(85,0,"firedemon",59 * 16,26 * 16,false,false,Config.default_color);
            this.addFakePlayer(181,0,"golem",101 * 16,58 * 16,false,false,Config.default_color);
            this.addFakePlayer(133,0,"raindrop",143 * 16,90 * 16,false,false,Config.default_color);
            this.addFakePlayer(141,0,"seagull",185 * 16,122 * 16,false,false,Config.default_color);
            this.addFakePlayer(70,0,"alien",227 * 16,24 * 16,false,false,Config.default_color);
            this.addFakePlayer(71,0,"astronaut",227 * 16,58 * 16,false,false,Config.default_color);
            this.addFakePlayer(9,11,"galaxy",259 * 16,107 * 16,true,false,Config.default_color);
         }
         this.player.hitmap = this.world;
         this.minimap = new MiniMap(this.world,rw,rh);
         Global.myId = myid;
         this.cointext = new BlText(12,100,16777215,"right");
         this.cointext.x = 523;
         this.cointext.y = 20;
         this.cointextcontainer.add(this.cointext);
         this.bcointext = new BlText(12,100,16777215,"right");
         this.bcointext.x = 523;
         this.bcointext.y = 20;
         this.bcointextcontainer.add(this.bcointext);
         this.deathcounttext = new BlText(12,100,16777215,"right");
         this.deathcounttext.x = 523;
         this.deathcounttext.y = 20;
         this.deathcountcontainer.add(this.deathcounttext);
         this.spectatingText = new BlText(12,300,16777215,"center","system");
         this.spectatingText.x = 197;
         this.spectatingText.y = 4;
         this.stopSpectatingText = new BlText(12,300,16777215,"center","system");
         this.stopSpectatingText.x = 197;
         this.stopSpectatingText.y = 450;
         this.stopSpectatingText.text = "Click anywhere to stop spectating";
         tcoin = BlSprite.createFromBitmapData(ItemManager.getBrickPackageByName("coins").bricks[0].bmd);
         tcoin.x = 626 - 4;
         tcoin.y = 24 - 3;
         this.cointextcontainer.add(tcoin);
         btcoin = BlSprite.createFromBitmapData(ItemManager.getBrickPackageByName("coins").bricks[1].bmd);
         btcoin.x = 626 - 4;
         btcoin.y = 24 - 3;
         this.bcointextcontainer.add(btcoin);
         skull = BlSprite.createFromBitmapData(deathIconBMD);
         skull.x = 626 - 2;
         skull.y = 24 - 3;
         this.deathcountcontainer.add(skull);
         s = this;
         shadowDebug = Config.enableDebugShadow;
         Global.debug_stats = new DebugStats(this);
         Global.base.overlayContainer.addChild(Global.debug_stats);
         Global.debug_stats.visible = false;
         this.connection.addMessageHandler("m",function(param1:Message, param2:int, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Boolean, param12:Boolean):void
         {
            if(param2 == myid && !shadowDebug)
            {
               return;
            }
            var _loc13_:Player = players[param2] as Player;
            if(!_loc13_ && shadowDebug)
            {
               _loc13_ = new Player(world,"shadow",false,connection,s);
               players[param2] = _loc13_;
               addBefore(_loc13_,player);
            }
            if(!_loc13_)
            {
               return;
            }
            _loc13_.x = param3;
            _loc13_.y = param4;
            _loc13_.speedX = param5;
            _loc13_.speedY = param6;
            _loc13_.modifierX = param7;
            _loc13_.modifierY = param8;
            _loc13_.horizontal = param9;
            _loc13_.vertical = param10;
            _loc13_.isDead = false;
            _loc13_.spacedown = param11;
            _loc13_.spacejustdown = param12;
            if(param12)
            {
               _loc13_.lastJump = -new Date().time;
            }
            if(!_loc13_.hasLevitation)
            {
               return;
            }
            if(param11)
            {
               _loc13_.applyThrust();
               _loc13_.isThrusting = true;
            }
            else
            {
               _loc13_.isThrusting = false;
            }
         });
         this.connection.addMessageHandler("add",function(param1:Message, param2:int, param3:String, param4:String, param5:int, param6:Number, param7:Number, param8:Boolean, param9:Boolean, param10:Boolean, param11:int, param12:int, param13:int, param14:Boolean, param15:Boolean, param16:Boolean, param17:int, param18:int, param19:int, param20:uint, param21:String, param22:Boolean, param23:ByteArray, param24:Boolean = false, param25:Boolean = false):void
         {
            var _loc26_:Player = players[param2] as Player;
            if(_loc26_)
            {
               return;
            }
            _loc26_ = new Player(world,param3,false,null,s);
            _loc26_.id = param2;
            _loc26_.connectedUserId = param4;
            players[param2] = _loc26_;
            _loc26_.isInGodMode = param8;
            _loc26_.isInModMode = param9;
            _loc26_.worldGravityMultiplier = gravityMultiplier;
            _loc26_.x = Math.min(param6,(rw - 2) * 16);
            _loc26_.y = Math.min(param7,(rh - 2) * 16);
            _loc26_.frame = param5;
            _loc26_.aura = param18;
            _loc26_.auraColor = param19;
            _loc26_.coins = param11;
            _loc26_.bcoins = param12;
            _loc26_.deaths = param13;
            _loc26_.isgoldmember = param15;
            _loc26_.wearsGoldSmiley = param16;
            _loc26_.team = param17;
            _loc26_.canToggleGodMode = param25;
            _loc26_.render = Bl.data.showPlayer;
            var _loc27_:Boolean = param3.indexOf("-") != -1;
            var _loc28_:Number = 13421772;
            if(!param10)
            {
               _loc28_ = 11184810;
            }
            if(_loc27_)
            {
               _loc28_ = 6710886;
            }
            if(param14)
            {
               _loc28_ = Config.friend_color;
            }
            if(param20 != 0)
            {
               _loc28_ = param20;
            }
            if(Player.getNameColor(_loc26_.name) != Config.default_color)
            {
               _loc28_ = Player.getNameColor(_loc26_.name);
            }
            _loc26_.nameColor = _loc28_;
            _loc26_.canEdit = param24;
            _loc26_.badge = param21;
            _loc26_.isCrewMember = param22;
            _loc26_.switches = {};
            var _loc29_:Array = getIntArrayFromVarint(param23);
            var _loc30_:int = 0;
            while(_loc30_ < _loc29_.length)
            {
               _loc26_.switches[_loc29_[_loc30_]] = true;
               _loc30_++;
            }
            addBefore(_loc26_,player);
            if(Global.mutedPlayersIds.indexOf(param4) != -1)
            {
               connection.send("say","/mute " + param3);
            }
         });
         this.connection.addMessageHandler("k",function(param1:Message, param2:int):void
         {
            var _loc3_:String = null;
            var _loc4_:Player = null;
            player.hascrown = param2 == myid;
            for(_loc3_ in players)
            {
               _loc4_ = players[_loc3_] as Player;
               _loc4_.hascrown = parseInt(_loc3_) == param2;
            }
            checkCrown(param2 == myid);
         });
         this.connection.addMessageHandler("ks",function(param1:Message, param2:int):void
         {
            var _loc3_:String = null;
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               player.hascrownsilver = true;
               checkSilverCrown(true);
            }
            else
            {
               for(_loc3_ in players)
               {
                  _loc4_ = players[_loc3_] as Player;
                  if(parseInt(_loc3_) == param2)
                  {
                     _loc4_.hascrownsilver = true;
                  }
               }
            }
         });
         this.connection.addMessageHandler("c",function(param1:Message, param2:String, param3:int, param4:int):void
         {
            var _loc5_:Player = players[param2];
            if(!_loc5_)
            {
               return;
            }
            _loc5_.coins = param3;
            _loc5_.bcoins = param4;
         });
         this.connection.addMessageHandler("favorited",function(param1:Message):void
         {
            SoundManager.playMiscSound(SoundId.FAVORITE);
            doAnim(player,"favorite");
         });
         this.connection.addMessageHandler("liked",function(param1:Message):void
         {
            SoundManager.playMiscSound(SoundId.LIKE);
            doAnim(player,"like");
         });
         this.connection.addMessageHandler("unfavorited",function(param1:Message):void
         {
            SoundManager.playMiscSound(SoundId.UNFAVORITE);
         });
         this.connection.addMessageHandler("unliked",function(param1:Message):void
         {
            SoundManager.playMiscSound(SoundId.UNLIKE);
         });
         this.connection.addMessageHandler("b",function(param1:Message, param2:int, param3:int, param4:int, param5:int, param6:int = -1):void
         {
            Global.log("b handler: layer=" + param2 + " x=" + param3 + " y=" + param4 + " blockId=" + param5 + " pid=" + param6);
            setTile(param2,param3,param4,param5,{});
            setBlockPlayerData(param3,param4,param2,param6);
         });
         this.connection.addMessageHandler("bc",function(param1:Message, param2:int, param3:int, param4:int, param5:int, param6:int = -1):void
         {
            setTile(0,param2,param3,param4,{"goal":param5});
            setBlockPlayerData(param2,param3,0,param6);
         });
         this.connection.addMessageHandler("pt",function(param1:Message, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int = -1):void
         {
            setTile(0,param2,param3,param4,{
               "rotation":param5,
               "id":param6,
               "target":param7
            });
            setBlockPlayerData(param2,param3,0,param8);
         });
         this.connection.addMessageHandler("wp",function(param1:Message, param2:int, param3:int, param4:int, param5:String, param6:int, param7:int = -1):void
         {
            setTile(0,param2,param3,param4,{
               "target":param5,
               "spawnid":param6
            });
            setBlockPlayerData(param2,param3,0,param7);
         });
         this.connection.addMessageHandler("br",function(param1:Message, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int = -1):void
         {
            setTile(param6,param2,param3,param4,{"rotation":param5});
            setBlockPlayerData(param2,param3,param6,param7);
         });
         this.connection.addMessageHandler("lb",function(param1:Message, param2:int, param3:int, param4:int, param5:String, param6:String, param7:int, param8:int = -1):void
         {
            setTile(0,param2,param3,param4,{
               "text":param5,
               "text_color":param6,
               "wraplength":param7
            });
            setBlockPlayerData(param2,param3,0,param8);
         });
         this.connection.addMessageHandler("ts",function(param1:Message, param2:int, param3:int, param4:int, param5:String, param6:int, param7:int = -1):void
         {
            setTile(0,param2,param3,param4,{
               "text":param5,
               "signtype":param6
            });
            setBlockPlayerData(param2,param3,0,param7);
         });
         this.connection.addMessageHandler("bs",function(param1:Message, param2:int, param3:int, param4:int, param5:int, param6:int = -1):void
         {
            setTile(0,param2,param3,param4,{"sound":param5});
            setBlockPlayerData(param2,param3,0,param6);
         });
         this.connection.addMessageHandler("bn",function(param1:Message, param2:int, param3:int, param4:int, param5:String, param6:String, param7:String, param8:String, param9:int = -1):void
         {
            setTile(0,param2,param3,param4,{
               "name":param5,
               "messages":new Array(param6,param7,param8)
            });
            setBlockPlayerData(param2,param3,0,param9);
         });
         this.connection.addMessageHandler("fill",function(param1:Message, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int):void
         {
            var _loc9_:int = 0;
            var _loc8_:int = param4;
            while(_loc8_ <= param6)
            {
               _loc9_ = param5;
               while(_loc9_ <= param6)
               {
                  setTile(param3,_loc8_,_loc9_,param2,{});
                  setBlockPlayerData(_loc8_,_loc9_,param3,-1);
                  _loc9_++;
               }
               _loc8_++;
            }
         });
         this.connection.addMessageHandler("left",function(param1:Message, param2:int):void
         {
            var _loc3_:Player = players[param2];
            if(!_loc3_)
            {
               return;
            }
            if(_loc3_ == target)
            {
               stopSpectating();
            }
            Global.base.ui2instance.hidePlayerActions(_loc3_.name);
            delete players[param2];
            remove(_loc3_);
         });
         this.connection.addMessageHandler("god",function(param1:Message, param2:int, param3:Boolean):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               _loc4_ = player;
            }
            else
            {
               _loc4_ = players[param2] as Player;
            }
            if(!_loc4_)
            {
               return;
            }
            _loc4_.isInGodMode = param3;
            _loc4_.resetDeath();
            if(param2 == myid)
            {
               world.setShowAllSecrets(param3);
            }
         });
         this.connection.addMessageHandler("toggleGod",function(param1:Message, param2:int, param3:Boolean):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               _loc4_ = player;
            }
            else
            {
               _loc4_ = players[param2] as Player;
            }
            if(!_loc4_)
            {
               return;
            }
            _loc4_.canToggleGodMode = param3;
            if(!param3)
            {
               _loc4_.isInGodMode = false;
            }
         });
         this.connection.addMessageHandler("toggleMap",function(param1:Message, param2:Boolean):void
         {
            Global.base.ui2instance.playerMapEnabled = param2;
            Global.base.ui2instance.configureInterface();
         });
         this.connection.addMessageHandler("access",function(param1:Message):void
         {
            player.canEdit = true;
            Bl.data.canEdit = true;
            if(Global.base.ui2instance)
            {
               Global.base.ui2instance.configureInterface();
            }
         });
         this.connection.addMessageHandler("lostaccess",function(param1:Message):void
         {
            player.isInGodMode = false;
            player.canEdit = false;
            player.canToggleGodMode = false;
            Bl.data.canEdit = false;
            Bl.data.canToggleGodMode = false;
            if(Global.base.ui2instance)
            {
               Global.base.ui2instance.configureInterface();
            }
         });
         this.connection.addMessageHandler("editRights",function(param1:Message, param2:int, param3:Boolean):void
         {
            var _loc4_:Player = players[param2] as Player;
            if(!_loc4_)
            {
               return;
            }
            _loc4_.canEdit = param3;
            if(!param3)
            {
               _loc4_.canToggleGodMode = false;
            }
            if(param2 == myid)
            {
               player.canEdit = param3;
               Bl.data.canEdit = param3;
               if(!param3)
               {
                  player.isInGodMode = false;
                  player.canToggleGodMode = false;
                  Bl.data.canToggleGodMode = false;
               }
               if(Global.base.ui2instance)
               {
                  Global.base.ui2instance.configureInterface();
               }
            }
         });
         this.connection.addMessageHandler("mod",function(param1:Message, param2:int, param3:Boolean):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               _loc4_ = player;
            }
            else
            {
               _loc4_ = players[param2] as Player;
            }
            if(!_loc4_)
            {
               return;
            }
            _loc4_.isInModMode = param3;
            _loc4_.resetDeath();
         });
         this.connection.addMessageHandler("say",function(param1:Message, param2:int, param3:String):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               _loc4_ = player;
            }
            else
            {
               _loc4_ = players[param2] as Player;
            }
            if(_loc4_)
            {
               _loc4_.say(param3);
            }
         });
         this.connection.addMessageHandler("autotext",function(param1:Message, param2:int, param3:String):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               _loc4_ = player;
            }
            else
            {
               _loc4_ = players[param2] as Player;
            }
            if(_loc4_)
            {
               _loc4_.say(param3);
            }
         });
         this.connection.addMessageHandler("smiley",function(param1:Message, param2:int, param3:int):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               _loc4_ = player;
            }
            else
            {
               _loc4_ = players[param2] as Player;
            }
            if(_loc4_)
            {
               _loc4_.frame = param3;
            }
         });
         this.connection.addMessageHandler("face",function(param1:Message, param2:int, param3:int):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               _loc4_ = player;
            }
            else
            {
               _loc4_ = players[param2] as Player;
            }
            if(_loc4_)
            {
               _loc4_.frame = param3;
            }
         });
         this.connection.addMessageHandler("aura",function(param1:Message, param2:int, param3:int, param4:int):void
         {
            var _loc5_:Player = null;
            if(param2 == myid)
            {
               _loc5_ = player;
            }
            else
            {
               _loc5_ = players[param2] as Player;
            }
            if(!_loc5_)
            {
               return;
            }
            _loc5_.aura = param3;
            _loc5_.auraColor = param4;
         });
         this.connection.addMessageHandler("smileyGoldBorder",function(param1:Message, param2:int, param3:Boolean):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               player.wearsGoldSmiley = param3;
               Global.base.ui2instance.smileyMenu.updateAllSmileyBorders();
            }
            else
            {
               _loc4_ = players[param2] as Player;
               if(_loc4_)
               {
                  _loc4_.wearsGoldSmiley = param3;
               }
            }
         });
         this.connection.addMessageHandler("ps",function(param1:Message, param2:int, param3:int, param4:int, param5:Boolean):void
         {
            var _loc6_:Player = null;
            if(param2 == myid)
            {
               return;
            }
            if(param3 == 0)
            {
               _loc6_ = players[param2] as Player;
               if(_loc6_ != null)
               {
                  _loc6_.pressPurpleSwitch(param4,param5);
               }
            }
            else if(param3 == 1)
            {
               pressOrangeSwitch(param4,param5);
            }
         });
         this.connection.addMessageHandler("hide",function(param1:Message):void
         {
            var _loc3_:String = null;
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1.getString(_loc2_);
               switch(_loc3_)
               {
                  case "red":
                  case "green":
                  case "blue":
                  case "cyan":
                  case "magenta":
                  case "yellow":
                     switchKey(_loc3_,true);
                     break;
                  case "timedoor":
                     world.setTimedoor(true);
               }
               _loc2_++;
            }
         });
         this.connection.addMessageHandler("show",function(param1:Message):void
         {
            var _loc3_:String = null;
            var _loc2_:int = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1.getString(_loc2_);
               switch(_loc3_)
               {
                  case "red":
                  case "green":
                  case "blue":
                  case "cyan":
                  case "magenta":
                  case "yellow":
                     switchKey(_loc3_,false);
                     break;
                  case "timedoor":
                     world.setTimedoor(false);
               }
               _loc2_++;
            }
         });
         this.connection.addMessageHandler("reset",function(param1:Message):void
         {
            world.removeAllLabels();
            tilequeue = [];
            var _loc2_:Array = world.deserializeFromMessage(rw,rh,param1);
            world.setMapArray(_loc2_);
            world.lookup.resetSecrets();
            minimap.reset(world);
            _loc2_ = [];
            player.coins = 0;
            player.bcoins = 0;
            player.deaths = 0;
            player.respawn();
            totalCoins = world.getTypeCount(100);
            bonusCoins = world.getTypeCount(101);
            unsavedChanges = false;
         });
         this.connection.addMessageHandler("clear",function(param1:Message, param2:int, param3:int, param4:int = 9, param5:int = 0):void
         {
            var _loc8_:int = 0;
            var _loc9_:int = 0;
            world.removeAllLabels();
            tilequeue = [];
            var _loc6_:Array = [];
            var _loc7_:int = 0;
            while(_loc7_ < 2)
            {
               _loc6_[_loc7_] = [];
               _loc8_ = 0;
               while(_loc8_ < param3)
               {
                  _loc6_[_loc7_][_loc8_] = [];
                  _loc9_ = 0;
                  while(_loc9_ < param2)
                  {
                     _loc6_[_loc7_][_loc8_][_loc9_] = param5;
                     _loc9_++;
                  }
                  _loc8_++;
               }
               _loc7_++;
            }
            _loc8_ = 0;
            while(_loc8_ < rh)
            {
               _loc6_[0][_loc8_][0] = param4;
               _loc6_[0][_loc8_][rw - 1] = param4;
               _loc8_++;
            }
            _loc8_ = 0;
            while(_loc8_ < rw)
            {
               _loc6_[0][0][_loc8_] = param4;
               _loc6_[0][rh - 1][_loc8_] = param4;
               _loc8_++;
            }
            totalCoins = 0;
            bonusCoins = 0;
            player.coins = 0;
            player.bcoins = 0;
            player.deaths = 0;
            world.setMapArray(_loc6_);
            minimap.reset(world);
            _loc6_ = [];
            world.lookup.reset();
            world.orangeSwitches = new ByteArray();
         });
         this.connection.addMessageHandler("resetGlobalSwitches",function():void
         {
            world.orangeSwitches = new ByteArray();
         });
         this.connection.addMessageHandler("refreshshop",function():void
         {
            Global.base.refresShop();
         });
         this.connection.addMessageHandler("tele",function(param1:Message):void
         {
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc7_:int = 0;
            var _loc8_:int = 0;
            var _loc9_:Player = null;
            var _loc2_:Boolean = param1.getBoolean(0);
            var _loc3_:Boolean = param1.getBoolean(1);
            if(_loc3_)
            {
               world.orangeSwitches = new ByteArray();
            }
            var _loc4_:int = 2;
            while(_loc4_ < param1.length)
            {
               _loc5_ = param1.getInt(_loc4_);
               _loc6_ = param1.getInt(_loc4_ + 1);
               _loc7_ = param1.getInt(_loc4_ + 2);
               _loc8_ = param1.getInt(_loc4_ + 3);
               _loc9_ = players[_loc5_];
               if(_loc9_ != null)
               {
                  _loc9_.x = _loc6_;
                  _loc9_.y = _loc7_;
                  _loc9_.deaths = _loc8_;
                  _loc9_.respawn();
                  if(_loc2_)
                  {
                     _loc9_.hascrown = false;
                     _loc9_.hascrownsilver = false;
                     _loc9_.resetCoins();
                     _loc9_.switches = {};
                     _loc9_.resetEffects();
                     _loc9_.team = 0;
                     (Global.base.sidechat.names[_loc9_.name] as UserlistItem).setTeam(0);
                     _loc9_.resetCheckpoint();
                  }
               }
               if(_loc5_ == myid)
               {
                  if(!isPlayerSpectating)
                  {
                     offset(player.x - _loc6_,player.y - _loc7_);
                  }
                  player.x = _loc6_;
                  player.y = _loc7_;
                  player.deaths = _loc8_;
                  player.respawn();
                  if(_loc2_)
                  {
                     player.hascrown = false;
                     player.hascrownsilver = false;
                     player.collideWithSilverCrownDoorGate = false;
                     player.resetCoins();
                     player.switches = {};
                     player.resetEffects();
                     player.team = 0;
                     (Global.base.sidechat.names[player.name] as UserlistItem).setTeam(0);
                     player.resetCheckpoint();
                     if(world.getTile(0,_loc6_ >> 4,_loc7_ >> 4) != ItemId.WORLD_PORTAL_SPAWN)
                     {
                        player.ticks = 0;
                        Global.base.ui2instance.validRun = true;
                     }
                     player.completed = false;
                     world.resetCoins();
                     world.lookup.resetSecrets();
                     Global.base.ui2instance.playerMapEnabled = false;
                     Global.base.ui2instance.configureInterface();
                  }
               }
               _loc4_ += 4;
            }
         });
         this.connection.addMessageHandler("kill",function(param1:Message, param2:int):void
         {
            var _loc4_:Player = null;
            var _loc3_:Player = player;
            if(param2 != myid)
            {
               _loc4_ = players[param2] as Player;
               if(!_loc4_)
               {
                  return;
               }
               _loc3_ = _loc4_;
            }
            if(!_loc3_.isFlying)
            {
               _loc3_.killPlayer();
            }
         });
         this.connection.addMessageHandler("teleport",function(param1:Message, param2:int, param3:Number, param4:Number):void
         {
            var _loc5_:Player = null;
            if(param2 == myid)
            {
               player.setPosition(param3,param4);
            }
            else
            {
               _loc5_ = players[param2] as Player;
               if(_loc5_)
               {
                  _loc5_.setPosition(param3,param4);
               }
            }
         });
         this.connection.addMessageHandler("backgroundColor",function(param1:Message, param2:uint):void
         {
            var _loc3_:Boolean = false;
            var _loc4_:int = 0;
            if(Bl.data.canChangeWorldOptions)
            {
               _loc3_ = (param2 >> 24 & 0xFF) == 255;
               Global.backgroundEnabled = _loc3_;
               Global.bgColor = param2;
               if(Global.base.ui2instance.settingsMenu.levelOptions != null)
               {
                  Global.base.ui2instance.settingsMenu.levelOptions.backgroundColorSelector.handleBackgroundChange(param1,param2);
               }
               else if(Global.cookie.data.previousColors.indexOf(param2) == -1)
               {
                  Global.cookie.data.previousColors.push(param2);
                  _loc4_ = 1;
                  while(_loc4_ < 5)
                  {
                     Global.cookie.data.previousColors[_loc4_] = Global.cookie.data.previousColors[_loc4_ + 1];
                     _loc4_++;
                  }
                  Global.cookie.data.previousColors.length = 4;
               }
            }
            world.setBackgroundColor(param2);
            minimap.reset(world);
         });
         this.connection.addMessageHandler("effect",function(param1:Message, param2:int, param3:int, param4:Boolean = true, param5:int = 0, param6:int = 0):void
         {
            var _loc7_:Player = null;
            if(param2 == myid)
            {
               player.setEffect(param3,param4,param5,param6);
            }
            else
            {
               _loc7_ = players[param2] as Player;
               if(_loc7_)
               {
                  _loc7_.setEffect(param3,param4,param5,param6);
               }
            }
         });
         this.connection.addMessageHandler("team",function(param1:Message, param2:int, param3:int):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               player.team = param3;
               (Global.base.sidechat.names[player.name] as UserlistItem).setTeam(param3);
            }
            else
            {
               _loc4_ = players[param2] as Player;
               if(_loc4_)
               {
                  _loc4_.team = param3;
                  (Global.base.sidechat.names[_loc4_.name] as UserlistItem).setTeam(param3);
               }
            }
         });
         this.connection.addMessageHandler("muted",function(param1:Message, param2:int, param3:Boolean):void
         {
            var _loc4_:Player = players[param2] as Player;
            if(!_loc4_)
            {
               return;
            }
            _loc4_.muted = param3;
            var _loc5_:int = Global.mutedPlayersIds.indexOf(_loc4_.connectedUserId);
            if(param3 && _loc5_ == -1)
            {
               Global.mutedPlayersIds.push(_loc4_.connectedUserId);
            }
            else if(_loc5_ != -1)
            {
               Global.mutedPlayersIds.splice(_loc5_,1);
            }
         });
         this.connection.addMessageHandler("badgeChange",function(param1:Message, param2:int, param3:String):void
         {
            var _loc4_:Player = null;
            if(param2 == myid)
            {
               player.badge = param3;
            }
            else
            {
               _loc4_ = players[param2] as Player;
               if(_loc4_)
               {
                  _loc4_.badge = param3;
               }
            }
         });
         this.connection.addMessageHandler("restoreProgress",function(param1:Message, param2:int, param3:Number, param4:Number, param5:int, param6:int, param7:ByteArray, param8:ByteArray, param9:ByteArray, param10:ByteArray, param11:int, param12:uint, param13:uint, param14:ByteArray, param15:Number, param16:Number, param17:Boolean):void
         {
            var _loc18_:Boolean = param2 == myid;
            var _loc19_:Player = _loc18_ ? player : players[param2] as Player;
            if(!_loc19_)
            {
               return;
            }
            _loc19_.respawn();
            if(_loc18_ && !isPlayerSpectating)
            {
               offset(_loc19_.x - param3,_loc19_.y - param4);
            }
            _loc19_.x = param3;
            _loc19_.y = param4;
            _loc19_.coins = param5;
            _loc19_.bcoins = param6;
            _loc19_.deaths = param11;
            _loc19_.checkpoint_x = param12;
            _loc19_.checkpoint_y = param13;
            _loc19_.switches = {};
            var _loc20_:Array = getIntArrayFromVarint(param14);
            var _loc21_:int = 0;
            while(_loc21_ < _loc20_.length)
            {
               _loc19_.switches[_loc20_[_loc21_]] = true;
               _loc21_++;
            }
            _loc19_.speedX = param15;
            _loc19_.speedY = param16;
            _loc19_.isInGodMode = param17;
            if(_loc18_)
            {
               restoreCoins(param7,param8,false);
               restoreCoins(param9,param10,true);
               world.setShowAllSecrets(param17);
            }
         });
         this.connection.addMessageHandler("images",function(param1:Message):void
         {
            var _loc4_:String = null;
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc2_:Array = new Array();
            var _loc3_:int = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = param1.getString(_loc3_);
               _loc5_ = param1.getInt(_loc3_ + 1);
               _loc6_ = param1.getInt(_loc3_ + 2);
               _loc2_.push(new ImageBlock(_loc4_,_loc5_,_loc6_));
               _loc3_ += 3;
            }
            world.imageBlocks = _loc2_;
         });
         this.connection.addMessageHandler("clip",function(param1:Message, param2:String):void
         {
            var sound:Sound = null;
            var m:Message = param1;
            var name:String = param2;
            if(!clips[name] && Global.base.settings.volume > 0)
            {
               SoundMixer.soundTransform = new SoundTransform(Global.base.settings.volume / 100);
               sound = new Sound();
               sound.load(new URLRequest(Config.site + "/Music/" + name));
               clips[name] = sound;
               sound.play().addEventListener(Event.SOUND_COMPLETE,function():void
               {
                  clips[name] = null;
               });
            }
         });
         this.connection.send("init2");
         Global.stage.frameRate = Config.maxFrameRate;
      }
      
      private function restoreCoins(param1:ByteArray, param2:ByteArray, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         param1.position = 0;
         param2.position = 0;
         while(param1.position < param1.length)
         {
            _loc4_ = (param1.readUnsignedByte() << 8) + param1.readUnsignedByte();
            _loc5_ = (param2.readUnsignedByte() << 8) + param2.readUnsignedByte();
            this.world.setTileComplex(0,_loc4_,_loc5_,param3 ? 111 : 110,null);
         }
      }
      
      public function updateMinimap(param1:int, param2:int) : void
      {
         this.minimap.updatePixel(param1,param2,this.world.getMinimapColor(param1,param2));
      }
      
      public function switchKey(param1:String, param2:Boolean) : void
      {
         this.world.setKey(param1,param2);
         if(this.world.overlaps(this.player))
         {
            this.world.setKey(param1,!param2);
            this.keysquene.push({
               "color":param1,
               "state":param2
            });
         }
      }
      
      public function pressOrangeSwitch(param1:int, param2:Boolean) : void
      {
         var i:int = 0;
         var switchId:int = param1;
         var enabled:Boolean = param2;
         if(switchId == 1000)
         {
            i = 0;
            while(i < 1000)
            {
               this.pressOrangeSwitch(i,enabled);
               i++;
            }
         }
         this.world.orangeSwitches[switchId] = enabled;
         if(this.world.overlaps(this.player))
         {
            this.world.orangeSwitches[switchId] = !enabled;
            this.queue.push(function():void
            {
               pressOrangeSwitch(switchId,enabled);
            });
         }
      }
      
      public function checkCrown(param1:Boolean) : void
      {
         var collide:Boolean = param1;
         this.player.collideWithCrownDoorGate = collide;
         if(this.world.overlaps(this.player))
         {
            this.player.collideWithCrownDoorGate = !collide;
            this.queue.push(function():void
            {
               checkCrown(collide);
            });
         }
      }
      
      public function checkSilverCrown(param1:Boolean) : void
      {
         var collide:Boolean = param1;
         this.player.collideWithSilverCrownDoorGate = collide;
         if(this.world.overlaps(this.player))
         {
            this.player.collideWithSilverCrownDoorGate = !collide;
            this.queue.push(function():void
            {
               checkSilverCrown(collide);
            });
         }
      }
      
      public function checkPurple() : void
      {
         this.world.canShowOrHidePurple = true;
         if(this.world.overlaps(this.player))
         {
            this.world.canShowOrHidePurple = false;
         }
      }
      
      public function setTile(param1:int, param2:int, param3:int, param4:int, param5:Object) : void
      {
         var _loc16_:Tile = null;
         var _loc17_:Player = null;
         var _loc6_:* = 0;
         while(_loc6_ < this.tilequeue.length)
         {
            _loc16_ = this.tilequeue[_loc6_] as Tile;
            if((this.tilequeue[_loc6_] as Tile).equals(new Tile(param1,param2,param3,param4,param5)))
            {
               this.tilequeue.splice(_loc6_,1);
               _loc6_--;
            }
            _loc6_++;
         }
         var _loc7_:int = this.world.getTile(param1,param2,param3);
         if(_loc7_ == param4 && _loc7_ != ItemId.COINDOOR && _loc7_ != ItemId.COINGATE && _loc7_ != ItemId.BLUECOINDOOR && _loc7_ != ItemId.BLUECOINGATE && _loc7_ != ItemId.PORTAL && _loc7_ != 77 && _loc7_ != 83 && _loc7_ != 1520 && _loc7_ != 1000 && _loc7_ != ItemId.SPIKE && _loc7_ != ItemId.SPIKE_SILVER && _loc7_ != ItemId.SPIKE_BLACK && _loc7_ != ItemId.SPIKE_RED && _loc7_ != ItemId.SPIKE_GOLD && _loc7_ != ItemId.SPIKE_GREEN && _loc7_ != ItemId.SPIKE_BLUE && _loc7_ != ItemId.WORLD_PORTAL && _loc7_ != ItemId.WORLD_PORTAL_SPAWN && _loc7_ != ItemId.PORTAL_INVISIBLE && _loc7_ != ItemId.SWITCH_PURPLE && _loc7_ != ItemId.RESET_PURPLE && _loc7_ != ItemId.DOOR_PURPLE && _loc7_ != ItemId.GATE_PURPLE && _loc7_ != ItemId.DEATH_DOOR && _loc7_ != ItemId.DEATH_GATE && _loc7_ != ItemId.EFFECT_TEAM && _loc7_ != ItemId.TEAM_DOOR && _loc7_ != ItemId.TEAM_GATE && _loc7_ != ItemId.EFFECT_CURSE && _loc7_ != ItemId.EFFECT_FLY && _loc7_ != ItemId.TEXT_SIGN && _loc7_ != ItemId.EFFECT_JUMP && _loc7_ != ItemId.EFFECT_PROTECTION && _loc7_ != ItemId
         .EFFECT_RUN && _loc7_ != ItemId.EFFECT_ZOMBIE && _loc7_ != ItemId.EFFECT_LOW_GRAVITY && _loc7_ != ItemId.EFFECT_MULTIJUMP && _loc7_ != ItemId.EFFECT_GRAVITY && _loc7_ != ItemId.EFFECT_POISON && _loc7_ != ItemId.SWITCH_ORANGE && _loc7_ != ItemId.RESET_ORANGE && _loc7_ != ItemId.DOOR_ORANGE && _loc7_ != ItemId.GATE_ORANGE && !ItemId.isBlockRotateable(_loc7_) && !ItemId.isBackgroundRotateable(_loc7_) && !ItemId.isNPC(_loc7_))
         {
            return;
         }
         var _loc8_:int = this.totalCoins;
         var _loc9_:int = this.player.coins;
         var _loc10_:int = this.bonusCoins;
         var _loc11_:int = this.player.bcoins;
         this.world.setTileComplex(param1,param2,param3,param4,param5);
         var _loc12_:Boolean = _loc7_ == 100 || _loc7_ == 110;
         var _loc13_:Boolean = param4 == 100 || param4 == 110;
         if(_loc13_)
         {
            if(!_loc12_)
            {
               ++this.totalCoins;
            }
            else
            {
               --this.player.coins;
            }
         }
         else if(_loc12_)
         {
            if(_loc7_ == 110)
            {
               --this.player.coins;
            }
            --this.totalCoins;
         }
         if(_loc7_ == ItemId.CHECKPOINT)
         {
            if(this.player.checkpoint_x == param2 && this.player.checkpoint_y == param3)
            {
               this.player.resetCheckpoint();
            }
            for each(_loc17_ in this.players)
            {
               if(_loc17_.checkpoint_x == param2 && _loc17_.checkpoint_y == param3)
               {
                  _loc17_.resetCheckpoint();
               }
            }
         }
         var _loc14_:Boolean = _loc7_ == 101 || _loc7_ == 111;
         var _loc15_:Boolean = param4 == 101 || param4 == 111;
         if(_loc15_)
         {
            if(!_loc14_)
            {
               ++this.bonusCoins;
            }
            else
            {
               --this.player.bcoins;
            }
         }
         else if(_loc14_)
         {
            if(_loc7_ == 111)
            {
               --this.player.bcoins;
            }
            --this.bonusCoins;
         }
         if(this.world.Overlaps(this.player,param2,param3))
         {
            this.totalCoins = _loc8_;
            this.bonusCoins = _loc10_;
            this.player.coins = _loc9_;
            this.player.bcoins = _loc11_;
            this.world.setTileComplex(param1,param2,param3,_loc7_,param5);
            this.tilequeue.push(new Tile(param1,param2,param3,param4,param5));
         }
         this.updateMinimap(param2,param3);
      }
      
      override public function enterFrame() : void
      {
         var _loc5_:Player = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Tile = null;
         super.enterFrame();
         Global.base.ui2instance.enterFrame();
         this.cointext.text = this.player.coins + "/" + this.totalCoins;
         this.bcointext.text = this.player.bcoins + "/" + this.bonusCoins;
         this.deathcounttext.text = this.player.deaths + "x";
         var _loc1_:Player = target as Player;
         if(_loc1_ != null)
         {
            this.spectatingText.text = "Spectating " + _loc1_.name.toUpperCase();
         }
         if(this.player.deaths > 9000 && !this.saidOver9000)
         {
            this.saidOver9000 = true;
            SoundManager.playMiscSound(SoundId.OVER9000);
         }
         var _loc2_:* = int(this.queue.length);
         while(_loc2_--)
         {
            this.queue.shift()();
         }
         var _loc3_:* = int(this.keysquene.length);
         while(_loc3_--)
         {
            _loc7_ = this.keysquene.shift();
            this.switchKey(_loc7_.color,_loc7_.state);
         }
         var _loc4_:* = int(this.tilequeue.length);
         while(_loc4_--)
         {
            _loc8_ = this.tilequeue.shift();
            this.setTile(_loc8_.layer,_loc8_.xo,_loc8_.yo,_loc8_.value,_loc8_.properties);
         }
         for each(_loc5_ in this.players)
         {
            this.minimap.showPlayer(_loc5_,_loc5_.minimapColor);
         }
         this.minimap.showPlayer(this.player,this.player.minimapColor);
         for(_loc6_ in this.players)
         {
            _loc5_ = this.players[_loc6_] as Player;
            _loc5_.enterChat();
         }
         this.player.enterChat();
      }
      
      override public function tick() : void
      {
         var old:Number;
         var oldb:Number;
         var oldd:Number;
         var i:int;
         var xo:int;
         var yo:int;
         var t:int = 0;
         var favBricks:BrickContainer = null;
         var id:int = 0;
         var pos:int = 0;
         var layer:int = 0;
         var determinedLayer:int = 0;
         var clicked:Boolean = false;
         var numberDown:int = 0;
         var dochange:Boolean = false;
         Global.base.ui2instance.tick();
         old = this.world.showCoinGate;
         this.world.showCoinGate = this.player.coins;
         if(this.world.overlaps(this.player))
         {
            this.world.showCoinGate = old;
         }
         oldb = this.world.showBlueCoinGate;
         this.world.showBlueCoinGate = this.player.bcoins;
         if(this.world.overlaps(this.player))
         {
            this.world.showBlueCoinGate = oldb;
         }
         oldd = this.world.showDeathGate;
         this.world.showDeathGate = this.player.deaths;
         if(this.world.overlaps(this.player))
         {
            this.world.showDeathGate = oldd;
         }
         i = 0;
         while(i < this.particles.length - 1)
         {
            if(this.particles[i] != null)
            {
               this.particles[i].tick();
               if(this.particles[i].life >= this.particles[i].maxlife)
               {
                  remove(this.particles[i]);
                  delete this.particles[i];
               }
            }
            i++;
         }
         if(!this.confirm)
         {
            if(KeyBinding.screenshot.isJustPressed())
            {
               this.confirm = new ConfirmPrompt("Do you want to make a screenshot?",false);
               this.confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  confirm.close();
                  Screenshot.SavePNG(param1);
               });
               this.confirm.onAnyClose = function():void
               {
                  confirm = null;
               };
               Global.base.showOnTop(this.confirm);
            }
            else if(KeyBinding.screenshotMinimap.isJustPressed() && Global.base.ui2instance.minimapEnabled)
            {
               this.confirm = new ConfirmPrompt("Do you want to save the minimap?",false);
               this.confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  confirm.close();
                  Screenshot.SavePNGWithMinimap(param1);
               });
               this.confirm.onAnyClose = function():void
               {
                  confirm = null;
               };
               Global.base.showOnTop(this.confirm);
            }
         }
         if(KeyBinding.download.isJustPressed())
         {
            if(!this.confirm && KeyBinding.download.isJustPressed())
            {
               this.confirm = new ConfirmPrompt("Do you want to download this level?",false);
               this.confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  confirm.close();
                  DownloadLevel.SaveLevel(param1);
               });
               this.confirm.onAnyClose = function():void
               {
                  confirm = null;
               };
               Global.base.showOnTop(this.confirm);
            }
         }
         if(KeyBinding.hideUsernames.isJustPressed())
         {
            Global.base.settings.hideUsernames = !Global.base.settings.hideUsernames;
            Global.base.SystemSay(Global.base.settings.hideUsernames ? "Usernames are now hidden." : "Usernames are now visible.","* System");
         }
         if(KeyBinding.hideChatBubbles.isJustPressed())
         {
            Global.base.settings.hideBubbles = !Global.base.settings.hideBubbles;
            Global.base.SystemSay(Global.base.settings.hideBubbles ? "Chat bubbles are now hidden." : "Chat bubbles are now visible.","* System");
         }
         if(KeyBinding.inspect.isJustPressed())
         {
            Global.getPlacer = !Global.getPlacer;
            Global.base.SystemSay("Inspect tool active: " + Global.getPlacer.toString().toUpperCase(),"* System");
         }
         if(KeyBinding.interact.isJustPressed())
         {
            if(this.player.currentNpc)
            {
               this.player.currentNpc.sayNext();
            }
         }
         if(Bl.isKeyJustPressed(119) && Bl.stage.displayState != StageDisplayState.NORMAL)
         {
            Bl.stage.scaleMode = Bl.stage.scaleMode == "exactFit" ? "showAll" : "exactFit";
            Global.base.SystemSay("Changed scalemode to \"" + (Bl.stage.scaleMode == "exactFit" ? "Exact Fit" : "Show All") + "\"","* System");
            Bl.stage.dispatchEvent(new Event(Event.RESIZE,false,false));
         }
         if(Player.isStaffMember(this.player.name))
         {
            if(KeyBinding.lookRight.isDown())
            {
               x += 15;
            }
            if(KeyBinding.lookLeft.isDown())
            {
               x -= 15;
            }
            if(KeyBinding.lookDown.isDown())
            {
               y += 15;
            }
            if(KeyBinding.lookUp.isDown())
            {
               y -= 15;
            }
            if(KeyBinding.lockCamera.isJustPressed())
            {
               target = target ? null : this.player;
            }
            if(KeyBinding.hideUI.isJustPressed())
            {
               Global.base.toggleUI();
            }
            if(!this.confirm && KeyBinding.screenshotFull.isJustPressed())
            {
               this.confirm = new ConfirmPrompt("Do you want to make a screenshot of this entire world?",false);
               this.confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
               {
                  confirm.close();
                  Screenshot.SavePNGWithFullWorld(param1);
               });
               this.confirm.onAnyClose = function():void
               {
                  confirm = null;
               };
               Global.base.showOnTop(this.confirm);
            }
         }
         if(KeyBinding.godmode.isJustPressed() && Boolean(Bl.data.canToggleGodMode))
         {
            this.connection.send("god",!this.player.isInGodMode);
            if(this.player.isInModMode)
            {
               this.connection.send("mod");
            }
         }
         if(Bl.isKeyJustPressed(27) && this.isPlayerSpectating)
         {
            this.stopSpectating();
         }
         if(Global.base.ui2instance.trialsMode && KeyBinding.retryRun.isJustPressed())
         {
            t = getTimer();
            if(this.lastRetry == -1 || t - this.lastRetry >= 500)
            {
               Global.base.hideCampaignTrialDone();
               Global.base.connection.send("say","/wpreset");
               this.lastRetry = t;
            }
         }
         xo = (Bl.mouseX - this.x) / 16 >> 0;
         yo = (Bl.mouseY - this.y) / 16 >> 0;
         if(Bl.isMiddleMouseJustPressed)
         {
            if(Global.playerInstance.name.toLowerCase() == Global.worldOwner.toLowerCase() || Global.playerInstance.canEdit)
            {
               favBricks = Global.base.ui2instance.favoriteBricks;
               id = this.world.getTile(0,xo,yo);
               if(id == 0)
               {
                  id = this.world.getTile(1,xo,yo);
                  if(id == 0)
                  {
                     favBricks.select(0);
                     return;
                  }
               }
               if(favBricks.getPosFromID(id) != -1)
               {
                  this.readBlock(this.getLayerFromId(id),xo,yo,favBricks.getPosFromID(id));
               }
               else
               {
                  pos = favBricks.selectedBlock;
                  this.readBlock(this.getLayerFromId(id),xo,yo,pos);
               }
            }
         }
         if(Bl.isMouseJustPressed || Boolean(Bl.data.isLockedRoom) && Boolean(Bl.isMouseDown))
         {
            if(Global.base.ui2instance.playerActionsVisible)
            {
               this.lockPlacement = true;
            }
            if(!(Bl.mouseX > 640 || Bl.mouseX < 0 || Bl.mouseY > 470 || Bl.mouseY < 0))
            {
               layer = this.getLayerFromId(Bl.data.brick);
               determinedLayer = layer;
               if(Bl.isMouseJustPressed)
               {
                  if(this.world.getTile(0,xo,yo) != 0)
                  {
                     determinedLayer = 0;
                  }
                  else
                  {
                     determinedLayer = 1;
                  }
                  this.eraserLayerLock = determinedLayer;
               }
               else
               {
                  determinedLayer = this.eraserLayerLock;
               }
               if(Bl.data.brick == 0)
               {
                  layer = determinedLayer;
               }
               clicked = false;
               if(Bl.isKeyDown(86) && Bl.isMouseJustPressed && Player.isStaffMember(this.player.name) && (this.player.isFlying || this.player.isInGodMode || this.player.isInModMode))
               {
                  this.player.x = xo << 4;
                  this.player.y = yo << 4;
                  this.player.enforceMovement = true;
               }
               if(Boolean(Bl.data.canEdit && xo >= 0 && yo >= 0 && xo < this.world.width) && Boolean(yo < this.world.height) && !Bl.isKeyDown(86))
               {
                  Global.log("PlayState mouse tick: canEdit=" + Bl.data.canEdit + " brick=" + Bl.data.brick + " xo=" + xo + " yo=" + yo + " connected=" + this.connection.connected + " isSame=" + this.isSame(layer,xo,yo));
                  if(Bl.data.brick == 100 && this.world.getTile(0,xo,yo) == 110)
                  {
                     this.setTile(0,xo,yo,100,null);
                  }
                  if(Bl.data.brick == 101 && this.world.getTile(0,xo,yo) == 111)
                  {
                     this.setTile(0,xo,yo,101,null);
                  }
                  clicked = true;
                  numberDown = this.numberKeyDown();
                  if(Global.base.settings.blockPicker && numberDown != -1)
                  {
                     this.readBlock(determinedLayer,xo,yo,numberDown);
                  }
                  else if(this.connection.connected && !this.isSame(layer,xo,yo) && Bl.data.brick >= 0 && !this.isPlayerSpectating)
                  {
                     dochange = true;
                     if(this.lockPlacement)
                     {
                        this.lockPlacement = false;
                        dochange = false;
                     }
                     else if(xo == this.pastX && yo == this.pastY && !Bl.isMouseJustPressed)
                     {
                        if(new Date().time - this.pastT < 100)
                        {
                           dochange = false;
                        }
                     }
                     if(dochange)
                     {
                        this.pastX = xo;
                        this.pastY = yo;
                        this.pastT = new Date().time;
                        Global.log("Calling placeBlock: layer=" + layer + " xo=" + xo + " yo=" + yo + " brick=" + Bl.data.brick);
                        this.placeBlock(layer,xo,yo,Bl.data.brick);
                     }
                  }
                  else
                  {
                     clicked = false;
                  }
               }
               if(!clicked && this.isPlayerSpectating && !Global.base.ui2instance.playerActionsVisible)
               {
                  this.stopSpectating();
                  this.lockPlacement = true;
               }
            }
         }
         this.playerOverlaps();
         super.tick();
      }
      
      private function getLayerFromId(param1:int) : int
      {
         return param1 >= 500 && param1 < 1000 ? 1 : 0;
      }
      
      private function numberKeyDown() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 48;
         while(_loc2_ <= 57)
         {
            if(Bl.isKeyDown(_loc2_))
            {
               return _loc1_;
            }
            _loc1_++;
            _loc2_++;
         }
         return -1;
      }
      
      private function readBlock(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc6_:LabelLookup = null;
         var _loc5_:int = this.world.getTile(param1,param2,param3);
         if(!Global.base.canUseBlock(ItemManager.getBrickById(_loc5_)) && _loc5_ != ItemId.COLLECTEDCOIN && _loc5_ != ItemId.COLLECTEDBLUECOIN)
         {
            return;
         }
         Bl.data.brick = _loc5_;
         switch(Bl.data.brick)
         {
            case ItemId.COINDOOR:
            case ItemId.COINGATE:
            case ItemId.BLUECOINDOOR:
            case ItemId.BLUECOINGATE:
               Bl.data.coincount = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.SWITCH_PURPLE:
            case ItemId.RESET_PURPLE:
            case ItemId.DOOR_PURPLE:
            case ItemId.GATE_PURPLE:
            case ItemId.SWITCH_ORANGE:
            case ItemId.RESET_ORANGE:
            case ItemId.DOOR_ORANGE:
            case ItemId.GATE_ORANGE:
               Bl.data.switchId = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.DEATH_DOOR:
            case ItemId.DEATH_GATE:
               Bl.data.deathcount = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.PORTAL_INVISIBLE:
            case ItemId.PORTAL:
               Bl.data.portal_id = this.world.lookup.getPortal(param2,param3).id;
               Bl.data.portal_target = this.world.lookup.getPortal(param2,param3).target;
               break;
            case ItemId.WORLD_PORTAL:
               Bl.data.world_portal_id = this.world.lookup.getWorldPortal(param2,param3).id;
               Bl.data.world_portal_target = this.world.lookup.getWorldPortal(param2,param3).target;
               Bl.data.world_portal_name = "";
               break;
            case ItemId.WORLD_PORTAL_SPAWN:
               Bl.data.spawn_id = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.TEXT_SIGN:
               Global.text_sign_text = this.world.lookup.getTextSign(param2,param3).text;
               break;
            case 83:
               Global.drumOffset = this.world.lookup.getInt(param2,param3);
               break;
            case 77:
               Global.pianoOffset = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.EFFECT_TEAM:
            case ItemId.TEAM_DOOR:
            case ItemId.TEAM_GATE:
               Bl.data.team = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.EFFECT_CURSE:
            case ItemId.EFFECT_ZOMBIE:
            case ItemId.EFFECT_POISON:
               Bl.data.effectDuration = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.EFFECT_FLY:
            case ItemId.EFFECT_PROTECTION:
            case ItemId.EFFECT_LOW_GRAVITY:
               Bl.data.onStatus = this.world.lookup.getBoolean(param2,param3);
               break;
            case ItemId.EFFECT_JUMP:
            case ItemId.EFFECT_RUN:
               Bl.data.mode = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.EFFECT_MULTIJUMP:
               Bl.data.jumps = this.world.lookup.getInt(param2,param3);
               break;
            case ItemId.EFFECT_GRAVITY:
               Bl.data.direction = this.world.lookup.getInt(param2,param3);
               break;
            case 1520:
               Global.guitarOffset = SoundManager.guitarMap.indexOf(this.world.lookup.getInt(param2,param3));
               break;
            case 1000:
               _loc6_ = this.world.lookup.getLabel(param2,param3);
               Bl.data.wrapLength = _loc6_.WrapLength;
               Global.default_label_text = _loc6_.Text;
               Global.default_label_hex = _loc6_.Color;
               break;
            case ItemId.COLLECTEDBLUECOIN:
            case ItemId.COLLECTEDCOIN:
               Bl.data.brick -= 10;
               break;
            default:
               if(ItemId.isNPC(Bl.data.brick))
               {
                  this.world.lookup.getNpc(param2,param3).setAsDefault();
               }
         }
         if(param4 == 0)
         {
            param4 = 10;
         }
         Global.base.ui2instance.favoriteBricks.setDefault(param4,ItemManager.getBrickById(Bl.data.brick));
         Global.base.ui2instance.favoriteBricks.select(param4);
      }
      
      private function playerOverlaps() : void
      {
         var _loc1_:Player = null;
         if(!this.player.getCanTag())
         {
            return;
         }
         if(this.touchCooldown > 0)
         {
            --this.touchCooldown;
            return;
         }
         for each(_loc1_ in this.players)
         {
            if(_loc1_.getCanBeTagged())
            {
               if(MathUtil.inRange(this.player.x,this.player.y,_loc1_.x,_loc1_.y,8))
               {
                  if(this.player.cursed && !_loc1_.cursed)
                  {
                     this.touchCooldown = 100;
                     this.connection.send("touch",_loc1_.id,Config.effectCurse);
                  }
                  if(this.player.zombie && !_loc1_.zombie)
                  {
                     this.connection.send("touch",_loc1_.id,Config.effectZombie);
                  }
                  if(this.player.isInvulnerable && (_loc1_.cursed || _loc1_.zombie))
                  {
                     this.connection.send("touch",_loc1_.id,Config.effectProtection);
                  }
               }
            }
         }
      }
      
      private function isSame(param1:int, param2:int, param3:int) : Boolean
      {
         if(Bl.data.brick != this.world.getTile(param1,param2,param3))
         {
            return false;
         }
         if(ItemId.isBackgroundRotateable(Bl.data.brick))
         {
            return false;
         }
         if(ItemId.isBlockRotateable(Bl.data.brick))
         {
            return false;
         }
         switch(Bl.data.brick)
         {
            case ItemId.COINDOOR:
            case ItemId.COINGATE:
            case ItemId.BLUECOINDOOR:
            case ItemId.BLUECOINGATE:
               return this.world.lookup.getInt(param2,param3) == Bl.data.coincount;
            case ItemId.SWITCH_PURPLE:
            case ItemId.RESET_PURPLE:
            case ItemId.DOOR_PURPLE:
            case ItemId.GATE_PURPLE:
            case ItemId.SWITCH_ORANGE:
            case ItemId.RESET_ORANGE:
            case ItemId.DOOR_ORANGE:
            case ItemId.GATE_ORANGE:
               return this.world.lookup.getInt(param2,param3) == Bl.data.switchId;
            case ItemId.DEATH_DOOR:
            case ItemId.DEATH_GATE:
               return this.world.lookup.getInt(param2,param3) == Bl.data.deathcount;
            case 83:
               return this.world.lookup.getInt(param2,param3) == Global.drumOffset;
            case 77:
               return this.world.lookup.getInt(param2,param3) == Global.pianoOffset;
            case ItemId.SPIKE:
            case ItemId.SPIKE_SILVER:
            case ItemId.SPIKE_BLACK:
            case ItemId.SPIKE_RED:
            case ItemId.SPIKE_GOLD:
            case ItemId.SPIKE_GREEN:
            case ItemId.SPIKE_BLUE:
            case ItemId.WORLD_PORTAL:
            case ItemId.PORTAL_INVISIBLE:
            case ItemId.TEXT_SIGN:
            case ItemId.PORTAL:
               return false;
            case ItemId.WORLD_PORTAL_SPAWN:
               return this.world.lookup.getInt(param2,param3) == Bl.data.spawn_id;
            case ItemId.EFFECT_TEAM:
            case ItemId.TEAM_DOOR:
            case ItemId.TEAM_GATE:
               return this.world.lookup.getInt(param2,param3) == Bl.data.team;
            case ItemId.EFFECT_GRAVITY:
               return this.world.lookup.getInt(param2,param3) == Bl.data.direction;
            case ItemId.EFFECT_CURSE:
            case ItemId.EFFECT_ZOMBIE:
            case ItemId.EFFECT_POISON:
               return this.world.lookup.getInt(param2,param3) == Bl.data.effectDuration;
            case ItemId.EFFECT_FLY:
            case ItemId.EFFECT_PROTECTION:
            case ItemId.EFFECT_LOW_GRAVITY:
               return this.world.lookup.getBoolean(param2,param3) == Bl.data.onStatus;
            case ItemId.EFFECT_JUMP:
            case ItemId.EFFECT_RUN:
               return this.world.lookup.getInt(param2,param3) == Bl.data.mode;
            case ItemId.EFFECT_MULTIJUMP:
               return this.world.lookup.getInt(param2,param3) == Bl.data.jumps;
            case 1000:
               return false;
            case 1520:
               return this.world.lookup.getInt(param2,param3) == Global.guitarOffset;
            default:
               if(ItemId.isNPC(Bl.data.brick))
               {
                  return false;
               }
               return true;
         }
      }
      
      override public function draw(param1:BitmapData, param2:int, param3:int) : void
      {
         var _loc8_:String = null;
         var _loc9_:Npc = null;
         var _loc12_:Player = null;
         var _loc4_:Number = new Date().time;
         this.startx = -this.x - 90;
         this.starty = -this.y - 90;
         this.endx = this.startx + Bl.width + 180;
         this.endy = this.starty + Bl.height + 180;
         super.draw(param1,param2,param3);
         var _loc5_:int = param2 + x;
         var _loc6_:int = param3 + y;
         var _loc7_:Boolean = !this.player.moving || Global.chatIsVisible;
         if(!_loc7_)
         {
            this.chatTime = new Date().time;
         }
         else if(new Date().time - this.chatTime < 1500)
         {
            _loc7_ = Global.chatIsVisible;
         }
         this.world.postDraw(param1,_loc5_,_loc6_);
         for(_loc8_ in this.players)
         {
            _loc12_ = this.players[_loc8_] as Player;
            if(_loc12_.x > this.startx && _loc12_.y > this.starty && _loc12_.x < this.endx && _loc12_.y < this.endy)
            {
               _loc12_.drawGods(param1,_loc5_,_loc6_);
               _loc12_.drawChat(param1,_loc5_,_loc6_,_loc7_);
            }
         }
         _loc9_ = this.world.findCurrentNPC();
         if(this.player.currentNpc != null)
         {
            _loc9_ = this.player.currentNpc;
         }
         if(Boolean(_loc9_) && this.player.isFlying)
         {
            _loc9_.drawName(param1,_loc5_,_loc6_);
         }
         if(this.player.currentNpc)
         {
            this.player.currentNpc.drawChat(param1,_loc5_,_loc6_);
         }
         this.player.drawGods(param1,_loc5_,_loc6_);
         this.player.drawChat(param1,_loc5_,_loc6_,_loc7_);
         if(Boolean(_loc9_) && !this.player.isFlying)
         {
            _loc9_.drawName(param1,_loc5_,_loc6_);
         }
         Chat.drawAll();
         this.world.drawDialogs(param1,_loc5_,_loc6_);
         var _loc10_:int = Global.showUI ? -16 : -200;
         var _loc11_:int = 0;
         if(this.player.deaths > 0)
         {
            this.deathcountcontainer.draw(param1,0,_loc11_ + _loc10_);
            _loc11_ += 15;
         }
         if(this.totalCoins > 0)
         {
            this.cointextcontainer.draw(param1,0,_loc11_ + _loc10_);
            _loc11_ += 15;
         }
         if(this.bonusCoins > 0)
         {
            this.bcointextcontainer.draw(param1,0,_loc11_ + _loc10_);
            _loc11_ += 15;
         }
         if(this.isPlayerSpectating)
         {
            this.spectatingText.draw(param1,0,0);
            this.stopSpectatingText.draw(param1,0,0);
         }
         if(Bl.data.showMap)
         {
            this.minimap.draw(param1,0,0);
         }
         else
         {
            this.minimap.clear();
         }
         if(Boolean(Global.debug_stats) && Global.base.overlayContainer.contains(Global.debug_stats))
         {
            Global.base.overlayContainer.setChildIndex(Global.debug_stats,Global.base.overlayContainer.numChildren - 1);
         }
         if(Global.drawableContentTest.numChildren > 0)
         {
            if(!Global.base.overlayContainer.contains(Global.drawableContentTest))
            {
               Global.base.overlayContainer.addChild(Global.drawableContentTest);
            }
         }
         this.lastframe = param1;
      }
      
      override public function get align() : String
      {
         return STATE_ALIGN_LEFT;
      }
      
      public function reset() : void
      {
         if(Boolean(Global.debug_stats) && Global.base.overlayContainer.contains(Global.debug_stats))
         {
            Global.base.overlayContainer.removeChild(Global.debug_stats);
         }
         Global.debug_stats = null;
      }
      
      public function getPlayerScreenPosition(param1:int = -1) : Point
      {
         var _loc2_:Player = this.player;
         if(param1 >= 0)
         {
            _loc2_ = this.players[param1] as Player;
         }
         return _loc2_ == null ? new Point(-1,-1) : new Point(x + _loc2_.x,y + _loc2_.y);
      }
      
      private function doAnim(param1:Player, param2:String) : void
      {
         var anim:AnimatedSprite;
         var bmd:BitmapData = null;
         var p:Player = param1;
         var type:String = param2;
         if(type == "favorite")
         {
            bmd = AnimationManager.animFavorite;
         }
         if(type == "like")
         {
            bmd = AnimationManager.animLike;
         }
         anim = new AnimatedSprite(bmd,40);
         anim.x = p.x - 12;
         anim.y = p.y - 13;
         anim.scale = 0;
         add(anim);
         TweenMax.to(anim,0.3,{
            "y":"-30",
            "scale":1,
            "ease":Quint.easeOut
         });
         TweenMax.to(anim,0.1,{
            "scale":0,
            "delay":2,
            "onCompleteParams":[anim],
            "onComplete":function(param1:AnimatedSprite):void
            {
               remove(param1);
            }
         });
      }
      
      public function getPlayers() : Object
      {
         var _loc2_:String = null;
         var _loc3_:Player = null;
         var _loc1_:Object = {};
         _loc1_[this.player.id] = this.player;
         for(_loc2_ in this.players)
         {
            _loc3_ = this.players[_loc2_] as Player;
            _loc1_[_loc3_.id] = _loc3_;
         }
         return _loc1_;
      }
      
      public function getPlayerFromId(param1:int) : Player
      {
         var _loc3_:String = null;
         var _loc4_:Player = null;
         var _loc2_:Object = {};
         _loc2_[this.player.id] = this.player;
         for(_loc3_ in this.players)
         {
            _loc4_ = this.players[_loc3_] as Player;
            _loc2_[_loc4_.id] = _loc4_;
         }
         return _loc2_[param1];
      }
      
      public function getPlayer() : Player
      {
         return this.player;
      }
      
      public function getConnection() : Connection
      {
         return this.connection;
      }
      
      public function setBlockPlayerData(param1:int, param2:int, param3:int, param4:int) : void
      {
         if(param4 == -1)
         {
            return;
         }
         var _loc5_:Player = null;
         if(param4 == Global.myId)
         {
            _loc5_ = this.player;
         }
         else
         {
            _loc5_ = this.players[param4] as Player;
         }
         if(!_loc5_)
         {
            return;
         }
         this.world.lookup.setPlacer(param1,param2,param3,_loc5_.name);
      }
      
      public function addFakePlayer(param1:int, param2:int, param3:String, param4:Number, param5:Number, param6:Boolean = false, param7:Boolean = false, param8:Number = -1) : void
      {
         var _loc9_:int = this.fPid_++;
         var _loc10_:Player = this.players[_loc9_] as Player;
         if(_loc10_)
         {
            return;
         }
         _loc10_ = new Player(this.world,param3,false,null,this);
         _loc10_.id = _loc9_;
         _loc10_.connectedUserId = "justasimple" + param3;
         this.players[_loc9_] = _loc10_;
         _loc10_.isInGodMode = param6;
         _loc10_.isInModMode = param7;
         _loc10_.worldGravityMultiplier = this.gravityMultiplier;
         _loc10_.x = param4;
         _loc10_.y = param5;
         _loc10_.frame = param1;
         _loc10_.aura = param2;
         _loc10_.coins = 0;
         _loc10_.bcoins = 0;
         _loc10_.deaths = 0;
         _loc10_.isgoldmember = false;
         _loc10_.team = 0;
         var _loc11_:Boolean = param3.indexOf("-") != -1;
         var _loc12_:Number = 13421772;
         if(_loc11_)
         {
            _loc12_ = 6710886;
         }
         if(param8 > -1)
         {
            _loc12_ = param8;
         }
         if(Player.getNameColor(_loc10_.name) != Config.default_color)
         {
            _loc12_ = Player.getNameColor(_loc10_.name);
         }
         _loc10_.nameColor = _loc12_;
         _loc10_.canEdit = false;
         _loc10_.badge = "";
         _loc10_.isCrewMember = false;
         addBefore(_loc10_,this.player);
      }
      
      public function randInt(param1:Number, param2:Number) : Number
      {
         return param1 + (param2 - param1) * Math.random();
      }
      
      public function get isPlayerSpectating() : Boolean
      {
         return this._isPlayerSpectating;
      }
      
      public function spectate(param1:Player) : void
      {
         this.target = param1;
         this._isPlayerSpectating = true;
      }
      
      public function stopSpectating() : void
      {
         target = this.player;
         this._isPlayerSpectating = false;
      }
      
      private function getIntArrayFromVarint(param1:ByteArray) : Array
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = uint(param1[_loc5_]);
            _loc7_ = uint(_loc6_ & 0x7F);
            _loc3_ |= _loc7_ << _loc2_;
            if((_loc6_ & 0x80) != 128)
            {
               _loc4_.push(int(_loc3_));
               _loc3_ = 0;
               _loc2_ = 0;
            }
            else
            {
               _loc2_ += 7;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function getBlockMaxFrames(param1:int) : int
      {
         var spr:BlockSprite = ItemManager.getRotateableSprite(param1);
         if(spr != null)
         {
            return spr.totalFrames > 0 ? spr.totalFrames : 4;
         }
         return 4;
      }

       public function placeBlock(param1:int, param2:int, param3:int, param4:int) : void
       {
          var isSameBlock:Boolean = (this.world.getTile(param1,param2,param3) == param4);
          if(ItemId.isBlockRotateable(param4) || ItemId.isNonRotatableHalfBlock(param4) || param4 == ItemId.SPIKE || param4 == ItemId.SPIKE_SILVER || param4 == ItemId.SPIKE_BLACK || param4 == ItemId.SPIKE_RED || param4 == ItemId.SPIKE_GOLD || param4 == ItemId.SPIKE_GREEN || param4 == ItemId.SPIKE_BLUE)
          {
             this.world.updateRotateablesMap(param4,param2,param3);
             var maxFrames:int = this.getBlockMaxFrames(param4);
             var curRot:int = 1;
             if(isSameBlock)
             {
                curRot = (this.world.lookup.getInt(param2,param3) + 1) % maxFrames;
             }
             this.world.lookup.setInt(param2,param3,curRot);
             this.connection.send("b",param1,param2,param3,param4,curRot);
             return;
          }
          switch(param4)
          {
             case ItemId.COINDOOR:
             case ItemId.COINGATE:
             case ItemId.BLUECOINDOOR:
             case ItemId.BLUECOINGATE:
                this.connection.send("b",param1,param2,param3,param4,Bl.data.coincount);
                break;
             case ItemId.SWITCH_PURPLE:
             case ItemId.RESET_PURPLE:
             case ItemId.DOOR_PURPLE:
             case ItemId.GATE_PURPLE:
             case ItemId.SWITCH_ORANGE:
             case ItemId.RESET_ORANGE:
             case ItemId.DOOR_ORANGE:
             case ItemId.GATE_ORANGE:
                this.connection.send("b",param1,param2,param3,param4,Bl.data.switchId);
                break;
             case ItemId.DEATH_DOOR:
             case ItemId.DEATH_GATE:
                this.connection.send("b",param1,param2,param3,param4,Bl.data.deathcount);
                break;
             case ItemId.PORTAL_INVISIBLE:
             case ItemId.PORTAL:
                var nextPortalRot:int = isSameBlock ? ((this.world.lookup.getPortal(param2,param3).rotation + 1) % 4) : 0;
                this.world.lookup.setPortal(param2,param3,new Portal(Bl.data.portal_id,Bl.data.portal_target,nextPortalRot,param4));
                this.connection.send("b",param1,param2,param3,param4,nextPortalRot,Bl.data.portal_id,Bl.data.portal_target);
                break;
             case ItemId.WORLD_PORTAL:
                if(Bl.data.world_portal_name != null)
                {
                   this.connection.send("b",param1,param2,param3,param4,Bl.data.world_portal_id,Bl.data.world_portal_target);
                }
                break;
             case ItemId.WORLD_PORTAL_SPAWN:
                this.connection.send("b",param1,param2,param3,param4,Bl.data.spawn_id);
                break;
             case ItemId.TEXT_SIGN:
                var signFrames:int = ItemManager.sprSign != null ? ItemManager.sprSign.totalFrames : 8;
                var nextSignType:int = isSameBlock ? ((this.world.lookup.getTextSign(param2,param3).type + 1) % signFrames) : 0;
                this.world.lookup.setTextSign(param2,param3,new TextSign(Global.text_sign_text,nextSignType));
                this.connection.send("b",param1,param2,param3,param4,Global.text_sign_text,nextSignType);
                break;
             case ItemId.LABEL:
                this.connection.send("b",param1,param2,param3,param4,Global.default_label_text,Global.default_label_hex,Bl.data.wrapLength);
                break;
            case 83:
               this.connection.send("b",param1,param2,param3,param4,Global.drumOffset);
               break;
            case 77:
               this.connection.send("b",param1,param2,param3,param4,Global.pianoOffset);
               break;
            case ItemId.EFFECT_TEAM:
            case ItemId.TEAM_DOOR:
            case ItemId.TEAM_GATE:
               this.connection.send("b",param1,param2,param3,param4,Bl.data.team);
               break;
            case ItemId.EFFECT_GRAVITY:
               this.connection.send("b",param1,param2,param3,param4,Bl.data.direction);
               break;
            case ItemId.EFFECT_CURSE:
            case ItemId.EFFECT_ZOMBIE:
            case ItemId.EFFECT_POISON:
               this.connection.send("b",param1,param2,param3,param4,Bl.data.effectDuration);
               break;
            case ItemId.EFFECT_FLY:
            case ItemId.EFFECT_PROTECTION:
            case ItemId.EFFECT_LOW_GRAVITY:
               this.connection.send("b",param1,param2,param3,param4,Bl.data.onStatus ? 1 : 0);
               break;
            case ItemId.EFFECT_JUMP:
            case ItemId.EFFECT_RUN:
               this.connection.send("b",param1,param2,param3,param4,Bl.data.mode);
               break;
            case ItemId.EFFECT_MULTIJUMP:
               this.connection.send("b",param1,param2,param3,param4,Bl.data.jumps);
               break;
            case 1520:
               this.connection.send("b",param1,param2,param3,param4,SoundManager.guitarMap[Global.guitarOffset]);
               break;
            default:
               if(ItemId.isNPC(param4))
               {
                  if(Badwords.isBadword(Bl.data.npc_name))
                  {
                     Global.base.showInfo2("Don\'t name the NPC like that!","They wouldn\'t like it! :(");
                     break;
                  }
                  this.connection.send("b",param1,param2,param3,param4,Bl.data.npc_name,Bl.data.npc_mes1,Bl.data.npc_mes2,Bl.data.npc_mes3);
                  break;
               }
               this.connection.send("b",param1,param2,param3,param4);
         }
      }
   }
}


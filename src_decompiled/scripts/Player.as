package
{
   import animations.AnimationManager;
   import blitter.Bl;
   import blitter.BlSprite;
   import com.reygazu.anticheat.variables.SecureBoolean;
   import com.reygazu.anticheat.variables.SecureInt;
   import com.reygazu.anticheat.variables.SecureNumber;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import items.ItemAura;
   import items.ItemId;
   import items.ItemManager;
   import playerio.Connection;
   import states.PlayState;
   import ui.chat.UserlistItem;
   import ui.ingame.MultiJumpCounter;
   
   public class Player extends SynchronizedSprite
   {
      
      protected static var Crown:Class = Player_Crown;
      
      private static var crown:BitmapData = new Crown().bitmapData;
      
      protected static var CrownSilver:Class = Player_CrownSilver;
      
      private static var crown_silver:BitmapData = new CrownSilver().bitmapData;
      
      protected static var StaffAura:Class = Player_StaffAura;
      
      private static var staffAuraBMD:BitmapData = new StaffAura().bitmapData;
      
      protected static var FireAura:Class = Player_FireAura;
      
      private static var fireAura:BitmapData = new FireAura().bitmapData;
      
      protected static var LevitationEffect:Class = Player_LevitationEffect;
      
      private static var levitationAnimationBitmapData:BitmapData = new LevitationEffect().bitmapData;
      
      protected static var EffectIcons:Class = Player_EffectIcons;
      
      private static var effectIconsBitmapData:BitmapData = new EffectIcons().bitmapData;
      
      protected static var SparkleAura:Class = Player_SparkleAura;
      
      private static var sparkleAura:BitmapData = new SparkleAura().bitmapData;
      
      private static var goldmemberaura:BitmapData = AnimationManager.animGoldMemberAura;
      
      private static var fireAnimation:BlSprite = new BlSprite(fireAura,0,0,26,26,6);
      
      private static var levitationAnimation:BlSprite = new BlSprite(levitationAnimationBitmapData,0,0,26,26,32);
      
      private static var effectIcons:BlSprite = new BlSprite(effectIconsBitmapData,0,0,16,16,effectIconsBitmapData.width / 16);
      
      private static var sparkleAnimation:BlSprite = new BlSprite(sparkleAura,0,0,64,64,7);
      
      private var _id:int;
      
      private var _connectedUserId:String;
      
      protected var world:World;
      
      public var isme:Boolean;
      
      protected var connection:Connection;
      
      protected var state:PlayState;
      
      protected var chat:Chat;
      
      private var deadAnim:BitmapData;
      
      public var isDead:Boolean = false;
      
      public var isFrozen:Boolean = false;
      
      private var deathsend:Boolean = false;
      
      public var resetSend:Boolean;
      
      public var name:String;
      
      private var textcolor:uint;
      
      private var morx:int = 0;
      
      private var mory:int = 0;
      
      public var overlapa:int = -1;
      
      public var overlapb:int = -1;
      
      public var overlapc:int = -1;
      
      public var overlapd:int = -1;
      
      public var hascrown:Boolean = false;
      
      public var collideWithCrownDoorGate:Boolean = false;
      
      public var collideWithSilverCrownDoorGate:Boolean = false;
      
      public var hascrownsilver:Boolean = false;
      
      public var render:Boolean = true;
      
      public var enforceMovement:Boolean = false;
      
      private var _posX:SecureNumber = new SecureNumber("PosX");
      
      private var _posY:SecureNumber = new SecureNumber("PosY");
      
      private var _coins:SecureInt = new SecureInt("Coins");
      
      private var _bcoins:SecureInt = new SecureInt("BlueCoins");
      
      private var _inGodMode:SecureBoolean = new SecureBoolean("GodMode");
      
      private var _inModMode:SecureBoolean = new SecureBoolean("ModMode");
      
      public var isgoldmember:Boolean = false;
      
      public var current:int = 0;
      
      public var current_bg:int = 0;
      
      public var current_below:int = 0;
      
      public var checkpoint_x:int = -1;
      
      public var checkpoint_y:int = -1;
      
      public var switches:Object = {};
      
      private var last_respawn:Number = 0;
      
      private var rect2:Rectangle = new Rectangle(0,0,26,26);
      
      private var itemAura:ItemAura;
      
      private var _aura:int = 0;
      
      private var _auraColor:int = 0;
      
      private var _isFlaunting:Boolean = false;
      
      private var tilequeue:Array;
      
      private var _deaths:SecureInt = new SecureInt("Deaths");
      
      public var team:int = 0;
      
      public var muted:Boolean;
      
      public var canEdit:Boolean;
      
      public var badge:String;
      
      public var isCrewMember:Boolean;
      
      protected var _canToggleGod:Boolean;
      
      public var currentNpc:Npc = null;
      
      protected var pastx:int = 0;
      
      protected var pasty:int = 0;
      
      private var queue:Vector.<int> = new Vector.<int>(Config.physics_queue_length);
      
      private var lastJump:Number = -new Date().time;
      
      private var changed:Boolean = false;
      
      private var tx:int = -1;
      
      private var ty:int = -1;
      
      protected var leftdown:int = 0;
      
      protected var rightdown:int = 0;
      
      protected var updown:int = 0;
      
      protected var downdown:int = 0;
      
      public var spacedown:Boolean = false;
      
      public var spacejustdown:Boolean = false;
      
      public var horizontal:int = 0;
      
      public var vertical:int = 0;
      
      public var oh:int = 0;
      
      public var ov:int = 0;
      
      public var ox:Number = 0;
      
      public var oy:Number = 0;
      
      public var ospacedown:Boolean = false;
      
      public var ospaceJP:Boolean = false;
      
      public var worldGravityMultiplier:Number = 1;
      
      private var lastPortal:Point = new Point();
      
      private var lastOverlap:int = 0;
      
      private var that:SynchronizedObject = this as SynchronizedObject;
      
      private var donex:Boolean = false;
      
      private var doney:Boolean = false;
      
      private var animoffset:Number = 0;
      
      private var modoffset:Number = 0;
      
      private var modrect:Rectangle;
      
      private var auraAnimOffset:Number = 0;
      
      private var deadoffset:Number = 0;
      
      public var low_gravity:Boolean = false;
      
      private var _isInvulnerable:SecureBoolean = new SecureBoolean("Protection");
      
      private var _hasLevitation:SecureBoolean = new SecureBoolean("Levitation");
      
      private var _jumpBoost:SecureInt = new SecureInt("JumpBoost");
      
      private var _speedBoost:SecureInt = new SecureInt("SpeedBoost");
      
      private var _flipGravity:SecureInt = new SecureInt("FlipGravity");
      
      private var _zombie:SecureBoolean = new SecureBoolean("Zombie");
      
      private var _cursed:SecureBoolean = new SecureBoolean("Curse");
      
      private var _poison:SecureBoolean = new SecureBoolean("Poison");
      
      private var _isThrusting:SecureBoolean = new SecureBoolean("IsThrusting");
      
      private var _maxThrust:Number = 0.2;
      
      private var _thrustBurnOff:Number = 0.01;
      
      private var _currentThrust:Number = 0;
      
      protected var isOnFire:Boolean = false;
      
      private var slippery:Number = 0;
      
      public var multiJumpEffectDisplay:MultiJumpCounter = null;
      
      public var jumpCount:int = 0;
      
      public var maxJumps:int = 1;
      
      private var starty:Number = 0;
      
      private var startx:Number = 0;
      
      private var endy:Number = 0;
      
      private var endx:Number = 0;
      
      private const staticEffects:Array = [Config.effectJump,Config.effectFly,Config.effectRun,Config.effectProtection,Config.effectLowGravity,Config.effectMultijump,Config.effectGravity];
      
      private const timedEffects:Array = [Config.effectCurse,Config.effectZombie,Config.effectFire,Config.effectPoison];
      
      public function Player(param1:World, param2:String, param3:Boolean = false, param4:Connection = null, param5:PlayState = null)
      {
         super(ItemManager.smileysBMD);
         this.state = param5;
         this.connection = param4;
         this.world = param1;
         this.hitmap = param1;
         this.tilequeue = [];
         this.x = 16;
         this.y = 16;
         this.isme = param3;
         this.name = param2;
         this.chat = new Chat(param2.indexOf(" ") == -1 ? param2 : "");
         this.chat.textColor = getNameColor(param2);
         size = 16;
         width = 16;
         height = 16;
         this.itemAura = ItemManager.getAuraByIdAndColor(0,0);
         var _loc6_:int = isAdmin(param2) ? 0 : (isModerator(param2) ? 1 : (isDesigner(param2) ? 2 : (isCampaignCurator(param2) ? 3 : 0)));
         this.modrect = new Rectangle(0,64 * _loc6_,64,64);
      }
      
      public static function isStaffMember(param1:String) : Boolean
      {
         return param1 != null && Bl.StaffObject != null && Bl.StaffObject.hasOwnProperty(param1.toLowerCase());
      }
      
      public static function isAdmin(param1:String) : Boolean
      {
         return hasStaffRank(param1,"Admin");
      }
      
      public static function isModerator(param1:String) : Boolean
      {
         return hasStaffRank(param1,"Mod") || hasStaffRank(param1,"Moderator") || isAdmin(param1);
      }
      
      public static function isDesigner(param1:String) : Boolean
      {
         return hasStaffRank(param1,"Design");
      }
      
      public static function isCampaignCurator(param1:String) : Boolean
      {
         return hasStaffRank(param1,"Campaign");
      }
      
      private static function hasStaffRank(param1:String, param2:String) : Boolean
      {
         return Bl.StaffObject != null && Bl.StaffObject.hasOwnProperty(param1.toLocaleLowerCase()) && Bl.StaffObject[param1.toLocaleLowerCase()] == param2;
      }
      
      public static function isPatron(param1:String) : Boolean
      {
         return Bl.PatronsObject != null && Bl.PatronsObject.hasOwnProperty(param1.toLocaleLowerCase());
      }
      
      public static function getPatronLevel(param1:String) : int
      {
         return isPatron(param1) ? int(Bl.PatronsObject[param1]) : 0;
      }
      
      public static function getPatronTier(param1:String) : String
      {
         var _loc2_:int = getPatronLevel(param1);
         return _loc2_ == 0 ? "" : (_loc2_ == 1 ? "Elite" : (_loc2_ == 2 ? "Magic" : (_loc2_ == 3 ? "Platinum" : (_loc2_ == 4 ? "Legendary" : (_loc2_ == 5 ? "Divine" : "Unknown")))));
      }
      
      public static function getPatronColor(param1:String) : uint
      {
         return Config.patron_color_1;
      }
      
      public static function getNameColor(param1:String) : uint
      {
         if(param1 == null || param1 == "") return Config.default_color;
         var lower:String = param1.toLowerCase();
         if(lower.indexOf("guest") == 0 || param1.indexOf("-") != -1)
         {
            return Config.guest_color;
         }
         return isAdmin(param1) ? Config.admin_color : (isModerator(param1) ? Config.moderator_color : (isDesigner(param1) ? Config.designer_color : (isCampaignCurator(param1) ? Config.campaign_curator_color : (isPatron(param1) ? getPatronColor(param1) : Config.default_color))));
      }
      
      public static function getProfileColor(param1:String) : uint
      {
         return getNameColor(param1);
      }
      
      public static function rotateBitmapData(param1:BitmapData, param2:int) : BitmapData
      {
         if(param2 == 0)
         {
            return param1;
         }
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         var _loc4_:Matrix = new Matrix();
         _loc4_.rotate(param2 * Math.PI / 180);
         if(param2 == 90)
         {
            _loc4_.translate(param1.height,0);
         }
         else if(param2 == 270)
         {
            _loc4_.translate(0,param1.width);
         }
         else if(param2 == 180)
         {
            _loc4_.translate(param1.width,param1.height);
         }
         _loc3_.draw(param1,_loc4_);
         return _loc3_;
      }
      
      override public function get x() : Number
      {
         return isNaN(this._posX.value) ? 0 : this._posX.value;
      }
      
      override public function set x(param1:Number) : void
      {
         this._posX.value = param1;
      }
      
      override public function get y() : Number
      {
         return isNaN(this._posY.value) ? 0 : this._posY.value;
      }
      
      override public function set y(param1:Number) : void
      {
         this._posY.value = param1;
      }
      
      public function set coins(param1:int) : void
      {
         this._coins.value = param1;
      }
      
      public function get coins() : int
      {
         return this._coins.value;
      }
      
      public function set bcoins(param1:int) : void
      {
         this._bcoins.value = param1;
      }
      
      public function get bcoins() : int
      {
         return this._bcoins.value;
      }
      
      public function set isInGodMode(param1:Boolean) : void
      {
         this._inGodMode.value = param1;
      }
      
      public function get isInGodMode() : Boolean
      {
         return this._inGodMode.value;
      }
      
      public function set isInModMode(param1:Boolean) : void
      {
         this._inModMode.value = param1;
      }
      
      public function get isInModMode() : Boolean
      {
         return this._inModMode.value;
      }
      
      public function set aura(param1:int) : void
      {
         this._aura = param1;
         this.itemAura = ItemManager.getAuraByIdAndColor(this.aura,this.auraColor);
      }
      
      public function get aura() : int
      {
         return this._aura;
      }
      
      public function set auraColor(param1:int) : void
      {
         this._auraColor = param1;
         this.itemAura = ItemManager.getAuraByIdAndColor(this.aura,this.auraColor);
      }
      
      public function get auraColor() : int
      {
         return this._auraColor;
      }
      
      public function set deaths(param1:int) : void
      {
         this._deaths.value = param1;
      }
      
      public function get deaths() : int
      {
         return this._deaths.value;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get connectedUserId() : String
      {
         return this._connectedUserId;
      }
      
      public function set connectedUserId(param1:String) : void
      {
         this._connectedUserId = param1;
      }
      
      public function get gravityMultiplier() : Number
      {
         var _loc1_:Number = 1;
         if(this.low_gravity)
         {
            _loc1_ *= 0.15;
         }
         else
         {
            _loc1_ *= this.worldGravityMultiplier;
         }
         return _loc1_;
      }
      
      public function get jumpMultiplier() : Number
      {
         var _loc1_:Number = 1;
         if(this.jumpBoost == 1)
         {
            _loc1_ *= 1.3;
         }
         if(this.jumpBoost == 2)
         {
            _loc1_ *= 0.75;
         }
         if(this.zombie)
         {
            _loc1_ *= 0.75;
         }
         if(this.slippery > 0)
         {
            _loc1_ *= 0.88;
         }
         return _loc1_;
      }
      
      public function get speedMultiplier() : Number
      {
         var _loc1_:Number = 1;
         if(this.speedBoost == 1)
         {
            _loc1_ *= 1.5;
         }
         if(this.speedBoost == 2)
         {
            _loc1_ *= 0.6;
         }
         if(this.zombie)
         {
            _loc1_ *= 0.6;
         }
         return _loc1_;
      }
      
      public function get dragMud() : Number
      {
         return _mud_drag;
      }
      
      override public function tick() : void
      {
         var delayed:int;
         var queue_length:int;
         var rotateGravitymo:Boolean;
         var rotateGravitymor:Boolean;
         var grounded:Boolean;
         var imx:int;
         var imy:int;
         var cx:int = 0;
         var cy:int = 0;
         var isgodmod:Boolean = false;
         var temp:Number = NaN;
         var reminderX:Number = NaN;
         var currentSX:Number = NaN;
         var reminderY:Number = NaN;
         var currentSY:Number = NaN;
         var osx:Number = NaN;
         var osy:Number = NaN;
         var rot:int = 0;
         var mod:int = 0;
         var injump:Boolean = false;
         var tx:Number = NaN;
         var ty:Number = NaN;
         var getCurrentBelow:Function = function():int
         {
            var _loc1_:int = 0;
            var _loc2_:int = 0;
            switch(current)
            {
               case 1:
               case 411:
                  _loc1_--;
                  break;
               case 2:
               case 412:
                  _loc2_--;
                  break;
               case 3:
               case 411:
                  _loc1_ += 1;
                  break;
               case 4:
               case 412:
                  _loc2_ += 1;
                  break;
               default:
                  switch(flipGravity)
                  {
                     case 0:
                        _loc2_ += 1;
                        break;
                     case 1:
                        _loc1_--;
                        break;
                     case 2:
                        _loc2_--;
                        break;
                     default:
                        _loc1_ += 1;
                  }
            }
            return world.getTile(0,cx + _loc1_,cy + _loc2_);
         };
         var stepx:Function = function():void
         {
            if(currentSX > 0)
            {
               if(currentSX + reminderX >= 1)
               {
                  x += 1 - reminderX;
                  x >>= 0;
                  currentSX -= 1 - reminderX;
                  reminderX = 0;
               }
               else
               {
                  x += currentSX;
                  currentSX = 0;
               }
            }
            else if(currentSX < 0)
            {
               if(reminderX + currentSX < 0 && (reminderX != 0 || ItemId.isBoost(current)))
               {
                  currentSX += reminderX;
                  x -= reminderX;
                  x >>= 0;
                  reminderX = 1;
               }
               else
               {
                  x += currentSX;
                  currentSX = 0;
               }
            }
            if(hitmap != null)
            {
               if(hitmap.overlaps(that))
               {
                  x = ox;
                  if(_speedX > 0 && morx > 0)
                  {
                     grounded = true;
                  }
                  if(_speedX < 0 && morx < 0)
                  {
                     grounded = true;
                  }
                  _speedX = 0;
                  currentSX = osx;
                  donex = true;
               }
            }
         };
         var stepy:Function = function():void
         {
            if(currentSY > 0)
            {
               if(currentSY + reminderY >= 1)
               {
                  y += 1 - reminderY;
                  y >>= 0;
                  currentSY -= 1 - reminderY;
                  reminderY = 0;
               }
               else
               {
                  y += currentSY;
                  currentSY = 0;
               }
            }
            else if(currentSY < 0)
            {
               if(reminderY + currentSY < 0 && (reminderY != 0 || ItemId.isBoost(current)))
               {
                  y -= reminderY;
                  y >>= 0;
                  currentSY += reminderY;
                  reminderY = 1;
               }
               else
               {
                  y += currentSY;
                  currentSY = 0;
               }
            }
            if(hitmap != null)
            {
               if(hitmap.overlaps(that))
               {
                  y = oy;
                  if(_speedY > 0 && mory > 0)
                  {
                     grounded = true;
                  }
                  if(_speedY < 0 && mory < 0)
                  {
                     grounded = true;
                  }
                  _speedY = 0;
                  currentSY = osy;
                  doney = true;
               }
            }
         };
         var randomRange:Function = function(param1:Number, param2:Number):Number
         {
            return Math.floor(Math.random() * (param2 - param1 + 1)) + param1;
         };
         var processPortals:Function = function():void
         {
            var _loc11_:WorldPortal = null;
            var _loc12_:NavigationEvent = null;
            var _loc13_:int = 0;
            var _loc14_:Number = NaN;
            current = world.getTile(0,cx,cy);
            if(!isgodmod && current == ItemId.WORLD_PORTAL)
            {
               if(isme && KeyBinding.risky.isDown() && !resetSend)
               {
                  _loc11_ = world.lookup.getWorldPortal(cx,cy);
                  if(_loc11_.id.length > 0)
                  {
                     resetSend = true;
                     if(_loc11_.id != connection.roomId)
                     {
                        if(connection.connected)
                        {
                           connection.disconnect();
                        }
                        _loc12_ = new NavigationEvent(NavigationEvent.JOIN_WORLD,true,false);
                        _loc12_.world_id = _loc11_.id;
                        _loc12_.joindata.spawnid = _loc11_.target;
                        _loc12_.joindata.lastowner = Global.ownerID;
                        _loc12_.joindata.lastcrew = Global.currentLevelCrew;
                        Global.base.dispatchEvent(_loc12_);
                     }
                     else
                     {
                        connection.send("reset",cx,cy);
                     }
                  }
               }
            }
            if(isgodmod || current != ItemId.PORTAL && current != ItemId.PORTAL_INVISIBLE || world.lookup.getPortal(cx,cy).target == world.lookup.getPortal(cx,cy).id)
            {
               lastPortal = null;
               return;
            }
            if(lastPortal != null)
            {
               return;
            }
            lastPortal = new Point(cx << 4,cy << 4);
            var _loc1_:Vector.<Point> = world.lookup.getPortals(world.lookup.getPortal(cx,cy).target);
            if(_loc1_.length <= 0)
            {
               return;
            }
            var _loc2_:Point = _loc1_[randomRange(0,_loc1_.length - 1)];
            var _loc3_:int = world.lookup.getPortal(lastPortal.x >> 4,lastPortal.y >> 4).rotation;
            var _loc4_:int = world.lookup.getPortal(_loc2_.x >> 4,_loc2_.y >> 4).rotation;
            if(_loc3_ < _loc4_)
            {
               _loc3_ += 4;
            }
            var _loc5_:Number = speedX;
            var _loc6_:Number = speedY;
            var _loc7_:Number = modifierX;
            var _loc8_:Number = modifierY;
            var _loc9_:int = _loc3_ - _loc4_;
            var _loc10_:Number = 1.42;
            switch(_loc9_)
            {
               case 1:
                  speedX = _loc6_ * _loc10_;
                  speedY = -_loc5_ * _loc10_;
                  modifierX = _loc8_ * _loc10_;
                  modifierY = -_loc7_ * _loc10_;
                  reminderY = -reminderX;
                  currentSY = -currentSX;
                  break;
               case 2:
                  speedX = -_loc5_ * _loc10_;
                  speedY = -_loc6_ * _loc10_;
                  modifierX = -_loc7_ * _loc10_;
                  modifierY = -_loc8_ * _loc10_;
                  reminderY = -reminderY;
                  currentSY = -currentSY;
                  reminderX = -reminderX;
                  currentSX = -currentSX;
                  break;
               case 3:
                  speedX = -_loc6_ * _loc10_;
                  speedY = _loc5_ * _loc10_;
                  modifierX = -_loc8_ * _loc10_;
                  modifierY = _loc7_ * _loc10_;
                  reminderX = -reminderY;
                  currentSX = -currentSY;
            }
            if(Boolean(isme) && Boolean(state) && !state.isPlayerSpectating)
            {
               state.offset(x - _loc2_.x,y - _loc2_.y);
            }
            if(Global.base.settings.particles)
            {
               if(current == ItemId.PORTAL && isme)
               {
                  _loc13_ = 0;
                  while(_loc13_ < 25)
                  {
                     _loc14_ = (Math.random() + 1) / 2;
                     world.addParticle(new Particle(world,Math.random() * 100 < 50 ? 5 : 4,_loc2_.x + 6,_loc2_.y + 6,_loc14_,_loc14_,_loc14_ / 70,_loc14_ / 70,Math.random() * 360,Math.random() * 90,false));
                     _loc13_++;
                  }
               }
            }
            x = _loc2_.x;
            y = _loc2_.y;
            lastPortal = _loc2_;
         };
         this.animoffset += 0.2;
         if(this.isInModMode && !this.isInGodMode)
         {
            this.modoffset += 0.2;
            if(this.modoffset >= 12)
            {
               this.modoffset = 6;
            }
         }
         else
         {
            this.modoffset = 0;
         }
         this.auraAnimOffset += this.itemAura.speed;
         if(this.auraAnimOffset >= this.itemAura.frames)
         {
            this.auraAnimOffset = 0;
         }
         if(this.isDead)
         {
            this.deadoffset += 0.3;
         }
         else
         {
            this.deadoffset = 0;
         }
         cx = this.x + 8 >> 4;
         cy = this.y + 8 >> 4;
         delayed = this.queue.shift();
         this.current = this.world.getTile(0,cx,cy);
         if(ItemId.isHalfBlock(this.current))
         {
            rot = this.world.lookup.getInt(cx,cy);
            if(!ItemId.isBlockRotateable(this.current) && ItemId.isNonRotatableHalfBlock(this.current))
            {
               rot = 1;
            }
            if(rot == 1)
            {
               cy--;
            }
            if(rot == 0)
            {
               cx--;
            }
            this.current = this.world.getTile(0,cx,cy);
         }
         if(this.tx != -1)
         {
            this.UpdateTeamDoors(this.tx,this.ty);
         }
         this.current_below = getCurrentBelow();
         this.queue.push(this.current);
         if(this.current == 4 || this.current == 414 || ItemId.isClimbable(this.current))
         {
            delayed = this.queue.shift();
            this.queue.push(this.current);
         }
         queue_length = int(this.tilequeue.length);
         while(queue_length--)
         {
            this.tilequeue.shift()();
         }
         this.getPlayerInput();
         if(this.isDead)
         {
            this.spacejustdown = false;
            this.spacedown = false;
            this.horizontal = 0;
            this.vertical = 0;
         }
         rotateGravitymo = true;
         rotateGravitymor = true;
         isgodmod = this.isFlying;
         this.morx = 0;
         this.mory = 0;
         this.mox = 0;
         this.moy = 0;
         if(!isgodmod)
         {
            if(ItemId.isClimbable(this.current))
            {
               this.morx = 0;
               this.mory = 0;
            }
            else
            {
               switch(this.current)
               {
                  case 1:
                  case 411:
                     this.morx = -_gravity;
                     this.mory = 0;
                     rotateGravitymor = false;
                     break;
                  case 2:
                  case 412:
                     this.morx = 0;
                     this.mory = -_gravity;
                     rotateGravitymor = false;
                     break;
                  case 3:
                  case 413:
                     this.morx = _gravity;
                     this.mory = 0;
                     rotateGravitymor = false;
                     break;
                  case 1518:
                  case 1519:
                     this.morx = 0;
                     this.mory = _gravity;
                     rotateGravitymor = false;
                     break;
                  case ItemId.SPEED_LEFT:
                  case ItemId.SPEED_RIGHT:
                  case ItemId.SPEED_UP:
                  case ItemId.SPEED_DOWN:
                  case 4:
                  case 414:
                     this.morx = 0;
                     this.mory = 0;
                     break;
                  case ItemId.WATER:
                     this.morx = 0;
                     this.mory = _water_buoyancy;
                     break;
                  case ItemId.MUD:
                     this.morx = 0;
                     this.mory = _mud_buoyancy;
                     break;
                  case ItemId.LAVA:
                     this.morx = 0;
                     this.mory = _lava_buoyancy;
                     break;
                  case ItemId.TOXIC_WASTE:
                     this.morx = 0;
                     this.mory = _toxic_buoyancy;
                     if(!this.isDead && !this.isInvulnerable)
                     {
                        this.killPlayer();
                     }
                     break;
                  case ItemId.FIRE:
                  case ItemId.SPIKE:
                  case ItemId.SPIKE_CENTER:
                  case ItemId.SPIKE_SILVER:
                  case ItemId.SPIKE_SILVER_CENTER:
                  case ItemId.SPIKE_BLACK:
                  case ItemId.SPIKE_BLACK_CENTER:
                  case ItemId.SPIKE_RED:
                  case ItemId.SPIKE_RED_CENTER:
                  case ItemId.SPIKE_GOLD:
                  case ItemId.SPIKE_GOLD_CENTER:
                  case ItemId.SPIKE_GREEN:
                  case ItemId.SPIKE_GREEN_CENTER:
                  case ItemId.SPIKE_BLUE:
                  case ItemId.SPIKE_BLUE_CENTER:
                     this.morx = 0;
                     this.mory = _gravity;
                     if(!this.isDead && !this.isInvulnerable)
                     {
                        this.killPlayer();
                     }
                     break;
                  default:
                     this.morx = 0;
                     this.mory = _gravity;
               }
            }
            if(ItemId.isClimbable(delayed))
            {
               this.mox = 0;
               this.moy = 0;
            }
            else
            {
               switch(delayed)
               {
                  case 1:
                  case 411:
                     this.mox = -_gravity;
                     this.moy = 0;
                     rotateGravitymo = false;
                     break;
                  case 2:
                  case 412:
                     this.mox = 0;
                     this.moy = -_gravity;
                     rotateGravitymo = false;
                     break;
                  case 3:
                  case 413:
                     this.mox = _gravity;
                     this.moy = 0;
                     rotateGravitymo = false;
                     break;
                  case 1518:
                  case 1519:
                     this.mox = 0;
                     this.moy = _gravity;
                     rotateGravitymo = false;
                     break;
                  case ItemId.SPEED_LEFT:
                  case ItemId.SPEED_RIGHT:
                  case ItemId.SPEED_UP:
                  case ItemId.SPEED_DOWN:
                  case 4:
                  case 414:
                     this.mox = 0;
                     this.moy = 0;
                     break;
                  case ItemId.WATER:
                     this.mox = 0;
                     this.moy = _water_buoyancy;
                     break;
                  case ItemId.MUD:
                     this.mox = 0;
                     this.moy = _mud_buoyancy;
                     break;
                  case ItemId.LAVA:
                     this.mox = 0;
                     this.moy = _lava_buoyancy;
                     break;
                  case ItemId.TOXIC_WASTE:
                     this.mox = 0;
                     this.moy = _toxic_buoyancy;
                     break;
                  default:
                     this.mox = 0;
                     this.moy = _gravity;
               }
            }
         }
         switch(this.flipGravity)
         {
            case 1:
               if(rotateGravitymo)
               {
                  temp = mox;
                  mox = -moy;
                  moy = temp;
               }
               if(rotateGravitymor)
               {
                  temp = this.morx;
                  this.morx = -this.mory;
                  this.mory = temp;
               }
               break;
            case 2:
               if(rotateGravitymo)
               {
                  mox = -mox;
                  moy = -moy;
               }
               if(rotateGravitymor)
               {
                  this.morx = -this.morx;
                  this.mory = -this.mory;
               }
               break;
            case 3:
               if(rotateGravitymo)
               {
                  temp = mox;
                  mox = moy;
                  moy = -temp;
               }
               if(rotateGravitymor)
               {
                  temp = this.morx;
                  this.morx = this.mory;
                  this.mory = -temp;
               }
               break;
            case 4:
               if(rotateGravitymo)
               {
                  mox = 0;
                  moy = 0;
               }
               if(rotateGravitymor)
               {
                  this.morx = 0;
                  this.mory = 0;
               }
         }
         if(ItemId.isLiquid(delayed))
         {
            mx = this.horizontal;
            my = this.vertical;
         }
         else if(this.moy)
         {
            mx = this.horizontal;
            my = 0;
         }
         else if(this.mox)
         {
            mx = 0;
            my = this.vertical;
         }
         else
         {
            mx = this.horizontal;
            my = this.vertical;
         }
         mx *= this.speedMultiplier;
         my *= this.speedMultiplier;
         mox *= this.gravityMultiplier;
         moy *= this.gravityMultiplier;
         this.modifierX = this.mox + mx;
         this.modifierY = this.moy + my;
         if(ItemId.isSlippery(this.current_below) && !ItemId.isClimbable(this.current) && this.current != 4 && this.current != 414)
         {
            this.slippery = 2;
         }
         else if(ItemId.isSolid(this.current_below))
         {
            this.slippery = 0;
         }
         else if(this.slippery > 0)
         {
            this.slippery -= 0.2;
         }
         if(Boolean(_speedX) || Boolean(_modifierX))
         {
            _speedX += _modifierX;
            if((mx == 0 && moy != 0 || _speedX < 0 && mx > 0 || _speedX > 0 && mx < 0) && (this.slippery <= 0 || isgodmod) || ItemId.isClimbable(this.current) && !isgodmod)
            {
               _speedX *= Config.physics_base_drag;
               _speedX *= _no_modifier_dragX;
            }
            else if(this.current == ItemId.WATER && !isgodmod)
            {
               _speedX *= Config.physics_base_drag;
               _speedX *= _water_drag;
            }
            else if(this.current == ItemId.MUD && !isgodmod)
            {
               _speedX *= Config.physics_base_drag;
               _speedX *= this.dragMud;
            }
            else if(this.current == ItemId.LAVA && !isgodmod)
            {
               _speedX *= Config.physics_base_drag;
               _speedX *= _lava_drag;
            }
            else if(this.current == ItemId.TOXIC_WASTE && !isgodmod)
            {
               _speedX *= Config.physics_base_drag;
               _speedX *= _toxic_drag;
            }
            else if(this.slippery > 0 && !isgodmod)
            {
               if(mx != 0 && !(_speedX < 0 && mx > 0 || _speedX > 0 && mx < 0))
               {
                  _speedX *= Config.physics_base_drag;
               }
               else
               {
                  _speedX *= Config.physics_ice_no_mod_drag;
               }
               if(_speedX < 0 && mx > 0 || _speedX > 0 && mx < 0)
               {
                  _speedX *= Config.physics_ice_drag;
               }
            }
            else
            {
               _speedX *= Config.physics_base_drag;
            }
            if(_speedX > 16)
            {
               _speedX = 16;
            }
            else if(_speedX < -16)
            {
               _speedX = -16;
            }
            else if(_speedX < 0.0001 && _speedX > -0.0001)
            {
               _speedX = 0;
            }
         }
         if(Boolean(_speedY) || Boolean(_modifierY))
         {
            _speedY += _modifierY;
            if((my == 0 && mox != 0 || _speedY < 0 && my > 0 || _speedY > 0 && my < 0) && (this.slippery <= 0 || isgodmod) || ItemId.isClimbable(this.current) && !isgodmod)
            {
               _speedY *= Config.physics_base_drag;
               _speedY *= _no_modifier_dragY;
            }
            else if(this.current == ItemId.WATER && !isgodmod)
            {
               _speedY *= Config.physics_base_drag;
               _speedY *= _water_drag;
            }
            else if(this.current == ItemId.MUD && !isgodmod)
            {
               _speedY *= Config.physics_base_drag;
               _speedY *= this.dragMud;
            }
            else if(this.current == ItemId.LAVA && !isgodmod)
            {
               _speedY *= Config.physics_base_drag;
               _speedY *= _lava_drag;
            }
            else if(this.current == ItemId.TOXIC_WASTE && !isgodmod)
            {
               _speedY *= Config.physics_base_drag;
               _speedY *= _toxic_drag;
            }
            else if(this.slippery > 0 && !isgodmod)
            {
               if(my != 0 && !(_speedY < 0 && my > 0 || _speedY > 0 && my < 0))
               {
                  _speedY *= Config.physics_base_drag;
               }
               else
               {
                  _speedY *= Config.physics_ice_no_mod_drag;
               }
               if(_speedY < 0 && my > 0 || _speedY > 0 && my < 0)
               {
                  _speedY *= Config.physics_ice_drag;
               }
            }
            else
            {
               _speedY *= Config.physics_base_drag;
            }
            if(_speedY > 16)
            {
               _speedY = 16;
            }
            else if(_speedY < -16)
            {
               _speedY = -16;
            }
            else if(_speedY < 0.0001 && _speedY > -0.0001)
            {
               _speedY = 0;
            }
         }
         if(!isgodmod)
         {
            switch(this.current)
            {
               case ItemId.SPEED_LEFT:
                  _speedX = -_boost;
                  break;
               case ItemId.SPEED_RIGHT:
                  _speedX = _boost;
                  break;
               case ItemId.SPEED_UP:
                  _speedY = -_boost;
                  break;
               case ItemId.SPEED_DOWN:
                  _speedY = _boost;
            }
            if(this.isDead)
            {
               _speedX = 0;
               _speedY = 0;
            }
         }
         reminderX = this.x % 1;
         currentSX = _speedX;
         reminderY = this.y % 1;
         currentSY = _speedY;
         this.donex = false;
         this.doney = false;
         grounded = false;
         while(currentSX != 0 && !this.donex || currentSY != 0 && !this.doney)
         {
            processPortals();
            this.ox = this.x;
            this.oy = this.y;
            osx = currentSX;
            osy = currentSY;
            stepx();
            stepy();
         }
         if(!this.isDead)
         {
            mod = 1;
            injump = false;
            if(this.spacejustdown)
            {
               this.lastJump = -new Date().time;
               injump = true;
               mod = -1;
               this.spacejustdown = false;
            }
            if(this.spacedown)
            {
               if(this.hasLevitation)
               {
                  this.isThrusting = true;
                  this.applyThrust();
               }
               else if(this.lastJump < 0)
               {
                  if(new Date().time + this.lastJump > 750)
                  {
                     injump = true;
                  }
               }
               else if(new Date().time - this.lastJump > 150)
               {
                  injump = true;
               }
            }
            else
            {
               this.isThrusting = false;
            }
            if((Boolean(this.speedX == 0 && this.morx && mox || this.speedY == 0 && this.mory && moy)) && Boolean(grounded) || this.current == ItemId.EFFECT_MULTIJUMP)
            {
               this.jumpCount = 0;
            }
            if(this.jumpCount == 0 && !grounded)
            {
               this.jumpCount = 1;
            }
            if(injump && !this.hasLevitation)
            {
               if(Boolean(this.jumpCount < this.maxJumps) && Boolean(this.morx) && Boolean(mox))
               {
                  if(this.maxJumps < 1000)
                  {
                     this.jumpCount += 1;
                  }
                  this.speedX = -this.morx * Config.physics_jump_height * this.jumpMultiplier;
                  this.changed = true;
                  this.lastJump = new Date().time * mod;
               }
               if(Boolean(this.jumpCount < this.maxJumps) && Boolean(this.mory) && Boolean(moy))
               {
                  if(this.maxJumps < 1000)
                  {
                     this.jumpCount += 1;
                  }
                  this.speedY = -this.mory * Config.physics_jump_height * this.jumpMultiplier;
                  this.changed = true;
                  this.lastJump = new Date().time * mod;
               }
            }
            this.touchBlock(cx,cy,isgodmod);
            this.sendMovement(cx,cy);
            this.changed = false;
         }
         if(this.hasLevitation)
         {
            this.updateThrust();
         }
         imx = _speedX << 8;
         imy = _speedY << 8;
         moving = false;
         if(imx != 0 || ItemId.isLiquid(this.current) && !isgodmod)
         {
            moving = true;
         }
         else if(_modifierX < 0.1 && _modifierX > -0.1)
         {
            tx = this.x % 16;
            if(tx < 2)
            {
               if(tx < 0.2)
               {
                  this.x >>= 0;
               }
               else
               {
                  this.x -= tx / 15;
               }
            }
            else if(tx > 14)
            {
               if(tx > 15.8)
               {
                  this.x >>= 0;
                  ++this.x;
               }
               else
               {
                  this.x += (tx - 14) / 15;
               }
            }
         }
         if(imy != 0 || ItemId.isLiquid(this.current) && !isgodmod)
         {
            moving = true;
         }
         else if(_modifierY < 0.1 && _modifierY > -0.1)
         {
            ty = this.y % 16;
            if(ty < 2)
            {
               if(ty < 0.2)
               {
                  this.y >>= 0;
               }
               else
               {
                  this.y -= ty / 15;
               }
            }
            else if(ty > 14)
            {
               if(ty > 15.8)
               {
                  this.y >>= 0;
                  ++this.y;
               }
               else
               {
                  this.y += (ty - 14) / 15;
               }
            }
         }
         this.updateStuff();
      }
      
      override public function update() : void
      {
      }
      
      public function drawChat(param1:BitmapData, param2:Number, param3:Number, param4:Boolean) : void
      {
         if(!this.isme && !this.render)
         {
            return;
         }
         if(Global.showUI && (Global.showChatAndNames || Global.chatIsVisible))
         {
            this.chat.drawChat(param1,param2 + this.x,param3 + this.y,param4,Global.base.settings.hideUsernames,Global.base.settings.hideBubbles,this.team);
         }
      }
      
      public function enterChat() : void
      {
         this.chat.enterFrame();
      }
      
      public function say(param1:String) : void
      {
         this.chat.say(param1);
      }
      
      public function killPlayer() : void
      {
         this.isDead = true;
         this.deadAnim = AnimationManager.animRandomDeath();
      }
      
      public function respawn() : void
      {
         _modifierX = 0;
         _modifierY = 0;
         modifierX = 0;
         modifierY = 0;
         _speedX = 0;
         _speedY = 0;
         speedX = 0;
         speedY = 0;
         this.isDead = false;
         this.deathsend = false;
         this.isOnFire = false;
         this.last_respawn = new Date().time;
         this.resetSend = false;
      }
      
      public function resetDeath() : void
      {
         this.isDead = false;
         this.deathsend = false;
      }
      
      public function resetCoins() : void
      {
         this.coins = 0;
         this.bcoins = 0;
      }
      
      public function resetCheckpoint() : void
      {
         this.checkpoint_x = -1;
         this.checkpoint_y = -1;
      }
      
      override public function draw(param1:BitmapData, param2:int, param3:int) : void
      {
         var _loc8_:int = 0;
         if(!this.isme && !this.render)
         {
            return;
         }
         if(this.isFlying)
         {
            return;
         }
         if(!this.state)
         {
            return;
         }
         this.starty = -this.state.y - 90;
         this.startx = -this.state.x - 90;
         this.endy = this.starty + Bl.height + 180;
         this.endx = this.startx + Bl.width + 180;
         if(!(this.x > this.startx && this.y > this.starty && this.x < this.endx && this.y < this.endy) && !this.isme)
         {
            return;
         }
         if(this.isDead)
         {
            if(this.deadoffset > 16)
            {
               if(this.isme && !this.deathsend)
               {
                  this.deathsend = true;
                  this.connection.send("death");
               }
               return;
            }
            if(this.deadoffset < 2)
            {
               this.drawFace(param1,new Point(this.x + param2 - 5,this.y + param3 - 5),this.zombie);
            }
            _loc8_ = this.deadoffset;
            param1.copyPixels(this.deadAnim,new Rectangle(_loc8_ * 64,0,64,64),new Point(this.x + param2 - 24,this.y + param3 - 24));
            return;
         }
         var _loc4_:Number = this.x + param2 - 5;
         var _loc5_:Number = this.y + param3 - 5;
         var _loc6_:BitmapData = this.hascrown ? crown : (this.hascrownsilver ? crown_silver : null);
         var _loc7_:int = this.flipGravity * 90;
         if(_loc7_ >= 360 || _loc7_ < 0)
         {
            _loc7_ = 0;
         }
         this.drawFace(param1,new Point(_loc4_,_loc5_),this.zombie,_loc7_);
         if(_loc6_ != null)
         {
            param1.copyPixels(rotateBitmapData(_loc6_,_loc7_),_loc6_.rect,new Point(_loc4_ + (this.flipGravity % 2 == 0 ? 0 : (this.flipGravity == 1 ? 1 : -1)),_loc5_ + (this.flipGravity % 2 == 1 ? 0 : (this.flipGravity == 2 ? 1 : -1))));
         }
         if(this.isOnFire)
         {
            if((this.animoffset >> 0) % 3 == 0)
            {
               if(fireAnimation.frame < fireAnimation.totalFrames - 1)
               {
                  ++fireAnimation.frame;
               }
               else
               {
                  fireAnimation.frame = 0;
               }
            }
            fireAnimation.RotateDeg = _loc7_;
            fireAnimation.draw(param1,_loc4_ + (this.flipGravity >= 1 && this.flipGravity <= 3 ? -1 : 1),_loc5_ + (this.flipGravity == 1 ? 1 : (this.flipGravity == 3 ? -1 : 0)));
         }
         if(this.hasLevitation && this.isThrusting)
         {
            this.playLevitationAnimation(param1,param2,param3);
         }
         this.drawTagged(param1,param2,param3);
      }
      
      private function drawFace(param1:BitmapData, param2:Point, param3:Boolean, param4:int = 0) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc5_:BitmapData = param4 == 0 ? param1 : new BitmapData(26,26,true,0);
         var _loc6_:Point = param4 == 0 ? param2 : new Point(0,0);
         if(param3)
         {
            _loc5_.copyPixels(bmd,new Rectangle(26 * 87,this.rect2.y,this.rect2.width,this.rect2.height),_loc6_);
         }
         else if(this.frame == ItemId.SMILEY_PLATINUM_SPENDER)
         {
            _loc7_ = getTimer() + this.id * 400;
            _loc8_ = 90;
            _loc9_ = ItemManager.smileyPlatinumSpenderBMD.width / 26;
            _loc10_ = 2920;
            _loc11_ = Math.max(0,(_loc7_ % (_loc8_ * _loc9_ + _loc10_) - _loc10_) / _loc8_);
            _loc5_.copyPixels(ItemManager.smileyPlatinumSpenderBMD,new Rectangle(_loc11_ * 26,this.rect2.y,this.rect2.width,this.rect2.height),_loc6_);
         }
         else
         {
            _loc5_.copyPixels(bmd,this.rect2,_loc6_);
         }
         if(param4 != 0)
         {
            param1.copyPixels(rotateBitmapData(_loc5_,param4),_loc5_.rect,param2);
         }
      }
      
      private function playLevitationAnimation(param1:BitmapData, param2:int, param3:int) : void
      {
         if(!this.isme && !this.render)
         {
            return;
         }
         if(this.morx == 0 && this.mory == 0)
         {
            return;
         }
         var _loc4_:int = 0;
         var _loc5_:int = 8;
         var _loc6_:int = -5;
         var _loc7_:int = -5;
         if(this.mory != 0)
         {
            if(this.mory < 0)
            {
               _loc6_ = -21;
               _loc4_ = 8;
            }
            else
            {
               _loc6_ = 12;
               _loc4_ = 0;
            }
         }
         if(this.morx != 0)
         {
            if(this.morx < 0)
            {
               _loc7_ = -24;
               _loc4_ = 16;
            }
            else
            {
               _loc7_ = 14;
               _loc4_ = 24;
            }
         }
         if(levitationAnimation.frame < _loc4_ + _loc5_ - 1)
         {
            ++levitationAnimation.frame;
         }
         else
         {
            levitationAnimation.frame = _loc4_;
         }
         levitationAnimation.draw(param1,this.x + param2 + _loc7_,this.y + param3 + _loc6_);
      }
      
      public function drawGods(param1:BitmapData, param2:int, param3:int) : void
      {
         var _loc5_:int = 0;
         if(!this.isme && !this.render || !this.isFlying)
         {
            return;
         }
         var _loc4_:Boolean = this.isInGodMode && this.aura == 10;
         if(_loc4_)
         {
            this.drawFace(param1,new Point(this.x + param2 - 5,this.y + param3 - 5),false);
            if(this.hascrown)
            {
               param1.copyPixels(crown,crown.rect,new Point(this.x + param2 - 5,this.y + param3 - 6));
            }
            else if(this.hascrownsilver)
            {
               param1.copyPixels(crown_silver,crown_silver.rect,new Point(this.x + param2 - 5,this.y + param3 - 6));
            }
         }
         if(this.isInGodMode)
         {
            ItemManager.getAuraByIdAndColor(this.aura,this.auraColor).drawTo(param1,this.x + param2 - 24,this.y + param3 - 24,this.auraAnimOffset);
         }
         else if(this.isInModMode)
         {
            _loc5_ = this.modoffset;
            this.modrect.x = _loc5_ * 64;
            param1.copyPixels(staffAuraBMD,this.modrect,new Point(this.x + param2 - 24,this.y + param3 - 24));
         }
         if(!_loc4_)
         {
            this.drawFace(param1,new Point(this.x + param2 - 5,this.y + param3 - 5),false);
            if(this.hascrown)
            {
               param1.copyPixels(crown,crown.rect,new Point(this.x + param2 - 5,this.y + param3 - 6));
            }
            else if(this.hascrownsilver)
            {
               param1.copyPixels(crown_silver,crown_silver.rect,new Point(this.x + param2 - 5,this.y + param3 - 6));
            }
         }
      }
      
      override public function set frame(param1:int) : void
      {
         this.rect2.x = param1 * 26;
      }
      
      override public function get frame() : int
      {
         return this.rect2.x / 26;
      }
      
      public function set wearsGoldSmiley(param1:Boolean) : void
      {
         this.rect2.y = param1 ? 26 : 0;
      }
      
      public function get wearsGoldSmiley() : Boolean
      {
         return this.rect2.y == 26;
      }
      
      public function set nameColor(param1:int) : void
      {
         this.chat.textColor = param1;
      }
      
      public function pressPurpleSwitch(param1:int, param2:Boolean) : void
      {
         var i:int = 0;
         var switchId:int = param1;
         var enabled:Boolean = param2;
         if(switchId == 1000)
         {
            i = 0;
            while(i < 1000)
            {
               this.pressPurpleSwitch(i,enabled);
               i++;
            }
         }
         this.switches[switchId] = enabled;
         if(this.world.overlaps(this))
         {
            this.switches[switchId] = !enabled;
            this.tilequeue.push(function():void
            {
               pressPurpleSwitch(switchId,enabled);
            });
         }
      }
      
      public function UpdateTeamDoors(param1:int, param2:int) : void
      {
         var _loc3_:int = this.world.lookup.getInt(param1,param2);
         var _loc4_:int = this.team;
         if(this.team == _loc3_)
         {
            return;
         }
         this.team = _loc3_;
         if(!hitmap.overlaps(this.that))
         {
            if(this.isme)
            {
               (Global.base.sidechat.names[this.name] as UserlistItem).setTeam(this.team);
               this.connection.send("team",param1,param2,_loc3_);
            }
            this.tx = -1;
            this.ty = -1;
         }
         else
         {
            this.team = _loc4_;
            this.tx = param1;
            this.ty = param2;
         }
      }
      
      public function get minimapColor() : uint
      {
         var _loc1_:uint = uint(ItemManager.getSmileyById(this.frame).minimapcolor || 16777215);
         return this.isInModMode ? getNameColor(this.name) : (_loc1_ != 4294967295 ? _loc1_ : (this.isInGodMode && isPatron(this.name) ? getPatronColor(this.name) : (this.isme && Global.base.settings.greenOnMinimap ? uint(4278255360) : uint(4294967295))));
      }
      
      private function drawTagged(param1:BitmapData, param2:Number, param3:Number) : void
      {
         var offset:int = 0;
         var deg:int = 0;
         var target:BitmapData = param1;
         var ox:Number = param2;
         var oy:Number = param3;
         var drawIcon:Function = function(param1:int):void
         {
            effectIcons.frame = param1;
            effectIcons.RotateDeg = deg;
            effectIcons.draw(target,x + ox + (flipGravity % 2 == 0 ? 0 : (flipGravity == 1 ? -offset : offset)),y + oy + (flipGravity % 2 == 1 ? 0 : (flipGravity == 2 ? -offset : offset)));
            offset -= 12;
         };
         offset = -16;
         deg = this.flipGravity * 90 % 360;
         if(this.isInvulnerable)
         {
            drawIcon(0);
         }
         if(this.cursed)
         {
            drawIcon(1);
         }
         if(this.poison)
         {
            drawIcon(3);
         }
      }
      
      public function get speedBoost() : int
      {
         return this._speedBoost.value;
      }
      
      public function set speedBoost(param1:int) : void
      {
         this._speedBoost.value = param1;
      }
      
      public function set flipGravity(param1:int) : void
      {
         this._flipGravity.value = param1;
      }
      
      public function get flipGravity() : int
      {
         return this._flipGravity.value;
      }
      
      public function get jumpBoost() : int
      {
         return this._jumpBoost.value;
      }
      
      public function set jumpBoost(param1:int) : void
      {
         this._jumpBoost.value = param1;
      }
      
      public function set cursed(param1:Boolean) : void
      {
         this._cursed.value = param1;
      }
      
      public function get cursed() : Boolean
      {
         return this._cursed.value;
      }
      
      public function set zombie(param1:Boolean) : void
      {
         this._zombie.value = param1;
      }
      
      public function get zombie() : Boolean
      {
         if(this.isFlying)
         {
            return false;
         }
         return this._zombie.value;
      }
      
      public function set poison(param1:Boolean) : void
      {
         this._poison.value = param1;
      }
      
      public function get poison() : Boolean
      {
         if(this.isFlying)
         {
            return false;
         }
         return this._poison.value;
      }
      
      public function getCanTag() : Boolean
      {
         if(this.isFlying || this.isDead)
         {
            return false;
         }
         return this.cursed || this.isInvulnerable || this.zombie;
      }
      
      public function getCanBeTagged() : Boolean
      {
         if(this.isFlying || this.isDead || this.isInvulnerable)
         {
            return false;
         }
         return new Date().time - this.last_respawn > 1000;
      }
      
      public function setPosition(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function setEffect(param1:int, param2:Boolean, param3:int = 0, param4:int = 0) : void
      {
         switch(param1)
         {
            case Config.effectReset:
               this.resetEffects(false);
            case Config.effectJump:
               this.jumpBoost = param2 ? param3 : 0;
               break;
            case Config.effectFly:
               this.hasLevitation = param2;
               break;
            case Config.effectRun:
               this.speedBoost = param2 ? param3 : 0;
               break;
            case Config.effectProtection:
               this.isInvulnerable = param2;
               break;
            case Config.effectCurse:
               this.cursed = param2;
               break;
            case Config.effectZombie:
               this.zombie = param2;
               break;
            case Config.effectLowGravity:
               this.low_gravity = param2;
               break;
            case Config.effectFire:
               this.isOnFire = param2;
               break;
            case Config.effectMultijump:
               this.maxJumps = param2 ? param3 : 1;
               break;
            case Config.effectGravity:
               this.flipGravity = param3;
               break;
            case Config.effectPoison:
               this.poison = param2;
         }
         if(this.isme)
         {
            Global.base.ui2instance.setEffectIcon(param1,param2,param3,param4);
         }
      }
      
      public function resetEffects(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         for each(_loc2_ in this.staticEffects)
         {
            this.setEffect(_loc2_,false);
         }
         if(param1)
         {
            for each(_loc3_ in this.timedEffects)
            {
               this.setEffect(_loc3_,false);
            }
         }
      }
      
      public function set isInvulnerable(param1:Boolean) : void
      {
         this._isInvulnerable.value = param1;
      }
      
      public function get isInvulnerable() : Boolean
      {
         return this._isInvulnerable.value;
      }
      
      public function get hasLevitation() : Boolean
      {
         return this._hasLevitation.value;
      }
      
      public function set hasLevitation(param1:Boolean) : void
      {
         this._hasLevitation.value = param1;
         if(!param1)
         {
            this._currentThrust = 0;
         }
      }
      
      public function updateThrust() : void
      {
         if(this.mory != 0)
         {
            this.speedY -= this._currentThrust * (Config.physics_jump_height / 2) * (this.mory * 0.5);
         }
         if(this.morx != 0)
         {
            this.speedX -= this._currentThrust * (Config.physics_jump_height / 2) * (this.morx * 0.5);
         }
         if(!this.isThrusting)
         {
            if(this._currentThrust > 0)
            {
               this._currentThrust -= this._thrustBurnOff;
            }
            else
            {
               this._currentThrust = 0;
            }
         }
      }
      
      public function get isThrusting() : Boolean
      {
         return this._isThrusting.value;
      }
      
      public function set isThrusting(param1:Boolean) : void
      {
         this._isThrusting.value = param1;
      }
      
      public function applyThrust() : void
      {
         this._currentThrust = this._maxThrust;
      }
      
      public function get isFlying() : Boolean
      {
         return this.isInGodMode || this.isInModMode;
      }
      
      public function get isFlaunting() : Boolean
      {
         return this._isFlaunting;
      }
      
      public function set isFlaunting(param1:Boolean) : void
      {
         this._isFlaunting = param1;
      }
      
      public function get canToggleGodMode() : Boolean
      {
         return this.canEdit || this._canToggleGod;
      }
      
      public function set canToggleGodMode(param1:Boolean) : void
      {
         this._canToggleGod = param1;
      }
      
      protected function getPlayerInput() : void
      {
      }
      
      protected function touchBlock(param1:int, param2:int, param3:Boolean) : void
      {
      }
      
      protected function sendMovement(param1:int, param2:int) : void
      {
      }
      
      protected function updateStuff() : void
      {
      }
   }
}


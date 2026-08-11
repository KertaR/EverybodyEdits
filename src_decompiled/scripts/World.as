package
{
   import blitter.Bl;
   import blitter.BlContainer;
   import blitter.BlObject;
   import blitter.BlSprite;
   import blitter.BlText;
   import blitter.BlTilemap;
   import com.reygazu.anticheat.variables.SecureBoolean;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import items.ItemId;
   import items.ItemManager;
   import items.ItemNpc;
   import playerio.DatabaseObject;
   import playerio.Message;
   import states.PlayState;
   import ui.ingame.ResetPopup;
   import utilities.MathUtil;
   
   public class World extends BlTilemap
   {
      
      private static var sprite:BlSprite;
      
      private static var bmd:BitmapData;
      
      private static var type:int;
      
      private static var worldportaltext:WorldPortalHelpBubble = new WorldPortalHelpBubble();
      
      private static var resetPopup:ResetPopup = new ResetPopup();
      
      private static var point:Point = new Point();
      
      private static var rect16x16:Rectangle = new Rectangle(0,0,16,16);
      
      private static var rect18x18:Rectangle = new Rectangle(0,0,18,18);
      
      private var player:Player;
      
      private var labelcontainer:BlContainer = new BlContainer();
      
      public var particlecontainer:BlContainer = new BlContainer();
      
      private var bgColor:uint = 11059452;
      
      private var customBgColor:Boolean = false;
      
      public var lookup:Lookup = new Lookup();
      
      private var textSignBubble:TextBubble = new TextBubble();
      
      public var showAllSecrets:Boolean = false;
      
      private var inspectTool:InspectTool;
      
      private var isAnimatingNPC:Boolean = false;
      
      private var offsetNPC:Number;
      
      public var imageBlocks:Array = new Array();
      
      private var offset:Number = 0;
      
      private var keys:Object = {
         "red":new SecureBoolean("RedKey"),
         "green":new SecureBoolean("GreenKey"),
         "blue":new SecureBoolean("BlueKey"),
         "cyan":new SecureBoolean("CyanKey"),
         "magenta":new SecureBoolean("MagentaKey"),
         "yellow":new SecureBoolean("YellowKey")
      };
      
      public var orangeSwitches:Object = {};
      
      private var timedoorState:Boolean = false;
      
      public var canShowOrHidePurple:Boolean = false;
      
      public var showCoinGate:int = 0;
      
      public var showBlueCoinGate:int = 0;
      
      public var showDeathGate:int = 0;
      
      public var hideTimedoorOffset:Number = 0;
      
      public var hideTimedoorTimer:Number = new Date().time;
      
      private var ice:Number = 0;
      
      private var iceTime:int = 60;
      
      public var fullImage:BitmapData;
      
      public function World(param1:Boolean = true)
      {
         super(new Bitmap(new BitmapData(16,16,false,0)),9);
         if(param1)
         {
            this.lookup.reset();
            this.customBgColor = false;
         }
         this.inspectTool = new InspectTool(this);
      }
      
      public static function layersFromDatabaseObject(param1:DatabaseObject) : Array
      {
         var _loc10_:int = 0;
         var _loc11_:Object = null;
         var _loc12_:ByteArray = null;
         var _loc13_:ByteArray = null;
         var _loc14_:ByteArray = null;
         var _loc15_:ByteArray = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc2_:int = int(int(param1.width) || 0);
         var _loc3_:int = int(int(param1.height) || 0);
         if(_loc2_ == 0 || _loc3_ == 0)
         {
            switch(param1.type)
            {
               case 1:
                  _loc2_ = 50;
                  _loc3_ = 50;
                  break;
               case 2:
                  _loc2_ = 100;
                  _loc3_ = 100;
                  break;
               default:
               case 3:
                  _loc2_ = 200;
                  _loc3_ = 200;
                  break;
               case 4:
                  _loc2_ = 400;
                  _loc3_ = 50;
                  break;
               case 5:
                  _loc2_ = 400;
                  _loc3_ = 200;
                  break;
               case 6:
                  _loc2_ = 100;
                  _loc3_ = 400;
                  break;
               case 7:
                  _loc2_ = 636;
                  _loc3_ = 50;
                  break;
               case 8:
                  _loc2_ = 110;
                  _loc3_ = 110;
                  break;
               case 11:
                  _loc2_ = 300;
                  _loc3_ = 300;
                  break;
               case 12:
                  _loc2_ = 250;
                  _loc3_ = 150;
            }
         }
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < 2)
         {
            _loc5_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc3_)
            {
               _loc6_ = [];
               _loc10_ = 0;
               while(_loc10_ < _loc2_)
               {
                  _loc6_.push(0);
                  _loc10_++;
               }
               _loc5_.push(_loc6_);
               _loc7_++;
            }
            _loc4_.push(_loc5_);
            _loc8_++;
         }
         var _loc9_:Array = param1.worlddata || [];
         _loc7_ = 0;
         while(_loc7_ < _loc9_.length)
         {
            if(_loc9_[_loc7_] != null)
            {
               _loc11_ = _loc9_[_loc7_];
               _loc12_ = _loc11_.x || new ByteArray();
               _loc13_ = _loc11_.y || new ByteArray();
               _loc14_ = _loc11_.x1 || new ByteArray();
               _loc15_ = _loc11_.y1 || new ByteArray();
               _loc16_ = int(int(_loc11_.layer) || 0);
               _loc17_ = int(int(_loc11_.type) || 0);
               _loc12_.position = 0;
               _loc13_.position = 0;
               _loc14_.position = 0;
               _loc15_.position = 0;
               while(_loc14_.position < _loc14_.length)
               {
                  _loc18_ = int(_loc14_.readUnsignedByte());
                  _loc19_ = int(_loc15_.readUnsignedByte());
                  _loc4_[_loc16_][_loc19_][_loc18_] = _loc17_;
               }
               while(_loc12_.position < _loc12_.length)
               {
                  _loc20_ = (_loc12_.readUnsignedByte() << 8) + _loc12_.readUnsignedByte();
                  _loc21_ = (_loc13_.readUnsignedByte() << 8) + _loc13_.readUnsignedByte();
                  _loc4_[_loc16_][_loc21_][_loc20_] = _loc17_;
               }
            }
            _loc7_++;
         }
         return _loc4_;
      }
      
      public function setShowAllSecrets(param1:Boolean) : void
      {
         this.showAllSecrets = param1;
      }
      
      public function setPlayer(param1:Player) : void
      {
         this.player = param1;
      }
      
      public function setBackgroundColor(param1:uint) : void
      {
         this.customBgColor = (param1 >> 24 & 0xFF) == 255;
         this.bgColor = param1;
         ItemManager.bricks[0].minimapColor = this.customBgColor ? param1 : 4278190080;
      }
      
      public function getKey(param1:String) : Boolean
      {
         if(!this.keys[param1])
         {
            throw new Error("Color \'" + param1 + "\' doesn\'t exist!");
         }
         if(!(this.keys[param1] is SecureBoolean))
         {
            throw new Error("Key \'" + param1 + "\' is not type \'SecureBoolean\'!");
         }
         return this.keys[param1].value;
      }
      
      public function setKey(param1:String, param2:Boolean) : void
      {
         if(!this.keys[param1])
         {
            throw new Error("Color \'" + param1 + "\' doesn\'t exist!");
         }
         if(!(this.keys[param1] is SecureBoolean))
         {
            throw new Error("Key \'" + param1 + "\' is not type \'SecureBoolean\'!");
         }
         this.keys[param1].value = param2;
      }
      
      public function setTimedoor(param1:Boolean) : void
      {
         this.hideTimedoorOffset = this.offset;
         this.hideTimedoorTimer = new Date().time;
         this.timedoorState = param1;
      }
      
      override public function update() : void
      {
         var _loc2_:Particle = null;
         this.offset += 0.3;
         var _loc1_:int = 0;
         while(_loc1_ < this.particlecontainer.children.length)
         {
            _loc2_ = this.particlecontainer.children[_loc1_] as Particle;
            _loc2_.tick();
            _loc1_++;
         }
         super.update();
      }
      
      public function updateRotateablesMap(param1:int, param2:int, param3:int, param4:int = 0) : void
      {
         var _loc5_:int = getTile(param4,param2,param3);
         if(_loc5_ == param1)
         {
            return;
         }
         if(_loc5_ != ItemId.SPIKE && _loc5_ != ItemId.SPIKE_SILVER && _loc5_ != ItemId.SPIKE_BLACK && _loc5_ != ItemId.SPIKE_RED && _loc5_ != ItemId.SPIKE_GOLD && _loc5_ != ItemId.SPIKE_GREEN && _loc5_ != ItemId.SPIKE_BLUE && !ItemId.isBlockRotateable(_loc5_))
         {
            return;
         }
         if(param1 != ItemId.SPIKE && param1 != ItemId.SPIKE_SILVER && param1 != ItemId.SPIKE_BLACK && param1 != ItemId.SPIKE_RED && param1 != ItemId.SPIKE_GOLD && param1 != ItemId.SPIKE_GREEN && param1 != ItemId.SPIKE_BLUE && !ItemId.isBlockRotateable(param1))
         {
            return;
         }
         this.lookup.deleteLookup(param2,param3);
      }
      
      public function deserializeFromDatabaseObject(param1:DatabaseObject) : void
      {
         this.setBackgroundColor(uint(param1.backgroundColor) || 0);
         setMapArray(layersFromDatabaseObject(param1));
      }
      
      public function deserializeFromMessage(param1:int, param2:int, param3:Message) : Array
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:ByteArray = null;
         var _loc16_:ByteArray = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:int = 0;
         var _loc24_:String = null;
         var _loc25_:String = null;
         var _loc26_:int = 0;
         var _loc27_:Boolean = false;
         var _loc28_:String = null;
         var _loc29_:Array = null;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:BlText = null;
         Global.worldData = param3;
         var _loc6_:int = 0;
         while(_loc6_ < param3.length)
         {
            try
            {
               if(param3.getString(_loc6_) == "ws")
               {
                  _loc4_ = int(_loc6_ + 1);
               }
               if(param3.getString(_loc6_) == "we")
               {
                  _loc5_ = _loc6_;
               }
            }
            catch(e:Error)
            {
            }
            _loc6_++;
         }
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         this.lookup.reset();
         var _loc10_:int = 0;
         while(_loc10_ < 2)
         {
            _loc8_ = [];
            _loc11_ = 0;
            while(_loc11_ < param2)
            {
               _loc9_ = [];
               _loc12_ = 0;
               while(_loc12_ < param1)
               {
                  _loc9_.push(0);
                  _loc12_++;
               }
               _loc8_.push(_loc9_);
               _loc11_++;
            }
            _loc7_.push(_loc8_);
            _loc10_++;
         }
         while(_loc4_ < _loc5_)
         {
            _loc13_ = param3.getInt(_loc4_++);
            _loc14_ = param3.getInt(_loc4_++);
            _loc15_ = param3.getByteArray(_loc4_++);
            _loc16_ = param3.getByteArray(_loc4_++);
            _loc17_ = 0;
            _loc18_ = 0;
            _loc19_ = 0;
            _loc20_ = 0;
            _loc29_ = new Array();
            if(ItemId.isBlockRotateable(_loc13_) || ItemId.isNonRotatableHalfBlock(_loc13_))
            {
               _loc18_ = param3.getInt(_loc4_++);
            }
            switch(_loc13_)
            {
               case ItemId.COINGATE:
               case ItemId.COINDOOR:
               case ItemId.BLUECOINDOOR:
               case ItemId.BLUECOINGATE:
               case ItemId.DEATH_DOOR:
               case ItemId.DEATH_GATE:
               case ItemId.SWITCH_PURPLE:
               case ItemId.RESET_PURPLE:
               case ItemId.DOOR_PURPLE:
               case ItemId.GATE_PURPLE:
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
               case ItemId.EFFECT_POISON:
               case ItemId.SWITCH_ORANGE:
               case ItemId.RESET_ORANGE:
               case ItemId.DOOR_ORANGE:
               case ItemId.GATE_ORANGE:
                  _loc17_ = param3.getInt(_loc4_++);
                  break;
               case ItemId.EFFECT_GRAVITY:
               case ItemId.SPIKE:
               case ItemId.SPIKE_SILVER:
               case ItemId.SPIKE_BLACK:
               case ItemId.SPIKE_RED:
               case ItemId.SPIKE_GOLD:
               case ItemId.SPIKE_GREEN:
               case ItemId.SPIKE_BLUE:
                  _loc18_ = param3.getInt(_loc4_++);
                  break;
               case ItemId.PORTAL_INVISIBLE:
               case ItemId.PORTAL:
                  _loc18_ = param3.getInt(_loc4_++);
                  _loc19_ = param3.getInt(_loc4_++);
                  _loc20_ = param3.getInt(_loc4_++);
                  break;
               case ItemId.WORLD_PORTAL:
                  _loc24_ = param3.getString(_loc4_++);
                  _loc20_ = param3.getInt(_loc4_++);
                  break;
               case ItemId.WORLD_PORTAL_SPAWN:
                  _loc19_ = param3.getInt(_loc4_++);
                  break;
               case ItemId.TEXT_SIGN:
                  _loc25_ = param3.getString(_loc4_++);
                  _loc26_ = param3.getInt(_loc4_++);
                  break;
               case 1000:
                  _loc21_ = param3.getString(_loc4_++);
                  _loc22_ = param3.getString(_loc4_++);
                  _loc23_ = param3.getInt(_loc4_++);
                  break;
               case 83:
               case 77:
               case 1520:
                  _loc19_ = param3.getInt(_loc4_++);
            }
            if(ItemId.isNPC(_loc13_))
            {
               _loc28_ = param3.getString(_loc4_++);
               _loc29_[0] = param3.getString(_loc4_++);
               _loc29_[1] = param3.getString(_loc4_++);
               _loc29_[2] = param3.getString(_loc4_++);
            }
            _loc15_.position = 0;
            _loc16_.position = 0;
            _loc30_ = 0;
            while(_loc30_ < _loc15_.length / 2)
            {
               _loc31_ = int(_loc15_.readUnsignedShort());
               _loc32_ = int(_loc16_.readUnsignedShort());
               _loc7_[_loc14_][_loc32_][_loc31_] = _loc13_;
               if(ItemId.isBlockRotateable(_loc13_) || ItemId.isNonRotatableHalfBlock(_loc13_))
               {
                  this.lookup.setInt(_loc31_,_loc32_,_loc18_);
               }
               switch(_loc13_)
               {
                  case ItemId.COINDOOR:
                  case ItemId.BLUECOINDOOR:
                  case ItemId.BLUECOINGATE:
                  case ItemId.COINGATE:
                  case ItemId.DEATH_DOOR:
                  case ItemId.DEATH_GATE:
                  case ItemId.SWITCH_PURPLE:
                  case ItemId.RESET_PURPLE:
                  case ItemId.DOOR_PURPLE:
                  case ItemId.GATE_PURPLE:
                  case ItemId.EFFECT_TEAM:
                  case ItemId.TEAM_DOOR:
                  case ItemId.TEAM_GATE:
                  case ItemId.EFFECT_CURSE:
                  case ItemId.EFFECT_ZOMBIE:
                  case ItemId.EFFECT_FLY:
                  case ItemId.EFFECT_JUMP:
                  case ItemId.EFFECT_PROTECTION:
                  case ItemId.EFFECT_RUN:
                  case ItemId.EFFECT_LOW_GRAVITY:
                  case ItemId.EFFECT_MULTIJUMP:
                  case ItemId.EFFECT_POISON:
                  case ItemId.SWITCH_ORANGE:
                  case ItemId.RESET_ORANGE:
                  case ItemId.DOOR_ORANGE:
                  case ItemId.GATE_ORANGE:
                     this.lookup.setInt(_loc31_,_loc32_,_loc17_);
                     break;
                  case 83:
                  case 77:
                  case 1520:
                     this.lookup.setInt(_loc31_,_loc32_,_loc19_);
                     break;
                  case ItemId.EFFECT_GRAVITY:
                  case ItemId.SPIKE:
                  case ItemId.SPIKE_SILVER:
                  case ItemId.SPIKE_BLACK:
                  case ItemId.SPIKE_RED:
                  case ItemId.SPIKE_GOLD:
                  case ItemId.SPIKE_GREEN:
                  case ItemId.SPIKE_BLUE:
                     this.lookup.setInt(_loc31_,_loc32_,_loc18_);
                     break;
                  case ItemId.PORTAL_INVISIBLE:
                  case ItemId.PORTAL:
                     this.lookup.setPortal(_loc31_,_loc32_,new Portal(_loc19_,_loc20_,_loc18_,_loc13_));
                     break;
                  case ItemId.WORLD_PORTAL:
                     this.lookup.setWorldPortal(_loc31_,_loc32_,new WorldPortal(_loc24_,_loc20_));
                     break;
                  case ItemId.WORLD_PORTAL_SPAWN:
                     this.lookup.setInt(_loc31_,_loc32_,_loc19_);
                     break;
                  case 1000:
                     this.lookup.setLabel(_loc31_,_loc32_,_loc21_,_loc22_,_loc23_);
                     _loc33_ = new BlText(Global.default_label_size,_loc23_,uint("0x" + _loc22_.substr(1,_loc22_.length)),"left","system",true);
                     _loc33_.text = _loc21_;
                     _loc33_.x = _loc31_ * size;
                     _loc33_.y = _loc32_ * size;
                     this.labelcontainer.add(_loc33_);
                  case ItemId.TEXT_SIGN:
                     this.lookup.setTextSign(_loc31_,_loc32_,new TextSign(_loc25_,_loc26_));
                     break;
                  case ItemId.BRICK_COMPLETE:
               }
               if(ItemId.isNPC(_loc13_))
               {
                  this.lookup.setNpc(_loc31_,_loc32_,_loc28_,_loc29_,ItemManager.getNpcById(_loc13_));
               }
               _loc30_++;
            }
         }
         setMapArray(_loc7_);
         return _loc7_;
      }
      
      public function resetCoins() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < width)
         {
            _loc2_ = 0;
            while(_loc2_ < height)
            {
               if(realmap[0][_loc2_][_loc1_] == 110)
               {
                  this.setTile(0,_loc1_,_loc2_,100);
               }
               if(realmap[0][_loc2_][_loc1_] == 111)
               {
                  this.setTile(0,_loc1_,_loc2_,101);
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      public function setTileComplex(param1:int, param2:int, param3:int, param4:int, param5:Object) : void
      {
         var _loc6_:BlText = null;
         var _loc7_:int = 0;
         var _loc8_:BlText = null;
         if(param1 == 0)
         {
            this.lookup.deleteLookup(param2,param3);
         }
         if(ItemId.isBlockRotateable(param4) || ItemId.isNonRotatableHalfBlock(param4))
         {
            if(param5.rotation != null)
            {
               this.lookup.setInt(param2,param3,param5.rotation);
            }
         }
         switch(param4)
         {
            case ItemId.COINDOOR:
            case ItemId.BLUECOINDOOR:
            case ItemId.BLUECOINGATE:
            case ItemId.COINGATE:
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
            case ItemId.EFFECT_ZOMBIE:
            case ItemId.EFFECT_FLY:
            case ItemId.EFFECT_JUMP:
            case ItemId.EFFECT_PROTECTION:
            case ItemId.EFFECT_RUN:
            case ItemId.EFFECT_LOW_GRAVITY:
            case ItemId.EFFECT_MULTIJUMP:
            case ItemId.EFFECT_POISON:
            case ItemId.SWITCH_ORANGE:
            case ItemId.RESET_ORANGE:
            case ItemId.DOOR_ORANGE:
            case ItemId.GATE_ORANGE:
            case ItemId.WORLD_PORTAL_SPAWN:
               this.lookup.setInt(param2,param3,param5.goal);
               break;
            case ItemId.EFFECT_GRAVITY:
            case ItemId.SPIKE:
            case ItemId.SPIKE_SILVER:
            case ItemId.SPIKE_BLACK:
            case ItemId.SPIKE_RED:
            case ItemId.SPIKE_GOLD:
            case ItemId.SPIKE_GREEN:
            case ItemId.SPIKE_BLUE:
               if(param5.rotation != null)
               {
                  this.lookup.setInt(param2,param3,param5.rotation);
               }
               break;
            case ItemId.PORTAL_INVISIBLE:
            case ItemId.PORTAL:
               if(param5.rotation != null && param5.id != null && param5.target != null)
               {
                  this.lookup.setPortal(param2,param3,new Portal(param5.id,param5.target,param5.rotation,param4));
               }
               break;
            case ItemId.WORLD_PORTAL:
               if(param5.target != null && param5.spawnid != null)
               {
                  this.lookup.setWorldPortal(param2,param3,new WorldPortal(param5.target,param5.spawnid));
               }
               break;
            case ItemId.TEXT_SIGN:
               if(param5.text != null && param5.signtype != null)
               {
                  this.lookup.setTextSign(param2,param3,new TextSign(param5.text,param5.signtype));
               }
               break;
            case 83:
            case 77:
            case 1520:
               this.lookup.setInt(param2,param3,param5.sound);
               this.lookup.setBlink(param2,param3,30);
               break;
            case 411:
            case 412:
            case 413:
            case 414:
            case ItemId.SLOW_DOT_INVISIBLE:
            case 1519:
            case ItemId.FIREWORKS:
               this.lookup.setBlink(param2,param3,0);
               break;
            case 1000:
               this.lookup.setLabel(param2,param3,param5.text,param5.text_color,param5.wraplength);
               _loc6_ = new BlText(Global.default_label_size,this.lookup.getLabel(param2,param3).WrapLength,uint("0x" + param5.text_color.substr(1,param5.text_color.length)),"left","system",true);
               _loc6_.text = param5.text;
               _loc6_.x = param2 * size;
               _loc6_.y = param3 * size;
               this.labelcontainer.add(_loc6_);
         }
         if(ItemId.isNPC(param4) && param5.name != null && Boolean(param5.messages))
         {
            if(Boolean(this.player.currentNpc) && this.lookup.getNpc(param2,param3).equals(this.player.currentNpc))
            {
               this.lookup.setNpc(param2,param3,param5.name,param5.messages,ItemManager.getNpcById(param4));
               this.player.currentNpc = this.lookup.getNpc(param2,param3);
               this.player.currentNpc.reset();
            }
            else
            {
               this.lookup.setNpc(param2,param3,param5.name,param5.messages,ItemManager.getNpcById(param4));
            }
         }
         if(param4 != 1000 && param1 == 0)
         {
            _loc7_ = 0;
            while(_loc7_ < this.labelcontainer.children.length)
            {
               _loc8_ = this.labelcontainer.children[_loc7_] as BlText;
               if(_loc8_.x == param2 * size && _loc8_.y == param3 * size)
               {
                  this.labelcontainer.remove(_loc8_);
                  break;
               }
               _loc7_++;
            }
         }
         this.setTile(param1,param2,param3,param4);
      }
      
      override protected function setTile(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc6_:Vector.<BlObject> = null;
         var _loc7_:int = 0;
         var _loc8_:BlObject = null;
         var _loc5_:int = realmap[param1][param3][param2];
         if(_loc5_ == 1000)
         {
            _loc6_ = this.labelcontainer.children;
            _loc7_ = 0;
            while(_loc7_ < _loc6_.length)
            {
               _loc8_ = _loc6_[_loc7_];
               if(_loc8_.x == param2 * size && _loc8_.y == param3 * size)
               {
                  this.labelcontainer.remove(_loc8_);
                  break;
               }
               _loc7_++;
            }
         }
         super.setTile(param1,param2,param3,param4);
         if(param4 == ItemId.COLLECTEDCOIN && _loc5_ == ItemId.COIN)
         {
            return;
         }
         if(param4 == ItemId.COLLECTEDBLUECOIN && _loc5_ == ItemId.BLUECOIN)
         {
            return;
         }
         if(param4 == ItemId.COIN && _loc5_ == ItemId.COLLECTEDCOIN)
         {
            return;
         }
         if(param4 == ItemId.BLUECOIN && _loc5_ == ItemId.COLLECTEDBLUECOIN)
         {
            return;
         }
         (Global.base.state as PlayState).unsavedChanges = true;
      }
      
      public function Overlaps(param1:BlObject, param2:int, param3:int, param4:Boolean = false) : Boolean
      {
         var _loc6_:Rectangle = null;
         if((param1 as Player).isFlying)
         {
            return false;
         }
         var _loc5_:int = realmap[0][param3][param2];
         if(ItemId.isSolid(_loc5_) || param4)
         {
            _loc6_ = ItemManager.GetBlockBounds(_loc5_);
            if(param4)
            {
               _loc6_ = ItemManager.GetBlockBounds(_loc5_,this.lookup.getInt(param2,param3));
            }
            _loc6_.x += param2 * 16;
            _loc6_.y += param3 * 16;
            if(_loc6_.intersects(new Rectangle(param1.x,param1.y,16,16)))
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      override public function overlaps(param1:BlObject) : int
      {
         var _loc11_:Vector.<int> = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(param1.x < 0 || param1.y < 0 || param1.x > this.width * 16 - 16 || param1.y > this.height * 16 - 16)
         {
            return 1;
         }
         var _loc2_:Player = param1 as Player;
         if(_loc2_.isFlying)
         {
            return 0;
         }
         var _loc3_:int = _loc2_.x >> 4;
         var _loc4_:int = _loc2_.y >> 4;
         var _loc5_:Number = (param1.x + param1.height) / size;
         var _loc6_:Number = (param1.y + param1.width) / size;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc12_:Rectangle = new Rectangle(_loc2_.x,_loc2_.y,16,16);
         var _loc13_:int = _loc4_;
         while(_loc13_ < _loc6_)
         {
            _loc11_ = realmap[0][_loc13_];
            _loc14_ = _loc3_;
            for(; _loc14_ < _loc5_; _loc14_++)
            {
               if(_loc11_)
               {
                  _loc15_ = _loc11_[_loc14_];
                  if(!ItemId.isSolid(_loc15_))
                  {
                     if(_loc15_ == 243 && _loc2_.isme)
                     {
                        this.lookup.setSecret(_loc14_,_loc13_,true);
                     }
                  }
                  else if(_loc12_.intersects(new Rectangle(_loc14_ * 16,_loc13_ * 16,16,16)))
                  {
                     _loc16_ = this.lookup.getInt(_loc14_,_loc13_);
                     if(ItemId.isRotatableHalfBlock(_loc15_))
                     {
                        if(ItemId.canJumpThroughFromBelow(_loc15_))
                        {
                           if((_loc2_.speedY < 0 || _loc13_ <= _loc2_.overlapa || _loc2_.speedY == 0 && _loc2_.speedX == 0 && _loc2_.oy + 15 > _loc13_ * 16) && _loc16_ == 1)
                           {
                              if(_loc13_ != _loc4_ || _loc2_.overlapa == -1)
                              {
                                 _loc2_.overlapa = _loc13_;
                              }
                              _loc7_ = true;
                              continue;
                           }
                           if((_loc2_.speedX > 0 || _loc14_ <= _loc2_.overlapb && _loc2_.speedX <= 0 && _loc2_.ox < _loc14_ * 16 + 16) && _loc16_ == 2)
                           {
                              if(_loc14_ != _loc3_ || _loc2_.overlapb == -1)
                              {
                                 _loc2_.overlapb = _loc14_;
                              }
                              _loc8_ = true;
                              continue;
                           }
                           if((_loc2_.speedY > 0 || _loc13_ <= _loc2_.overlapc && _loc2_.speedY <= 0 && _loc2_.oy < _loc13_ * 16 + 16) && _loc16_ == 3)
                           {
                              if(_loc13_ != _loc4_ || _loc2_.overlapc == -1)
                              {
                                 _loc2_.overlapc = _loc13_;
                              }
                              _loc9_ = true;
                              continue;
                           }
                           if((_loc2_.speedX < 0 || _loc14_ <= _loc2_.overlapd || _loc2_.speedY == 0 && _loc2_.speedX < 0 && _loc2_.ox - 15 < _loc14_ * 16) && _loc16_ == 0)
                           {
                              if(_loc14_ != _loc3_ || _loc2_.overlapd == -1)
                              {
                                 _loc2_.overlapd = _loc14_;
                              }
                              _loc10_ = true;
                              continue;
                           }
                        }
                     }
                     else if(ItemId.isHalfBlock(_loc15_))
                     {
                        if(_loc16_ == 1)
                        {
                           if(!_loc12_.intersects(new Rectangle(_loc14_ * 16,_loc13_ * 16 + 8,16,8)))
                           {
                              continue;
                           }
                        }
                        else if(_loc16_ == 2)
                        {
                           if(!_loc12_.intersects(new Rectangle(_loc14_ * 16,_loc13_ * 16,8,16)))
                           {
                              continue;
                           }
                        }
                        else if(_loc16_ == 3)
                        {
                           if(!_loc12_.intersects(new Rectangle(_loc14_ * 16,_loc13_ * 16,16,8)))
                           {
                              continue;
                           }
                        }
                        else if(_loc16_ == 0)
                        {
                           if(!_loc12_.intersects(new Rectangle(_loc14_ * 16 + 8,_loc13_ * 16,8,16)))
                           {
                              continue;
                           }
                        }
                     }
                     else if(ItemId.canJumpThroughFromBelow(_loc15_))
                     {
                        if(_loc2_.speedY < 0 || _loc13_ <= _loc2_.overlapa || _loc2_.speedY == 0 && _loc2_.speedX == 0 && _loc2_.oy + 15 > _loc13_ * 16)
                        {
                           if(_loc13_ != _loc4_ || _loc2_.overlapa == -1)
                           {
                              _loc2_.overlapa = _loc13_;
                           }
                           _loc7_ = true;
                           continue;
                        }
                     }
                     switch(_loc15_)
                     {
                        case 23:
                           if(!this.getKey("red"))
                           {
                              break;
                           }
                           continue;
                        case 24:
                           if(!this.getKey("green"))
                           {
                              break;
                           }
                           continue;
                        case 25:
                           if(!this.getKey("blue"))
                           {
                              break;
                           }
                           continue;
                        case 26:
                           if(this.getKey("red"))
                           {
                              break;
                           }
                           continue;
                        case 27:
                           if(this.getKey("green"))
                           {
                              break;
                           }
                           continue;
                        case 28:
                           if(this.getKey("blue"))
                           {
                              break;
                           }
                           continue;
                        case 1005:
                           if(!this.getKey("cyan"))
                           {
                              break;
                           }
                           continue;
                        case 1006:
                           if(!this.getKey("magenta"))
                           {
                              break;
                           }
                           continue;
                        case 1007:
                           if(!this.getKey("yellow"))
                           {
                              break;
                           }
                           continue;
                        case 1008:
                           if(this.getKey("cyan"))
                           {
                              break;
                           }
                           continue;
                        case 1009:
                           if(this.getKey("magenta"))
                           {
                              break;
                           }
                           continue;
                        case 1010:
                           if(this.getKey("yellow"))
                           {
                              break;
                           }
                           continue;
                        case 156:
                           if(!this.timedoorState)
                           {
                              break;
                           }
                           continue;
                        case 157:
                           if(this.timedoorState)
                           {
                              break;
                           }
                           continue;
                        case ItemId.DOOR_PURPLE:
                           if(!_loc2_.switches[this.lookup.getInt(_loc14_,_loc13_)])
                           {
                              break;
                           }
                           continue;
                        case ItemId.GATE_PURPLE:
                           if(_loc2_.switches[this.lookup.getInt(_loc14_,_loc13_)])
                           {
                              break;
                           }
                           continue;
                        case ItemId.DOOR_ORANGE:
                           if(!this.orangeSwitches[this.lookup.getInt(_loc14_,_loc13_)])
                           {
                              break;
                           }
                           continue;
                        case ItemId.GATE_ORANGE:
                           if(this.orangeSwitches[this.lookup.getInt(_loc14_,_loc13_)])
                           {
                              break;
                           }
                           continue;
                        case ItemId.DOOR_GOLD:
                           if(!_loc2_.isgoldmember)
                           {
                              break;
                           }
                           continue;
                        case ItemId.GATE_GOLD:
                           if(_loc2_.isgoldmember)
                           {
                              break;
                           }
                           continue;
                        case ItemId.CROWNDOOR:
                           if(!_loc2_.collideWithCrownDoorGate)
                           {
                              break;
                           }
                           continue;
                        case ItemId.CROWNGATE:
                           if(_loc2_.collideWithCrownDoorGate)
                           {
                              break;
                           }
                           continue;
                        case ItemId.SILVERCROWNDOOR:
                           if(!_loc2_.collideWithSilverCrownDoorGate)
                           {
                              break;
                           }
                           continue;
                        case ItemId.SILVERCROWNGATE:
                           if(_loc2_.collideWithSilverCrownDoorGate)
                           {
                              break;
                           }
                           continue;
                        case ItemId.COINDOOR:
                           if(this.lookup.getInt(_loc14_,_loc13_) > _loc2_.coins)
                           {
                              break;
                           }
                           continue;
                        case ItemId.BLUECOINDOOR:
                           if(this.lookup.getInt(_loc14_,_loc13_) > _loc2_.bcoins)
                           {
                              break;
                           }
                           continue;
                        case ItemId.DEATH_DOOR:
                           if(this.lookup.getInt(_loc14_,_loc13_) > _loc2_.deaths)
                           {
                              break;
                           }
                           continue;
                        case ItemId.COINGATE:
                           if(this.lookup.getInt(_loc14_,_loc13_) <= (_loc2_.isme ? this.showCoinGate : _loc2_.coins))
                           {
                              break;
                           }
                           continue;
                        case ItemId.BLUECOINGATE:
                           if(this.lookup.getInt(_loc14_,_loc13_) <= (_loc2_.isme ? this.showBlueCoinGate : _loc2_.bcoins))
                           {
                              break;
                           }
                           continue;
                        case ItemId.DEATH_GATE:
                           if(this.lookup.getInt(_loc14_,_loc13_) <= (_loc2_.isme ? this.showDeathGate : _loc2_.deaths))
                           {
                              break;
                           }
                           continue;
                        case ItemId.TEAM_DOOR:
                           if(_loc2_.team != this.lookup.getInt(_loc14_,_loc13_))
                           {
                              break;
                           }
                           continue;
                        case ItemId.TEAM_GATE:
                           if(_loc2_.team == this.lookup.getInt(_loc14_,_loc13_))
                           {
                              break;
                           }
                           continue;
                        case ItemId.ZOMBIE_GATE:
                           if(_loc2_.zombie)
                           {
                              break;
                           }
                           continue;
                        case ItemId.ZOMBIE_DOOR:
                           if(!_loc2_.zombie)
                           {
                              break;
                           }
                           continue;
                        case 50:
                           if(_loc2_.isme)
                           {
                              this.lookup.setSecret(_loc14_,_loc13_,true);
                           }
                     }
                     return _loc15_;
                  }
               }
            }
            _loc13_++;
         }
         if(!_loc7_)
         {
            _loc2_.overlapa = -1;
         }
         if(!_loc8_)
         {
            _loc2_.overlapb = -1;
         }
         if(!_loc9_)
         {
            _loc2_.overlapc = -1;
         }
         if(!_loc10_)
         {
            _loc2_.overlapd = -1;
         }
         return 0;
      }
      
      public function getMinimapColor(param1:int, param2:int) : Number
      {
         return ItemManager.getMinimapColor(decoration[param2][param1] || forground[param2][param1] || background[param2][param1]) || ItemManager.getMinimapColor(background[param2][param1]);
      }
      
      public function drawFull() : void
      {
         this.fullImage = new BitmapData(width * size,height * size,false);
         this.onDraw(this.fullImage,0,0,true);
         this.postDraw(this.fullImage,0,0,true);
         this.labelcontainer.draw(this.fullImage,0,0);
      }
      
      override public function draw(param1:BitmapData, param2:int, param3:int) : void
      {
         this.onDraw(param1,param2,param3,false);
      }
      
      private function onDraw(param1:BitmapData, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:Vector.<int> = null;
         var _loc15_:Vector.<int> = null;
         var _loc16_:Vector.<int> = null;
         var _loc19_:Object = null;
         var _loc20_:int = 0;
         var _loc21_:ImageBlock = null;
         var _loc22_:int = 0;
         var _loc23_:BlSprite = null;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Portal = null;
         var _loc27_:Portal = null;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:Player = null;
         var _loc34_:int = 0;
         var _loc35_:Number = NaN;
         var _loc36_:int = 0;
         var _loc37_:int = 0;
         var _loc5_:int = param4 ? int(height * size) : int(Bl.height / size);
         var _loc6_:int = param4 ? int(width * size) : int(Bl.width / size);
         var _loc7_:int = -param3 / size - 1;
         var _loc8_:int = -param2 / size - 1;
         var _loc9_:Boolean = false;
         if(_loc7_ < 0)
         {
            _loc9_ = true;
            _loc7_ = 0;
         }
         if(_loc8_ < 0)
         {
            _loc9_ = true;
            _loc8_ = 0;
         }
         var _loc10_:int = _loc7_ + _loc5_ + 2;
         var _loc11_:int = _loc8_ + _loc6_ + 2;
         if(_loc10_ > height)
         {
            _loc9_ = true;
            _loc10_ = height;
         }
         if(_loc11_ > width)
         {
            _loc9_ = true;
            _loc11_ = width;
         }
         if(_loc9_)
         {
            param1.fillRect(param1.rect,0);
         }
         _loc12_ = uint(_loc7_);
         while(_loc12_ < _loc10_)
         {
            _loc14_ = background[_loc12_];
            _loc15_ = forground[_loc12_];
            _loc13_ = uint(_loc8_);
            while(_loc13_ < _loc11_)
            {
               point.x = (_loc13_ << 4) + param2;
               point.y = (_loc12_ << 4) + param3;
               if(_loc15_[_loc13_] == 0)
               {
                  _loc20_ = _loc14_[_loc13_];
                  if(_loc14_[_loc13_] == 0 && this.customBgColor)
                  {
                     param1.fillRect(new Rectangle(point.x,point.y,16,16),this.bgColor);
                  }
                  else
                  {
                     param1.copyPixels(ItemManager.bmdBricks[_loc14_[_loc13_]],rect16x16,point);
                  }
               }
               _loc13_++;
            }
            _loc12_++;
         }
         var _loc17_:int = 0;
         while(_loc17_ < this.imageBlocks.length)
         {
            _loc21_ = this.imageBlocks[_loc17_] as ImageBlock;
            if(_loc21_.loaded)
            {
               if(_loc21_.isInbounds(_loc8_,_loc7_,_loc11_,_loc10_))
               {
                  param1.copyPixels(_loc21_.bitmapData,_loc21_.rect,new Point((_loc21_.x << 4) + param2,(_loc21_.y << 4) + param3));
               }
            }
            _loc17_++;
         }
         this.ice += 0.25;
         if(this.ice > this.iceTime)
         {
            this.ice = 0;
            this.iceTime = Math.floor(Math.random() * (80 + 1)) + 40;
         }
         var _loc18_:Vector.<Object> = new Vector.<Object>();
         _loc12_ = uint(_loc7_);
         while(_loc12_ < _loc10_)
         {
            _loc14_ = background[_loc12_];
            _loc16_ = decoration[_loc12_];
            _loc15_ = forground[_loc12_];
            _loc13_ = uint(_loc8_);
            for(; _loc13_ < _loc11_; _loc13_++)
            {
               point.x = (_loc13_ << 4) + param2;
               point.y = (_loc12_ << 4) + param3;
               type = _loc15_[_loc13_];
               if(type != 0)
               {
                  param1.copyPixels(ItemManager.bmdBricks[type],rect18x18,point);
               }
               else
               {
                  type = _loc16_[_loc13_];
                  if(type != 0)
                  {
                     if(ItemId.isBlockRotateable(type) && !ItemId.isNonRotatableHalfBlock(type) && type != ItemId.HALLOWEEN_2016_EYES && type != ItemId.FIREWORKS && type != ItemId.DUNGEON_TORCH)
                     {
                        _loc22_ = this.lookup.getInt(_loc13_,_loc12_);
                        _loc23_ = ItemManager.getRotateableSprite(type);
                        _loc23_.drawPoint(param1,point,_loc22_);
                     }
                     else
                     {
                        switch(type)
                        {
                           case ItemId.CHECKPOINT:
                              continue;
                           case 23:
                           case 26:
                              if(!this.getKey("red"))
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,type == 23 ? 0 : 3);
                              continue;
                           case 24:
                           case 27:
                              if(!this.getKey("green"))
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,type == 24 ? 1 : 4);
                              continue;
                           case 25:
                           case 28:
                              if(!this.getKey("blue"))
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,type == 25 ? 2 : 5);
                              continue;
                           case 1005:
                           case 1008:
                              if(!this.getKey("cyan"))
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,type == 1005 ? 14 : 17);
                              continue;
                           case 1006:
                           case 1009:
                              if(!this.getKey("magenta"))
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,type == 1006 ? 15 : 18);
                              continue;
                           case 1007:
                           case 1010:
                              if(!this.getKey("yellow"))
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,type == 1007 ? 16 : 19);
                              continue;
                           case ItemId.DEATH_DOOR:
                              if(this.lookup.getInt(_loc13_,_loc12_) <= this.player.deaths)
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,20);
                              }
                              else
                              {
                                 ItemManager.sprDeathDoor.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) - this.player.deaths);
                              }
                              continue;
                           case ItemId.DEATH_GATE:
                              if(this.lookup.getInt(_loc13_,_loc12_) <= this.player.deaths)
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,21);
                              }
                              else
                              {
                                 ItemManager.sprDeathGate.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) - this.player.deaths);
                              }
                              continue;
                           case ItemId.DOOR_PURPLE:
                              if(this.player.switches[this.lookup.getInt(_loc13_,_loc12_)])
                              {
                                 ItemManager.sprPurpleGates.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              else
                              {
                                 ItemManager.sprPurpleDoors.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              continue;
                           case ItemId.GATE_PURPLE:
                              if(this.player.switches[this.lookup.getInt(_loc13_,_loc12_)])
                              {
                                 ItemManager.sprPurpleDoors.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              else
                              {
                                 ItemManager.sprPurpleGates.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              continue;
                           case ItemId.DOOR_ORANGE:
                              if(this.orangeSwitches[this.lookup.getInt(_loc13_,_loc12_)])
                              {
                                 ItemManager.sprOrangeGates.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              else
                              {
                                 ItemManager.sprOrangeDoors.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              continue;
                           case ItemId.GATE_ORANGE:
                              if(this.orangeSwitches[this.lookup.getInt(_loc13_,_loc12_)])
                              {
                                 ItemManager.sprOrangeDoors.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              else
                              {
                                 ItemManager.sprOrangeGates.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              continue;
                           case ItemId.DOOR_GOLD:
                              if(!this.player.isgoldmember)
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,10);
                              continue;
                           case ItemId.GATE_GOLD:
                              if(!this.player.isgoldmember)
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,11);
                              continue;
                           case ItemId.SWITCH_PURPLE:
                              if(this.player.switches[this.lookup.getInt(_loc13_,_loc12_)])
                              {
                                 ItemManager.sprSwitchDOWN.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              else
                              {
                                 ItemManager.sprSwitchUP.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              continue;
                           case ItemId.SWITCH_ORANGE:
                              if(this.orangeSwitches[this.lookup.getInt(_loc13_,_loc12_)])
                              {
                                 ItemManager.sprOrangeSwitchDOWN.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              else
                              {
                                 ItemManager.sprOrangeSwitchUP.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              continue;
                           case ItemId.RESET_PURPLE:
                              ItemManager.sprSwitchRESET.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.RESET_ORANGE:
                              ItemManager.sprOrangeSwitchRESET.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.TIMEDOOR:
                              ItemManager.sprDoorsTime.drawPoint(param1,point,Math.min((this.offset - this.hideTimedoorOffset) / 30 >> 0,4) + (this.timedoorState ? 5 : 0));
                              continue;
                           case ItemId.TIMEGATE:
                              ItemManager.sprDoorsTime.drawPoint(param1,point,Math.min((this.offset - this.hideTimedoorOffset) / 30 >> 0,4) + (this.timedoorState ? 0 : 5));
                              continue;
                           case 411:
                           case 412:
                           case 413:
                           case 414:
                              if(!(!this.player.isFlying && !param4))
                              {
                                 break;
                              }
                              if(this.lookup.isBlink(_loc13_,_loc12_))
                              {
                                 if(this.lookup.getBlink(_loc13_,_loc12_) < 0)
                                 {
                                    this.lookup.updateBlink(_loc13_,_loc12_,1);
                                    break;
                                 }
                                 _loc24_ = type - 411;
                                 if(this.lookup.getBlink(_loc13_,_loc12_) == 0)
                                 {
                                    this.lookup.setBlink(_loc13_,_loc12_,_loc24_ * 5);
                                 }
                                 _loc25_ = this.lookup.getBlink(_loc13_,_loc12_);
                                 ItemManager.sprInvGravityBlink.drawPoint(param1,point,_loc25_);
                                 if(this.lookup.updateBlink(_loc13_,_loc12_,1 / 10) >= 5 + _loc24_ * 5)
                                 {
                                    this.lookup.deleteBlink(_loc13_,_loc12_);
                                 }
                              }
                              continue;
                           case 1519:
                              if(!(!this.player.isFlying && !param4))
                              {
                                 break;
                              }
                              if(this.lookup.isBlink(_loc13_,_loc12_))
                              {
                                 if(this.lookup.getBlink(_loc13_,_loc12_) < 0)
                                 {
                                    this.lookup.updateBlink(_loc13_,_loc12_,1);
                                    break;
                                 }
                                 ItemManager.sprInvGravityDownBlink.drawPoint(param1,point,this.lookup.getBlink(_loc13_,_loc12_));
                                 if(this.lookup.updateBlink(_loc13_,_loc12_,1 / 10) >= 5)
                                 {
                                    this.lookup.deleteBlink(_loc13_,_loc12_);
                                 }
                              }
                              continue;
                           case ItemId.SLOW_DOT_INVISIBLE:
                              if(!(!this.player.isFlying && !param4))
                              {
                                 break;
                              }
                              if(this.lookup.isBlink(_loc13_,_loc12_))
                              {
                                 if(this.lookup.getBlink(_loc13_,_loc12_) < 0)
                                 {
                                    this.lookup.updateBlink(_loc13_,_loc12_,1);
                                    break;
                                 }
                                 ItemManager.sprInvDotBlink.drawPoint(param1,point,this.lookup.getBlink(_loc13_,_loc12_));
                                 if(this.lookup.updateBlink(_loc13_,_loc12_,1 / 10) >= 5)
                                 {
                                    this.lookup.deleteBlink(_loc13_,_loc12_);
                                 }
                              }
                              continue;
                           case ItemId.CROWNDOOR:
                              if(!this.player.collideWithCrownDoorGate)
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,40);
                              continue;
                           case ItemId.CROWNGATE:
                              if(!this.player.collideWithCrownDoorGate)
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,41);
                              continue;
                           case ItemId.SILVERCROWNDOOR:
                              if(!this.player.collideWithSilverCrownDoorGate)
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,42);
                              continue;
                           case ItemId.SILVERCROWNGATE:
                              if(!this.player.collideWithSilverCrownDoorGate)
                              {
                                 break;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,43);
                              continue;
                           case ItemId.COINDOOR:
                              if(this.lookup.getInt(_loc13_,_loc12_) <= this.player.coins)
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,6);
                              }
                              else
                              {
                                 ItemManager.sprCoinDoors.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) - this.player.coins);
                              }
                              continue;
                           case ItemId.BLUECOINDOOR:
                              if(this.lookup.getInt(_loc13_,_loc12_) <= this.player.bcoins)
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,36);
                              }
                              else
                              {
                                 ItemManager.sprBlueCoinDoors.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) - this.player.bcoins);
                              }
                              continue;
                           case ItemId.COINGATE:
                              if(this.lookup.getInt(_loc13_,_loc12_) <= this.player.coins)
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,7);
                              }
                              else
                              {
                                 ItemManager.sprCoinGates.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) - this.player.coins);
                              }
                              continue;
                           case ItemId.BLUECOINGATE:
                              if(this.lookup.getInt(_loc13_,_loc12_) <= this.player.bcoins)
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,37);
                              }
                              else
                              {
                                 ItemManager.sprBlueCoinGates.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) - this.player.bcoins);
                              }
                              continue;
                           case ItemId.ZOMBIE_DOOR:
                              if(this.player.zombie)
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,12);
                              }
                              else
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,13);
                              }
                              continue;
                           case ItemId.ZOMBIE_GATE:
                              if(this.player.zombie)
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,13);
                              }
                              else
                              {
                                 ItemManager.sprDoors.drawPoint(param1,point,12);
                              }
                              continue;
                           case 83:
                              if(!this.lookup.isBlink(_loc13_,_loc12_))
                              {
                                 break;
                              }
                              ItemManager.sprDrumsBlink.drawPoint(param1,point,this.lookup.getBlink(_loc13_,_loc12_) / 6 << 0);
                              if(this.lookup.updateBlink(_loc13_,_loc12_,-1) <= 0)
                              {
                                 this.lookup.deleteBlink(_loc13_,_loc12_);
                              }
                              continue;
                           case 77:
                              if(!this.lookup.isBlink(_loc13_,_loc12_))
                              {
                                 break;
                              }
                              ItemManager.sprPianoBlink.drawPoint(param1,point,this.lookup.getBlink(_loc13_,_loc12_) / 6 << 0);
                              if(this.lookup.updateBlink(_loc13_,_loc12_,-1) <= 0)
                              {
                                 this.lookup.deleteBlink(_loc13_,_loc12_);
                              }
                              continue;
                           case 110:
                              if(Bl.data.canEdit)
                              {
                                 ItemManager.sprCoinShadow.drawPoint(param1,point,((this.offset >> 0) + _loc13_ + _loc12_) % 12);
                              }
                              continue;
                           case 111:
                              if(Bl.data.canEdit)
                              {
                                 ItemManager.sprBonusCoinShadow.drawPoint(param1,point,((this.offset >> 0) + _loc13_ + _loc12_) % 12);
                              }
                              continue;
                           case ItemId.SPIKE:
                              ItemManager.sprSpikes.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.SPIKE_SILVER:
                              ItemManager.sprSpikesSilver.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.SPIKE_BLACK:
                              ItemManager.sprSpikesBlack.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.SPIKE_RED:
                              ItemManager.sprSpikesRed.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.SPIKE_GOLD:
                              ItemManager.sprSpikesGold.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.SPIKE_GREEN:
                              ItemManager.sprSpikesGreen.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.SPIKE_BLUE:
                              ItemManager.sprSpikesBlue.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.PORTAL:
                              _loc26_ = this.lookup.getPortal(_loc13_,_loc12_);
                              ItemManager.sprPortal.drawPoint(param1,point,_loc26_.rotation * 15 + ((this.offset / 1.5 >> 0) + _loc13_ + _loc12_) % 15 + 1);
                              continue;
                           case ItemId.PORTAL_INVISIBLE:
                              if(Boolean(Bl.data.canEdit) && Boolean(this.player.isFlying) || param4)
                              {
                                 _loc27_ = this.lookup.getPortal(_loc13_,_loc12_);
                                 ItemManager.sprPortalInvisible.drawPoint(param1,point,_loc27_.rotation);
                              }
                              continue;
                           case ItemId.WORLD_PORTAL:
                              ItemManager.sprPortalWorld.drawPoint(param1,point,((this.offset / 2 >> 0) + _loc13_ + _loc12_) % 21);
                              if(Math.random() * 100 < 18)
                              {
                                 this.addParticle(new Particle(this,Math.random() * 100 < 50 ? 6 : 7,_loc13_ * 16 + 6,_loc12_ * 16 + 6,0.7,0.7,0.013,0.013,Math.random() * 360,Math.random() * 115,true));
                              }
                              continue;
                           case ItemId.DIAMOND:
                              ItemManager.sprDiamond.drawPoint(param1,point,((this.offset / 5 >> 0) + _loc13_ + _loc12_) % 13);
                              continue;
                           case ItemId.CAKE:
                              ItemManager.sprCake.drawPoint(param1,point,((this.offset / 5 >> 0) + _loc13_ + _loc12_) % 5);
                              continue;
                           case ItemId.HOLOGRAM:
                              ItemManager.sprHologram.drawPoint(param1,point,((this.offset / 5 >> 0) + _loc13_ + _loc12_) % 5);
                              continue;
                           case ItemId.EFFECT_TEAM:
                              _loc28_ = this.lookup.getInt(_loc13_,_loc12_);
                              ItemManager.sprTeamEffect.drawPoint(param1,point,_loc28_);
                              continue;
                           case ItemId.TEAM_DOOR:
                              _loc29_ = this.lookup.getInt(_loc13_,_loc12_);
                              _loc30_ = 22 + _loc29_;
                              if(this.player.team == _loc29_)
                              {
                                 _loc30_ += 7;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,_loc30_);
                              continue;
                           case ItemId.TEAM_GATE:
                              _loc31_ = this.lookup.getInt(_loc13_,_loc12_);
                              _loc32_ = 29 + _loc31_;
                              if(this.player.team == _loc31_)
                              {
                                 _loc32_ -= 7;
                              }
                              ItemManager.sprDoors.drawPoint(param1,point,_loc32_);
                              continue;
                           case ItemId.EFFECT_CURSE:
                              ItemManager.sprEffect.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) != 0 ? 4 : 11);
                              continue;
                           case ItemId.EFFECT_FLY:
                              ItemManager.sprEffect.drawPoint(param1,point,this.lookup.getBoolean(_loc13_,_loc12_) ? 1 : 8);
                              continue;
                           case ItemId.EFFECT_JUMP:
                              ItemManager.sprEffect.drawPoint(param1,point,[7,0,22][this.lookup.getInt(_loc13_,_loc12_)]);
                              continue;
                           case ItemId.EFFECT_PROTECTION:
                              ItemManager.sprEffect.drawPoint(param1,point,this.lookup.getBoolean(_loc13_,_loc12_) ? 3 : 10);
                              continue;
                           case ItemId.EFFECT_RUN:
                              ItemManager.sprEffect.drawPoint(param1,point,[9,2,25][this.lookup.getInt(_loc13_,_loc12_)]);
                              continue;
                           case ItemId.EFFECT_ZOMBIE:
                              ItemManager.sprEffect.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) != 0 ? 5 : 12);
                              continue;
                           case ItemId.EFFECT_LOW_GRAVITY:
                              ItemManager.sprEffect.drawPoint(param1,point,this.lookup.getBoolean(_loc13_,_loc12_) ? 13 : 14);
                              continue;
                           case ItemId.EFFECT_MULTIJUMP:
                              if(this.lookup.getInt(_loc13_,_loc12_) == 1)
                              {
                                 ItemManager.sprEffect.drawPoint(param1,point,16);
                              }
                              else
                              {
                                 ItemManager.sprMultiJumps.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              continue;
                           case ItemId.EFFECT_GRAVITY:
                              ItemManager.sprGravityEffect.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              continue;
                           case ItemId.EFFECT_POISON:
                              ItemManager.sprEffect.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) != 0 ? 23 : 24);
                              continue;
                           case 50:
                              if(this.showAllSecrets || param4 || this.lookup.getSecret(_loc13_,_loc12_))
                              {
                                 ItemManager.sprSecret.drawPoint(param1,point,0);
                              }
                              continue;
                           case 243:
                              if(this.showAllSecrets || param4 || this.lookup.getSecret(_loc13_,_loc12_))
                              {
                                 ItemManager.sprSecret.drawPoint(param1,point,1);
                              }
                              else
                              {
                                 ItemManager.bricks[44].drawTo(param1,(_loc13_ << 4) + param2,(_loc12_ << 4) + param3);
                              }
                              continue;
                           case 136:
                              _loc33_ = (Global.base.state as PlayState).player;
                              if(Boolean(Bl.data.canEdit) && Boolean(_loc33_.isFlying) || param4)
                              {
                                 ItemManager.sprSecret.drawPoint(param1,point,2);
                              }
                              continue;
                           case ItemId.LABEL:
                              continue;
                           case ItemId.ICE:
                              if(this.lookup.getNumber(_loc13_,_loc12_) != 0)
                              {
                                 this.lookup.setNumber(_loc13_,_loc12_,this.lookup.getNumber(_loc13_,_loc12_) - 0.25);
                                 if(this.lookup.getNumber(_loc13_,_loc12_) % 12 == 0)
                                 {
                                    this.lookup.setNumber(_loc13_,_loc12_,0);
                                 }
                              }
                              else if(this.ice == (_loc13_ + _loc12_) % this.iceTime || Math.random() < 0.0001)
                              {
                                 this.lookup.setNumber(_loc13_,_loc12_,11.75);
                              }
                              ItemManager.sprIce.drawPoint(param1,point,11 - (this.lookup.getNumber(_loc13_,_loc12_) >> 0) % 12);
                              continue;
                           case ItemId.CAVE_TORCH:
                              ItemManager.sprCaveTorch.drawPoint(param1,point,((this.offset / 2.3 >> 0) + (width - _loc13_) + _loc12_) % 12);
                              continue;
                           case ItemId.DUNGEON_TORCH:
                              ItemManager.sprDungeonTorch.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_) * 12 + ((this.offset / 2.3 >> 0) + (width - _loc13_) + _loc12_) % 12);
                              continue;
                           case ItemId.CHRISTMAS_2016_CANDLE:
                              ItemManager.sprChristmas2016Candle.drawPoint(param1,point,((this.offset / 2.3 >> 0) + (width - _loc13_) + _loc12_) % 12);
                              continue;
                           case ItemId.HALLOWEEN_2016_EYES:
                              if(this.player.isFlying)
                              {
                                 ItemManager.sprHalloweenEyes.drawPoint(param1,point,this.lookup.getNumber(_loc13_,_loc12_) * 6);
                              }
                              else if(this.lookup.isBlink(_loc13_,_loc12_))
                              {
                                 if(_loc13_ == _loc8_ || _loc13_ == _loc11_ - 1 || _loc12_ == _loc7_ || _loc12_ == _loc10_ - 1)
                                 {
                                    this.lookup.deleteBlink(_loc13_,_loc12_);
                                    continue;
                                 }
                                 _loc34_ = this.lookup.getBlink(_loc13_,_loc12_);
                                 if(_loc34_ >= 6)
                                 {
                                    _loc34_ -= 6;
                                 }
                                 else
                                 {
                                    _loc34_ = 5 - _loc34_;
                                 }
                                 ItemManager.sprHalloweenEyes.drawPoint(param1,point,_loc34_ + this.lookup.getNumber(_loc13_,_loc12_) * 6);
                                 if(this.lookup.getBlink(_loc13_,_loc12_) != 5 && Math.random() < 0.25 || this.lookup.getBlink(_loc13_,_loc12_) == 5 && Math.random() <= 0.01)
                                 {
                                    if(this.lookup.updateBlink(_loc13_,_loc12_,-1) <= 0)
                                    {
                                       this.lookup.deleteBlink(_loc13_,_loc12_);
                                    }
                                 }
                              }
                              else if(Math.random() < 0.05 && MathUtil.inRange(_loc13_ * 16,_loc12_ * 16,this.player.x,this.player.y,120))
                              {
                                 this.lookup.setBlink(_loc13_,_loc12_,11);
                              }
                              continue;
                           case 1520:
                              if(!this.lookup.isBlink(_loc13_,_loc12_))
                              {
                                 break;
                              }
                              ItemManager.sprGuitarBlink.drawPoint(param1,point,this.lookup.getBlink(_loc13_,_loc12_) / 6 << 0);
                              if(this.lookup.updateBlink(_loc13_,_loc12_,-1) <= 0)
                              {
                                 this.lookup.deleteBlink(_loc13_,_loc12_);
                              }
                              continue;
                           case ItemId.FIREWORKS:
                              if(this.lookup.isBlink(_loc13_,_loc12_))
                              {
                                 _loc35_ = 1 / 3;
                                 _loc36_ = this.lookup.getBlink(_loc13_,_loc12_);
                                 _loc37_ = ItemManager.blocksFireworksBMD.width / 64 / _loc35_;
                                 if(_loc36_ >= 0 && _loc36_ <= _loc37_)
                                 {
                                    _loc18_.push({
                                       "d":ItemManager.blocksFireworksBMD,
                                       "r":new Rectangle(Math.floor(_loc36_ * _loc35_) * 64,this.lookup.getInt(_loc13_,_loc12_) * 64,64,64),
                                       "p":new Point(point.x - 24,point.y - 24)
                                    });
                                 }
                                 if(this.lookup.updateBlink(_loc13_,_loc12_,1) >= _loc37_ + 60 * 3)
                                 {
                                    this.lookup.deleteBlink(_loc13_,_loc12_);
                                 }
                              }
                              else if(Math.random() < 0.01 && MathUtil.inRange(_loc13_ * 16,_loc12_ * 16,this.player.x,this.player.y,12 * 16))
                              {
                                 this.lookup.setBlink(_loc13_,_loc12_,0);
                              }
                              if(this.player.isFlying)
                              {
                                 ItemManager.sprFireworks.drawPoint(param1,point,this.lookup.getInt(_loc13_,_loc12_));
                              }
                              continue;
                        }
                        param1.copyPixels(ItemManager.bmdBricks[type],rect18x18,point);
                     }
                  }
               }
            }
            _loc12_++;
         }
         for each(_loc19_ in _loc18_)
         {
            param1.copyPixels(_loc19_.d,_loc19_.r,_loc19_.p);
         }
         param4 = false;
      }
      
      final public function postDraw(param1:BitmapData, param2:int, param3:int, param4:Boolean = false) : void
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Vector.<int> = null;
         var _loc16_:Object = null;
         var _loc17_:Boolean = false;
         var _loc18_:Npc = null;
         var _loc19_:ItemNpc = null;
         var _loc20_:int = 0;
         var _loc21_:BlSprite = null;
         var _loc5_:int = param4 ? int(height * size) : int(Bl.height / size);
         var _loc6_:int = param4 ? int(width * size) : int(Bl.width / size);
         var _loc7_:int = -param3 / size - 1;
         var _loc8_:int = -param2 / size - 1;
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         if(_loc8_ < 0)
         {
            _loc8_ = 0;
         }
         var _loc9_:int = _loc7_ + _loc5_ + 2;
         var _loc10_:int = _loc8_ + _loc6_ + 2;
         if(_loc9_ > height)
         {
            _loc9_ = height;
         }
         if(_loc10_ > width)
         {
            _loc10_ = width;
         }
         var _loc14_:Boolean = false;
         var _loc15_:Vector.<Object> = new Vector.<Object>();
         _loc11_ = _loc7_;
         while(_loc11_ < _loc9_)
         {
            _loc13_ = above[_loc11_];
            _loc12_ = _loc8_;
            while(_loc12_ < _loc10_)
            {
               type = _loc13_[_loc12_];
               point.x = (_loc12_ << 4) + param2;
               point.y = (_loc11_ << 4) + param3;
               switch(type)
               {
                  case 0:
                     break;
                  case 100:
                     ItemManager.sprCoin.drawPoint(param1,point,((this.offset >> 0) + _loc12_ + _loc11_) % 12);
                     break;
                  case 101:
                     ItemManager.sprBonusCoin.drawPoint(param1,point,((this.offset >> 0) + _loc12_ + _loc11_) % 12);
                     break;
                  case ItemId.WAVE:
                     ItemManager.sprWave.drawPoint(param1,point,(this.offset / 5 >> 0) % 8);
                     break;
                  case ItemId.MUD_BUBBLE:
                     if(this.lookup.getNumber(_loc12_,_loc11_) != 0)
                     {
                        this.lookup.setNumber(_loc12_,_loc11_,this.lookup.getNumber(_loc12_,_loc11_) + 0.25);
                        if(this.lookup.getNumber(_loc12_,_loc11_) % 10 == 0)
                        {
                           this.lookup.setNumber(_loc12_,_loc11_,0);
                        }
                     }
                     else if(Math.random() < 0.005)
                     {
                        this.lookup.setNumber(_loc12_,_loc11_,1 + Math.round(Math.random()) * 10);
                     }
                     ItemManager.sprMudBubble.drawPoint(param1,point,(this.lookup.getNumber(_loc12_,_loc11_) >> 0) % 19);
                     break;
                  case ItemId.FIRE:
                     ItemManager.sprFireHazard.drawPoint(param1,point,((this.offset / 1.2 >> 0) + (width - _loc12_) + _loc11_) % 12);
                     break;
                  case ItemId.WATER:
                     if(this.lookup.getInt(_loc12_,_loc11_) != 0)
                     {
                        this.lookup.setInt(_loc12_,_loc11_,this.lookup.getInt(_loc12_,_loc11_) + 1);
                        if(this.lookup.getInt(_loc12_,_loc11_) % 25 == 0)
                        {
                           this.lookup.setInt(_loc12_,_loc11_,0);
                        }
                     }
                     else if(Math.random() < 0.001)
                     {
                        this.lookup.setInt(_loc12_,_loc11_,int(Math.random() * 4) * 25 + 5);
                     }
                     ItemManager.sprWater.drawPoint(param1,point,int(this.lookup.getNumber(_loc12_,_loc11_) / 5));
                     break;
                  case ItemId.TOXIC_WASTE:
                     if(this.lookup.getInt(_loc12_,_loc11_) != 0)
                     {
                        this.lookup.setInt(_loc12_,_loc11_,this.lookup.getInt(_loc12_,_loc11_) + 1);
                        if(this.lookup.getInt(_loc12_,_loc11_) % 25 == 0)
                        {
                           this.lookup.setInt(_loc12_,_loc11_,0);
                        }
                     }
                     else if(Math.random() < 0.005)
                     {
                        this.lookup.setInt(_loc12_,_loc11_,int(Math.random() * 4) * 25 + 5);
                     }
                     ItemManager.sprToxic.drawPoint(param1,point,int(this.lookup.getNumber(_loc12_,_loc11_) / 5));
                     break;
                  case ItemId.TOXIC_WASTE_SURFACE:
                     if(this.lookup.getNumber(_loc12_,_loc11_) != 0)
                     {
                        this.lookup.setNumber(_loc12_,_loc11_,this.lookup.getNumber(_loc12_,_loc11_) + 0.25);
                        if(this.lookup.getNumber(_loc12_,_loc11_) % 10 == 0)
                        {
                           this.lookup.setNumber(_loc12_,_loc11_,0);
                        }
                     }
                     else if(Math.random() < 0.01)
                     {
                        this.lookup.setNumber(_loc12_,_loc11_,1 + Math.round(Math.random()) * 10);
                     }
                     ItemManager.sprToxicBubble.drawPoint(param1,point,(this.lookup.getNumber(_loc12_,_loc11_) >> 0) % 19);
                     break;
                  case ItemId.TEXT_SIGN:
                     _loc17_ = !ItemId.isSolid(getTile(0,_loc12_,_loc11_ + 1));
                     ItemManager.sprSign.drawPoint(param1,point,this.lookup.getTextSign(_loc12_,_loc11_).type + (_loc17_ ? 4 : 0));
                     break;
                  case ItemId.LAVA:
                     ItemManager.sprLava.drawPoint(param1,point,(this.offset / 5 >> 0) % 8);
                     break;
                  case ItemId.GOLDEN_EASTER_EGG:
                     _loc15_.push({
                        "d":ItemManager.blocksGoldenEasterEggBMD,
                        "r":new Rectangle(0,0,48,48),
                        "p":new Point(point.x - 16,point.y - 16)
                     });
                     break;
                  default:
                     if(ItemId.isNPC(type))
                     {
                        _loc18_ = this.lookup.getNpc(_loc12_,_loc11_);
                        _loc19_ = ItemManager.getNpcById(type);
                        if(this.player.currentNpc != null && this.player.currentNpc.equals(_loc18_) && this.player.currentNpc.isTalking)
                        {
                           if(!this.isAnimatingNPC)
                           {
                              this.isAnimatingNPC = true;
                              this.offsetNPC = this.offset;
                           }
                           _loc19_.drawTo(param1,point,((this.offset - this.offsetNPC) / _loc19_.rate >> 0) % _loc19_.frames);
                           _loc14_ = true;
                        }
                        else
                        {
                           _loc19_.drawTo(param1,point,0);
                        }
                     }
                     else if(ItemId.isBlockRotateable(type) && !ItemId.isNonRotatableHalfBlock(type) && type != ItemId.HALLOWEEN_2016_EYES && type != ItemId.FIREWORKS && type != ItemId.DUNGEON_TORCH)
                     {
                        _loc20_ = this.lookup.getInt(_loc12_,_loc11_);
                        _loc21_ = ItemManager.getRotateableSprite(type);
                        _loc21_.drawPoint(param1,point,_loc20_);
                     }
                     else
                     {
                        param1.copyPixels(ItemManager.bmdBricks[type],rect18x18,point);
                     }
               }
               if(decoration[_loc11_][_loc12_] == ItemId.CHECKPOINT)
               {
                  ItemManager.sprCheckpoint.drawPoint(param1,point,this.player.checkpoint_x == _loc12_ && this.player.checkpoint_y == _loc11_ ? 1 : 0);
               }
               _loc12_++;
            }
            _loc11_++;
         }
         for each(_loc16_ in _loc15_)
         {
            param1.copyPixels(_loc16_.d,_loc16_.r,_loc16_.p);
         }
         if(!_loc14_)
         {
            this.isAnimatingNPC = false;
         }
         this.labelcontainer.draw(param1,param2,param3);
         this.particlecontainer.draw(param1,param2,param3);
         lastframe = param1;
      }
      
      public function drawDialogs(param1:BitmapData, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         _loc4_ = Math.max(0,-param3 / size - 1);
         _loc5_ = Math.max(0,-param2 / size - 1);
         var _loc6_:int = Math.min(height,_loc4_ + Bl.height / size + 2);
         var _loc7_:int = Math.min(width,_loc5_ + Bl.width / size + 2);
         var _loc8_:int = _loc4_;
         while(_loc8_ < _loc6_)
         {
            _loc9_ = _loc5_;
            while(_loc9_ < _loc7_)
            {
               point.x = (_loc9_ << 4) + param2;
               point.y = (_loc8_ << 4) + param3;
               type = decoration[_loc8_][_loc9_];
               switch(type)
               {
                  case ItemId.WORLD_PORTAL:
                     if(MathUtil.inRange(this.player.x,this.player.y,_loc9_ * 16,_loc8_ * 16,8))
                     {
                        worldportaltext.update(this.lookup.getWorldPortal(_loc9_,_loc8_),this.player.isInGodMode);
                        worldportaltext.drawPoint(param1,point);
                     }
                     break;
                  case ItemId.PORTAL:
                  case ItemId.PORTAL_INVISIBLE:
                     if(MathUtil.inRange(this.player.x,this.player.y,_loc9_ * 16,_loc8_ * 16,8) && (Boolean(this.player.isFlying) && Boolean(Bl.data.canEdit)))
                     {
                        this.textSignBubble.update("ID: " + this.lookup.getPortal(_loc9_,_loc8_).id + "\nTARGET: " + this.lookup.getPortal(_loc9_,_loc8_).target);
                        this.textSignBubble.drawPoint(param1,point);
                     }
                     break;
                  case ItemId.EFFECT_CURSE:
                  case ItemId.EFFECT_ZOMBIE:
                  case ItemId.EFFECT_POISON:
                     if(MathUtil.inRange(this.player.x,this.player.y,_loc9_ * 16,_loc8_ * 16,8) && (Boolean(this.player.isFlying) && Boolean(Bl.data.canEdit)))
                     {
                        _loc10_ = this.lookup.getInt(_loc9_,_loc8_);
                        if(_loc10_ == 0)
                        {
                           break;
                        }
                        this.textSignBubble.update("Duration: " + _loc10_);
                        this.textSignBubble.drawPoint(param1,point);
                     }
               }
               type = above[_loc8_][_loc9_];
               switch(type)
               {
                  case ItemId.TEXT_SIGN:
                     if(MathUtil.inRange(this.player.x,this.player.y,_loc9_ * 16,_loc8_ * 16,8))
                     {
                        this.textSignBubble.update(this.lookup.getTextSign(_loc9_,_loc8_).text,this.lookup.getTextSign(_loc9_,_loc8_).type);
                        this.textSignBubble.drawPoint(param1,point);
                     }
                     break;
                  case ItemId.RESET_POINT:
                     if(MathUtil.inRange(this.player.x,this.player.y,_loc9_ * 16,_loc8_ * 16,8))
                     {
                        resetPopup.drawPoint(param1,point);
                     }
               }
               if(Global.getPlacer)
               {
                  _loc11_ = Bl.mouseX - param2 - 16;
                  _loc12_ = Bl.mouseY - param3 - 16;
                  _loc13_ = _loc9_ * 16;
                  _loc14_ = _loc8_ * 16;
                  if(_loc13_ > _loc11_ && _loc13_ < _loc11_ + 16 && _loc14_ > _loc12_ && _loc14_ < _loc12_ + 16)
                  {
                     this.inspectTool.updateForBlockAt(_loc9_,_loc8_);
                     this.inspectTool.drawPoint(param1,point);
                  }
               }
               _loc9_++;
            }
            _loc8_++;
         }
      }
      
      public function findCurrentNPC() : Npc
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:Npc = null;
         var _loc1_:Npc = null;
         var _loc2_:Npc = null;
         var _loc3_:int = 64;
         var _loc4_:int = _loc3_ * _loc3_;
         var _loc7_:int = Math.max(this.player.x - _loc3_ >> 4,0);
         var _loc8_:int = Math.min(this.player.x + _loc3_ - 0.001 >> 4,width - 1);
         var _loc9_:int = Math.max(this.player.y - _loc3_ >> 4,0);
         var _loc10_:int = Math.min(this.player.y + _loc3_ - 0.001 >> 4,height - 1);
         var _loc11_:int = _loc9_;
         while(_loc11_ <= _loc10_)
         {
            _loc12_ = _loc7_;
            while(_loc12_ <= _loc8_)
            {
               if(!(_loc12_ < 0 || _loc11_ < 0 || _loc12_ >= width || _loc11_ >= height || !ItemId.isNPC(above[_loc11_][_loc12_])))
               {
                  _loc6_ = MathUtil.distanceSqr(this.player.x,this.player.y,_loc12_ << 4,_loc11_ << 4);
                  if(_loc6_ <= _loc4_ && (!_loc1_ || _loc6_ < _loc5_))
                  {
                     _loc13_ = this.lookup.getNpc(_loc12_,_loc11_);
                     if(!(_loc13_ == _loc1_ || _loc13_ == _loc2_))
                     {
                        _loc1_ = _loc13_;
                        _loc5_ = _loc6_;
                        if(!_loc13_.messagesEmpty)
                        {
                           _loc2_ = _loc13_;
                        }
                     }
                  }
               }
               _loc12_++;
            }
            _loc11_++;
         }
         if(!_loc2_)
         {
            this.player.currentNpc = null;
         }
         else if(!this.player.currentNpc || !this.player.currentNpc.equals(_loc2_))
         {
            this.player.currentNpc = _loc2_;
            this.player.currentNpc.reset();
         }
         return _loc1_;
      }
      
      public function addParticle(param1:Particle) : void
      {
         if(!Global.base.settings.particles)
         {
            return;
         }
         this.particlecontainer.add(param1);
         var _loc2_:int = int(this.particlecontainer.children.length);
         if(_loc2_ <= Config.max_Particles)
         {
            return;
         }
         var _loc3_:int = _loc2_ - Config.max_Particles;
         var _loc4_:Vector.<BlObject> = this.particlecontainer.children.splice(this.particlecontainer.children.length - _loc3_,_loc3_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            this.particlecontainer.remove(_loc4_[_loc5_]);
            _loc5_++;
         }
      }
      
      public function worldOnScreen(param1:Point, param2:Point) : Point
      {
         return new Point((param1.x << 4) + param2.x,(param1.y << 4) + param2.y);
      }
      
      public function reset() : void
      {
         bmd.dispose();
         realmap = null;
         background = null;
         decoration = null;
         forground = null;
         above = null;
      }
      
      public function removeAllLabels() : void
      {
         this.labelcontainer.removeAll();
      }
   }
}


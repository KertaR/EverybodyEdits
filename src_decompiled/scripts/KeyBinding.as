package
{
   import blitter.Bl;
   import playerio.Message;
   
   public class KeyBinding
   {
      
      public static var _all:Vector.<KeyBinding> = new Vector.<KeyBinding>();
      
      private static var _ref:Array = [];
      
      public static var jump:KeyBinding = _add(25,"Jump",new Key(32));
      
      public static var up:KeyBinding = _add(0,"Move Up (alt)",new Key(87),new Key(90));
      
      public static var left:KeyBinding = _add(1,"Move Left (alt)",new Key(65),new Key(81));
      
      public static var down:KeyBinding = _add(2,"Move Down (alt)",new Key(83));
      
      public static var right:KeyBinding = _add(3,"Move Right (alt)",new Key(68));
      
      public static var godmode:KeyBinding = _add(4,"Toggle God Mode",new Key(71));
      
      public static var modmode:KeyBinding = _add(5,"Toggle Mod Mode",new Key(80),null,true);
      
      public static var minimap:KeyBinding = _add(6,"Toggle Minimap",new Key(77));
      
      public static var inspect:KeyBinding = _add(7,"Toggle Inspect Tool",new Key(73));
      
      public static var chat:KeyBinding = _add(8,"Chat (alt)",new Key(84));
      
      public static var blockbar:KeyBinding = _add(9,"Show Blocks (held)",new Key(66));
      
      public static var interact:KeyBinding = _add(10,"NPC Interaction",new Key(67));
      
      public static var risky:KeyBinding = _add(11,"World Interaction",new Key(89));
      
      public static var decrement:KeyBinding = _add(12,"Decrement Value",new Key(81),new Key(65));
      
      public static var increment:KeyBinding = _add(13,"Increment Value",new Key(69));
      
      public static var retryRun:KeyBinding = _add(26,"Retry Time Trial",new Key(82,true));
      
      public static var hideUsernames:KeyBinding = _add(14,"Hide Usernames",new Key(85,true));
      
      public static var hideChatBubbles:KeyBinding = _add(15,"Hide Chat Bubbles",new Key(73,true));
      
      public static var screenshot:KeyBinding = _add(16,"Screenshot",new Key(66,true));
      
      public static var screenshotFull:KeyBinding = _add(17,"Full Screenshot",new Key(78,true),null,true);
      
      public static var screenshotMinimap:KeyBinding = _add(18,"Minimap Screenshot",new Key(86,true));
      
      public static var lockCamera:KeyBinding = _add(19,"Lock Camera",new Key(76,true),null,true);
      
      public static var lookUp:KeyBinding = _add(20,"Look Up",new Key(72,true),null,true);
      
      public static var lookLeft:KeyBinding = _add(21,"Look Left",new Key(74,true),null,true);
      
      public static var lookDown:KeyBinding = _add(22,"Look Down",new Key(89,true),null,true);
      
      public static var lookRight:KeyBinding = _add(23,"Look Right",new Key(71,true),null,true);
      
      public static var hideUI:KeyBinding = _add(24,"Hide UI",new Key(79,true),null,true);
      
      public static var download:KeyBinding = _add(27,"Download Level",new Key(67,true),null);
      
      public var id:int;
      
      public var name:String;
      
      public var keyDefault:Key;
      
      public var keyAzerty:Key;
      
      public var keyCustom:Key = null;
      
      public var staffOnly:Boolean;
      
      public function KeyBinding(param1:int, param2:String, param3:Key, param4:Key = null, param5:Boolean = false)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.keyDefault = param3;
         this.keyAzerty = param4;
         this.staffOnly = param5;
      }
      
      private static function _add(param1:int, param2:String, param3:Key, param4:Key = null, param5:Boolean = false) : KeyBinding
      {
         var _loc6_:KeyBinding = new KeyBinding(param1,param2,param3,param4,param5);
         _all.push(_loc6_);
         _ref[param1] = _loc6_;
         return _loc6_;
      }
      
      public static function load() : void
      {
         var _loc1_:KeyBinding = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         for each(_loc1_ in _all)
         {
            _loc1_.keyCustom = null;
         }
         _loc2_ = Global.base.settings.keybinds;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = int(_loc2_[_loc3_]);
            _loc5_ = int(_loc2_[_loc3_ + 1]);
            _loc6_ = Boolean(_loc2_[_loc3_ + 2]);
            _ref[_loc4_].keyCustom = new Key(_loc5_,_loc6_);
            _loc3_ += 3;
         }
      }
      
      public static function save() : void
      {
         var _loc4_:KeyBinding = null;
         var _loc1_:Array = new Array();
         var _loc2_:Message = new Message("keybinds");
         var _loc3_:int = 0;
         while(_loc3_ < _all.length)
         {
            _loc4_ = _all[_loc3_];
            if(_loc4_.keyCustom)
            {
               _loc1_[_loc3_ * 3] = _loc4_.id;
               _loc2_.add(_loc4_.id);
               _loc1_[_loc3_ * 3 + 1] = _loc4_.keyCustom.keyCode;
               _loc2_.add(_loc4_.keyCustom.keyCode);
               _loc1_[_loc3_ * 3 + 2] = _loc4_.keyCustom.needsShift ? 1 : 0;
               _loc2_.add(_loc4_.keyCustom.needsShift ? 1 : 0);
            }
            _loc3_++;
         }
         Global.base.settings.keybinds = _loc1_;
         Global.base.ui2instance.connection.sendMessage(_loc2_);
      }
      
      public function get key() : Key
      {
         return this.keyCustom ? this.keyCustom : (Global.base.settings.azerty && Boolean(this.keyAzerty) ? this.keyAzerty : this.keyDefault);
      }
      
      public function isDown(param1:Boolean = false) : Boolean
      {
         var _loc2_:Key = this.key;
         if(!param1 && Bl.isKeyDown(16) != _loc2_.needsShift)
         {
            return false;
         }
         return Bl.isKeyDown(_loc2_.keyCode as int);
      }
      
      public function isJustPressed(param1:Boolean = false) : Boolean
      {
         var _loc2_:Key = this.key;
         if(!param1 && Bl.isKeyDown(16) != _loc2_.needsShift)
         {
            return false;
         }
         return Bl.isKeyJustPressed(_loc2_.keyCode as int);
      }
      
      public function isJustReleased(param1:Boolean = false) : Boolean
      {
         var _loc2_:Key = this.key;
         if(!param1 && Bl.isKeyDown(16) != _loc2_.needsShift)
         {
            return false;
         }
         return Bl.isKeyJustReleased(_loc2_.keyCode as int);
      }
   }
}


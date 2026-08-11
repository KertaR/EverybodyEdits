package
{
   import flash.utils.ByteArray;
   import playerio.Message;
   
   public class SettingsManager
   {
      
      public var smileys:Array = new Array();
      
      public var keybinds:Array = new Array();
      
      public var particles:Boolean = false;
      
      public var greenOnMinimap:Boolean = true;
      
      public var minimapAlpha:Number = 1;
      
      public var wordFilter:Boolean = true;
      
      public var coloredNames:Boolean = false;
      
      public var hideUsernames:Boolean = false;
      
      public var hideBubbles:Boolean = false;
      
      public var showPackageNames:Boolean = true;
      
      public var visibleRows:int = 3;
      
      public var collapsed:Boolean = false;
      
      public var blockPicker:Boolean = false;
      
      public var historyLimit:int = 25;
      
      public var volume:int = 100;
      
      public var azerty:Boolean = false;
      
      public function SettingsManager()
      {
         super();
      }
      
      private function setSmileys(param1:ByteArray) : void
      {
         this.smileys = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.smileys.push(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function setKeybinds(param1:ByteArray) : void
      {
         this.keybinds = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this.keybinds.push(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function extractPlayerObjectsMessage(param1:Message) : int
      {
         var _loc2_:int = -1;
         var _loc3_:int = -1;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            try
            {
               if(param1.getString(_loc4_) == "ss")
               {
                  _loc2_ = _loc4_;
               }
               else if(param1.getString(_loc4_) == "se")
               {
                  _loc3_ = _loc4_;
               }
            }
            catch(e:Error)
            {
            }
            _loc4_++;
         }
         if(_loc3_ == -1)
         {
            throw new Error("Settings end is missing.");
         }
         if(_loc2_ == -1)
         {
            return _loc3_;
         }
         this.setSmileys(param1.getByteArray(++_loc2_));
         this.setKeybinds(param1.getByteArray(++_loc2_));
         this.particles = param1.getBoolean(++_loc2_);
         this.greenOnMinimap = param1.getBoolean(++_loc2_);
         this.minimapAlpha = param1.getNumber(++_loc2_);
         this.wordFilter = param1.getBoolean(++_loc2_);
         this.coloredNames = param1.getBoolean(++_loc2_);
         this.hideUsernames = param1.getBoolean(++_loc2_);
         this.hideBubbles = param1.getBoolean(++_loc2_);
         this.showPackageNames = param1.getBoolean(++_loc2_);
         this.visibleRows = param1.getInt(++_loc2_);
         this.collapsed = param1.getBoolean(++_loc2_);
         this.blockPicker = param1.getBoolean(++_loc2_);
         this.historyLimit = param1.getInt(++_loc2_);
         this.volume = param1.getInt(++_loc2_);
         this.azerty = param1.getBoolean(++_loc2_);
         return _loc3_;
      }
      
      public function save(param1:Boolean = false) : void
      {
         var _loc2_:Message = new Message("settings");
         _loc2_.add(this.particles);
         _loc2_.add(this.greenOnMinimap);
         _loc2_.add(this.minimapAlpha);
         _loc2_.add(this.wordFilter);
         _loc2_.add(this.coloredNames);
         _loc2_.add(this.hideUsernames);
         _loc2_.add(this.hideBubbles);
         _loc2_.add(this.showPackageNames);
         _loc2_.add(this.visibleRows);
         _loc2_.add(this.collapsed);
         _loc2_.add(this.blockPicker);
         _loc2_.add(this.historyLimit);
         _loc2_.add(this.volume);
         _loc2_.add(this.azerty);
         Global.base.connection.sendMessage(_loc2_);
      }
   }
}


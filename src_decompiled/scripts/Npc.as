package
{
   import blitter.Bl;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import io.player.tools.Badwords;
   import items.ItemId;
   import items.ItemManager;
   import items.ItemNpc;
   import states.PlayState;
   
   public class Npc
   {
      
      private var _name:String;
      
      private var _messages:Array;
      
      private var _loc:Point;
      
      private var item:ItemNpc;
      
      private var chat:Chat;
      
      private var curChat:int = -1;
      
      public var messagesEmpty:Boolean = false;
      
      public function Npc(param1:String, param2:Array, param3:Point, param4:ItemNpc)
      {
         super();
         this._name = param1;
         this._messages = param2;
         this._loc = param3;
         this.item = param4;
         this.chat = new Chat(param1);
         this.messagesEmpty = param2[0] == "" && param2[1] == "" && param2[2] == "";
      }
      
      public static function getNextNpcID(param1:int, param2:Boolean = true) : int
      {
         if(!ItemId.isNPC(param1) || !Global.base.canUseBlock(ItemManager.getBrickById(param1)))
         {
            return param1;
         }
         var _loc3_:Boolean = false;
         var _loc4_:* = ItemId.NpcArray.indexOf(param1);
         do
         {
            if(param2)
            {
               _loc4_++;
            }
            else
            {
               _loc4_--;
            }
            if(param2 && _loc4_ >= ItemId.NpcArray.length)
            {
               _loc4_ = 0;
            }
            if(!param2 && _loc4_ < 0)
            {
               _loc4_ = int(ItemId.NpcArray.length - 1);
            }
            if(Global.base.canUseBlock(ItemManager.getBrickById(ItemId.NpcArray[_loc4_])))
            {
               _loc3_ = true;
            }
         }
         while(!_loc3_);
         return ItemId.NpcArray[_loc4_];
      }
      
      private static function richMessage(param1:String) : String
      {
         var _loc2_:Player = (Global.base.state as PlayState).player;
         var _loc3_:String = param1;
         _loc3_ = _loc3_.replace(/%coins%/g,_loc2_.coins);
         _loc3_ = _loc3_.replace(/%bcoins%/g,_loc2_.bcoins);
         _loc3_ = _loc3_.replace(/%deaths%/g,_loc2_.deaths);
         _loc3_ = _loc3_.replace(/%levelname%/g,Global.currentLevelname);
         _loc3_ = _loc3_.replace(/%username%/g,_loc2_.name);
         _loc3_ = _loc3_.replace(/%Username%/g,_loc2_.name.substring(0,1).toUpperCase() + _loc2_.name.substr(1));
         _loc3_ = _loc3_.replace(/%USERNAME%/g,_loc2_.name.toUpperCase());
         return Badwords.Filter(_loc3_);
      }
      
      public function get isTalking() : Boolean
      {
         return this.curChat != -1;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get messages() : Array
      {
         return this._messages;
      }
      
      public function get location() : Point
      {
         return this._loc;
      }
      
      public function drawName(param1:BitmapData, param2:Number, param3:Number) : void
      {
         if(this.name != "")
         {
            this.chat.drawNpcName(param1,param2 + this.location.x * 16,param3 + this.location.y * 16);
         }
      }
      
      public function drawChat(param1:BitmapData, param2:Number, param3:Number) : void
      {
         if(this.messagesEmpty)
         {
            return;
         }
         if(this.item != null && this.curChat > -1)
         {
            param3 += this.item.bubbleOffset;
         }
         this.chat.drawNpcChat(param1,param2 + this.location.x * 16,param3 + this.location.y * 16,this.curChat == -1);
      }
      
      public function equals(param1:Npc) : Boolean
      {
         return this.name == param1.name && this.location.equals(param1.location) && this.messages[0] == param1.messages[0] && this.messages[1] == param1.messages[1] && this.messages[2] == param1.messages[2];
      }
      
      public function reset() : void
      {
         this.curChat = -1;
         this.chat.clearChats();
      }
      
      public function sayNext() : void
      {
         ++this.curChat;
         var _loc1_:String = this.getNextMessage();
         if(_loc1_ == "")
         {
            this.reset();
         }
         else
         {
            this.chat.say(richMessage(_loc1_));
         }
         Global.base.connection.send("npc",this.location.x,this.location.y,this.curChat);
      }
      
      private function getNextMessage() : String
      {
         var _loc1_:int = this.curChat;
         while(_loc1_ < this.messages.length)
         {
            if(this.messages[_loc1_] != "")
            {
               return this.messages[_loc1_];
            }
            ++this.curChat;
            _loc1_++;
         }
         return "";
      }
      
      public function setAsDefault() : void
      {
         Bl.data.npc_name = this.name;
         Bl.data.npc_mes1 = this.messages[0];
         Bl.data.npc_mes2 = this.messages[1];
         Bl.data.npc_mes3 = this.messages[2];
      }
   }
}


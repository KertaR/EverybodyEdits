package ui.chat
{
   import blitter.BlText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sample.ui.components.Box;
   import states.PlayState;
   
   public class UserlistItem extends Box
   {
      
      public var username:String;
      
      public var time:Number;
      
      private var _count:int = 0;
      
      public var canchat:Boolean = false;
      
      public var isguest:Boolean = false;
      
      public var isfriend:Boolean = false;
      
      private var ps:PlayState;
      
      private var usernameBitmap:Bitmap;
      
      private var usernamefield:Box;
      
      public var flagBitmap:Bitmap;
      
      public var country:String = "HU";
      
      private var usernameCount:Bitmap;
      
      private var usernameCountField:Box;
      
      private var iconBox:Box;
      
      private var userId:String;
      
      private var goldmember:Boolean;
      
      private var teamIcons:assets_teamicons;
      
      private var teamIcon:Box;
      
      private var goldIcon:Box;
      
      private var offset:int = 0;
      
      public var chatColor:Number;
      
      public var darkChatColor:Number;
      
      public function UserlistItem(param1:String, param2:Boolean, param3:Boolean = false, param4:Boolean = false, param5:uint = 0)
      {
         var tf:BlText;
         var handleMouse:Function = null;
         var un:String = param1;
         var canchat:Boolean = param2;
         var isfriend:Boolean = param3;
         var goldmember:Boolean = param4;
         var ChatColor:uint = param5;
         this.time = new Date().time;
         this.teamIcons = new assets_teamicons();
         this.teamIcon = new Box();
         this.goldIcon = new Box();
         handleMouse = function(param1:MouseEvent):void
         {
            if(param1.type != MouseEvent.MOUSE_OUT)
            {
               fill(2236962);
            }
            else
            {
               fill(0,0);
            }
         };
         super();
         this.isguest = un.indexOf("-") != -1 || un.toLowerCase().indexOf("guest") == 0;
         this.canchat = !this.isguest && canchat;
         this.isfriend = isfriend;
         margin(0,0,0,0);
         this.username = un;
         this.goldmember = !this.isguest && goldmember;
         this.chatColor = Player.getNameColor(un);
         if(this.chatColor == Config.default_color)
         {
            this.chatColor = isfriend ? Config.friend_color : (this.isguest ? Config.guest_color : (canchat ? Config.default_color : 6710886));
            this.darkChatColor = isfriend ? Config.friend_color_dark : (this.chatColor == Config.default_color ? Config.default_color_dark : this.chatColor);
         }
         else
         {
            this.darkChatColor = this.chatColor;
         }
         if(ChatColor != 0)
         {
            this.chatColor = this.darkChatColor = ChatColor;
         }
         tf = new BlText(14,155,this.chatColor,"left","visitor");
         tf.text = un;
         
         var nameContainer:Sprite = new Sprite();
         
         this.flagBitmap = new Bitmap(createFlagBitmapData("HU"));
         this.flagBitmap.x = 0;
         this.flagBitmap.y = 1;
         nameContainer.addChild(this.flagBitmap);
         
         this.usernameBitmap = new Bitmap(tf.clone());
         this.usernameBitmap.x = 20;
         this.usernameBitmap.y = 0;
         nameContainer.addChild(this.usernameBitmap);
         
         this.usernamefield = new Box();
         this.usernamefield.margin(0,NaN,NaN,0);
         this.usernamefield.add(nameContainer);
         
         buttonMode = true;
         useHandCursor = true;
         addEventListener(MouseEvent.MOUSE_OVER,handleMouse);
         addEventListener(MouseEvent.MOUSE_OUT,handleMouse);
         addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_PLAYER_ACTIONS,true);
            _loc2_.extra.shift = param1.shiftKey;
            _loc2_.username = username;
            _loc2_.userId = userId;
            dispatchEvent(_loc2_);
            param1.preventDefault();
            param1.stopPropagation();
         });
         this.iconBox = new Box();
         this.iconBox.margin(3,0,0,NaN);
         this.teamIcon.margin(NaN,NaN,NaN,0);
         this.teamIcon.add(this.teamIcons);
         this.iconBox.add(this.teamIcon);
         if(goldmember)
         {
            this.goldIcon.add(new assets_goldiconxsmall());
            this.iconBox.add(this.goldIcon);
         }
         add(this.iconBox);
         add(this.usernamefield);
         this.setTeam(0);
      }
      
      public static function createFlagBitmapData(param1:String) : BitmapData
      {
         var bmd:BitmapData = new BitmapData(16, 11, false, 0x1e293b);
         var c:String = param1 ? param1.toUpperCase() : "HU";
         var x:int;
         var y:int;
         
         if (c == "HU")
         {
            for (y = 0; y < 11; y++)
            {
               var colHU:uint = (y < 4) ? 0xCE2939 : ((y < 7) ? 0xFFFFFF : 0x477050);
               for (x = 0; x < 16; x++) bmd.setPixel(x, y, colHU);
            }
         }
         else if (c == "US")
         {
            for (y = 0; y < 11; y++)
            {
               var colUS:uint = (y % 2 == 0) ? 0xBB133E : 0xFFFFFF;
               for (x = 0; x < 16; x++)
               {
                  if (x < 7 && y < 6) bmd.setPixel(x, y, 0x002147);
                  else bmd.setPixel(x, y, colUS);
               }
            }
            bmd.setPixel(2, 1, 0xFFFFFF); bmd.setPixel(4, 1, 0xFFFFFF);
            bmd.setPixel(3, 3, 0xFFFFFF);
            bmd.setPixel(2, 4, 0xFFFFFF); bmd.setPixel(4, 4, 0xFFFFFF);
         }
         else if (c == "GB" || c == "UK")
         {
            for (y = 0; y < 11; y++)
            {
               for (x = 0; x < 16; x++) bmd.setPixel(x, y, 0x012169);
            }
            for (x = 0; x < 16; x++)
            {
               var dy:int = Math.round(x * 10 / 15);
               bmd.setPixel(x, dy, 0xFFFFFF);
               bmd.setPixel(x, 10 - dy, 0xFFFFFF);
            }
            for (y = 0; y < 11; y++) { bmd.setPixel(7, y, 0xFFFFFF); bmd.setPixel(8, y, 0xFFFFFF); }
            for (x = 0; x < 16; x++) { bmd.setPixel(x, 4, 0xFFFFFF); bmd.setPixel(x, 6, 0xFFFFFF); }
            for (y = 0; y < 11; y++) { bmd.setPixel(7, y, 0xC8102E); bmd.setPixel(8, y, 0xC8102E); }
            for (x = 0; x < 16; x++) { bmd.setPixel(x, 5, 0xC8102E); }
         }
         else if (c == "DE")
         {
            for (y = 0; y < 11; y++)
            {
               var colDE:uint = (y < 4) ? 0x000000 : ((y < 7) ? 0xDD0000 : 0xFFCE00);
               for (x = 0; x < 16; x++) bmd.setPixel(x, y, colDE);
            }
         }
         else if (c == "FR")
         {
            for (x = 0; x < 16; x++)
            {
               var colFR:uint = (x < 5) ? 0x0055A4 : ((x < 11) ? 0xFFFFFF : 0xEF4135);
               for (y = 0; y < 11; y++) bmd.setPixel(x, y, colFR);
            }
         }
         else if (c == "IT")
         {
            for (x = 0; x < 16; x++)
            {
               var colIT:uint = (x < 5) ? 0x009246 : ((x < 11) ? 0xFFFFFF : 0xCE2B37);
               for (y = 0; y < 11; y++) bmd.setPixel(x, y, colIT);
            }
         }
         else if (c == "RO")
         {
            for (x = 0; x < 16; x++)
            {
               var colRO:uint = (x < 5) ? 0x002B7F : ((x < 11) ? 0xFCD116 : 0xCE1126);
               for (y = 0; y < 11; y++) bmd.setPixel(x, y, colRO);
            }
         }
         else if (c == "PL")
         {
            for (y = 0; y < 11; y++)
            {
               var colPL:uint = (y < 6) ? 0xFFFFFF : 0xDC143C;
               for (x = 0; x < 16; x++) bmd.setPixel(x, y, colPL);
            }
         }
         else if (c == "UA")
         {
            for (y = 0; y < 11; y++)
            {
               var colUA:uint = (y < 6) ? 0x0057B7 : 0xFFD700;
               for (x = 0; x < 16; x++) bmd.setPixel(x, y, colUA);
            }
         }
         else if (c == "ES")
         {
            for (y = 0; y < 11; y++)
            {
               var colES:uint = (y < 3 || y >= 8) ? 0xAA151B : 0xF1BF00;
               for (x = 0; x < 16; x++) bmd.setPixel(x, y, colES);
            }
         }
         else if (c == "NL")
         {
            for (y = 0; y < 11; y++)
            {
               var colNL:uint = (y < 4) ? 0xAE1C28 : ((y < 7) ? 0xFFFFFF : 0x21468B);
               for (x = 0; x < 16; x++) bmd.setPixel(x, y, colNL);
            }
         }
         else if (c == "SE")
         {
            for (y = 0; y < 11; y++)
            {
               for (x = 0; x < 16; x++)
               {
                  if (x == 5 || x == 6 || y == 5) bmd.setPixel(x, y, 0xFECC00);
                  else bmd.setPixel(x, y, 0x006AA7);
               }
            }
         }
         else if (c == "NO")
         {
            for (y = 0; y < 11; y++)
            {
               for (x = 0; x < 16; x++)
               {
                  if (x == 5 || y == 5) bmd.setPixel(x, y, 0x00205B);
                  else if (x == 4 || x == 6 || y == 4 || y == 6) bmd.setPixel(x, y, 0xFFFFFF);
                  else bmd.setPixel(x, y, 0xBA0C2F);
               }
            }
         }
         else if (c == "FI")
         {
            for (y = 0; y < 11; y++)
            {
               for (x = 0; x < 16; x++)
               {
                  if (x == 5 || x == 6 || y == 5) bmd.setPixel(x, y, 0x002F6C);
                  else bmd.setPixel(x, y, 0xFFFFFF);
               }
            }
         }
         else if (c == "JP")
         {
            for (y = 0; y < 11; y++)
            {
               for (x = 0; x < 16; x++)
               {
                  var dist:Number = (x - 7.5) * (x - 7.5) + (y - 5) * (y - 5);
                  if (dist <= 9) bmd.setPixel(x, y, 0xBC002D);
                  else bmd.setPixel(x, y, 0xFFFFFF);
               }
            }
         }
         else if (c == "CA")
         {
            for (x = 0; x < 16; x++)
            {
               var colCA:uint = (x < 4 || x >= 12) ? 0xFF0000 : 0xFFFFFF;
               for (y = 0; y < 11; y++) bmd.setPixel(x, y, colCA);
            }
            bmd.setPixel(7, 5, 0xFF0000); bmd.setPixel(8, 5, 0xFF0000);
            bmd.setPixel(7, 6, 0xFF0000); bmd.setPixel(8, 6, 0xFF0000);
         }
         else if (c == "BR")
         {
            for (y = 0; y < 11; y++)
            {
               for (x = 0; x < 16; x++)
               {
                  var dX:Number = Math.abs(x - 7.5) / 6.0 + Math.abs(y - 5) / 4.0;
                  if (dX <= 0.4) bmd.setPixel(x, y, 0x002776);
                  else if (dX <= 1.0) bmd.setPixel(x, y, 0xFEDF00);
                  else bmd.setPixel(x, y, 0x009C3B);
               }
            }
         }
         else
         {
            for (y = 0; y < 11; y++)
            {
               var colDef:uint = (y < 4) ? 0xCE2939 : ((y < 7) ? 0xFFFFFF : 0x477050);
               for (x = 0; x < 16; x++) bmd.setPixel(x, y, colDef);
            }
         }
         
         for (x = 0; x < 16; x++)
         {
            bmd.setPixel(x, 0, 0x222222);
            bmd.setPixel(x, 10, 0x222222);
         }
         for (y = 0; y < 11; y++)
         {
            bmd.setPixel(0, y, 0x222222);
            bmd.setPixel(15, y, 0x222222);
         }
         
         return bmd;
      }
      
      public function setCountry(param1:String) : void
      {
         if(param1 == null || param1 == "")
         {
            param1 = "HU";
         }
         this.country = param1;
         if(this.flagBitmap != null)
         {
            this.flagBitmap.bitmapData = createFlagBitmapData(param1);
         }
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function setTeam(param1:int) : void
      {
         this.offset = 0;
         if(param1 > 0)
         {
            this.teamIcons.gotoAndStop(param1);
            this.teamIcon.visible = true;
            this.offset += 11;
         }
         else
         {
            this.teamIcon.visible = false;
         }
         this.goldIcon.margin(NaN,NaN,NaN,-this.offset);
      }
      
      public function setUserId(param1:String) : void
      {
         this.userId = param1;
      }
      
      public function getUserId() : String
      {
         return this.userId;
      }
   }
}

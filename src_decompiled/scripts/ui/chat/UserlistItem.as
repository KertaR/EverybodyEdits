package ui.chat
{
   import blitter.BlText;
   import flash.display.Bitmap;
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
         tf = new BlText(14,180,this.chatColor,"left","visitor");
         tf.text = un;
         this.usernamefield = new Box();
         this.usernamefield.margin(0,NaN,NaN,0);
         this.usernameBitmap = new Bitmap(tf.clone());
         this.usernamefield.add(this.usernameBitmap);
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


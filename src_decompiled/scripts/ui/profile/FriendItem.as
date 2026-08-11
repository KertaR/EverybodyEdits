package ui.profile
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import items.ItemManager;
   import mx.utils.StringUtil;
   import playerio.Message;
   import ui.social.SocialFriend;
   
   public class FriendItem extends asset_friend
   {
      
      public static const DELETE:String = "delete";
      
      public static const BLOCK:String = "block";
      
      public var friend:SocialFriend;
      
      private var altType:String;
      
      private var altUsername:String;
      
      private var smileyGraphics:FriendSmiley;
      
      private var smileyBitmap:Bitmap;
      
      private var smileyHolder:MovieClip;
      
      public function FriendItem(param1:SocialFriend, param2:String = null)
      {
         super();
         this.friend = param1;
         this.altType = param2;
         divider.mouseEnabled = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse,false,0,true);
         this.init(param1 ? param1.type : param2);
         this.setOnlineStatus();
      }
      
      public function get type() : String
      {
         return this.friend ? this.friend.type : this.altType;
      }
      
      public function set type(param1:String) : void
      {
         if(this.friend)
         {
            this.friend.type = param1;
         }
         else
         {
            this.altType = param1;
         }
      }
      
      public function get username() : String
      {
         return this.friend ? this.friend.username : this.altUsername;
      }
      
      public function set username(param1:String) : void
      {
         if(this.friend)
         {
            this.friend.username = param1;
         }
         else
         {
            this.altUsername = param1;
         }
      }
      
      private function init(param1:String) : void
      {
         var type:String = param1;
         this.type = type;
         gotoAndStop(type == SocialFriend.ACCEPTED || type == SocialFriend.REJECTED ? SocialFriend.MESSAGE : type);
         this.height = 55;
         switch(type)
         {
            case SocialFriend.FRIEND:
               tf_name.text = this.friend.username.toUpperCase();
               tf_name.setTextFormat(new TextFormat(null,null,Player.getNameColor(this.friend.username.toLowerCase())));
               tf_online.text = "";
               tf_playing.text = "";
               tf_name.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_PROFILE,true,false);
                  _loc2_.username = friend.username.toLowerCase();
                  dispatchEvent(_loc2_);
               });
               tf_name.addEventListener(MouseEvent.ROLL_OVER,function(param1:MouseEvent):void
               {
                  var _loc2_:TextFormat = tf_name.getTextFormat();
                  _loc2_.url = "asfunction:";
                  _loc2_.underline = true;
                  tf_name.setTextFormat(_loc2_);
               });
               tf_name.addEventListener(MouseEvent.ROLL_OUT,function(param1:MouseEvent):void
               {
                  var _loc2_:TextFormat = tf_name.getTextFormat();
                  _loc2_.underline = false;
                  tf_name.setTextFormat(_loc2_);
               });
               btn_play.visible = false;
               btn_delete.visible = false;
               btn_delete.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDeleteFriend,false,0,true);
               break;
            case SocialFriend.CONFIRM:
               btn_confirmcancel.addEventListener(MouseEvent.MOUSE_DOWN,this.handleCancelDelete,false,0,true);
               btn_confirmdelete.addEventListener(MouseEvent.MOUSE_DOWN,this.handleConfirmDelete,false,0,true);
               break;
            case SocialFriend.INVITE:
               tf_error.text = "";
               tf_error.autoSize = TextFieldAutoSize.LEFT;
               tf_usermail.text = "";
               tf_usermail.restrict = "0-9A-Za-z";
               tf_usermail.maxChars = 20;
               btn_send.addEventListener(MouseEvent.MOUSE_DOWN,this.createInvite,false,0,true);
               btn_cancel.addEventListener(MouseEvent.MOUSE_DOWN,this.removeSelf,false,0,true);
               this.height = 84;
               break;
            case SocialFriend.PENDING:
               Global.base.hideLoadingScreen();
               tf_mail.text = "Pending response:\n" + this.username.toUpperCase();
               btn_delete.visible = false;
               btn_delete.addEventListener(MouseEvent.MOUSE_DOWN,this.deleteInvite,false,0,true);
               break;
            case SocialFriend.INVITATION:
               tf_error.text = "";
               tf_mail.text = this.friend.username.toUpperCase() + " would like to be your friend.";
               btn_block.addEventListener(MouseEvent.MOUSE_DOWN,this.blockUserInvites,false,0,true);
               btn_accept.addEventListener(MouseEvent.MOUSE_DOWN,this.handleAnswerInvitation,false,0,true);
               btn_ignore.addEventListener(MouseEvent.MOUSE_DOWN,this.handleAnswerInvitation,false,0,true);
               break;
            case SocialFriend.ACCEPTED:
               tf_mail.text = this.friend.username.toUpperCase() + " has accepted your friend request.";
               btn_ok.addEventListener(MouseEvent.MOUSE_DOWN,this.deleteInvite,false,0,true);
               break;
            case SocialFriend.REJECTED:
               tf_mail.text = this.friend.username.toUpperCase() + " has rejected your friend request.";
               btn_ok.addEventListener(MouseEvent.MOUSE_DOWN,this.deleteInvite,false,0,true);
               break;
            case SocialFriend.BLOCKED:
               tf_message.text = "\n" + this.friend.username.toUpperCase();
               btn_unblock.addEventListener(MouseEvent.MOUSE_DOWN,this.unblockUserInvites,false,0,true);
         }
         dispatchEvent(new Event(Event.CHANGE,true,false));
      }
      
      private function setOnlineStatus() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:String = null;
         if(!this.friend || this.friend.type != SocialFriend.FRIEND)
         {
            return;
         }
         if(this.friend.online)
         {
            tf_online.text = "Online";
            if(Boolean(this.friend.worldId) && Boolean(this.friend.worldName))
            {
               btn_play.visible = true;
               btn_play.addEventListener(MouseEvent.MOUSE_DOWN,this.handleJoinWorld,false,0,true);
               tf_online.appendText(" - Playing in: ");
               tf_playing.autoSize = TextFieldAutoSize.LEFT;
               tf_playing.text = this.friend.worldName;
               _loc1_ = new Sprite();
               _loc1_.x = tf_playing.x;
               _loc1_.y = tf_playing.y;
               _loc1_.graphics.beginFill(0,0);
               _loc1_.graphics.drawRect(-3,-3,tf_playing.textWidth + 6,tf_playing.textHeight + 6);
               addChild(_loc1_);
               _loc1_.useHandCursor = true;
               _loc1_.buttonMode = true;
               _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.handleJoinWorld,false,0,true);
            }
            tf_online.setTextFormat(new TextFormat(null,null,65280),0,6);
         }
         else
         {
            btn_play.visible = false;
            _loc2_ = this.getElapsedTimeString(this.friend.lastSeen);
            tf_online.text = "Offline - Last seen:";
            tf_playing.text = _loc2_;
            tf_playing.setTextFormat(new TextFormat(null,null,7829367),0,_loc2_.length);
            tf_online.setTextFormat(new TextFormat(null,null,7829367),8,tf_online.length);
         }
         this.smileyGraphics = new FriendSmiley(ItemManager.smileysBMD);
         this.smileyGraphics.frame = this.friend.smileyId;
         this.smileyGraphics.setRectY(this.friend.usingGoldBorder ? 26 : 0);
         if(Boolean(this.smileyBitmap) && Boolean(this.smileyBitmap.parent))
         {
            removeChild(this.smileyBitmap);
         }
         this.smileyBitmap = this.smileyGraphics.getAsBitmap(2);
         this.smileyBitmap.x = 5;
         addChild(this.smileyBitmap);
      }
      
      private function getElapsedTimeString(param1:Number) : String
      {
         var _loc2_:TimeSpan = null;
         var _loc3_:int = 0;
         if(param1 < 0)
         {
            return "Never";
         }
         _loc2_ = TimeSpan.fromDates(new Date(param1 * 1000),new Date());
         if(_loc2_.days >= 365)
         {
            return "More than 1 year ago";
         }
         if(_loc2_.days >= 30)
         {
            _loc3_ = _loc2_.days / 30;
            return _loc3_ + " month" + (_loc3_ > 1 ? "s" : "") + " ago";
         }
         if(_loc2_.days == 1)
         {
            return "Yesterday";
         }
         if(_loc2_.days > 0)
         {
            return _loc2_.days + " days ago";
         }
         if(_loc2_.hours > 0)
         {
            return _loc2_.hours + " hour" + (_loc2_.hours > 1 ? "s" : "") + " ago";
         }
         if(_loc2_.minutes > 0)
         {
            return _loc2_.minutes + " minute" + (_loc2_.minutes > 1 ? "s" : "") + " ago";
         }
         return "Few seconds ago";
      }
      
      private function handleJoinWorld(param1:MouseEvent) : void
      {
         var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD,true,false);
         _loc2_.world_id = this.friend.worldId;
         dispatchEvent(_loc2_);
      }
      
      private function handleDeleteFriend(param1:MouseEvent) : void
      {
         this.init(SocialFriend.CONFIRM);
      }
      
      private function handleCancelDelete(param1:MouseEvent) : void
      {
         this.init(SocialFriend.FRIEND);
         this.setOnlineStatus();
      }
      
      private function handleConfirmDelete(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         gotoAndStop(SocialFriend.WAITING);
         Global.base.requestRemoteMethod("deleteFriend",function(param1:Message):void
         {
            removeSelf();
         },this.username);
      }
      
      private function deleteInvite(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         gotoAndStop(SocialFriend.WAITING);
         Global.base.requestRemoteMethod("deleteInvite",function(param1:Message):void
         {
            removeSelf();
         },this.username);
      }
      
      private function createInvite(param1:MouseEvent) : void
      {
         Global.base.showLoadingScreen("Sending Invite");
         Global.base.requestRemoteMethod("createInvite",this.handleInvitationSent,StringUtil.trim(tf_usermail.text));
      }
      
      private function handleInvitationSent(param1:Message) : void
      {
         if(param1.getBoolean(0))
         {
            this.username = tf_usermail.text;
            this.init(SocialFriend.PENDING);
         }
         else
         {
            Global.base.hideLoadingScreen();
            tf_error.text = param1.getString(1);
         }
      }
      
      private function handleAnswerInvitation(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = param1.target == btn_accept;
         Global.base.requestRemoteMethod("answerInvite",this.handleInvitationAnswered,this.friend.username,_loc2_);
         gotoAndStop(SocialFriend.WAITING);
         if(!_loc2_)
         {
            this.removeSelf();
         }
      }
      
      private function handleInvitationAnswered(param1:Message) : void
      {
         if(param1.getBoolean(0))
         {
            this.init(SocialFriend.FRIEND);
            this.friend.setOnlineStatus(param1.getBoolean(1),param1.getInt(4),param1.getBoolean(6),param1.getString(2),param1.getString(3),param1.getNumber(5));
            this.setOnlineStatus();
         }
         else
         {
            this.init(SocialFriend.INVITATION);
            tf_error.text = param1.getString(1);
         }
      }
      
      private function blockUserInvites(param1:MouseEvent) : void
      {
         var that:FriendItem;
         var event:MouseEvent = param1;
         gotoAndStop(SocialFriend.WAITING);
         that = this;
         Global.base.requestRemoteMethod("blockUserInvites",function(param1:Message):void
         {
            init(SocialFriend.BLOCKED);
            var _loc2_:Event = new Event(BLOCK,true,false);
            dispatchEvent(_loc2_);
         },this.friend.username,true);
      }
      
      private function unblockUserInvites(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         gotoAndStop(SocialFriend.WAITING);
         Global.base.requestRemoteMethod("blockUserInvites",function(param1:Message):void
         {
            removeSelf();
         },this.friend.username,false);
      }
      
      private function removeSelf(param1:MouseEvent = null) : void
      {
         dispatchEvent(new Event(FriendItem.DELETE,true,false));
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouse,false,0,true);
         }
         else
         {
            _loc2_ = getBounds(this).contains(mouseX,mouseY);
            this.showMouseOver(_loc2_);
            if(!_loc2_)
            {
               try
               {
                  if(stage != null)
                  {
                     stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouse);
                  }
               }
               catch(e:Error)
               {
               }
               addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse,false,0,true);
            }
         }
      }
      
      private function showMouseOver(param1:Boolean) : void
      {
         if(currentLabel == SocialFriend.WAITING)
         {
            return;
         }
         switch(this.type)
         {
            case SocialFriend.FRIEND:
               btn_delete.visible = param1;
               break;
            case SocialFriend.CONFIRM:
            case SocialFriend.INVITE:
               break;
            case SocialFriend.PENDING:
               btn_delete.visible = param1;
               break;
            case SocialFriend.INVITATION:
            case SocialFriend.BLOCKED:
         }
      }
      
      private function truncateText(param1:TextField, param2:String, param3:int) : void
      {
         param1.text = param2;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length && param1.numLines > param3)
         {
            param1.text = StringUtil.trim(param2.substring(0,param2.length - _loc4_)).concat("...");
            _loc4_++;
         }
      }
      
      override public function set height(param1:Number) : void
      {
         eventarea.height = param1;
         divider.y = param1 - divider.height;
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc5_:String = null;
         var _loc2_:int = 45;
         var _loc3_:int = 10;
         eventarea.width = param1;
         divider.width = param1 - 4;
         var _loc4_:int = 8;
         divider_v.x = param1 - 2 * _loc3_ - _loc2_;
         divider_v.visible = true;
         if(currentLabel == SocialFriend.WAITING)
         {
            return;
         }
         switch(this.type)
         {
            case SocialFriend.FRIEND:
               btn_delete.x = divider_v.x + _loc3_;
               btn_play.x = divider_v.x + _loc3_;
               tf_name.width = divider_v.x - tf_name.x - _loc3_;
               tf_online.width = divider_v.x - tf_online.x - _loc3_;
               tf_playing.width = divider_v.x - tf_playing.x - _loc3_;
               if(this.friend.worldName != null && this.friend.worldName.length > 0)
               {
                  this.truncateText(tf_playing,this.friend.worldName,1);
               }
               break;
            case SocialFriend.CONFIRM:
               divider_v.visible = false;
               tf_msg.width = param1 - 200;
               tf_msg.x = Math.round((param1 - tf_msg.width) / 2);
               btn_confirmcancel.x = param1 / 2 - btn_confirmcancel.width - 5;
               btn_confirmdelete.x = param1 / 2 + 5;
               break;
            case SocialFriend.INVITE:
               btn_send.x = divider_v.x + _loc3_;
               btn_cancel.x = divider_v.x + _loc3_;
               tf_mail.width = divider_v.x - tf_mail.x - _loc3_;
               tf_usermail.width = divider_v.x - tf_usermail.x - _loc3_;
               bg_mail.width = divider_v.x - bg_mail.x - _loc3_;
               tf_error.width = divider_v.x - tf_error.x - _loc3_;
               tf_moreinfo.width = divider_v.x - tf_error.x - _loc3_;
               break;
            case SocialFriend.PENDING:
               btn_delete.x = divider_v.x + _loc3_;
               tf_mail.width = divider_v.x - tf_mail.x - _loc3_;
               this.truncateText(tf_mail,"Pending response:\n" + this.username.toUpperCase(),3);
               break;
            case SocialFriend.INVITATION:
               btn_accept.x = divider_v.x + _loc3_;
               btn_ignore.x = divider_v.x + _loc3_;
               btn_block.x = divider_v.x + _loc3_;
               tf_mail.width = divider_v.x - tf_mail.x - _loc3_;
               tf_error.width = divider_v.x - tf_error.x - _loc3_;
               this.truncateText(tf_mail,this.friend.username.toUpperCase() + " would like to be your friend.",2);
               break;
            case SocialFriend.ACCEPTED:
            case SocialFriend.REJECTED:
               btn_ok.x = divider_v.x + _loc3_;
               tf_mail.width = divider_v.x - tf_mail.x - _loc3_;
               _loc5_ = this.friend.username.toUpperCase() + (this.friend.type == SocialFriend.ACCEPTED ? " has accepted your friend request." : " has rejected your friend request.");
               this.truncateText(tf_mail,_loc5_,3);
               break;
            case SocialFriend.BLOCKED:
               btn_unblock.x = divider_v.x + _loc3_;
               tf_message.width = divider_v.x - tf_message.x - _loc3_;
               this.truncateText(tf_message,"\n" + this.friend.username.toUpperCase(),3);
         }
      }
   }
}


package ui.chat
{
   import blitter.Bl;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFormat;
   import io.player.tools.Badwords;
   import playerio.Connection;
   import playerio.Message;
   import sample.ui.components.Label;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   import states.PlayState;
   import utilities.ColorUtil;
   
   public class SideChat extends Sprite
   {
      
      protected static var CHATBG:Class = SideChat_CHATBG;
      
      private var ucontainer:Rows;
      
      private var userlist:ScrollBox;
      
      private var ccontainer:Rows;
      
      public var chatbox:ScrollBox;
      
      private var labelName:Label;
      
      private var labelBy:Label;
      
      private var bg:Sprite;
      
      private var returntolobbybtn:asset_return_to_lobby;
      
      private var loginbtn:asset_login_now;
      
      private var friendsonline:Boolean = false;
      
      private var guests:Object;
      
      private var plays:int = 0;
      
      private var favorites:int = 0;
      
      private var likes:int = 0;
      
      private var ownername:String;
      
      private var infobtn:assets_infobtn;
      
      private var myname:String = "";
      
      private var chats:Array;
      
      private var prevHeader:String = "";
      
      private var users:Object;
      
      public var names:Object;
      
      private var staffJoined:Boolean;
      
      public function SideChat(param1:Connection)
      {
         var c:Connection = param1;
         this.ucontainer = new Rows().spacing(0);
         this.ccontainer = new Rows().spacing(0);
         this.labelName = new Label("",20,"left",16777215,false,"visitor");
         this.labelBy = new Label("",12,"left",11184810,false,"visitor");
         this.bg = new Sprite();
         this.guests = {};
         this.infobtn = new assets_infobtn();
         this.chats = [];
         this.users = {};
         this.names = {};
         super();
         c.addMessageHandler("add",function(param1:Message, param2:int, param3:String, param4:String, param5:int, param6:Number, param7:Number, param8:Boolean, param9:Boolean, param10:Boolean, param11:int, param12:int, param13:int, param14:Boolean, param15:Boolean, param16:Boolean, param17:int, param18:int, param19:int, param20:uint):void
         {
            addUser(param2.toString(),param3,param10,param14,param15,param17,param20);
         });
         c.addMessageHandler("left",function(param1:Message, param2:int):void
         {
            removeUser(param2.toString());
         });
         c.addMessageHandler("updatemeta",function(param1:Message, param2:String, param3:String, param4:int, param5:int, param6:int):void
         {
            setMetaData(param2,param3,param4,param5,param6);
            Global.currentLevelname = param3;
         });
         c.addMessageHandler("say",function(param1:Message, param2:int, param3:String):void
         {
            if(param3.length > 0)
            {
               addChat(param2.toString(),param3);
            }
         });
         c.addMessageHandler("say_old",function(param1:Message, param2:String, param3:String, param4:Boolean, param5:uint):void
         {
            var _loc6_:uint = Player.getNameColor(param2);
            if(_loc6_ == Config.default_color)
            {
               _loc6_ = param4 ? Config.friend_color_dark : Config.default_color_dark;
            }
            if(param5 != 0)
            {
               _loc6_ = param5;
            }
            addLine(param2,param3,_loc6_,true);
         });
         c.addMessageHandler("pm",function(param1:Message, param2:int, param3:String, param4:Boolean):void
         {
            var _loc5_:UserlistItem = users[param2];
            if(!_loc5_)
            {
               return;
            }
            addLine(param4 ? "* " + _loc5_.username + " > you" : "* you > " + _loc5_.username + "",param3,16777215);
         });
         c.addMessageHandler("write",function(param1:Message, param2:String, param3:String):void
         {
            addLine(param2,param3,16777215);
         });
         this.bg.graphics.beginFill(0,1);
         this.bg.graphics.drawRect(0,0,100,500);
         this.bg.x = 3;
         addChild(this.bg);
         addChild(new CHATBG());
         this.userlist = new ScrollBox().margin(1,1,1,1).add(this.ucontainer);
         this.userlist.border(1,1118481,1);
         this.userlist.width = Global.width - 640 - 5;
         this.userlist.scrollMultiplier = 6;
         this.userlist.x = 3;
         this.userlist.y = 50;
         addChild(this.userlist);
         this.chatbox = new ScrollBox().margin(1,1,1,1).add(this.ccontainer);
         this.chatbox.x = 3;
         this.chatbox.y = 172;
         this.chatbox.scrollMultiplier = 6;
         this.chatbox.border(1,1118481,1);
         this.chatbox.height = Global.height - this.chatbox.y;
         addChild(this.chatbox);
         this.labelName.x = 3;
         this.labelName.y = 0;
         addChild(this.labelName);
         this.labelBy.x = 4;
         this.labelBy.y = 15;
         addChild(this.labelBy);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemove);
      }
      
      public function refresh() : void
      {
         if(this.userlist)
         {
            this.userlist.refresh();
         }
         if(this.chatbox)
         {
            this.chatbox.refresh();
         }
      }
      
      private function addSystemMessage(param1:String) : ChatEntry
      {
         return this.addLine("* SYSTEM",param1,16777215);
      }
      
      public function handleAttach(param1:Event) : void
      {
         var e:Event = param1;
         this.adjust();
         if(Global.isFirstLogin && Global.roomid == Global.playerObject.homeworld)
         {
            TweenLite.delayedCall(3,this.addSystemMessage,["Welcome to your home world!"]);
            TweenLite.delayedCall(5,this.addSystemMessage,["Use the bottom bar to select what items you wish to place, then click where you want to draw!"]);
            TweenLite.delayedCall(10,this.addSystemMessage,["You can find more items in the items tab by clicking the \'More\' button."]);
            TweenLite.delayedCall(13,this.addSystemMessage,["Press the god mode button to fly around freely as you edit."]);
            TweenLite.delayedCall(16,this.addSystemMessage,["Check out \'Options\' to see other useful options."]);
         }
         if(Global.worldOwner)
         {
            this.infobtn.x = Math.round(Config.maxwidth - 640 - this.infobtn.width / 2 - 4);
            this.updateInfoBtn();
            this.infobtn.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               Global.base.showWorldPreview(Global.roomid,Global.currentLevelname,Global.base.ui2instance.description,Global.worldOwner,Global.currentLevelCrewName,(Global.base.state as PlayState).minimap.getBitmapData());
            });
            addChild(this.infobtn);
         }
      }
      
      private function updateInfoBtn() : void
      {
         if(this.infobtn)
         {
            this.infobtn.y = Math.round(this.userlist.y - this.infobtn.height / 2 - 3);
         }
      }
      
      public function handleRemove(param1:Event) : void
      {
      }
      
      private function adjust() : void
      {
         var w:int = 0;
         var newWidth:int = Config.maxwidth;
         this.bg.width = newWidth - 640;
         this.userlist.width = newWidth - 640 - 5;
         this.userlist.height = 115;
         this.chatbox.width = newWidth - 640 - 5;
         if(Global.player_is_guest)
         {
            this.returntolobbybtn = new asset_return_to_lobby();
            this.returntolobbybtn.addEventListener(MouseEvent.CLICK,function():void
            {
               Global.base.ShowLobby();
            });
            addChild(this.returntolobbybtn);
            this.loginbtn = new asset_login_now();
            this.loginbtn.addEventListener(MouseEvent.CLICK,function():void
            {
               Global.base.logout();
            });
            addChild(this.loginbtn);
            w = Math.min(Math.max(this.bg.width - 5,50),182.25);
            this.returntolobbybtn.width = w;
            this.returntolobbybtn.height = w * 0.12;
            this.returntolobbybtn.x = 27;
            this.returntolobbybtn.y = 120 + 347 + 32 - this.returntolobbybtn.height;
            this.loginbtn.width = w;
            this.loginbtn.height = w * 0.12;
            this.loginbtn.x = 27;
            this.loginbtn.y = 120 + 347 + 32 - this.returntolobbybtn.height - 2 - this.loginbtn.height;
            this.chatbox.height -= this.returntolobbybtn.height + this.loginbtn.height + 10;
            this.clearChat();
            this.addLine("* SYSTEM","If you want to chat, you should register an account!",16777215,false);
         }
         else
         {
            if(Boolean(this.returntolobbybtn) && Boolean(this.returntolobbybtn.parent))
            {
               this.returntolobbybtn.parent.removeChild(this.returntolobbybtn);
            }
            if(Boolean(this.loginbtn) && Boolean(this.loginbtn.parent))
            {
               this.returntolobbybtn.parent.removeChild(this.loginbtn);
            }
         }
         this.redrawUserlist();
      }
      
      public function setMe(param1:String, param2:String, param3:Boolean, param4:int, param5:Boolean, param6:uint) : void
      {
         this.myname = param2;
         this.addUser(param1,param2,param3,false,param5,param4,param6);
         this.redrawUserlist();
      }
      
      public function addFavorite(param1:int = 1) : void
      {
         this.setMetaData(this.ownername,Bl.data.roomname,this.plays,this.favorites = this.favorites + param1,this.likes);
      }
      
      public function addLike(param1:int = 1) : void
      {
         this.setMetaData(this.ownername,Bl.data.roomname,this.plays,this.favorites,this.likes = this.likes + param1);
      }
      
      public function setMetaData(param1:String, param2:String, param3:int, param4:int, param5:int) : void
      {
         Global.setPath(Badwords.Filter(param2) + " | Everybody Edits");
         Bl.data.roomname = Badwords.Filter(param2);
         this.labelName.text = Badwords.Filter(param2);
         this.ownername = param1;
         this.plays = param3;
         this.favorites = param4;
         this.likes = param5;
         this.updateBy();
      }
      
      public function addChat(param1:String, param2:String) : void
      {
         var _loc3_:UserlistItem = this.users[param1] as UserlistItem;
         if(_loc3_)
         {
            this.addLine(_loc3_.username,param2,_loc3_.chatColor,false,false);
         }
      }
      
      public function addLine(param1:String, param2:String, param3:Number, param4:Boolean = false, param5:Boolean = true) : ChatEntry
      {
         var _loc12_:String = null;
         var _loc13_:Number = NaN;
         param2 = Badwords.Filter(param2);
         var _loc6_:Boolean = param2.search(new RegExp("\\b" + this.myname + "\\b","i")) != -1 || param1.substr(-5).toLowerCase() == "> you";
         var _loc7_:Boolean = param1.substr(0,7).toLowerCase() == "* you >";
         var _loc8_:Boolean = this.chatbox.scrollHeight - this.chatbox.scrollY < 50;
         var _loc9_:ChatEntry = new ChatEntry(param1 == this.prevHeader ? "" : param1,param2,_loc7_ ? 1710618 : (_loc6_ ? 2236962 : 0),param3,param4);
         this.ccontainer.addChild(_loc9_);
         if(!param4 && param5)
         {
            this.prevHeader = param1;
         }
         else
         {
            this.prevHeader = "";
         }
         var _loc10_:Boolean = Global.base.settings.coloredNames;
         var _loc11_:TextFormat = new TextFormat(null,null,null,!_loc10_);
         for(_loc12_ in this.names)
         {
            if(_loc10_)
            {
               _loc11_.color = (this.names[_loc12_] as UserlistItem).darkChatColor;
            }
            _loc9_.highlightWords(new RegExp("\\b" + _loc12_ + "\\b","gi"),_loc11_);
         }
         if(this.ccontainer.numChildren > 80)
         {
            _loc13_ = this.chatbox.scrollHeight;
            this.ccontainer.removeChild(this.ccontainer.getChildAt(0));
            if(!_loc8_)
            {
               this.chatbox.refresh();
               this.chatbox.scrollY += this.chatbox.scrollHeight - _loc13_;
            }
         }
         this.chatbox.refresh();
         if(_loc8_)
         {
            this.chatbox.scrollY = 100000;
         }
         return _loc9_;
      }
      
      public function clearChat() : void
      {
         this.ccontainer.removeAllChildren();
         this.chatbox.scrollY = 0;
      }
      
      public function addUser(param1:String, param2:String, param3:Boolean, param4:Boolean = false, param5:Boolean = false, param6:int = 0, param7:uint = 0) : void
      {
         var _loc8_:UserlistItem = null;
         var _loc9_:ChatEntry = null;
         if(this.names[param2] == null)
         {
            _loc8_ = new UserlistItem(param2,param3,param4,param5,param7);
            this.names[param2] = _loc8_;
            this.ucontainer.addChild(_loc8_);
            this.userlist.refresh();
            _loc8_.setUserId(param1);
            _loc8_.setTeam(param6);
            if(!this.staffJoined && (Player.isAdmin(param2) || Player.isModerator(param2)))
            {
               this.staffJoined = true;
               if(Global.player_is_guest)
               {
                  _loc9_ = this.addSystemMessage("You can private message admins or moderators by using /pm command.");
                  _loc9_.highlightWords(/\badmins\b/gi,new TextFormat(null,null,Config.admin_color,true));
                  _loc9_.highlightWords(/\bmoderators\b/gi,new TextFormat(null,null,Config.moderator_color,true));
               }
            }
         }
         this.users[param1] = this.names[param2];
         this.names[param2].count += 1;
         this.redrawUserlist();
      }
      
      public function getUsers() : Object
      {
         var _loc2_:String = null;
         var _loc1_:Object = {};
         for(_loc2_ in this.names)
         {
            _loc1_[_loc2_.toUpperCase()] = true;
         }
         return _loc1_;
      }
      
      public function removeUser(param1:String) : void
      {
         if(this.users[param1])
         {
            if(--this.users[param1].count == 0)
            {
               delete this.names[this.users[param1].username];
               this.ucontainer.removeChild(this.users[param1]);
               this.userlist.refresh();
            }
            delete this.users[param1];
            this.redrawUserlist();
         }
      }
      
      private function toScoreFormat(param1:int) : String
      {
         var _loc2_:Array = param1.toString().split("");
         var _loc3_:int = 0;
         var _loc4_:* = int(_loc2_.length);
         while(_loc4_ >= 0)
         {
            if(_loc3_ > 0 && _loc4_ > 0 && _loc3_ % 3 == 0)
            {
               _loc2_.splice(_loc4_,0,["."]);
            }
            _loc3_++;
            _loc4_--;
         }
         return _loc2_.join("");
      }
      
      private function redrawUserlist() : void
      {
         var a:int;
         var x:String = null;
         var item:UserlistItem = null;
         var tusers:Array = [];
         this.friendsonline = true;
         for(x in this.users)
         {
            item = this.users[x];
            this.friendsonline = this.friendsonline && item.isfriend;
            tusers.push(item);
         }
         while(this.ucontainer.numChildren > 0)
         {
            this.ucontainer.removeChild(this.ucontainer.getChildAt(0));
         }
         tusers.sort(function(param1:UserlistItem, param2:UserlistItem):Number
         {
            if(!param1.isfriend && param2.isfriend)
            {
               return 1;
            }
            if(param1.isfriend && !param2.isfriend)
            {
               return -1;
            }
            if(param1.isguest && !param2.isguest)
            {
               return 1;
            }
            if(!param1.isguest && param2.isguest)
            {
               return -1;
            }
            if(param1.canchat && !param2.canchat)
            {
               return -1;
            }
            if(!param1.canchat && param2.canchat)
            {
               return 1;
            }
            return param1.time < param2.time ? 1 : -1;
         });
         a = 0;
         while(a < tusers.length)
         {
            this.ucontainer.addChild(tusers[a]);
            a++;
         }
         this.updateBy();
         this.userlist.scrollY = this.userlist.scrollY;
      }
      
      public function updateBy() : void
      {
         var infostring:String = "plays: " + this.toScoreFormat(this.plays);
         infostring += "\nfavorites: " + this.toScoreFormat(this.favorites);
         infostring += "\nlikes: " + this.toScoreFormat(this.likes);
         var labelButton:Sprite = new Sprite();
         var label2Button:Sprite = new Sprite();
         if(this.ownername)
         {
            if(Global.currentLevelCrew == "")
            {
               this.labelBy.text = "By " + this.ownername + "\n" + infostring;
               this.labelBy.setTextFormat(new TextFormat(null,null,Player.getNameColor(this.ownername)),3,3 + this.ownername.length);
               ColorUtil.colorizeUsername(this.labelBy,3,this.ownername.length);
            }
            else
            {
               this.labelBy.text = "By " + Global.currentLevelCrewName + "\nHosted by " + this.ownername + "\n" + infostring;
               this.labelBy.setTextFormat(new TextFormat(null,null,16777215),3,3 + Global.currentLevelCrewName.length);
               this.labelBy.setTextFormat(new TextFormat(null,null,Player.getNameColor(this.ownername)),14 + Global.currentLevelCrewName.length,14 + Global.currentLevelCrewName.length + this.ownername.length);
               ColorUtil.colorizeUsername(this.labelBy,3 + Global.currentLevelCrewName.length + 11,this.ownername.length);
            }
            labelButton.graphics.beginFill(16711935,0);
            labelButton.graphics.drawRect(0,0,this.labelBy.width,8);
            labelButton.x = this.labelBy.x;
            labelButton.y = this.labelBy.y;
            if(Global.currentLevelCrew != "")
            {
               label2Button.graphics.beginFill(16711935,0);
               label2Button.graphics.drawRect(0,0,this.labelBy.width,8);
               label2Button.x = this.labelBy.x;
               label2Button.y = this.labelBy.y + 9;
               addChild(label2Button);
            }
            labelButton.buttonMode = true;
            label2Button.buttonMode = true;
            addChild(labelButton);
         }
         else
         {
            this.labelBy.text = infostring;
         }
         this.userlist.y = this.labelBy.y + this.labelBy.height - 2;
         this.updateInfoBtn();
         labelButton.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            var _loc2_:NavigationEvent = null;
            if(Global.currentLevelCrew == "")
            {
               if(Bl.shiftKey)
               {
                  navigateToURL(new URLRequest(Config.site + "/profiles/" + ownername),"_blank");
               }
               else
               {
                  _loc2_ = new NavigationEvent(NavigationEvent.SHOW_PROFILE,true);
                  _loc2_.username = ownername;
                  dispatchEvent(_loc2_);
               }
            }
            else if(Bl.shiftKey)
            {
               navigateToURL(new URLRequest(Config.site + "/crews/" + Global.currentLevelCrew),"_blank");
            }
            else
            {
               _loc2_ = new NavigationEvent(NavigationEvent.SHOW_CREW_PROFILE,true);
               _loc2_.crewname = Global.currentLevelCrew;
               dispatchEvent(_loc2_);
            }
         });
         label2Button.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            var _loc2_:NavigationEvent = null;
            if(Bl.shiftKey)
            {
               navigateToURL(new URLRequest(Config.site + "/profiles/" + ownername),"_blank");
            }
            else
            {
               _loc2_ = new NavigationEvent(NavigationEvent.SHOW_PROFILE,true);
               _loc2_.username = ownername;
               dispatchEvent(_loc2_);
            }
         });
      }
      
      public function toggleVisible(param1:Boolean) : void
      {
         visible = param1;
      }
   }
}


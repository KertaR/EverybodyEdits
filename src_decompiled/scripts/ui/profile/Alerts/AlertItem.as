package ui.profile.Alerts
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import io.player.tools.Badwords;
   import playerio.DatabaseObject;
   import playerio.Message;
   import ui.WorldPreview;
   
   public class AlertItem extends assets_alertitem
   {
      
      public static var NOTIFICATION:String = "Notification";
      
      public static var INVITE:String = "Invite";
      
      private var icon:Bitmap;
      
      private var alertType:String;
      
      private var id:String;
      
      private var worldId:String;
      
      private var channel:String;
      
      private var closeCallback:Function;
      
      public function AlertItem(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String = "", param7:String = "", param8:String = "", param9:Function = null)
      {
         super();
         this.channel = param2;
         this.alertType = param5;
         this.worldId = param7;
         this.closeCallback = param9;
         this.id = param1;
         if(param6 != "")
         {
            tf_timestamp.text = param6;
         }
         else
         {
            tf_timestamp.visible = false;
         }
         crewName.tf_name.text = param3;
         crewName.mouseEnabled = true;
         crewName.buttonMode = true;
         crewName.useHandCursor = true;
         crewName.mouseChildren = false;
         crewName.addEventListener(MouseEvent.CLICK,this.handleNameClick);
         crewName.addEventListener(MouseEvent.MOUSE_OVER,this.handleNameOver);
         crewName.addEventListener(MouseEvent.MOUSE_OUT,this.handleNameOut);
         tf_message.text = Badwords.Filter(param4);
         tf_worldid.visible = false;
         if(param5 == NOTIFICATION)
         {
            if(param2 == "news" || param2 == "creweverybodyeditsstaff")
            {
               background.gotoAndStop(2);
            }
            else if(param2.substring(0,4) == "crew")
            {
               background.gotoAndStop(3);
            }
            else
            {
               background.gotoAndStop(1);
            }
         }
         else if(param5 == INVITE)
         {
            background.gotoAndStop(4);
         }
         else
         {
            background.gotoAndStop(1);
         }
         var _loc10_:Boolean = param5 == INVITE;
         gotoAndStop(_loc10_ ? 2 : 1);
         if(_loc10_ && currentFrame == 2)
         {
            btn_accept.addEventListener(MouseEvent.CLICK,this.handleCrewInviteButtons);
            btn_reject.addEventListener(MouseEvent.CLICK,this.handleCrewInviteButtons);
            btn_block.addEventListener(MouseEvent.CLICK,this.handleCrewInviteButtons);
         }
         nologo.visible = false;
         this.setImage(param2,param8);
         closebtn.addEventListener(MouseEvent.CLICK,this.handleCloseButton);
      }
      
      protected function handleNameClick(param1:MouseEvent) : void
      {
         if(this.channel.substring(0,4) == "crew")
         {
            Global.base.showCrewProfile(this.channel.substring(4),"ingame");
         }
      }
      
      protected function handleNameOver(param1:MouseEvent) : void
      {
         if(crewName.tf_name.textColor != 13421772)
         {
            crewName.tf_name.textColor = 13421772;
         }
      }
      
      protected function handleNameOut(param1:MouseEvent) : void
      {
         if(crewName.tf_name.textColor != 16777215)
         {
            crewName.tf_name.textColor = 16777215;
         }
      }
      
      protected function handleCrewInviteButtons(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case btn_accept:
               Global.base.requestCrewLobbyMethod("crew" + this.id,"answerInvite",this.handleResponse,null,true);
               this.handleCloseButton();
               break;
            case btn_reject:
               Global.base.requestCrewLobbyMethod("crew" + this.id,"answerInvite",this.handleResponse,null,false);
               this.handleCloseButton();
               break;
            case btn_block:
               Global.base.requestRemoteMethod("blockCrewInvites",null,this.id,true);
               this.handleCloseButton();
         }
      }
      
      private function handleResponse(param1:Message) : void
      {
         if(!param1.getBoolean(0))
         {
            Global.base.showInfo("Error",param1.getString(1));
         }
      }
      
      private function setImage(param1:String, param2:String) : void
      {
         var textContainer:Sprite = null;
         var channel:String = param1;
         var imageName:String = param2;
         switch(this.alertType)
         {
            case INVITE:
               if(this.worldId != "")
               {
                  this.setCrewLogo(this.worldId);
               }
               break;
            case NOTIFICATION:
               if(channel.substring(0,4) == "crew")
               {
                  if(imageName == "")
                  {
                     nologo.visible = true;
                  }
                  else
                  {
                     this.setCrewLogo(imageName);
                  }
               }
               else if(imageName != "")
               {
                  this.setIcon(imageName);
               }
               if(this.worldId != "")
               {
                  tf_worldid.text = "Click here to join: " + this.worldId;
                  tf_worldid.visible = true;
                  textContainer = new Sprite();
                  textContainer.buttonMode = true;
                  textContainer.useHandCursor = true;
                  textContainer.mouseChildren = false;
                  textContainer.addChild(tf_worldid);
                  addChild(textContainer);
                  textContainer.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
                  {
                     var _loc2_:String = tf_worldid.text.replace("Click here to join: ","");
                     var _loc3_:NavigationEvent = new NavigationEvent(NavigationEvent.JOIN_WORLD,true,false);
                     _loc3_.world_id = _loc2_;
                     dispatchEvent(_loc3_);
                  });
               }
               else
               {
                  tf_worldid.visible = false;
               }
         }
      }
      
      private function setIcon(param1:String) : void
      {
         var loaded:Function = null;
         var imageName:String = param1;
         loaded = function(param1:Event):void
         {
            var _loc2_:Bitmap = param1.target.content;
            _loc2_.width = _loc2_.height = 100;
            icon = _loc2_;
            icon.x = 6;
            icon.y = 6;
            addChild(icon);
            param1.target.removeEventListener(Event.COMPLETE,loaded);
         };
         var url:URLRequest = new URLRequest(Config.site + "/Images/" + imageName);
         var img:Loader = new Loader();
         img.load(url);
         img.contentLoaderInfo.addEventListener(Event.COMPLETE,loaded);
      }
      
      private function setCrewLogo(param1:String) : void
      {
         var logoId:String = param1;
         Global.base.client.bigDB.load("Worlds",logoId,function(param1:DatabaseObject):void
         {
            var _loc2_:WorldPreview = new WorldPreview(param1,false);
            icon = _loc2_.bitmap;
            icon.x = 6;
            icon.y = 6;
            addChild(icon);
         });
      }
      
      protected function handleCloseButton(param1:MouseEvent = null) : void
      {
         if(this.alertType == NOTIFICATION)
         {
            Global.base.requestRemoteMethod("dismissNotification",null,this.id);
         }
         this.closeCallback(this as AlertItem);
      }
   }
}


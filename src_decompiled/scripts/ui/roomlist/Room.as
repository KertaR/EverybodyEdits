package ui.roomlist
{
   import com.greensock.TweenMax;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import playerio.Connection;
   import playerio.Message;
   import ui.ConfirmPrompt;
   import ui.HoverLabel;
   
   public class Room extends asset_roominstance
   {
      
      private var _key:String;
      
      private var hoverLabel:HoverLabel;
      
      private var hoverTimer:uint;
      
      public function Room(param1:String, param2:String, param3:String, param4:String, param5:int, param6:int, param7:int, param8:int, param9:Boolean, param10:Boolean, param11:Boolean, param12:Boolean, param13:Boolean, param14:Boolean, param15:Boolean, param16:Object, param17:Function, param18:Function)
      {
         var canEnter:Boolean;
         var tf:TextFormat;
         var sv:Boolean;
         var be:Boolean;
         var key:String = param1;
         var title:String = param2;
         var description:String = param3;
         var size:String = param4;
         var online:int = param5;
         var plays:int = param6;
         var favorites:int = param7;
         var likes:int = param8;
         var inFavorites:Boolean = param9;
         var isCampaign:Boolean = param10;
         var myworld:Boolean = param11;
         var saved:Boolean = param12;
         var needskey:Boolean = param13;
         var lobbyPreviewEnabled:Boolean = param14;
         var isHistory:Boolean = param15;
         var me:Object = param16;
         var callback:Function = param17;
         var unfavoriteCallback:Function = param18;
         super();
         this._key = key;
         canEnter = true;
         this.hoverLabel = new HoverLabel();
         this.hoverLabel.visible = false;
         ltitle.embedFonts = true;
         ltitle.defaultTextFormat = new TextFormat(new system().fontName,11);
         ltitle.text = title;
         ltitle.antiAliasType = AntiAliasType.ADVANCED;
         lonline.antiAliasType = AntiAliasType.ADVANCED;
         lonline.embedFonts = true;
         lonline.defaultTextFormat = new TextFormat(new system().fontName,8,10066329);
         lonline.text = online + " Online - " + this.toScoreFormat(likes) + (likes == 1 ? " like" : " likes") + " - " + this.toScoreFormat(plays) + (plays == 1 ? " play" : " plays");
         tf = new TextFormat(new system().fontName,8,8607744);
         lonline.setTextFormat(tf,(online + " Online ").length,lonline.text.length);
         if(online < 1)
         {
            lonline.visible = false;
            btn_info.visible = false;
         }
         if(inFavorites)
         {
            favstar.mouseEnabled = true;
            favstar.buttonMode = true;
            favstar.useHandCursor = true;
            favstar.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               var confirm:ConfirmPrompt = null;
               var e:MouseEvent = param1;
               confirm = new ConfirmPrompt("Are you sure you want to unfavorite\n" + title + "?",false);
               confirm.btn_yes.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
               {
                  var e:MouseEvent = param1;
                  unfavoriteCallback(key);
                  Global.client.multiplayer.createJoinRoom(key,key.substring(0,2) == "BW" ? Config.server_type_betaroom : Config.server_type_normalroom,true,{},{"QuickAction":"unfavorite"},function(param1:Connection):void
                  {
                     var connection:Connection = param1;
                     connection.addMessageHandler("unfavorited",function(param1:Message):void
                     {
                     });
                  });
                  confirm.close();
               });
               Global.base.showOnTop(confirm);
            });
            favstar.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            favstar.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
            favstar.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         }
         else
         {
            favstar.visible = false;
            ltitle.x = 0;
         }
         sv = saved || key.substring(0,2) == "PW" || key.substring(0,2) == "BW";
         be = key.substring(0,2) == "BW";
         if(!myworld || be)
         {
            mine.visible = false;
         }
         if(!be)
         {
            beta.visible = false;
         }
         if(isCampaign)
         {
            if(be)
            {
               beta.visible = false;
            }
            if(myworld)
            {
               mine.visible = false;
            }
            campaignTag.visible = true;
            lonline.x = campaignTag.x + campaignTag.width + 3;
         }
         else
         {
            campaignTag.visible = false;
         }
         if(myworld && online < 1 || isHistory)
         {
            lonline.visible = true;
            lonline.text = size;
         }
         if(!sv)
         {
            btn_info.visible = false;
         }
         else
         {
            btn_info.addEventListener(MouseEvent.MOUSE_DOWN,function():void
            {
               Global.base.showWorldPreview(key,title,description);
            });
         }
         if(!be && !myworld && !isCampaign)
         {
            lonline.x -= 33;
         }
         if(online >= 80)
         {
            btn_play.visible = false;
         }
         else
         {
            full.visible = false;
         }
         btn_play.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            callback(key,title,me);
         });
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            this.hoverTimer = setTimeout(this.showHoverLabel,200);
         }
         else
         {
            this.hoverLabel.visible = false;
            clearInterval(this.hoverTimer);
         }
      }
      
      public function showHoverLabel() : void
      {
         addChild(this.hoverLabel);
         this.hoverLabel.alpha = 0;
         TweenMax.to(this.hoverLabel,0.25,{"alpha":1});
         this.hoverLabel.draw("Unfavorite");
         this.hoverLabel.visible = true;
         this.handleMouseMove();
      }
      
      private function handleMouseMove(param1:MouseEvent = null) : void
      {
         if(this.hoverLabel.visible)
         {
            this.hoverLabel.x = mouseX;
            if(this.hoverLabel.x > width / 2)
            {
               this.hoverLabel.x -= this.hoverLabel.w + 12;
            }
            else
            {
               this.hoverLabel.x += 12;
            }
            this.hoverLabel.y = mouseY - this.hoverLabel.height / 2;
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
   }
}


package ui
{
   import com.greensock.*;
   import com.greensock.easing.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   import playerio.Connection;
   
   public class LevelOptions extends assets_leveloptions
   {
      
      private var connection:Connection;
      
      private var confirmAction:String;
      
      private var currentPage:int = 1;
      
      public var backgroundColorSelector:BackgroundColorSelector;
      
      public function LevelOptions(param1:Connection, param2:String, param3:String, param4:Boolean, param5:Boolean, param6:Boolean, param7:String, param8:int, param9:int, param10:Boolean, param11:Boolean, param12:Boolean, param13:Boolean, param14:UI2)
      {
         var worldVisibility:WorldVisibilitySmall = null;
         var worldStatus:WorldStatusSmall = null;
         var con:Connection = param1;
         var levelname:String = param2;
         var editkey:String = param3;
         var levelVisible:Boolean = param4;
         var levelHideLobby:Boolean = param5;
         var allowSpectating:Boolean = param6;
         var description:String = param7;
         var curseLimit:int = param8;
         var zombieLimit:int = param9;
         var minimapEnabled:Boolean = param10;
         var lobbyPreviewEnabled:Boolean = param11;
         var hasCurse:Boolean = param12;
         var hasZombie:Boolean = param13;
         var ui2:UI2 = param14;
         super();
         this.connection = con;
         this.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.addButton(btn_actions,1);
         this.addButton(btn_info,2);
         this.addButton(btn_perms,3);
         this.addButton(btn_settings,4);
         Actions.Confirm.visible = false;
         Actions.Confirm.btn_no.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            Actions.Confirm.visible = false;
         });
         Actions.Confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,this.handleConfirmAction);
         Actions.btn_savelevel.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            showConfirmAction("Are you sure you want to save this world?","save");
         });
         Actions.btn_loadlevel.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            showConfirmAction("Are you sure you want to load this level?\nUnsaved changes will be lost forever!","loadlevel");
         });
         Actions.btn_resetlevel.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            showConfirmAction("Are you sure you want to reset all players?","resetall");
         });
         Actions.btn_clearlevel.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            showConfirmAction("Are you sure you want to clear this world?\nUnsaved changes will be lost forever!","clear");
         });
         Info.input_description.addEventListener(Event.CHANGE,this.descChar);
         Info.input_name.maxChars = 20;
         Info.input_editkey.maxChars = 20;
         Info.input_name.text = levelname;
         if(ui2.editKey == "")
         {
            Info.input_editkey.text = this.genEditKey(16);
         }
         Info.input_editkey.text = editkey;
         Info.input_description.text = description;
         Info.btn_randkey.addEventListener(MouseEvent.CLICK,function():void
         {
            Info.input_editkey.text = genEditKey(16);
         });
         this.descChar();
         this.setupCheckbox(Permissions.showlobby_checkbox,!levelHideLobby);
         this.setupCheckbox(Permissions.spectating_checkbox,allowSpectating);
         this.setupCheckbox(Settings.checkbox_minimap_ingame,minimapEnabled);
         this.setupCheckbox(Settings.checkbox_minimap_lobby,lobbyPreviewEnabled);
         if(!hasCurse)
         {
            Settings.curseLimitTf.selectable = false;
            Settings.curseLimitTf.type = TextFieldType.DYNAMIC;
            Settings.curseLimitTf.alpha = 0.5;
            Settings.curseText.textColor = 15461348;
            Settings.curseText.alpha = 0.5;
         }
         Settings.curseLimitTf.restrict = "0-9";
         Settings.curseLimitTf.text = curseLimit.toString();
         if(!hasZombie)
         {
            Settings.zombieLimitTf.selectable = false;
            Settings.zombieLimitTf.type = TextFieldType.DYNAMIC;
            Settings.zombieLimitTf.alpha = 0.5;
            Settings.zombieText.textColor = 15461348;
            Settings.zombieText.alpha = 0.5;
         }
         Settings.zombieLimitTf.restrict = "0-9";
         Settings.zombieLimitTf.text = zombieLimit.toString();
         status.alpha = 0;
         this.setActive(this.currentPage,true);
         if(Global.cookie.data.backgroundEnabled == null)
         {
            Global.cookie.data.backgroundEnabled = true;
         }
         if(Global.cookie.data.previousColors == null)
         {
            Global.cookie.data.previousColors = new Array();
         }
         this.backgroundColorSelector = new BackgroundColorSelector(con);
         this.backgroundColorSelector.y = 120;
         Settings.addChild(this.backgroundColorSelector);
         worldVisibility = new WorldVisibilitySmall(con);
         worldVisibility.y = 80;
         worldStatus = new WorldStatusSmall(con);
         worldStatus.y = worldVisibility.height + 12;
         if(Global.currentLevelCrew != "")
         {
            Permissions.addChild(worldStatus);
         }
         Permissions.addChild(worldVisibility);
         this.save_all.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            var _loc6_:int = 0;
            var _loc7_:int = 0;
            if(Info.input_name.text != levelname)
            {
               con.send("name",Info.input_name.text);
               levelname = Info.input_name.text;
            }
            if(Info.input_editkey.text != editkey)
            {
               con.send("key",Info.input_editkey.text);
               editkey = Info.input_editkey.text;
               ui2.editKey = editkey;
            }
            var _loc2_:Boolean = Permissions.showlobby_checkbox.currentFrame == 2;
            if(levelHideLobby != !_loc2_)
            {
               con.send("setHideLobby",!_loc2_);
               levelHideLobby = !_loc2_;
            }
            var _loc3_:Boolean = Permissions.spectating_checkbox.currentFrame == 2;
            if(allowSpectating != _loc3_)
            {
               con.send("setAllowSpectating",_loc3_);
               allowSpectating = _loc3_;
            }
            if(description != Info.input_description.text)
            {
               con.send("setRoomDescription",Info.input_description.text);
               description = Info.input_description.text;
            }
            if(hasCurse)
            {
               _loc6_ = parseInt(Settings.curseLimitTf.text);
               if(!isNaN(_loc6_) && _loc6_ >= 0 && _loc6_ <= 75)
               {
                  con.send("setCurseLimit",_loc6_);
               }
            }
            if(hasZombie)
            {
               _loc7_ = parseInt(Settings.zombieLimitTf.text);
               if(!isNaN(_loc7_) && _loc7_ >= 0 && _loc7_ <= 75)
               {
                  con.send("setZombieLimit",_loc7_);
               }
            }
            var _loc4_:Boolean = Settings.checkbox_minimap_ingame.currentFrame == 2;
            if(minimapEnabled != _loc4_)
            {
               con.send("setMinimapEnabled",_loc4_);
               minimapEnabled = _loc4_;
            }
            var _loc5_:Boolean = Settings.checkbox_minimap_lobby.currentFrame == 2;
            if(lobbyPreviewEnabled != _loc5_)
            {
               con.send("setLobbyPreviewEnabled",_loc5_);
               lobbyPreviewEnabled = _loc5_;
            }
            backgroundColorSelector.handleSave();
            if(Global.currentLevelCrew != "")
            {
               worldStatus.handleSave();
            }
            worldVisibility.handleSave();
            showInfo("Saved all settings!");
         });
         closebtn.addEventListener(MouseEvent.MOUSE_DOWN,this.close);
      }
      
      private function genEditKey(param1:int) : String
      {
         var _loc2_:String = "bcdfjnpqrstvwxzAEIOUYKLMGH_-";
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param1)
         {
            _loc3_ += _loc2_.charAt(int(Math.random() * _loc2_.length));
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function setupCheckbox(param1:MovieClip, param2:Boolean) : void
      {
         var checkbox:MovieClip = param1;
         var active:Boolean = param2;
         checkbox.gotoAndStop(active ? 2 : 1);
         checkbox.buttonMode = true;
         checkbox.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            checkbox.gotoAndStop(checkbox.currentFrame == 1 ? 2 : 1);
         });
      }
      
      private function showConfirmAction(param1:String, param2:String) : void
      {
         Actions.Confirm.visible = true;
         Actions.Confirm.confirmText.text = param1;
         this.confirmAction = param2;
      }
      
      private function handleConfirmAction(param1:MouseEvent) : void
      {
         switch(this.confirmAction)
         {
            case "save":
               this.connection.send("save");
               this.close();
               break;
            case "resetall":
            case "loadlevel":
               this.connection.send("say","/" + this.confirmAction);
               this.close();
               break;
            case "clear":
               this.connection.send("clear");
               this.close();
         }
         this.confirmAction = "none";
         Actions.Confirm.visible = false;
      }
      
      public function showInfo(param1:String) : void
      {
         var text:String = param1;
         status.text = text;
         TweenMax.to(status,0.4,{
            "alpha":1,
            "onComplete":function():void
            {
               TweenMax.to(status,1,{
                  "alpha":0,
                  "delay":3
               });
            }
         });
      }
      
      public function addButton(param1:MovieClip, param2:int) : void
      {
         var m:MovieClip = param1;
         var p:int = param2;
         m.buttonMode = true;
         m.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            setActive(p);
         });
         m.addEventListener(MouseEvent.ROLL_OVER,function(param1:MouseEvent):void
         {
            if(m.currentFrame != 3)
            {
               m.gotoAndStop(2);
            }
         });
         m.addEventListener(MouseEvent.ROLL_OUT,function(param1:MouseEvent):void
         {
            if(m.currentFrame != 3)
            {
               m.gotoAndStop(1);
            }
         });
      }
      
      public function descChar(param1:Event = null) : void
      {
         var _loc2_:int = 0;
         Info.description_chars.text = Info.input_description.text.length + " of 100";
         if(Info.input_description.text.length >= 100)
         {
            Info.description_chars.textColor = 16711680;
         }
         else if(Info.input_description.text.length >= 90)
         {
            Info.description_chars.textColor = 16750848;
         }
         else if(Info.input_description.text.length >= 80)
         {
            Info.description_chars.textColor = 16776960;
         }
         else
         {
            Info.description_chars.textColor = 65280;
         }
         if(Info.input_description.numLines > 3)
         {
            _loc2_ = Info.input_description.getLineOffset(3) - 1;
            _loc2_ = Info.input_description.text.substring(0,_loc2_ + 1).search(/\S\s*$/);
            Info.input_description.text = Info.input_description.text.substring(0,_loc2_ + 1);
         }
      }
      
      public function setActive(param1:int, param2:Boolean = false) : void
      {
         if(param1 == this.currentPage && !param2)
         {
            return;
         }
         this.currentPage = param1;
         btn_actions.gotoAndStop(param1 == 1 ? 3 : 1);
         btn_info.gotoAndStop(param1 == 2 ? 3 : 1);
         btn_perms.gotoAndStop(param1 == 3 ? 3 : 1);
         btn_settings.gotoAndStop(param1 == 4 ? 3 : 1);
         Actions.visible = param1 == 1;
         Info.visible = param1 == 2;
         Permissions.visible = param1 == 3;
         Settings.visible = param1 == 4;
         switch(param1)
         {
            case 1:
               TweenMax.from(Actions,0.3,{
                  "x":Actions.x - 30,
                  "alpha":0
               });
               break;
            case 2:
               TweenMax.from(Info,0.3,{
                  "x":Info.x - 30,
                  "alpha":0
               });
               break;
            case 3:
               TweenMax.from(Permissions,0.3,{
                  "x":Permissions.x - 30,
                  "alpha":0
               });
               break;
            case 4:
               TweenMax.from(Settings,0.3,{
                  "x":Settings.x - 30,
                  "alpha":0
               });
         }
      }
      
      public function close(param1:Event = null) : void
      {
         var e:Event = param1;
         var pm:LevelOptions = this;
         TweenMax.to(pm,0.4,{
            "alpha":0,
            "onComplete":function(param1:LevelOptions):void
            {
               if(stage)
               {
                  stage.focus = Global.base;
               }
               param1.parent.removeChild(param1);
            },
            "onCompleteParams":[pm]
         });
      }
   }
}


package ui.login
{
   import blitter.Bl;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import playerio.Client;
   import playerio.DatabaseObject;
   import playerio.PlayerIO;
   import playerio.PlayerIOError;
   
   public class LoginWindow extends assets_loginwindow
   {
      
      private var lock_overlay:Sprite;
      
      private var defaulttext:Object;
      
      private var displayAsPassword:Object;
      
      public function LoginWindow()
      {
         this.defaulttext = {};
         this.displayAsPassword = {};
         super();
         filters = [new DropShadowFilter(0,45,0,1,40,40,1,1)];
         close.addEventListener(MouseEvent.CLICK,this.handleClose,false,0,true);
         btn_login.addEventListener(MouseEvent.CLICK,this.handleLogin,false,0,true);
         btn_remember.gotoAndStop(2);
         btn_remember.mouseEnabled = true;
         btn_remember.buttonMode = true;
         btn_remember.mouseChildren = false;
         btn_remember.addEventListener(MouseEvent.CLICK,this.handleRemember,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.lock_overlay = new Sprite();
         this.lock_overlay.graphics.beginFill(0,0);
         this.lock_overlay.graphics.drawRect(0,0,this.width,height);
         this.lock_overlay.mouseEnabled = true;
         this.lock_overlay.visible = false;
         addChild(this.lock_overlay);
         this.defaulttext[inpemail.name] = inpemail.text;
         this.defaulttext[inppassword.name] = inppassword.text;
         this.displayAsPassword[inpemail.name] = false;
         this.displayAsPassword[inppassword.name] = true;
         inpemail.addEventListener(FocusEvent.FOCUS_IN,this.handleFocus,false,0,true);
         inpemail.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocus,false,0,true);
         inpemail.tabIndex = 1;
         inppassword.addEventListener(FocusEvent.FOCUS_IN,this.handleFocus,false,0,true);
         inppassword.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocus,false,0,true);
         inppassword.tabIndex = 2;
         inppassword.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown,false,0,true);
      }
      
      public function hasEmptyFields() : Boolean
      {
         if(inpemail.text == this.defaulttext[inpemail.name])
         {
            bg_mail.gotoAndStop(2);
         }
         if(inppassword.text == this.defaulttext[inppassword.name])
         {
            bg_password.gotoAndStop(2);
         }
         return bg_mail.currentFrame == 2 || bg_password.currentFrame == 2;
      }
      
      public function lock(param1:Boolean) : void
      {
         this.lock_overlay.visible = param1;
      }
      
      protected function handleFocus(param1:FocusEvent) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         if(param1.type == FocusEvent.FOCUS_IN)
         {
            if(_loc2_.text == this.defaulttext[_loc2_.name])
            {
               _loc2_.defaultTextFormat = new TextFormat(null,null,0);
               _loc2_.displayAsPassword = this.displayAsPassword[_loc2_.name];
               _loc2_.text = "";
            }
         }
         else if(_loc2_.text == "")
         {
            _loc2_.defaultTextFormat = new TextFormat(null,null,10066329);
            _loc2_.displayAsPassword = false;
            _loc2_.text = this.defaulttext[_loc2_.name];
         }
      }
      
      override public function get width() : Number
      {
         return bg.width;
      }
      
      protected function handleClose(param1:MouseEvent) : void
      {
         Global.base.showMainLogin();
      }
      
      protected function handleRemember(param1:MouseEvent) : void
      {
         btn_remember.gotoAndStop(btn_remember.currentFrame == 1 ? 2 : 1);
      }
      
      protected function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.handleLogin(param1);
         }
      }
      
      protected function handleLogin(param1:Event) : void
      {
         var event:Event = param1;
         btn_login.visible = false;
         errors.text = "";
         bg_mail.gotoAndStop(1);
         bg_password.gotoAndStop(1);
         if(this.hasEmptyFields())
         {
            errors.text = "Please fill out both email and password.";
            btn_login.visible = true;
            return;
         }
         if(inpemail.text == "guest")
         {
            Global.base.authenticateAsGuest();
            return;
         }
         if(inpemail.text.indexOf("@") == -1 && false)
         {
            this.getUserIDFromName(inpemail.text,function(param1:String):void
            {
               if(param1 != "")
               {
                  if(param1.indexOf("simple") == -1)
                  {
                     btn_login.visible = true;
                     errors.appendText("Simple users only.");
                     bg_mail.gotoAndStop(2);
                  }
                  tryToLogin(param1.substr(6),inppassword.text);
               }
               else
               {
                  btn_login.visible = true;
                  errors.appendText("Couldn\'t find the username.");
                  bg_mail.gotoAndStop(2);
               }
            });
         }
         else
         {
            this.tryToLogin(inpemail.text,inppassword.text);
         }
      }
      
      private function tryToLogin(param1:String, param2:String) : void
      {
         var email:String = param1;
         var pass:String = param2;
         PlayerIO.authenticate(Bl.stage,Config.playerio_game_id,"simpleusers",{
            "email":email,
            "password":pass
         },null,function(param1:Client):void
         {
            if(btn_remember.currentFrame == 2)
            {
               Global.cookie.data.username = email;
               Global.cookie.data.password = pass;
               Global.cookie.data.remember = true;
               if(!Global.noSave)
               {
                  Global.cookie.flush();
               }
            }
            else
            {
               Global.cleanCookie();
            }
            if(parent)
            {
               hide();
            }
            Global.base.disconnectRPC();
            Global.base.simpleConnect(param1);
         },function(param1:PlayerIOError):void
         {
            btn_login.visible = true;
            if(param1.message.toString().toLowerCase().indexOf("password") < 0)
            {
               errors.appendText("Email not registered.");
               bg_mail.gotoAndStop(2);
            }
            else if(param1.message.toString().toLowerCase().indexOf("password") > 0)
            {
               errors.appendText("Password incorrect");
               bg_password.gotoAndStop(2);
            }
         });
      }
      
      private function getUserIDFromName(param1:String, param2:Function) : void
      {
         var name:String = param1;
         var callback:Function = param2;
         PlayerIO.authenticate(Bl.stage,Config.playerio_game_id,"simpleusers",{
            "username":"guest",
            "password":"guest"
         },null,function(param1:Client):void
         {
            var c:Client = param1;
            c.bigDB.load("usernames",name.toLowerCase(),function(param1:DatabaseObject):void
            {
               if(param1 == null || param1["owner"] == null)
               {
                  callback("");
               }
               else
               {
                  callback(param1["owner"].toString());
               }
            },function(param1:PlayerIOError):void
            {
               callback("");
            });
         },function(param1:PlayerIOError):void
         {
            btn_login.visible = true;
         });
      }
      
      public function hide() : void
      {
         parent.removeChild(this);
      }
   }
}


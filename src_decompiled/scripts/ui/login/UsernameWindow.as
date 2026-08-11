package ui.login
{
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import io.player.tools.Badwords;
   import playerio.Connection;
   import playerio.Message;
   import states.LoadState;
   
   public class UsernameWindow extends assets_username
   {
      
      private var oncomplete:Function;
      
      private var defaulttext:Object;
      
      private var chosen_name:String;
      
      private var connection:Connection;
      
      private var toSend:String = "setUsername";
      
      public function UsernameWindow(param1:Function, param2:Boolean)
      {
         var oncomplete:Function = param1;
         var change:Boolean = param2;
         this.defaulttext = {};
         super();
         this.oncomplete = oncomplete;
         if(change)
         {
            this.toSend = "changeUsername";
            this.smileys.y -= 35;
            if(Global.base.state is LoadState)
            {
               this.txt_logout.text = "Welcome back. You can now change your username!";
            }
         }
         this.txt_logout.visible = change;
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.defaulttext[inpname.name] = inpname.text;
         inpname.addEventListener(FocusEvent.FOCUS_IN,this.handleFocus,false,0,true);
         inpname.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocus,false,0,true);
         inpname.addEventListener(KeyboardEvent.KEY_UP,this.handleUsername,false,0,true);
         inpname.maxChars = 20;
         inpname.restrict = "0-9A-Z";
         this.enableOkButton(false);
         btnOk.addEventListener(MouseEvent.CLICK,this.handleOk,false,0,true);
      }
      
      override public function get width() : Number
      {
         return bg.width;
      }
      
      protected function handleOk(param1:MouseEvent) : void
      {
         Global.base.requestRemoteMethod(this.toSend,this.onNameSet,this.chosen_name);
         this.enableOkButton(false);
      }
      
      private function onNameSet(param1:Message) : void
      {
         Global.base.clearOverlayContainer();
         this.oncomplete();
      }
      
      protected function handleFocus(param1:FocusEvent) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         if(param1.type == FocusEvent.FOCUS_IN)
         {
            if(_loc2_.text == this.defaulttext[_loc2_.name])
            {
               _loc2_.defaultTextFormat = new TextFormat(null,null,0);
               _loc2_.text = "";
            }
         }
         else if(_loc2_.text == "")
         {
            _loc2_.defaultTextFormat = new TextFormat(null,null,10066329);
            _loc2_.text = this.defaulttext[_loc2_.name];
         }
      }
      
      protected function handleUsername(param1:KeyboardEvent = null) : void
      {
         var username:String;
         var pattern:RegExp;
         var event:KeyboardEvent = param1;
         if(this.connection == null)
         {
            Global.base.getRPCConnection(function(param1:Connection):void
            {
               connection = param1;
               param1.addMessageHandler("checkUsername",handleUsernameCheck);
               enableOkButton(false);
               handleUsername();
            });
            return;
         }
         username = inpname.text;
         errors.text = "";
         bg_name.gotoAndStop(1);
         pattern = /[^0-9A-Z]/;
         if(pattern.test(username))
         {
            bg_name.gotoAndStop(2);
            errors.text = "Your username contains invalid charaters. Valid charaters are 0-9 and A-Z.";
            this.chosen_name = null;
            this.enableOkButton(false);
            return;
         }
         if(username.length < 3 || username.length > 20)
         {
            bg_name.gotoAndStop(2);
            errors.text = "Your username must be between 3 and 20 characters long.";
            this.chosen_name = null;
            this.enableOkButton(false);
            return;
         }
         if(username != Badwords.Filter(username,true))
         {
            bg_name.gotoAndStop(2);
            errors.text = "Your username contains inappropriate words.";
            this.chosen_name = null;
            this.enableOkButton(false);
            return;
         }
         this.enableOkButton(true);
         this.connection.send("checkUsername",username);
      }
      
      private function handleUsernameCheck(param1:Message, param2:String, param3:Boolean) : void
      {
         if(inpname.text == param2)
         {
            if(param3)
            {
               this.chosen_name = param2;
               this.enableOkButton(true);
            }
            else
            {
               this.chosen_name = null;
               bg_name.gotoAndStop(2);
               errors.text = "Username not available!";
               this.enableOkButton(false);
            }
         }
      }
      
      private function enableOkButton(param1:Boolean) : void
      {
         btnOk.gotoAndStop(param1 ? 1 : 2);
         btnOk.mouseEnabled = param1;
         btnOk.mouseChildren = false;
         btnOk.buttonMode = param1;
      }
   }
}


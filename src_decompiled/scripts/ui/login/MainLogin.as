package ui.login
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import playerio.Client;
   import playerio.DatabaseObject;
   import playerio.PlayerIO;
   
   public class MainLogin extends assets_loginsimple
   {
      
      private var loginwindow:LoginWindow;
      
      public function MainLogin()
      {
         super();
         stop();
         filters = [new DropShadowFilter(0,45,0,1,12,12,1,1)];
         news.title.text = "Everybody Edits Private Server";
         news.subtitle.text = "Offline Mode";
         news.body.text = "Welcome to your local Everybody Edits server!\n\nClick Login, Register, or Play as Guest below to start!";
         if(news.loader != null)
         {
            news.loader.visible = false;
         }
         if(Global.playing_on_kongregate)
         {
            gotoAndStop(2);
            btn_kongregate.addEventListener(MouseEvent.CLICK,function():void
            {
               Global.base.showKongregateLoginWindow();
            });
         }
         else
         {
            btn_login.addEventListener(MouseEvent.CLICK,this.handleLoginButton,false,0,true);
            btn_register.addEventListener(MouseEvent.CLICK,function():void
            {
               Global.base.showRegister();
            });
            btn_recoverpass.addEventListener(MouseEvent.CLICK,function():void
            {
               Global.base.showRecoverPassword();
            });
            btn_guestlogin.addEventListener(MouseEvent.CLICK,function():void
            {
               Global.base.authenticateAsGuest();
            });
         }
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
      }
      
      protected function handleRemovedFromStage(param1:Event) : void
      {
         this.stopAll();
      }
      
      protected function handleLoginButton(param1:MouseEvent) : void
      {
         Global.base.showLoginWindow();
      }
      
      protected function handleAdded(param1:Event) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      override public function get width() : Number
      {
         return bg.width;
      }
      
      public function stopAll() : void
      {
      }
   }
}


package ui.login
{
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import playerio.PlayerIO;
   import playerio.PlayerIOError;
   import states.*;
   
   public class ResetPassword extends assets_resetpassword
   {
      
      private var defaulttext:Object;
      
      public function ResetPassword()
      {
         this.defaulttext = {};
         super();
         gotoAndStop(1);
         filters = [new DropShadowFilter(0,45,0,1,40,40,1,1)];
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.defaulttext[inpemail.name] = inpemail.text;
         inpemail.addEventListener(FocusEvent.FOCUS_IN,this.handleFocus,false,0,true);
         inpemail.addEventListener(FocusEvent.FOCUS_OUT,this.handleFocus,false,0,true);
         close.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            if(Global.base.state is LoadState)
            {
               Global.base.showMainLogin();
            }
         });
         btn_send.addEventListener(MouseEvent.CLICK,function():void
         {
            errors.text = "";
            if(inpemail.text == defaulttext[inpemail.name] || inpemail.text.search("@") < 0)
            {
               errors.text = "Please fill in an email address";
               return;
            }
            PlayerIO.quickConnect.simpleRecoverPassword(Config.playerio_game_id,inpemail.text,function():void
            {
               gotoAndStop(2);
            },function(param1:PlayerIOError):void
            {
               errors.text = param1.message;
            });
         });
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
      
      override public function get width() : Number
      {
         return bg.width;
      }
   }
}


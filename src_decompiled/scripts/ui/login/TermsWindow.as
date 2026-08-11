package ui.login
{
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import playerio.Message;
   
   public class TermsWindow extends assets_termswindow
   {
      
      private var oncomplete:Function;
      
      public function TermsWindow(param1:Function)
      {
         var tf:TextField;
         var oncomplete:Function = param1;
         super();
         this.oncomplete = oncomplete;
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.enableOkButton(false);
         btnOk.addEventListener(MouseEvent.CLICK,this.handleOk,false,0,true);
         termsbutton.gotoAndStop(1);
         termsbutton.addEventListener(MouseEvent.CLICK,this.handleTermsToggle);
         tf = termslink.tf;
         tf.htmlText = "I have read and accept the <a href=\'event:terms\'><u>Terms & Conditions</u></a>";
         tf.addEventListener(TextEvent.LINK,this.handleTextLink);
      }
      
      protected function handleTextLink(param1:TextEvent) : void
      {
         dispatchEvent(new NavigationEvent(NavigationEvent.SHOW_TERMS,true,false));
      }
      
      override public function get width() : Number
      {
         return bg.width;
      }
      
      protected function handleTermsToggle(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = termsbutton.currentFrame == 2;
         termsbutton.gotoAndStop(_loc2_ ? 1 : 2);
         this.enableOkButton(!_loc2_);
      }
      
      protected function handleOk(param1:MouseEvent) : void
      {
         Global.base.requestRemoteMethod("acceptTerms",this.onTermsAccepted);
         this.enableOkButton(false);
      }
      
      private function enableOkButton(param1:Boolean) : void
      {
         btnOk.gotoAndStop(param1 ? 1 : 2);
         btnOk.mouseEnabled = param1;
         btnOk.mouseChildren = false;
         btnOk.buttonMode = param1;
      }
      
      private function onTermsAccepted(param1:Message) : void
      {
         Global.base.clearOverlayContainer();
         this.oncomplete();
      }
   }
}


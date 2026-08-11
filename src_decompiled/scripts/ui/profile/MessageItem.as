package ui.profile
{
   import flash.events.MouseEvent;
   import io.player.tools.Badwords;
   
   public class MessageItem extends assets_message
   {
      
      private var inbox:MyInbox;
      
      private var key:String;
      
      private var sender:String;
      
      private var subject:String;
      
      private var message:String;
      
      private var closeCallback:Function;
      
      public function MessageItem(param1:MyInbox, param2:String, param3:String, param4:String, param5:String, param6:Function = null)
      {
         super();
         this.inbox = param1;
         this.key = param2;
         this.sender = param3;
         this.subject = param4;
         this.message = param5;
         this.closeCallback = param6;
         messageHeader.buttonMode = true;
         messageHeader.mouseChildren = false;
         messageHeader.gotoAndStop(1);
         messageHeader.msg_sender.text = param3.toUpperCase();
         messageHeader.msg_subject.text = Badwords.Filter(param4);
         gotoAndStop(1);
         messageHeader.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
         messageHeader.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         messageHeader.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         if(currentFrame != 2)
         {
            gotoAndStop(2);
            messageContainer.buttonMode = false;
            messageContainer.mouseChildren = false;
            messageContainer.mouseEnabled = false;
            msg_text.text = Badwords.Filter(this.message);
            btn_reply.addEventListener(MouseEvent.CLICK,this.handleReplyMessage);
            btn_delete.addEventListener(MouseEvent.CLICK,this.handleDeleteMessage);
         }
         else
         {
            gotoAndStop(1);
         }
      }
      
      protected function handleReplyMessage(param1:MouseEvent) : void
      {
         this.inbox.sendReply(this.sender,"RE: " + this.subject);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         if(messageHeader.currentFrame != 2)
         {
            messageHeader.gotoAndStop(2);
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         if(messageHeader.currentFrame != 1)
         {
            messageHeader.gotoAndStop(1);
         }
      }
      
      private function handleDeleteMessage(param1:MouseEvent) : void
      {
         Global.base.requestRemoteMethod("deleteMail",null,this.key);
         this.closeCallback(this);
      }
   }
}


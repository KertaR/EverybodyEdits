package ui.profile
{
   import flash.events.MouseEvent;
   import playerio.Message;
   
   public class NewAlert extends assets_newalert
   {
      
      public function NewAlert()
      {
         super();
         tf_message.text = "";
         tf_error.visible = false;
         tf_message.maxChars = 140;
         btn_send.addEventListener(MouseEvent.CLICK,this.handleSendMessage);
      }
      
      protected function handleSendMessage(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(tf_message.text == "")
         {
            return;
         }
         Global.base.requestCrewLobbyMethod(Global.currentCrew,"sendAlert",function(param1:Message):void
         {
            if(param1.length > 0)
            {
               tf_error.text = param1.getString(0);
               tf_error.visible = true;
            }
            else
            {
               tf_message.text = "";
            }
         },null,tf_message.text);
      }
   }
}


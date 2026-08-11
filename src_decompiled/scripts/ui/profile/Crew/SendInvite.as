package ui.profile.Crew
{
   import flash.events.MouseEvent;
   import playerio.Message;
   
   public class SendInvite extends assets_sendcrewinvite
   {
      
      private var crewId:String;
      
      private var sendCallback:Function;
      
      public function SendInvite(param1:String, param2:Function)
      {
         super();
         this.crewId = param1;
         this.sendCallback = param2;
         tf_username.restrict = "A-Za-z0-9";
         tf_username.text = "";
         btn_invite.addEventListener(MouseEvent.CLICK,this.handleSendInvite);
         tf_error.visible = false;
      }
      
      private function handleSendInvite(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(tf_username.text.length > 0)
         {
            Global.base.showLoadingScreen("Sending invite");
            Global.base.requestCrewLobbyMethod("crew" + this.crewId,"inviteMember",function(param1:Message):void
            {
               if(!param1.getBoolean(0))
               {
                  tf_error.visible = true;
                  tf_error.text = param1.getString(1);
               }
               else
               {
                  tf_error.visible = false;
                  sendCallback(tf_username.text.toLowerCase());
                  tf_username.text = "";
               }
               Global.base.hideLoadingScreen();
            },null,tf_username.text);
         }
         else
         {
            tf_error.visible = true;
            tf_error.text = "No username found.";
         }
      }
   }
}


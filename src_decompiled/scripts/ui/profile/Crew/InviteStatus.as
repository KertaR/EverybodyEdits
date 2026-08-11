package ui.profile.Crew
{
   import flash.events.MouseEvent;
   import playerio.Message;
   
   public class InviteStatus extends assets_invitestatus
   {
      
      private var crewId:String;
      
      private var _username:String;
      
      private var deleteCallback:Function;
      
      private var type:int;
      
      public function InviteStatus(param1:String, param2:String, param3:int, param4:Function)
      {
         super();
         this.crewId = param1;
         this._username = param2;
         this.type = param3;
         this.deleteCallback = param4;
         tf_title.text = this.getStatusText(param2);
         btn_status.buttonMode = true;
         btn_status.useHandCursor = true;
         btn_status.mouseChildren = false;
         btn_status.gotoAndStop(param3 == 0 ? 1 : 2);
         btn_status.addEventListener(MouseEvent.CLICK,this.handleButton);
      }
      
      private function handleButton(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         Global.base.requestCrewLobbyMethod("crew" + this.crewId,"deleteInvite",function(param1:Message):void
         {
            if(param1.getBoolean(0))
            {
               deleteCallback(username);
            }
         },null,this.username);
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      private function getStatusText(param1:String) : String
      {
         param1 = param1.toUpperCase();
         switch(this.type)
         {
            case -1:
               return "An unknown error occured";
            case 0:
               return "Awaiting response from " + param1;
            case 1:
               return param1 + " has accepted the invite.";
            case 2:
               return param1 + " has rejected the invite.";
            default:
               return "";
         }
      }
   }
}


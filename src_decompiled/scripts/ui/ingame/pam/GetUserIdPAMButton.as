package ui.ingame.pam
{
   import flash.events.MouseEvent;
   import flash.system.System;
   
   public class GetUserIdPAMButton extends PAMButton
   {
      
      public function GetUserIdPAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override protected function get text() : String
      {
         return "Get UserId";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         var _loc2_:String = targetPlayer.isme ? Global.ownerID : targetPlayer.connectedUserId;
         Global.base.showInfo2(targetPlayer.name + "\'s UserId","Copied \"" + _loc2_ + "\" to your clipboard!");
         System.setClipboard(_loc2_);
      }
   }
}


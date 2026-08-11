package ui.ingame.pam
{
   import flash.events.MouseEvent;
   
   public class MutePAMButton extends PAMButton
   {
      
      public function MutePAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override public function get active() : Boolean
      {
         return !targetPlayer.isme && !Player.isStaffMember(targetPlayer.name);
      }
      
      override protected function get text() : String
      {
         return targetPlayer.muted ? "Unmute" : "Mute";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         var _loc2_:String = targetPlayer.muted ? "unmute" : "mute";
         executeCommand(_loc2_,targetPlayer.name);
      }
   }
}


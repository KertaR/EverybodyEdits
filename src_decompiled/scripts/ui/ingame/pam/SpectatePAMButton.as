package ui.ingame.pam
{
   import flash.events.MouseEvent;
   
   public class SpectatePAMButton extends PAMButton
   {
      
      public function SpectatePAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override public function get active() : Boolean
      {
         return Global.base.ui2instance.allowSpectating && !targetPlayer.isme;
      }
      
      override protected function get text() : String
      {
         return playState.target == targetPlayer ? "Stop spectating" : "Spectate";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         if(targetPlayer.isme || playState.target == targetPlayer)
         {
            playState.stopSpectating();
         }
         else
         {
            playState.spectate(targetPlayer);
         }
      }
   }
}


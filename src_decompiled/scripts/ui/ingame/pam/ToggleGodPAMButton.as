package ui.ingame.pam
{
   import blitter.Bl;
   import flash.events.MouseEvent;
   
   public class ToggleGodPAMButton extends PAMButton
   {
      
      public function ToggleGodPAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override public function get active() : Boolean
      {
         if(Bl.data.isCampaignRoom)
         {
            return false;
         }
         if(targetPlayer.canEdit)
         {
            return false;
         }
         if(hasSpecialPowers && targetPlayer.name != Global.worldOwner)
         {
            return true;
         }
         return Boolean(Bl.data.owner) && !targetPlayer.isme;
      }
      
      override protected function get text() : String
      {
         return (targetPlayer.canToggleGodMode ? "Remove" : "Give") + " god mode";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         var _loc2_:String = targetPlayer.canToggleGodMode ? "removegod" : "givegod";
         executeCommand(_loc2_,targetPlayer.name);
      }
   }
}


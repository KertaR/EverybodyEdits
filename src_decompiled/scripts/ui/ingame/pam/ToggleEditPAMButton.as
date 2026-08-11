package ui.ingame.pam
{
   import blitter.Bl;
   import flash.events.MouseEvent;
   
   public class ToggleEditPAMButton extends PAMButton
   {
      
      public function ToggleEditPAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override public function get active() : Boolean
      {
         if(Bl.data.isCampaignRoom)
         {
            return false;
         }
         if(hasSpecialPowers && targetPlayer.name != Global.worldOwner)
         {
            return true;
         }
         return !targetPlayer.isme && Boolean(Bl.data.owner);
      }
      
      override protected function get text() : String
      {
         return (targetPlayer.canEdit ? "Remove" : "Give") + " edit";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         var _loc2_:String = targetPlayer.canEdit ? "removeedit" : "giveedit";
         executeCommand(_loc2_,targetPlayer.name);
      }
   }
}


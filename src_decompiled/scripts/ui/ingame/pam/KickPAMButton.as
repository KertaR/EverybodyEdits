package ui.ingame.pam
{
   import blitter.Bl;
   import flash.events.MouseEvent;
   import ui.Prompt;
   
   public class KickPAMButton extends PAMButton
   {
      
      public function KickPAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override public function get active() : Boolean
      {
         if(targetPlayer.isme)
         {
            return false;
         }
         if(hasSpecialPowers)
         {
            return true;
         }
         if(!Bl.data.owner || Boolean(Bl.data.isCampaignRoom))
         {
            return false;
         }
         return !Player.isStaffMember(targetPlayer.name);
      }
      
      override protected function get text() : String
      {
         return "Kick";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var prompt:Prompt = new Prompt("Reason for kicking " + targetPlayer.name.toUpperCase() + ":","",function(param1:String):void
         {
            executeCommand("kick",targetPlayer.name,param1);
         });
         prompt.savebtn.gotoAndStop(2);
         Global.base.showOnTop(prompt);
      }
   }
}


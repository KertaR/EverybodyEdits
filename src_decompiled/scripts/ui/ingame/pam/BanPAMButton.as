package ui.ingame.pam
{
   import flash.events.MouseEvent;
   import ui.Prompt;
   
   public class BanPAMButton extends PAMButton
   {
      
      public function BanPAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override public function get active() : Boolean
      {
         if(targetPlayer.isme || targetIsGuest)
         {
            return false;
         }
         return hasSpecialPowers;
      }
      
      override protected function get text() : String
      {
         return "Ban";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var daysPrompt:Prompt = new Prompt("Number of days:","1",function(param1:String):void
         {
            var days:String = param1;
            var reasonPrompt:* = new Prompt("Reason:","",function(param1:String):void
            {
               executeCommand("tempban",targetPlayer.name,days,param1);
            });
            reasonPrompt.savebtn.gotoAndStop(2);
            Global.base.showOnTop(reasonPrompt);
         });
         daysPrompt.savebtn.gotoAndStop(2);
         Global.base.showOnTop(daysPrompt);
      }
   }
}


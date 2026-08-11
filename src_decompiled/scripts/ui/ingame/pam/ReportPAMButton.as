package ui.ingame.pam
{
   import flash.events.MouseEvent;
   import ui.Prompts.ConfirmRulesPrompt;
   import ui.ReportPrompt;
   
   public class ReportPAMButton extends PAMButton
   {
      
      public function ReportPAMButton(param1:int, param2:PlayerActionsMenu)
      {
         super(param1,param2);
      }
      
      override public function get active() : Boolean
      {
         return !targetPlayer.isme && !targetIsGuest && !Player.isStaffMember(targetPlayer.name);
      }
      
      override protected function get text() : String
      {
         return "Report";
      }
      
      override protected function action(param1:MouseEvent) : void
      {
         var reportPrompt:ReportPrompt = null;
         var e:MouseEvent = param1;
         reportPrompt = new ReportPrompt(targetPlayer.name);
         reportPrompt.confirmButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var confirmRules:ConfirmRulesPrompt = null;
            var e:MouseEvent = param1;
            confirmRules = new ConfirmRulesPrompt();
            confirmRules.continueButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
            {
               executeCommand("report",targetPlayer.name,reportPrompt.reportText);
               confirmRules.close();
               reportPrompt.close();
            });
            Global.base.overlayContainer.addChild(confirmRules);
         });
         Global.base.overlayContainer.addChild(reportPrompt);
      }
   }
}


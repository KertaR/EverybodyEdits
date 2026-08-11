package ui.Prompts
{
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import sample.ui.components.Label;
   import ui.button.Button;
   import ui.button.ButtonColorType;
   
   public class ConfirmRulesPrompt extends BasePrompt
   {
      
      private var info:Label;
      
      public var continueButton:Button;
      
      private var closeButton:Button;
      
      public function ConfirmRulesPrompt()
      {
         var _loc1_:Number = NaN;
         super("Warning",600,250);
         this.info = new Label("Frivoulous and rule-breaking abuse reports will be viewed as spam. \n\nThis includes: \n\t- Reports for trolling, trolling is not against the rules. \n\t- Reports trying to PM other users. \n\t- Reports for not receiving edit. \n\t- Any report that does not actually report behaviour which is against the rules. This will result \t  in a warning or ban.",13,"left",16777215,true,"Arial");
         this.info.antiAliasType = AntiAliasType.ADVANCED;
         this.info.sharpness = 0;
         this.info.width = width - 40;
         this.info.x = (width - this.info.width) / 2;
         this.info.y = title.y + title.height + 10;
         addChild(this.info);
         this.continueButton = new Button("Report");
         this.closeButton = new Button("Close",ButtonColorType.RED);
         this.closeButton.addEventListener(MouseEvent.CLICK,close);
         _loc1_ = this.continueButton.width + this.closeButton.width + 35;
         this.continueButton.x = (width - _loc1_) / 2;
         this.continueButton.y = height - this.continueButton.height - 20;
         this.closeButton.x = this.continueButton.x + (_loc1_ - this.closeButton.width);
         this.closeButton.y = this.continueButton.y;
         addChild(this.continueButton);
         addChild(this.closeButton);
      }
   }
}


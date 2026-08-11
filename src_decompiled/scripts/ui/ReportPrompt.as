package ui
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import sample.ui.components.Label;
   import ui.button.Button;
   
   public class ReportPrompt extends Sprite
   {
      
      private var title:Label;
      
      private var reasonLabel:Label;
      
      private var charsLeft:Label;
      
      public var reasonBox:TextField;
      
      private var reasonBoxSprite:Sprite;
      
      private var prompt:Sprite;
      
      private const WIDTH:Number = 520;
      
      private const HEIGHT:Number = 290;
      
      private const maxChars:Number = 140;
      
      private var selectedOptions:String = "Spamming";
      
      private var username:String;
      
      private var optionsList:DropDownList;
      
      private var closeButton:ProfileCloseButton;
      
      public var confirmButton:Button;
      
      private var dropShadow:DropShadowFilter;
      
      private var reportId:int = 0;
      
      private var items:Array = null;
      
      private var prevText:String;
      
      public function ReportPrompt(param1:String, param2:String = "")
      {
         var ddWidth:Number;
         var blackBG:BlackBG;
         var username:String = param1;
         var reason:String = param2;
         super();
         this.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.username = username;
         this.dropShadow = new DropShadowFilter(4,75,0,1,5,5,0.5,1,true);
         this.prompt = new Sprite();
         addChild(this.prompt);
         this.confirmButton = new Button("Confirm");
         addChild(this.confirmButton);
         this.closeButton = new ProfileCloseButton();
         this.closeButton.x = x + (this.WIDTH - this.closeButton.width / 2);
         this.closeButton.y = y - this.closeButton.height / 2;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.close);
         addChild(this.closeButton);
         this.title = new Label("Reporting " + username.toUpperCase(),15,"left",16777215,false,"system");
         this.title.x = (this.WIDTH - this.title.textWidth) / 2;
         this.title.y = 10;
         addChild(this.title);
         this.reasonLabel = new Label("Details:",12,"left",16777215,true,"system");
         addChild(this.reasonLabel);
         this.reasonBoxSprite = new Sprite();
         this.reasonBoxSprite.filters = [this.dropShadow];
         addChild(this.reasonBoxSprite);
         this.reasonBox = new TextField();
         this.reasonBox.defaultTextFormat = new TextFormat("Arial",14,0);
         this.reasonBox.multiline = true;
         this.reasonBox.wordWrap = true;
         this.reasonBox.selectable = true;
         this.reasonBox.type = TextFieldType.INPUT;
         this.reasonBox.maxChars = this.maxChars;
         this.reasonBox.addEventListener(Event.CHANGE,this.handleReasonChange);
         this.reasonBox.text = reason;
         addChild(this.reasonBox);
         this.charsLeft = new Label("0 of " + this.maxChars + " characters.",10,"left",16777215,false,"system");
         this.charsLeft.textColor = 65280;
         addChild(this.charsLeft);
         ddWidth = 440;
         this.items = [new DropDownListItem("Harassment: Offensive Language / Content",ddWidth,this.setReportId),new DropDownListItem("Harassment: Verbal Abuse",ddWidth,this.setReportId),new DropDownListItem("Inappropriate Username",ddWidth,this.setReportId),new DropDownListItem("Violence or Drugs",ddWidth,this.setReportId),new DropDownListItem("Spamming Chat",ddWidth,this.setReportId),new DropDownListItem("Other",ddWidth,this.setReportId)];
         this.optionsList = new DropDownList(ddWidth,this.items);
         this.optionsList.x = (this.WIDTH - ddWidth) / 2;
         this.optionsList.y = 50;
         addChild(this.optionsList);
         if(reason != "")
         {
            this.selectReportId(this.items.length - 1);
         }
         this.redraw();
         blackBG = new BlackBG();
         blackBG.x = -x;
         blackBG.y = -y;
         addChildAt(blackBG,0);
      }
      
      public function get reportText() : String
      {
         var _loc1_:String = (this.items[this.reportId] as DropDownListItem).text;
         if(this.reasonBox.text != "")
         {
            _loc1_ += " - " + this.reasonBox.text;
         }
         return _loc1_;
      }
      
      protected function setReportId(param1:MouseEvent) : void
      {
         var _loc2_:DropDownListItem = param1.target as DropDownListItem;
         var _loc3_:int = this.items.indexOf(_loc2_) == -1 ? 0 : this.items.indexOf(_loc2_);
         this.selectReportId(_loc3_);
      }
      
      private function selectReportId(param1:int) : void
      {
         this.reportId = param1;
         this.confirmButton.setActive(this.reportId != this.items.length - 1 || this.reasonBox.text != "");
         this.charsLeft.text = "0 of " + this.maxChars + " characters.";
         this.charsLeft.textColor = 65280;
         this.optionsList.inputBox.text = (this.items[this.reportId] as DropDownListItem).text;
         this.optionsList.showDropDownList(false);
      }
      
      private function redraw() : void
      {
         this.prompt.graphics.clear();
         this.prompt.graphics.lineStyle(1,13421772);
         this.prompt.graphics.beginFill(2105376);
         this.prompt.graphics.drawRoundRect(0,0,this.WIDTH,this.HEIGHT,5,5);
         this.prompt.graphics.endFill();
         this.reasonLabel.x = this.optionsList.x;
         this.reasonLabel.y = this.optionsList.y + this.optionsList.oh + 15;
         this.reasonBoxSprite.graphics.clear();
         this.reasonBoxSprite.graphics.beginFill(16777215);
         this.reasonBoxSprite.graphics.drawRoundRect(0,0,440,90,5,5);
         this.reasonBoxSprite.graphics.endFill();
         this.reasonBoxSprite.x = (this.WIDTH - this.reasonBoxSprite.width) / 2;
         this.reasonBoxSprite.y = this.reasonLabel.y + this.reasonLabel.height + 5;
         this.reasonBox.x = this.reasonBoxSprite.x + 3;
         this.reasonBox.y = this.reasonBoxSprite.y + 3;
         this.reasonBox.width = this.reasonBoxSprite.width - 3;
         this.reasonBox.height = this.reasonBoxSprite.height - 3;
         this.charsLeft.x = this.reasonLabel.x;
         this.charsLeft.y = this.reasonBox.y + this.reasonBox.height + 5;
         this.confirmButton.x = (this.WIDTH - this.confirmButton.width) / 2;
         this.confirmButton.y = (this.charsLeft.y + this.charsLeft.height + (this.HEIGHT - this.confirmButton.height)) / 2;
         x = (Config.maxwidth - this.WIDTH) / 2;
         y = (500 - this.HEIGHT) / 2;
      }
      
      protected function handleReasonChange(param1:Event) : void
      {
         if(this.reasonBox.textHeight >= this.reasonBox.height)
         {
            this.reasonBox.text = this.prevText;
         }
         else
         {
            this.prevText = this.reasonBox.text;
         }
         if(this.reportId == this.items.length - 1)
         {
            if(this.reasonBox.text.length > 0)
            {
               this.confirmButton.setActive(true);
            }
            else
            {
               this.confirmButton.setActive(false);
            }
         }
         if(this.reasonBox.text.length >= 100)
         {
            this.charsLeft.textColor = 16711680;
         }
         else if(this.reasonBox.text.length >= 90)
         {
            this.charsLeft.textColor = 16750848;
         }
         else if(this.reasonBox.text.length >= 80)
         {
            this.charsLeft.textColor = 16776960;
         }
         else
         {
            this.charsLeft.textColor = 65280;
         }
         this.charsLeft.text = this.reasonBox.text.length + " of " + this.maxChars + " characters.";
      }
      
      public function close(param1:MouseEvent = null) : void
      {
         var reportPrompt:ReportPrompt = null;
         var e:MouseEvent = param1;
         this.closeButton.removeEventListener(MouseEvent.CLICK,this.close);
         reportPrompt = this;
         TweenMax.to(reportPrompt,0.4,{
            "alpha":0,
            "onComplete":function(param1:ReportPrompt):void
            {
               if(param1 != null && param1.parent != null)
               {
                  param1.parent.removeChild(reportPrompt);
               }
            },
            "onCompleteParams":[reportPrompt]
         });
      }
   }
}


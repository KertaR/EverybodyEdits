package ui.Prompts
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import ui.button.Button;
   import ui.button.ButtonColorType;
   
   public class DailyBonusPrompt extends Sprite
   {
      
      private var panel:Sprite;
      
      private var claimButton:Button;
      
      private var pw:Number = 420;
      
      private var ph:Number = 240;
      
      public function DailyBonusPrompt(streak:int, gems:int, energy:int, xp:int)
      {
         super();
         
         // 1. Dark semi-transparent background overlay
         var bgOverlay:Sprite = new Sprite();
         bgOverlay.graphics.beginFill(0x000000, 0.7);
         bgOverlay.graphics.drawRect(-1000, -1000, 3000, 3000);
         bgOverlay.graphics.endFill();
         addChild(bgOverlay);
         
         this.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
         {
            e.stopImmediatePropagation();
            e.stopPropagation();
         });
         
         // 2. Dialog Panel Window
         this.panel = new Sprite();
         this.panel.graphics.lineStyle(2, 0x22c55e, 1);
         this.panel.graphics.beginFill(0x1e293b, 0.98);
         this.panel.graphics.drawRoundRect(0, 0, this.pw, this.ph, 14, 14);
         this.panel.graphics.endFill();
         
         // Header bar
         this.panel.graphics.lineStyle(0, 0, 0);
         this.panel.graphics.beginFill(0x0f172a, 0.85);
         this.panel.graphics.drawRoundRectComplex(0, 0, this.pw, 42, 12, 12, 0, 0);
         this.panel.graphics.endFill();
         
         // Title label
         var titleTf:TextField = new TextField();
         titleTf.text = "Daily Login Bonus";
         titleTf.width = this.pw;
         titleTf.height = 30;
         titleTf.selectable = false;
         var titleFmt:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
         titleFmt.align = TextFormatAlign.CENTER;
         titleTf.defaultTextFormat = titleFmt;
         titleTf.setTextFormat(titleFmt);
         titleTf.y = 10;
         this.panel.addChild(titleTf);
         
         // Streak Banner
         var streakTf:TextField = new TextField();
         streakTf.text = "Login Streak: Day " + streak + " Reward!";
         streakTf.width = this.pw;
         streakTf.height = 24;
         streakTf.selectable = false;
         var streakFmt:TextFormat = new TextFormat("Arial", 13, 0xfacc15, true);
         streakFmt.align = TextFormatAlign.CENTER;
         streakTf.defaultTextFormat = streakFmt;
         streakTf.setTextFormat(streakFmt);
         streakTf.y = 52;
         this.panel.addChild(streakTf);
         
         // Reward details box
         var rewBox:Sprite = new Sprite();
         rewBox.graphics.lineStyle(1, 0x334155, 0.8);
         rewBox.graphics.beginFill(0x0f172a, 0.7);
         rewBox.graphics.drawRoundRect(30, 80, this.pw - 60, 85, 8, 8);
         rewBox.graphics.endFill();
         this.panel.addChild(rewBox);
         
         var rewTf:TextField = new TextField();
         rewTf.text = "+ " + gems + " Gems\n+ " + energy + " Energy\n+ " + xp + " XP";
         rewTf.x = 45;
         rewTf.y = 90;
         rewTf.width = this.pw - 90;
         rewTf.height = 70;
         rewTf.selectable = false;
         var rewFmt:TextFormat = new TextFormat("Arial", 13, 0x38bdf8, true);
         rewFmt.leading = 6;
         rewTf.defaultTextFormat = rewFmt;
         rewTf.setTextFormat(rewFmt);
         this.panel.addChild(rewTf);
         
         // Claim Button
         this.claimButton = new Button("Claim Reward", ButtonColorType.GREEN);
         this.claimButton.x = (this.pw - this.claimButton.width) / 2;
         this.claimButton.y = this.ph - this.claimButton.height - 14;
         this.claimButton.addEventListener(MouseEvent.CLICK, this.close);
         this.panel.addChild(this.claimButton);
         
         // Center panel on screen
         this.panel.x = (Config.width - this.pw) / 2;
         this.panel.y = (Config.height - this.ph) / 2;
         addChild(this.panel);
         
         // Fade in animation
         this.alpha = 0;
         TweenMax.to(this, 0.25, {"alpha": 1});
      }
      
      public function close(e:Event = null):void
      {
         var that:Sprite = this;
         TweenMax.to(that, 0.2, {
            "alpha": 0,
            "onComplete": function():void
            {
               if (that.parent)
               {
                  that.parent.removeChild(that);
               }
            }
         });
      }
   }
}

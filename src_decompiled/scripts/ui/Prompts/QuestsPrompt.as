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
   
   public class QuestsPrompt extends Sprite
   {
      
      private var panel:Sprite;
      
      private var closeBtn:Button;
      
      private var pw:Number = 520;
      
      private var ph:Number = 330;
      
      public function QuestsPrompt(streak:int, questsList:Array)
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
         this.panel.graphics.lineStyle(2, 0x3b82f6, 1);
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
         titleTf.text = "Daily Quests & Missions";
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
         streakTf.text = "Login Streak: Day " + streak;
         streakTf.width = this.pw;
         streakTf.height = 24;
         streakTf.selectable = false;
         var streakFmt:TextFormat = new TextFormat("Arial", 12, 0xf59e0b, true);
         streakFmt.align = TextFormatAlign.CENTER;
         streakTf.defaultTextFormat = streakFmt;
         streakTf.setTextFormat(streakFmt);
         streakTf.y = 48;
         this.panel.addChild(streakTf);
         
         // Quest Cards
         var startY:Number = 74;
         if (questsList && questsList.length > 0)
         {
            for (var i:int = 0; i < questsList.length; i++)
            {
               var q:Object = questsList[i];
               var qCard:Sprite = new Sprite();
               var cardY:Number = startY + i * 58;
               
               // Card background
               qCard.graphics.lineStyle(1, q.completed ? 0x22c55e : 0x334155, 0.9);
               qCard.graphics.beginFill(q.completed ? 0x14532d : 0x0f172a, 0.75);
               qCard.graphics.drawRoundRect(20, cardY, this.pw - 40, 52, 8, 8);
               qCard.graphics.endFill();
               this.panel.addChild(qCard);
               
               // Quest Title & Reward
               var qTitleTf:TextField = new TextField();
               qTitleTf.text = (i + 1) + ". " + q.title + " (+" + q.rewardGems + " Gems, +" + q.rewardXP + " XP)";
               qTitleTf.x = 30;
               qTitleTf.y = cardY + 6;
               qTitleTf.width = 330;
               qTitleTf.height = 20;
               qTitleTf.selectable = false;
               var qTitleFmt:TextFormat = new TextFormat("Arial", 12, 0xffffff, true);
               qTitleTf.defaultTextFormat = qTitleFmt;
               qTitleTf.setTextFormat(qTitleFmt);
               this.panel.addChild(qTitleTf);
               
               // Quest Description
               var qDescTf:TextField = new TextField();
               qDescTf.text = String(q.desc || "");
               qDescTf.x = 30;
               qDescTf.y = cardY + 26;
               qDescTf.width = 330;
               qDescTf.height = 20;
               qDescTf.selectable = false;
               var qDescFmt:TextFormat = new TextFormat("Arial", 11, 0x94a3b8, false);
               qDescTf.defaultTextFormat = qDescFmt;
               qDescTf.setTextFormat(qDescFmt);
               this.panel.addChild(qDescTf);
               
               // Progress text
               var progTf:TextField = new TextField();
               progTf.text = q.completed ? "COMPLETED" : (q.current + " / " + q.target);
               progTf.x = this.pw - 160;
               progTf.y = cardY + 16;
               progTf.width = 130;
               progTf.height = 24;
               progTf.selectable = false;
               var progFmt:TextFormat = new TextFormat("Arial", 12, q.completed ? 0x4ade80 : 0x38bdf8, true);
               progFmt.align = TextFormatAlign.RIGHT;
               progTf.defaultTextFormat = progFmt;
               progTf.setTextFormat(progFmt);
               this.panel.addChild(progTf);
            }
         }
         else
         {
            var noQ:TextField = new TextField();
            noQ.text = "No active daily quests available at this moment.";
            noQ.x = 30;
            noQ.y = startY + 30;
            noQ.width = this.pw - 60;
            noQ.selectable = false;
            var noQFmt:TextFormat = new TextFormat("Arial", 12, 0x94a3b8, false);
            noQFmt.align = TextFormatAlign.CENTER;
            noQ.defaultTextFormat = noQFmt;
            noQ.setTextFormat(noQFmt);
            this.panel.addChild(noQ);
         }
         
         // Close Button
         this.closeBtn = new Button("Close", ButtonColorType.BLUE);
         this.closeBtn.x = (this.pw - this.closeBtn.width) / 2;
         this.closeBtn.y = this.ph - this.closeBtn.height - 14;
         this.closeBtn.addEventListener(MouseEvent.CLICK, this.close);
         this.panel.addChild(this.closeBtn);
         
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

package ui.campaigns
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.getTimer;
   import items.ItemManager;
   import sample.ui.components.Label;
   
   public class CampaignTrialDone extends Sprite
   {
      
      public function CampaignTrialDone(param1:int, param2:int, param3:int = 0, param4:int = -1, param5:int = -1)
      {
         var blackBG:BlackBG;
         var newTime:Boolean;
         var newRank:Boolean;
         var headerBox:Sprite;
         var headerLabel:Label;
         var labelTime:Label;
         var dismissButton:assets_dismiss;
         var retryMain1:assets_retry;
         var retryMain2:assets_retry;
         var retryW:Number;
         var retryUp:Sprite;
         var retryOver:Sprite;
         var retryButton:SimpleButton;
         var pivot:Sprite = null;
         var startTime:int = 0;
         var starburst:assets_lightrotation = null;
         var footerBox:Sprite = null;
         var prefix:String = null;
         var clock:Clock = null;
         var pivot2:Sprite = null;
         var smiley:Bitmap = null;
         var labelPrevious:Label = null;
         var labelGoal:Label = null;
         var rank:int = param1;
         var time:int = param2;
         var lastRank:int = param3;
         var lastTime:int = param4;
         var nextTime:int = param5;
         super();
         name = "CampaignTrialDoneScreen";
         blackBG = new BlackBG();
         blackBG.width = 660;
         addChild(blackBG);
         newTime = lastTime < 0 || time < lastTime;
         newRank = rank > lastRank;
         pivot = new Sprite();
         pivot.x = 640 / 2;
         pivot.y = 470 / 2;
         addChild(pivot);
         this.alphaFade(pivot,0.5,1);
         startTime = getTimer();
         starburst = new assets_lightrotation();
         starburst.alpha = 0.75;
         starburst.x = -starburst.width / 2;
         starburst.y = -starburst.height / 2;
         pivot.addChild(starburst);
         if(newRank)
         {
            clock = new Clock(rank);
            clock.scaleX = clock.scaleY = 4;
            clock.x = -clock.width / 2;
            clock.y = -clock.height / 2;
            pivot.addChild(clock);
         }
         else
         {
            pivot2 = !newTime ? new Sprite() : null;
            if(pivot2)
            {
               pivot.addChild(pivot2);
            }
            smiley = new Bitmap(ItemManager.getSmileyById(newTime ? 1 : 2).bmd);
            smiley.scaleX = smiley.scaleY = 4;
            smiley.x = -smiley.width / 2;
            smiley.y = -smiley.height / 2;
            (newTime ? pivot : pivot2).addChild(smiley);
            if(!newTime)
            {
               pivot2.addEventListener(Event.ENTER_FRAME,function():void
               {
                  pivot2.rotation = Math.sin((getTimer() - startTime) * 0.001 * 2) * 30;
               });
            }
         }
         if(newRank || newTime)
         {
            pivot.addEventListener(Event.ENTER_FRAME,function():void
            {
               pivot.y = 470 / 2 + Math.sin((getTimer() - startTime) * 0.001 * 3) * 6;
            });
         }
         headerBox = new Sprite();
         headerBox.y = -80;
         headerBox.graphics.clear();
         headerBox.graphics.beginFill(2236962,0.85);
         headerBox.graphics.drawRect(0,0,640,57);
         headerBox.graphics.endFill();
         addChild(headerBox);
         TweenMax.to(headerBox,0.5,{"y":27});
         headerLabel = new Label(newRank ? "Congratulations!" : (newTime ? "New personal best!" : "Better luck next time!"),newRank || newTime ? 30 : 26,"left",16777215,false,"system");
         headerLabel.x = Math.round((640 - headerLabel.width) / 2);
         headerLabel.y = -100;
         addChild(headerLabel);
         TweenMax.to(headerLabel,0.5,{"y":(newRank || newTime ? 38 : 40)});
         footerBox = new Sprite();
         footerBox.y = 510;
         footerBox.graphics.clear();
         footerBox.graphics.beginFill(2236962,0.85);
         footerBox.graphics.drawRect(0,0,640,57);
         footerBox.graphics.endFill();
         addChild(footerBox);
         TweenMax.to(footerBox,0.5,{"y":350});
         labelTime = new Label("Time: " + ClockTime.format(time),16,"left",16777215,false,"system");
         labelTime.setTextFormat(new TextFormat(null,null,newRank ? ClockTime.rankColor(rank) : (newTime ? 4259648 : 16728128)),5,labelTime.length);
         labelTime.x = (640 - labelTime.width) / 2;
         labelTime.y = 510;
         addChild(labelTime);
         TweenMax.to(labelTime,0.5,{"y":350 + Math.floor((footerBox.height - labelTime.height) / 2)});
         if(lastTime >= 0)
         {
            prefix = newTime ? "Previous Best: " : "Personal Best: ";
            labelPrevious = new Label(prefix + ClockTime.format(lastTime),11,"left",10461087,false,"system");
            labelPrevious.setTextFormat(new TextFormat(null,null,14671839),prefix.length,labelPrevious.length);
            labelPrevious.x = 20;
            labelPrevious.y = 510;
            addChild(labelPrevious);
            TweenMax.to(labelPrevious,0.5,{"y":350 + Math.floor((footerBox.height - labelPrevious.height) / 2)});
         }
         if(nextTime >= 0)
         {
            prefix = newRank ? "Next Goal: " : "Current Goal: ";
            labelGoal = new Label(prefix + ClockTime.format(nextTime),11,"left",10461087,false,"system");
            labelGoal.setTextFormat(new TextFormat(null,null,14671839),prefix.length,labelGoal.length);
            labelGoal.x = 640 - labelGoal.width - 20;
            labelGoal.y = 510;
            addChild(labelGoal);
            TweenMax.to(labelGoal,0.5,{"y":350 + Math.floor((footerBox.height - labelGoal.height) / 2)});
         }
         dismissButton = new assets_dismiss();
         dismissButton.alpha = 0;
         dismissButton.x = 3;
         dismissButton.y = 446;
         dismissButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            Global.base.hideCampaignTrialDone();
         });
         addChild(dismissButton);
         this.alphaFade(dismissButton,0.2,1);
         retryMain1 = new assets_retry();
         retryMain1.label.autoSize = TextFieldAutoSize.LEFT;
         retryMain1.label.text += " (" + KeyBinding.retryRun.key.print() + ")";
         retryMain1.label.setTextFormat(new TextFormat(null,null,10066329),5,retryMain1.label.length);
         retryMain2 = new assets_retry();
         retryMain2.label.autoSize = TextFieldAutoSize.LEFT;
         retryMain2.label.text = retryMain1.label.text;
         retryMain2.label.setTextFormat(new TextFormat(null,null,10066329),5,retryMain1.label.length);
         retryW = retryMain1.width + 15;
         retryUp = new Sprite();
         retryUp.addChild(retryMain1);
         retryUp.graphics.beginFill(2236962);
         retryUp.graphics.lineStyle(1,13421772,1,true);
         retryUp.graphics.drawRoundRect(0,0,retryW,18,3,5);
         retryOver = new Sprite();
         retryOver.addChild(retryMain2);
         retryOver.graphics.beginFill(3355443);
         retryOver.graphics.lineStyle(1,13421772,1,true);
         retryOver.graphics.drawRoundRect(0,0,retryW,18,3,5);
         retryButton = new SimpleButton(retryUp,retryOver,retryOver,retryUp);
         retryButton.alpha = 0;
         retryButton.x = dismissButton.x + dismissButton.width + 5;
         retryButton.y = 446;
         retryButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            Global.base.hideCampaignTrialDone();
            Global.base.connection.send("say","/wpreset");
         });
         addChild(retryButton);
         this.alphaFade(retryButton,0.2,1);
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
      }
      
      private function alphaFade(param1:*, param2:Number, param3:Number) : void
      {
         if(param1.alpha == param3)
         {
            return;
         }
         TweenMax.to(param1,param2,{"alpha":param3});
      }
   }
}


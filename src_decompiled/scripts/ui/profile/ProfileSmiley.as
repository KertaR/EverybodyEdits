package ui.profile
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import items.ItemSmiley;
   import sample.ui.components.Box;
   import ui.HoverLabel;
   
   public class ProfileSmiley extends Box
   {
      
      private var bm:Bitmap;
      
      private var cs:ItemSmiley;
      
      private var hoverLabel:HoverLabel;
      
      private var hovertimer:uint;
      
      public function ProfileSmiley(param1:ItemSmiley)
      {
         super();
         this.cs = param1;
         border(1,3355443,1);
         fill(1118481,1,5);
         margin(NaN,NaN,0);
         this.bm = new Bitmap(param1.bmd);
         addChild(this.bm);
         this.bm.x = (28 - this.bm.width) / 2;
         this.bm.y = (28 - this.bm.height) / 2;
         this.width = 28;
         this.height = 28;
         this.hoverLabel = new HoverLabel();
         this.hoverLabel.draw(param1.name);
         this.hoverLabel.visible = false;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouse);
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(e.type == MouseEvent.MOUSE_OVER)
         {
            this.hovertimer = setTimeout(function():void
            {
               parent.addChild(hoverLabel);
               hoverLabel.alpha = 0;
               TweenMax.to(hoverLabel,0.25,{"alpha":1});
               hoverLabel.visible = true;
               setHoverLabelPosition();
            },400);
         }
         else if(e.type == MouseEvent.MOUSE_MOVE)
         {
            if(this.hoverLabel.visible)
            {
               this.setHoverLabelPosition();
            }
         }
         else if(e.type == MouseEvent.MOUSE_OUT)
         {
            TweenMax.to(this.hoverLabel,0.2,{"alpha":0});
            clearInterval(this.hovertimer);
         }
      }
      
      private function setHoverLabelPosition() : void
      {
         this.hoverLabel.x = parent.mouseX;
         if(this.hoverLabel.x > parent.width / 2)
         {
            this.hoverLabel.x -= this.hoverLabel.w + 12;
         }
         else
         {
            this.hoverLabel.x += 12;
         }
         this.hoverLabel.y = parent.mouseY - this.hoverLabel.height / 2;
      }
   }
}


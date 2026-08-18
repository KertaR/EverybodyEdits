package ui.lobby
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class LobbyTabButton extends Sprite
   {
      
      private var tf:TextField;
      
      private var tabWidth:Number = 95;
      
      private var tabHeight:Number = 30;
      
      public function LobbyTabButton(title:String)
      {
         super();
         this.buttonMode = true;
         this.mouseChildren = false;
         
         this.tf = new TextField();
         this.tf.text = title;
         this.tf.width = this.tabWidth;
         this.tf.height = this.tabHeight;
         this.tf.selectable = false;
         var fmt:TextFormat = new TextFormat("system", 13, 0xffffff, false);
         fmt.align = TextFormatAlign.CENTER;
         this.tf.defaultTextFormat = fmt;
         this.tf.setTextFormat(fmt);
         this.tf.y = 5;
         
         this.draw(0x232323, 0x383838);
         this.addChild(this.tf);
         
         this.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void
         {
            draw(0x383838, 0x4f4f4f);
         });
         
         this.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void
         {
            draw(0x232323, 0x383838);
         });
      }
      
      public function draw(bgColor:uint, borderColor:uint):void
      {
         this.graphics.clear();
         this.graphics.lineStyle(1, borderColor, 1, true);
         this.graphics.beginFill(bgColor, 1);
         this.graphics.drawRoundRectComplex(0, 0, this.tabWidth, this.tabHeight, 4, 4, 0, 0);
         this.graphics.endFill();
      }
   }
}

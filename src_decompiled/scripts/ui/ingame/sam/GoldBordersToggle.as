package ui.ingame.sam
{
   import blitter.BlText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class GoldBordersToggle extends Sprite
   {
      
      private static var checkmarkBM:Class = GoldBordersToggle_checkmarkBM;
      
      private static var checkmarkBMD:BitmapData = new checkmarkBM().bitmapData;
      
      private var text:BlText;
      
      private var textBM:Bitmap;
      
      private var checkBox:Sprite;
      
      public var checkmark:Bitmap;
      
      public function GoldBordersToggle()
      {
         super();
         useHandCursor = true;
         mouseEnabled = true;
         buttonMode = true;
         graphics.lineStyle(1,8092539);
         graphics.beginFill(3289650);
         graphics.drawRect(0,0,89,28);
         graphics.endFill();
         this.checkBox = new Sprite();
         this.checkBox.graphics.lineStyle(1,8092539);
         this.checkBox.graphics.beginFill(4473924);
         this.checkBox.graphics.drawRect(0,0,13,13);
         this.checkBox.graphics.endFill();
         this.checkBox.x = 4;
         this.checkBox.y = 8;
         addChild(this.checkBox);
         this.checkmark = new Bitmap(checkmarkBMD);
         this.checkBox.addChild(this.checkmark);
      }
      
      public function setActive(param1:Boolean) : void
      {
         if(Boolean(this.textBM) && contains(this.textBM))
         {
            removeChild(this.textBM);
         }
         this.checkmark.visible = param1;
         this.text = new BlText(8,68);
         this.text.text = "Gold Borders";
         this.textBM = new Bitmap(this.text.clone());
         this.textBM.x = this.checkBox.x + 17;
         this.textBM.y = 9;
         addChild(this.textBM);
      }
   }
}


package ui
{
   import blitter.BlText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   
   public class HoverLabel extends Sprite
   {
      
      public var w:int = 0;
      
      public var textCount:BlText;
      
      public function HoverLabel(param1:int = 120)
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this.textCount = new BlText(14,param1,16777215,"left","visitor");
      }
      
      public function draw(param1:String) : void
      {
         var _loc2_:Bitmap = null;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         this.textCount.textfield.autoSize = TextFieldAutoSize.LEFT;
         this.textCount.text = param1;
         _loc2_ = new Bitmap(this.textCount.clone());
         _loc2_.x = 4;
         _loc2_.y = 3;
         addChild(_loc2_);
         graphics.clear();
         graphics.lineStyle(1,8092539,1);
         graphics.beginFill(3289649,0.85);
         graphics.drawRect(0,0,this.textCount.textfield.textWidth + 10,this.textCount.textfield.height + 8);
         this.w = this.textCount.textfield.textWidth + 10;
      }
   }
}


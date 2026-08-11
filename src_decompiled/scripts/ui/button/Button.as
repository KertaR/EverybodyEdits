package ui.button
{
   import flash.display.GradientType;
   import flash.display.SpreadMethod;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import sample.ui.components.Label;
   
   public class Button extends Sprite
   {
      
      private var text:String;
      
      private var active:Boolean = true;
      
      private var ow:Number;
      
      private var oh:Number;
      
      private var prevColor:String = "green";
      
      private var color:String = "green";
      
      private var borderColor:uint;
      
      private var matrix:Matrix;
      
      private var title:Label;
      
      private var colors:Array = [];
      
      public function Button(param1:String, param2:String = "green", param3:Number = 15, param4:Number = 225, param5:Number = 40)
      {
         super();
         this.text = param1;
         this.color = param2;
         this.ow = param4;
         this.oh = param5;
         this.prevColor = param2;
         this.matrix = new Matrix();
         this.matrix.createGradientBox(param4,param5,Math.PI / 2);
         this.title = new Label(param1,param3,"left",16777215,false,"system");
         this.title.filters = [new DropShadowFilter(0,0,0,1,5,5)];
         this.title.x = (this.width - this.title.width) / 2;
         this.title.y = (this.height - this.title.height) / 2;
         this.title.mouseEnabled = false;
         addChild(this.title);
         mouseChildren = false;
         this.setActive(true);
      }
      
      private function redraw() : void
      {
         switch(this.color)
         {
            case ButtonColorType.DISABLED:
               this.borderColor = 6513507;
               this.colors = [62108595,6513507];
               break;
            case ButtonColorType.RED:
               this.borderColor = 10223872;
               this.colors = [16002093,10223872];
               break;
            case ButtonColorType.GREEN:
               this.borderColor = 2980642;
               this.colors = [3396906,2980642];
               break;
            case ButtonColorType.BLUE:
               this.borderColor = 543868;
               this.colors = [5482471,543868];
         }
         graphics.clear();
         graphics.lineStyle(1,this.borderColor);
         graphics.beginGradientFill(GradientType.LINEAR,this.colors,[1,1],[0,255],this.matrix,SpreadMethod.PAD);
         graphics.drawRoundRect(0,0,this.ow,this.oh,5,5);
         graphics.endFill();
      }
      
      public function setActive(param1:Boolean) : void
      {
         buttonMode = param1;
         useHandCursor = param1;
         mouseEnabled = param1;
         if(param1 == false)
         {
            this.prevColor = this.color;
            this.color = ButtonColorType.DISABLED;
         }
         else
         {
            this.color = this.prevColor;
         }
         this.redraw();
      }
      
      override public function get width() : Number
      {
         return this.ow;
      }
      
      override public function get height() : Number
      {
         return this.oh;
      }
   }
}


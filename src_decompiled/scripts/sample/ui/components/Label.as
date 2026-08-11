package sample.ui.components
{
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Label extends TextField
   {
      
      public function Label(param1:String, param2:Number = 12, param3:String = "left", param4:Number = 0, param5:Boolean = false, param6:String = null)
      {
         super();
         var _loc7_:TextFormat = new TextFormat();
         _loc7_.font = param6 || "Arial";
         if(_loc7_.font != "Arial")
         {
            embedFonts = true;
            antiAliasType = AntiAliasType.ADVANCED;
            sharpness = 400;
         }
         _loc7_.align = param3;
         _loc7_.size = param2;
         _loc7_.color = param4;
         this.defaultTextFormat = _loc7_;
         super.text = param1;
         this.selectable = false;
         this.mouseEnabled = false;
         if(param5)
         {
            this.multiline = true;
            this.wordWrap = true;
         }
         this.resize();
      }
      
      override public function set text(param1:String) : void
      {
         super.text = param1;
         this.resize();
      }
      
      override public function set htmlText(param1:String) : void
      {
         super.htmlText = param1;
         this.mouseEnabled = true;
         this.resize();
      }
      
      public function clear() : void
      {
         super.text = "";
      }
      
      private function resize() : void
      {
         this.width = this.textWidth + 10;
         this.height = this.textHeight + (this.defaultTextFormat.size as Number) / 2;
      }
      
      override public function get height() : Number
      {
         return this.textHeight + 3;
      }
      
      public function Clone() : Label
      {
         return new Label(this.text,this.defaultTextFormat.size as Number,this.defaultTextFormat.align);
      }
   }
}


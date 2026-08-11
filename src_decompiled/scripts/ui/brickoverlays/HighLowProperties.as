package ui.brickoverlays
{
   import blitter.Bl;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import ui2.ui2minusbtn;
   import ui2.ui2plusbtn;
   
   public class HighLowProperties extends PropertiesBackground
   {
      
      private var inptf:TextField;
      
      public function HighLowProperties()
      {
         var tf:TextField;
         var tff:TextFormat;
         var inptff:TextFormat;
         var sub:ui2minusbtn;
         var add:ui2plusbtn = null;
         super();
         tf = new TextField();
         tf.embedFonts = true;
         tf.selectable = false;
         tf.sharpness = 100;
         tf.multiline = false;
         tf.wordWrap = false;
         tff = new TextFormat("system",12,16777215);
         tf.defaultTextFormat = tff;
         tf.width = 280;
         tf.x = -150;
         tf.y = -38;
         tf.text = "Effect:";
         tf.height = tf.textHeight;
         addChild(tf);
         this.inptf = new TextField();
         this.inptf.selectable = true;
         this.inptf.sharpness = 100;
         this.inptf.multiline = true;
         this.inptf.borderColor = 16777215;
         this.inptf.backgroundColor = 11184810;
         this.inptf.background = true;
         this.inptf.border = true;
         this.inptf.restrict;
         this.inptf.maxChars = 2;
         this.inptf.type = TextFieldType.INPUT;
         inptff = new TextFormat("Arial",12,0,null,null,null,null,null,TextFormatAlign.CENTER);
         this.inptf.defaultTextFormat = inptff;
         this.updateText();
         this.inptf.height = tf.height + 3;
         this.inptf.width = 75;
         this.inptf.y = -38;
         this.inptf.x = 50;
         this.inptf.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.inptf.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         add = new ui2plusbtn();
         add.x = 140;
         add.y = -29;
         addChild(add);
         add.addEventListener(MouseEvent.MOUSE_DOWN,this.incrementValue);
         sub = new ui2minusbtn();
         sub.y = -29;
         sub.x = this.inptf.x - sub.width - 3;
         addChild(sub);
         sub.addEventListener(MouseEvent.MOUSE_DOWN,this.decrementValue);
         addChild(this.inptf);
         setSize(325,50);
      }
      
      private function updateText() : void
      {
         this.inptf.text = ["Normal","High","Low"][Bl.data.mode];
      }
      
      override public function incrementValue(param1:int = 1) : void
      {
         if(Bl.data.mode == 2)
         {
            Bl.data.mode = 0;
            this.updateText();
         }
         else if(Bl.data.mode == 0)
         {
            Bl.data.mode = 1;
            this.updateText();
         }
      }
      
      override public function decrementValue(param1:int = 1) : void
      {
         if(Bl.data.mode == 1)
         {
            Bl.data.mode = 0;
            this.updateText();
         }
         else if(Bl.data.mode == 0)
         {
            Bl.data.mode = 2;
            this.updateText();
         }
      }
   }
}


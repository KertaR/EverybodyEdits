package ui.brickoverlays
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TextSignProperties extends PropertiesBackground
   {
      
      public function TextSignProperties()
      {
         super();
         var _loc1_:Sprite = this.createTextField("Sign text:");
         _loc1_.y = -39 - 25;
         addChild(_loc1_);
         setSize(325,70);
      }
      
      private function createTextField(param1:String) : Sprite
      {
         var tff:TextFormat;
         var inptff:TextFormat;
         var container:Sprite = null;
         var inptf:TextField = null;
         var name:String = param1;
         container = new Sprite();
         var tf:TextField = new TextField();
         tf.embedFonts = true;
         tf.selectable = false;
         tf.sharpness = 100;
         tf.multiline = false;
         tf.wordWrap = false;
         tff = new TextFormat("system",12,16777215);
         tf.defaultTextFormat = tff;
         tf.width = 280;
         tf.x = -150;
         tf.y = 2.5;
         tf.text = name;
         tf.height = tf.textHeight;
         container.addChild(tf);
         inptf = new TextField();
         inptf.type = TextFieldType.INPUT;
         inptf.selectable = true;
         inptf.sharpness = 100;
         inptf.multiline = false;
         inptf.borderColor = 16777215;
         inptf.backgroundColor = 11184810;
         inptf.background = true;
         inptf.border = true;
         inptf.maxChars = 140;
         inptf.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            Global.text_sign_text = inptf.text;
         });
         inptff = new TextFormat("Tahoma",12,0,null,null,null,null,null,TextFormatAlign.LEFT);
         inptf.defaultTextFormat = inptff;
         inptf.text = Global.text_sign_text;
         inptf.height = tf.height + 3;
         inptf.width = 297;
         inptf.y = tf.y + tf.height + 5;
         inptf.x = tf.x;
         inptf.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         inptf.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         inptf.addEventListener(KeyboardEvent.KEY_UP,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         container.addChild(inptf);
         return container;
      }
   }
}


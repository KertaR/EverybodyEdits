package ui.brickoverlays
{
   import blitter.Bl;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class LabelProperties extends PropertiesBackground
   {
      
      public function LabelProperties()
      {
         super();
         var _loc1_:Sprite = this.createTextField("Label text:");
         _loc1_.y = -39 - 25;
         addChild(_loc1_);
         setSize(325,70);
      }
      
      private function createTextField(param1:String) : Sprite
      {
         var tff:TextFormat;
         var inptff:TextFormat;
         var inptff2:TextFormat;
         var container:Sprite = null;
         var inptf:TextField = null;
         var inptf2:TextField = null;
         var inptfWrap:TextField = null;
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
         inptf.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            Global.default_label_text = inptf.text;
         });
         inptff = new TextFormat("Tahoma",12,0,null,null,null,null,null,TextFormatAlign.LEFT);
         inptf.defaultTextFormat = inptff;
         inptf.text = Global.default_label_text;
         inptf.height = tf.height + 3;
         inptf.width = 297 - 58;
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
         inptf2 = new TextField();
         inptf2.type = TextFieldType.INPUT;
         inptf2.selectable = true;
         inptf2.sharpness = 100;
         inptf2.multiline = false;
         inptf2.borderColor = 16777215;
         inptf2.backgroundColor = 11184810;
         inptf2.background = true;
         inptf2.border = true;
         inptf2.maxChars = 7;
         inptf2.restrict = "0-9A-Fa-f";
         inptf2.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            inptf2.text = "#" + inptf2.text.substr(1,inptf2.text.length).replace("#","");
            inptf2.backgroundColor = uint("0x" + inptf2.text.substr(1,inptf2.text.length));
            inptf2.textColor = 16777215 - uint("0x" + inptf2.text.substr(1,inptf2.text.length));
            Global.default_label_hex = inptf2.text;
         });
         inptff2 = new TextFormat("Tahoma",12,0,null,null,null,null,null,TextFormatAlign.LEFT);
         inptf2.defaultTextFormat = inptff2;
         inptf2.text = Global.default_label_hex;
         inptf2.height = tf.height + 3;
         inptf2.width = 58;
         inptf2.y = tf.y + tf.height + 5;
         inptf2.x = tf.x + 297 - 55;
         inptf2.backgroundColor = uint("0x" + inptf2.text.substr(1,inptf2.text.length));
         inptf2.textColor = 16777215 - uint("0x" + inptf2.text.substr(1,inptf2.text.length));
         inptf2.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         inptf2.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         container.addChild(inptf2);
         inptfWrap = new TextField();
         inptfWrap.type = TextFieldType.INPUT;
         inptfWrap.text = Bl.data.wrapLength;
         inptfWrap.restrict = "0-9";
         inptfWrap.maxChars = 5;
         inptfWrap.selectable = true;
         inptfWrap.sharpness = 100;
         inptfWrap.multiline = false;
         inptfWrap.borderColor = 16777215;
         inptfWrap.backgroundColor = 11184810;
         inptfWrap.background = true;
         inptfWrap.border = true;
         inptfWrap.x = inptf2.x;
         inptfWrap.y = 2.5;
         inptfWrap.height = tf.height + 3;
         inptfWrap.width = 58;
         inptfWrap.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            var _loc2_:int = parseInt(inptfWrap.text);
            if(!isNaN(_loc2_))
            {
               Bl.data.wrapLength = _loc2_;
            }
         });
         inptfWrap.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         inptfWrap.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         container.addChild(inptfWrap);
         return container;
      }
   }
}


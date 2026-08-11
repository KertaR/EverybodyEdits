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
   import items.ItemId;
   import ui2.ui2minusbtn;
   import ui2.ui2plusbtn;
   
   public class SwitchProperties extends PropertiesBackground
   {
      
      public var inptf:TextField;
      
      private var allowAll:Boolean = false;
      
      public function SwitchProperties(param1:int)
      {
         var tf:TextField;
         var tff:TextFormat;
         var inptff:TextFormat;
         var add:ui2plusbtn;
         var sub:ui2minusbtn;
         var bricktype:int = param1;
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
         if(bricktype == ItemId.SWITCH_PURPLE || bricktype == ItemId.SWITCH_ORANGE)
         {
            tf.text = "ID of this switch";
         }
         else if(bricktype == ItemId.RESET_PURPLE || bricktype == ItemId.RESET_ORANGE)
         {
            tf.text = "ID of this switch reset";
            this.allowAll = true;
         }
         else if(bricktype == ItemId.DOOR_PURPLE || bricktype == ItemId.DOOR_ORANGE)
         {
            tf.text = "ID of this door";
         }
         else
         {
            tf.text = "ID of this gate";
         }
         if(!this.allowAll && Bl.data.switchId < 0)
         {
            Bl.data.switchId = 0;
         }
         tf.height = tf.textHeight;
         addChild(tf);
         this.inptf = new TextField();
         this.inptf.selectable = true;
         this.inptf.sharpness = 100;
         this.inptf.multiline = false;
         this.inptf.borderColor = 16777215;
         this.inptf.backgroundColor = 11184810;
         this.inptf.background = true;
         this.inptf.border = true;
         this.inptf.restrict = "0-9";
         this.inptf.maxChars = 3;
         this.inptf.type = TextFieldType.INPUT;
         this.inptf.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            var _loc2_:int = parseInt(inptf.text);
            if(!isNaN(_loc2_) && _loc2_ >= (allowAll ? -1 : 0) && _loc2_ <= 999)
            {
               Bl.data.switchId = _loc2_;
            }
         });
         inptff = new TextFormat("Arial",12,0,null,null,null,null,null,TextFormatAlign.CENTER);
         this.inptf.defaultTextFormat = inptff;
         this.inptf.text = Bl.data.switchId;
         this.inptf.height = tf.height + 3;
         this.inptf.width = 30;
         this.inptf.y = -38;
         this.inptf.x = 130 - 35;
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
         add.y = -29;
         add.x = 130 + 10;
         addChild(add);
         add.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            incrementValue();
         });
         sub = new ui2minusbtn();
         sub.y = -29;
         sub.x = 130 - 34 - 16;
         addChild(sub);
         sub.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            decrementValue();
         });
         addChild(this.inptf);
         setSize(325,50);
      }
      
      override public function incrementValue(param1:int = 1) : void
      {
         if(Bl.data.switchId < 999)
         {
            ++Bl.data.switchId;
         }
         this.inptf.text = Bl.data.switchId;
      }
      
      override public function decrementValue(param1:int = 1) : void
      {
         if(Bl.data.switchId > (this.allowAll ? -1 : 0))
         {
            --Bl.data.switchId;
         }
         this.inptf.text = Bl.data.switchId;
      }
   }
}


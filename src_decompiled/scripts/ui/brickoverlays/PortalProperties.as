package ui.brickoverlays
{
   import blitter.Bl;
   import flash.display.Sprite;
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
   
   public class PortalProperties extends PropertiesBackground
   {
      
      public function PortalProperties(param1:int)
      {
         super();
         var _loc2_:String = "ID of this portal:";
         var _loc3_:String = "ID of the target portal:";
         var _loc4_:Sprite = this.createPointScroller(_loc2_,"portal_id");
         _loc4_.y = -39 - 25;
         var _loc5_:Sprite = this.createPointScroller(_loc3_,"portal_target");
         _loc5_.y = -39;
         addChild(_loc4_);
         addChild(_loc5_);
         setSize(325,75);
      }
      
      private function createPointScroller(param1:String, param2:String) : Sprite
      {
         var tff:TextFormat;
         var inptff:TextFormat;
         var add:ui2plusbtn;
         var sub:ui2minusbtn;
         var container:Sprite = null;
         var tf:TextField = null;
         var inptf:TextField = null;
         var name:String = param1;
         var id:String = param2;
         container = new Sprite();
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
         tf.y = 0;
         tf.text = name;
         tf.height = tf.textHeight;
         container.addChild(tf);
         inptf = new TextField();
         inptf.type = TextFieldType.INPUT;
         inptf.restrict = "0-9";
         inptf.maxChars = 5;
         inptf.selectable = true;
         inptf.sharpness = 100;
         inptf.multiline = false;
         inptf.borderColor = 16777215;
         inptf.backgroundColor = 11184810;
         inptf.background = true;
         inptf.border = true;
         inptf.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            var _loc2_:int = parseInt(inptf.text);
            if(!isNaN(_loc2_) && _loc2_ >= 0 && _loc2_ <= 99999)
            {
               Bl.data[id] = _loc2_;
            }
         });
         inptff = new TextFormat("Arial",12,0,null,null,null,null,null,TextFormatAlign.CENTER);
         inptf.defaultTextFormat = inptff;
         inptf.text = Bl.data[id];
         inptf.height = tf.height + 3;
         inptf.width = 50;
         inptf.x = 75;
         inptf.y = 0;
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
         add = new ui2plusbtn();
         add.y = 9;
         add.x = inptf.x + inptf.width + add.width + 5;
         container.addChild(add);
         add.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            if(Bl.data[id] < 99999)
            {
               ++Bl.data[id];
            }
            inptf.text = Bl.data[id];
         });
         sub = new ui2minusbtn();
         sub.y = 9;
         sub.x = inptf.x - sub.width - 5;
         container.addChild(sub);
         sub.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            if(Bl.data[id] > 0)
            {
               --Bl.data[id];
            }
            inptf.text = Bl.data[id];
         });
         container.addChild(inptf);
         return container;
      }
   }
}


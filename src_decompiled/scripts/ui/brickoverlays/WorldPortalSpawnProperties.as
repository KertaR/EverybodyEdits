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
   
   public class WorldPortalSpawnProperties extends PropertiesBackground
   {
      
      public var inptf:TextField;
      
      public function WorldPortalSpawnProperties()
      {
         var tf:TextField;
         var tff:TextFormat;
         var inptff:TextFormat;
         var add:ui2plusbtn;
         var sub:ui2minusbtn;
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
         tf.text = "ID of this spawn point:";
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
         this.inptf.maxChars = 5;
         this.inptf.type = TextFieldType.INPUT;
         this.inptf.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            var _loc2_:int = parseInt(inptf.text);
            if(!isNaN(_loc2_) && _loc2_ >= 1 && _loc2_ <= 99999)
            {
               Bl.data.spawn_id = _loc2_;
            }
            inptf.text = Bl.data.spawn_id;
         });
         inptff = new TextFormat("Arial",12,0,null,null,null,null,null,TextFormatAlign.CENTER);
         this.inptf.defaultTextFormat = inptff;
         this.inptf.text = Bl.data.spawn_id;
         this.inptf.height = tf.height + 3;
         this.inptf.width = 50;
         this.inptf.y = -38;
         this.inptf.x = 130 - 55;
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
         add.addEventListener(MouseEvent.MOUSE_DOWN,this.incrementValue);
         sub = new ui2minusbtn();
         sub.y = -29;
         sub.x = 130 - 54 - 16;
         addChild(sub);
         sub.addEventListener(MouseEvent.MOUSE_DOWN,this.decrementValue);
         addChild(this.inptf);
         setSize(325,50);
      }
      
      override public function incrementValue(param1:int = 1) : void
      {
         if(Bl.data.spawn_id < 99999)
         {
            ++Bl.data.spawn_id;
         }
         this.inptf.text = Bl.data.spawn_id;
      }
      
      override public function decrementValue(param1:int = 1) : void
      {
         if(Bl.data.spawn_id > 1)
         {
            --Bl.data.spawn_id;
         }
         this.inptf.text = Bl.data.spawn_id;
      }
   }
}


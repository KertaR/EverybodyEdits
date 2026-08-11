package ui.brickoverlays
{
   import blitter.Bl;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import items.ItemId;
   import items.ItemManager;
   
   public class NpcProperties extends PropertiesBackground
   {
      
      private static var Arrows:Class = NpcProperties_Arrows;
      
      private static var arrowsBMD:BitmapData = new Arrows().bitmapData;
      
      private var smiley:Bitmap;
      
      private var ui:UI2;
      
      private var hotbar:Boolean;
      
      public function NpcProperties(param1:int, param2:UI2, param3:Boolean)
      {
         super();
         if(!ItemId.isNPC(param1))
         {
            throw new Error("Tried creating properties for non-NPC block");
         }
         Bl.data.brick = param1;
         this.ui = param2;
         this.hotbar = param3;
         this.createChatField("Message 1:","npc_mes1",-256,-142,0);
         this.createChatField("Message 2:","npc_mes2",-256,-100,1);
         this.createChatField("Message 3:","npc_mes3",-256,-57,2);
         this.createNameText("Name your NPC!",69,-140);
         this.createArrow(false);
         this.createArrow(true);
         this.switchSmiley();
         this.createNameField(Bl.data.npc_name,69,-43,3);
         setSize(525,145);
      }
      
      override public function incrementValue(param1:int = 1) : void
      {
         this.updateSelection(Npc.getNextNpcID(Bl.data.brick,true));
         this.switchSmiley();
      }
      
      override public function decrementValue(param1:int = 1) : void
      {
         this.updateSelection(Npc.getNextNpcID(Bl.data.brick,false));
         this.switchSmiley();
      }
      
      private function switchSmiley() : void
      {
         if(!ItemId.isNPC(Bl.data.brick))
         {
            return;
         }
         if(Boolean(this.smiley) && this.smiley.parent == this)
         {
            this.removeChild(this.smiley);
         }
         var _loc1_:BitmapData = ItemManager.getBrickById(Bl.data.brick).bmd;
         var _loc2_:Matrix = new Matrix();
         _loc2_.scale(64 / _loc1_.width,64 / _loc1_.height);
         var _loc3_:BitmapData = new BitmapData(64,64,true,0);
         _loc3_.draw(_loc1_,_loc2_);
         this.smiley = new Bitmap(_loc3_);
         this.smiley.pixelSnapping = PixelSnapping.NEVER;
         this.smiley.smoothing = false;
         this.smiley.y = -113;
         this.smiley.x = 122;
         this.addChild(this.smiley);
      }
      
      private function updateSelection(param1:int) : void
      {
         if(this.hotbar)
         {
            Bl.data.brick = param1;
            this.ui.favoriteBricks.setDefault(this.ui.favoriteBricks.selectedBlock,ItemManager.getBrickById(param1));
         }
         this.ui.hideAllProperties();
         this.ui.setSelected(param1);
      }
      
      private function createArrow(param1:Boolean) : void
      {
         var arrow:Sprite;
         var increase:Boolean = param1;
         var arrowBMD:BitmapData = new BitmapData(20,64,true,0);
         arrowBMD.copyPixels(arrowsBMD,new Rectangle(increase ? 20 : 0,0,20,64),new Point());
         arrow = new Sprite();
         arrow.addChild(new Bitmap(arrowBMD));
         arrow.y = -109;
         arrow.x = increase ? 186 : 102;
         arrow.addEventListener(MouseEvent.CLICK,function():void
         {
            if(increase)
            {
               incrementValue();
            }
            else
            {
               decrementValue();
            }
         });
         addChild(arrow);
      }
      
      private function createNameField(param1:String, param2:Number = -150, param3:Number = 2.5, param4:int = -1) : void
      {
         var inptf:TextField = null;
         var name:String = param1;
         var x:Number = param2;
         var y:Number = param3;
         var tabIndex:int = param4;
         var inptff:TextFormat = new TextFormat("Tahoma",12,0);
         inptff.align = TextFormatAlign.CENTER;
         inptf = new TextField();
         inptf.type = TextFieldType.INPUT;
         inptf.selectable = true;
         inptf.sharpness = 100;
         inptf.multiline = false;
         inptf.borderColor = 16777215;
         inptf.backgroundColor = 11184810;
         inptf.background = true;
         inptf.border = true;
         inptf.maxChars = 20;
         inptf.defaultTextFormat = inptff;
         inptf.text = name;
         inptf.height = 23;
         inptf.width = 175;
         inptf.x = x;
         inptf.y = y;
         inptf.tabIndex = tabIndex;
         inptf.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            var _loc2_:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.-\'~%";
            var _loc3_:String = "";
            var _loc4_:int = 0;
            while(_loc4_ < inptf.text.length)
            {
               if(_loc2_.indexOf(inptf.text.charAt(_loc4_)) != -1)
               {
                  _loc3_ += inptf.text.charAt(_loc4_);
               }
               _loc4_++;
            }
            Bl.data.npc_name = inptf.text = _loc3_;
         });
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
         addChild(inptf);
      }
      
      private function createNameText(param1:String, param2:Number, param3:Number) : void
      {
         var _loc4_:TextField = new TextField();
         _loc4_.embedFonts = true;
         _loc4_.selectable = false;
         _loc4_.sharpness = 100;
         _loc4_.multiline = false;
         _loc4_.wordWrap = false;
         var _loc5_:TextFormat = new TextFormat("system",16,16777215);
         _loc5_.align = TextFormatAlign.CENTER;
         _loc4_.defaultTextFormat = _loc5_;
         _loc4_.width = 174;
         _loc4_.x = param2;
         _loc4_.y = param3;
         _loc4_.text = param1;
         _loc4_.height = _loc4_.textHeight;
         addChild(_loc4_);
      }
      
      private function createNpcSmiley(param1:int) : Bitmap
      {
         var _loc2_:BitmapData = ItemManager.getBrickById(param1).bmd;
         var _loc3_:Matrix = new Matrix();
         _loc3_.scale(64 / _loc2_.width,64 / _loc2_.height);
         var _loc4_:BitmapData = new BitmapData(64,64,true,0);
         _loc4_.draw(_loc2_,_loc3_);
         var _loc5_:Bitmap = new Bitmap(_loc4_);
         _loc5_.pixelSnapping = PixelSnapping.NEVER;
         _loc5_.smoothing = false;
         _loc5_.y = -113;
         _loc5_.x = 122;
         return _loc5_;
      }
      
      private function createChatField(param1:String, param2:String, param3:Number = -150, param4:Number = 2.5, param5:int = 0) : void
      {
         var inptff:TextFormat;
         var inptf:TextField = null;
         var name:String = param1;
         var id:String = param2;
         var x:Number = param3;
         var y:Number = param4;
         var tabIndex:int = param5;
         var tff:TextFormat = new TextFormat("system",12,16777215);
         var tf:TextField = new TextField();
         tf.embedFonts = true;
         tf.selectable = false;
         tf.sharpness = 100;
         tf.multiline = false;
         tf.wordWrap = false;
         tf.defaultTextFormat = tff;
         tf.width = 280;
         tf.x = x;
         tf.y = y;
         tf.text = name;
         tf.height = tf.textHeight;
         addChild(tf);
         inptff = new TextFormat("Tahoma",12,0,null,null,null,null,null,TextFormatAlign.LEFT);
         inptf = new TextField();
         inptf.type = TextFieldType.INPUT;
         inptf.selectable = true;
         inptf.sharpness = 100;
         inptf.multiline = false;
         inptf.borderColor = 16777215;
         inptf.backgroundColor = 11184810;
         inptf.background = true;
         inptf.border = true;
         inptf.maxChars = 80;
         inptf.defaultTextFormat = inptff;
         inptf.text = Bl.data[id];
         inptf.height = tf.height + 3;
         inptf.width = 297;
         inptf.y = tf.y + tf.height + 5;
         inptf.x = tf.x;
         inptf.tabIndex = tabIndex;
         inptf.addEventListener(Event.CHANGE,function(param1:Event):void
         {
            Bl.data[id] = inptf.text;
         });
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
         addChild(inptf);
      }
   }
}


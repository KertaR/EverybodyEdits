package ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import items.ItemBrick;
   import items.ItemManager;
   import ui2.worldbrickscontainer;
   
   public class BrickContainer extends worldbrickscontainer
   {
      
      private var images:Array;
      
      private var sprites:Array;
      
      private var defaults:Vector.<ItemBrick>;
      
      private var curdefaults:Object;
      
      private var selected:int = 0;
      
      private var selectedIndex:int = 0;
      
      private var uix:UI2;
      
      private var dragmc:Sprite;
      
      private var dragbm:Bitmap;
      
      private var indrag:Boolean = false;
      
      private var dragged:ItemBrick;
      
      private var oldKeyCode:uint = 0;
      
      private var oldvar:int = 0;
      
      public function BrickContainer(param1:Vector.<ItemBrick>, param2:UI2)
      {
         var _loc4_:BitmapData = null;
         var _loc5_:Bitmap = null;
         var _loc6_:Sprite = null;
         this.images = [];
         this.sprites = [];
         this.curdefaults = {};
         this.dragmc = new Sprite();
         this.dragbm = new Bitmap(new BitmapData(16,16,false,0));
         super();
         this.uix = param2;
         this.defaults = param1.concat();
         this.dragmc.addChild(this.dragbm);
         this.dragmc.mouseChildren = false;
         this.dragmc.mouseEnabled = false;
         this.dragmc.filters = [new DropShadowFilter(0,45,0,1,4,4,1,3)];
         selector.mouseEnabled = numbers.mouseEnabled = false;
         var _loc3_:int = 0;
         while(_loc3_ < 11)
         {
            _loc4_ = new BitmapData(16,16,false,0);
            _loc5_ = new Bitmap(_loc4_);
            _loc6_ = new Sprite();
            this.attachClickHandler(_loc6_,_loc3_);
            ItemManager.bricks[0].drawTo(_loc4_,0,0);
            _loc6_.useHandCursor = true;
            _loc6_.buttonMode = true;
            _loc6_.addChild(_loc5_);
            _loc6_.x = _loc3_ * 16;
            brickcontainer.addChild(_loc6_);
            this.images.push(_loc4_);
            this.sprites.push(_loc6_);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            this.setDefault(_loc3_,param1[_loc3_]);
            _loc3_++;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleDetatch);
      }
      
      public function get value() : int
      {
         return this.selected;
      }
      
      public function get selectedBlock() : int
      {
         return this.selectedIndex;
      }
      
      public function setDefault(param1:int, param2:ItemBrick) : void
      {
         this.defaults[param1] = param2;
         this.drawDefault(param1,param2);
         this.setSelected(param2.id);
      }
      
      public function setDefaults(param1:Vector.<ItemBrick>) : void
      {
         this.defaults = param1.concat();
         var _loc2_:int = 0;
         while(_loc2_ < 11)
         {
            this.drawDefault(_loc2_,this.defaults[_loc2_]);
            _loc2_++;
         }
      }
      
      public function select(param1:int, param2:Boolean = false) : void
      {
         this.selectedIndex = param1;
         this.selected = this.defaults[param1].id;
         selector.x = 3 + param1 * 16;
         selector.y = 10;
         selector.visible = true;
         if(!param2)
         {
            this.uix.setSelected(this.selected,true);
         }
      }
      
      public function getPosFromID(param1:int) : int
      {
         if(param1 == 110)
         {
            param1 = 100;
         }
         if(param1 == 111)
         {
            param1 = 101;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.defaults.length)
         {
            if(this.defaults[_loc2_].id == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function getPosWithID(param1:int) : Point
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.defaults.length)
         {
            if(this.defaults[_loc2_].id == param1)
            {
               return new Point(3 + _loc2_ * 16 + 8,-5);
            }
            _loc2_++;
         }
         return new Point(0,0);
      }
      
      public function setSelected(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.defaults.length)
         {
            if(this.defaults[_loc2_].id == param1)
            {
               this.select(_loc2_,true);
               return;
            }
            _loc2_++;
         }
         selector.visible = false;
      }
      
      public function dragIt(param1:ItemBrick) : void
      {
         this.dragged = param1;
         this.indrag = true;
         this.uix.addChild(this.dragmc);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         this.dragbm.bitmapData.fillRect(this.dragbm.bitmapData.rect,0);
         ItemManager.bricks[param1.selectorBG].drawTo(this.dragbm.bitmapData,0,0);
         param1.drawTo(this.dragbm.bitmapData,0,0);
         this.dragmc.x = -1000;
         this.dragmc.y = -1000;
      }
      
      private function handleMouseMove(param1:MouseEvent = null) : void
      {
         this.dragmc.x = this.uix.mouseX - 8;
         this.dragmc.y = this.uix.mouseY - 8;
         if(param1)
         {
            param1.updateAfterEvent();
         }
         Mouse.hide();
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         var _loc4_:Sprite = null;
         Mouse.show();
         if(!this.indrag)
         {
            return;
         }
         var _loc2_:Point = this.dragmc.parent.localToGlobal(new Point(this.dragmc.x + 8,this.dragmc.y + 8));
         if(this.dragmc.parent)
         {
            this.dragmc.parent.removeChild(this.dragmc);
         }
         this.indrag = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         var _loc3_:int = 0;
         while(_loc3_ < this.sprites.length)
         {
            _loc4_ = this.sprites[_loc3_] as Sprite;
            if(_loc4_.hitTestPoint(_loc2_.x,_loc2_.y))
            {
               if(_loc3_ != 0)
               {
                  this.setDefault(_loc3_,this.dragged);
                  this.setSelected(this.dragged.id);
               }
               return;
            }
            _loc3_++;
         }
      }
      
      private function handleAttach(param1:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
      }
      
      private function handleDetatch(param1:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == this.oldKeyCode)
         {
            return;
         }
         this.oldKeyCode = param1.keyCode;
         switch(param1.keyCode)
         {
            case 16:
            case 17:
               if(this.selectedIndex != 0)
               {
                  this.oldvar = this.selectedIndex;
               }
               this.select(0);
               break;
            case 49:
               this.indrag ? this.setDefault(1,this.dragged) : this.select(1);
               break;
            case 50:
               this.indrag ? this.setDefault(2,this.dragged) : this.select(2);
               break;
            case 51:
               this.indrag ? this.setDefault(3,this.dragged) : this.select(3);
               break;
            case 52:
               this.indrag ? this.setDefault(4,this.dragged) : this.select(4);
               break;
            case 53:
               this.indrag ? this.setDefault(5,this.dragged) : this.select(5);
               break;
            case 54:
               this.indrag ? this.setDefault(6,this.dragged) : this.select(6);
               break;
            case 55:
               this.indrag ? this.setDefault(7,this.dragged) : this.select(7);
               break;
            case 56:
               this.indrag ? this.setDefault(8,this.dragged) : this.select(8);
               break;
            case 57:
               this.indrag ? this.setDefault(9,this.dragged) : this.select(9);
               break;
            case 48:
               this.indrag ? this.setDefault(10,this.dragged) : this.select(10);
         }
      }
      
      private function handleKeyUp(param1:KeyboardEvent) : void
      {
         if(this.oldvar != 0 && (param1.keyCode == 16 || param1.keyCode == 17))
         {
            this.oldvar == 0;
            this.select(this.oldvar);
         }
         this.oldKeyCode = 0;
      }
      
      private function attachClickHandler(param1:Sprite, param2:int) : void
      {
         var o:Sprite = param1;
         var offset:int = param2;
         o.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            select(offset);
         });
      }
      
      private function drawDefault(param1:int, param2:ItemBrick) : void
      {
         this.images[param1].fillRect(new Rectangle(0,0,16,16),0);
         ItemManager.bricks[param2.selectorBG].drawTo(this.images[param1],0,0);
         param2.drawTo(this.images[param1],0,0);
      }
   }
}


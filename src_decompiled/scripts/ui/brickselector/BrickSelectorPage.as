package ui.brickselector
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import items.ItemBrick;
   import ui2.tabPage1;
   import ui2.tabPage2;
   import ui2.tabPage3;
   import ui2.tabPage4;
   
   public class BrickSelectorPage extends MovieClip
   {
      
      private var container:MovieClip;
      
      private var _id:int;
      
      private var page:MovieClip;
      
      private var currentX:int = 5;
      
      private var currentY:int = 5;
      
      private var rowHeight:int;
      
      private var maxRows:int;
      
      public function BrickSelectorPage(param1:int, param2:Function, param3:Sprite)
      {
         var id:int = param1;
         var onSelect:Function = param2;
         var blocksContainer:Sprite = param3;
         this.container = new MovieClip();
         this.maxRows = Global.base.settings.visibleRows;
         super();
         this._id = id;
         this.rowHeight = Global.base.settings.showPackageNames ? 30 : 20;
         switch(id)
         {
            case 0:
               this.page = new tabPage1();
               break;
            case 1:
               this.page = new tabPage2();
               break;
            case 2:
               this.page = new tabPage3();
               break;
            default:
            case 3:
               this.page = new tabPage4();
         }
         this.page.mouseEnabled = true;
         this.page.buttonMode = true;
         this.page.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            onSelect(id);
         });
         addChild(this.page);
         blocksContainer.addChild(this.container);
         this.visible = false;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this.page.gotoAndStop(param1 ? 1 : 2);
         this.container.visible = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.selected = false;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function addPackage(param1:BrickPackage) : Boolean
      {
         if(this.currentX + param1.width + 5 >= Global.fullWidth)
         {
            if(this.maxRows > 0 && this.currentY + this.rowHeight >= this.maxRows * this.rowHeight)
            {
               return false;
            }
            this.currentX = 5;
            this.currentY += this.rowHeight;
         }
         param1.x = this.currentX;
         param1.y = this.currentY;
         this.currentX += param1.width + 5;
         this.container.addChild(param1);
         return true;
      }
      
      public function removePackages() : void
      {
         this.currentX = 5;
         this.currentY = 5;
         this.container.removeChildren();
      }
      
      public function setMaxY(param1:int) : int
      {
         return this.currentY >= param1 ? this.currentY : param1;
      }
      
      public function get hasBlocks() : Boolean
      {
         return this.container.numChildren > 0;
      }
      
      public function hasBlock(param1:int) : Boolean
      {
         var _loc3_:BrickPackage = null;
         var _loc4_:ItemBrick = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.container.numChildren)
         {
            _loc3_ = this.container.getChildAt(_loc2_) as BrickPackage;
            for each(_loc4_ in _loc3_.content)
            {
               if(_loc4_.id == param1)
               {
                  return true;
               }
            }
            _loc2_++;
         }
         return false;
      }
   }
}


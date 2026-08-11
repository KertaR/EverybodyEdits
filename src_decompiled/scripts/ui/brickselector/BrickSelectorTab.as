package ui.brickselector
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import items.ItemTab;
   import ui2.tabAction;
   import ui2.tabBackground;
   import ui2.tabBlocks;
   import ui2.tabDecorative;
   
   public class BrickSelectorTab extends Sprite
   {
      
      public var tabId:int;
      
      private var tab:MovieClip;
      
      private var blocksContainer:Sprite;
      
      private var pagesContainer:Sprite = new Sprite();
      
      private var uix:UI2;
      
      public var pages:Vector.<BrickSelectorPage> = new Vector.<BrickSelectorPage>();
      
      private var currentPage:int = 0;
      
      public function BrickSelectorTab(param1:int, param2:Sprite, param3:UI2)
      {
         super();
         this.tabId = param1;
         this.blocksContainer = param2;
         this.uix = param3;
         switch(param1)
         {
            case ItemTab.BLOCK:
               this.tab = new tabBlocks();
               break;
            case ItemTab.ACTION:
               this.tab = new tabAction();
               break;
            case ItemTab.DECORATIVE:
               this.tab = new tabDecorative();
               break;
            case ItemTab.BACKGROUND:
               this.tab = new tabBackground();
         }
         addChild(this.pagesContainer);
         this.addPage();
         this.tab.mouseEnabled = true;
         this.tab.buttonMode = true;
         this.tab.gotoAndStop(2);
         addChild(this.tab);
      }
      
      private function addPage() : BrickSelectorPage
      {
         var _loc1_:BrickSelectorPage = null;
         _loc1_ = new BrickSelectorPage(this.pages.length,this.selectPage,this.blocksContainer);
         _loc1_.x = 22 * this.pages.length;
         this.pagesContainer.addChild(_loc1_);
         this.pages.push(_loc1_);
         return _loc1_;
      }
      
      public function selectPage(param1:int) : void
      {
         var _loc2_:BrickSelectorPage = null;
         if(param1 == -1)
         {
            param1 = Math.max(0,this.pages.length - 1);
         }
         this.currentPage = param1;
         for each(_loc2_ in this.pages)
         {
            _loc2_.selected = _loc2_.id == param1;
         }
         this.uix.hideBrickPackagePopup();
         this.uix.hideAllProperties();
      }
      
      public function cyclePages(param1:int = 1) : Boolean
      {
         var _loc2_:int = this.currentPage + param1;
         if(_loc2_ < 0 || _loc2_ >= this.pages.length)
         {
            return false;
         }
         this.selectPage(_loc2_);
         return true;
      }
      
      public function onSelect(param1:Function) : void
      {
         var action:Function = param1;
         this.tab.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            action(tabId);
         });
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:BrickSelectorPage = null;
         this.tab.gotoAndStop(param1 ? 1 : 2);
         for each(_loc2_ in this.pages)
         {
            _loc2_.visible = param1 && this.pages.length > 1;
         }
         if(param1 && this.pages.length > 0)
         {
            this.pages[this.currentPage].selected = true;
         }
      }
      
      public function get selected() : Boolean
      {
         return this.tab.currentFrame == 1;
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         this.tab.x = param1;
         this.tab.y = param2;
         this.pagesContainer.x = param1;
         this.pagesContainer.y = param2 - 21;
      }
      
      public function addPackage(param1:BrickPackage) : void
      {
         var _loc4_:BrickSelectorPage = null;
         if(this.pages.length == 0)
         {
            this.addPage();
         }
         var _loc2_:BrickSelectorPage = this.pages[this.pages.length - 1];
         var _loc3_:Boolean = _loc2_.addPackage(param1);
         if(!_loc3_)
         {
            _loc4_ = this.addPage();
            this.selected = this.selected;
            _loc4_.addPackage(param1);
         }
      }
      
      public function removePackages() : void
      {
         while(this.pagesContainer.numChildren > 0)
         {
            this.pagesContainer.removeChildAt(0);
         }
         this.pages = new Vector.<BrickSelectorPage>();
         this.currentPage = 0;
      }
      
      public function setMaxY(param1:int) : int
      {
         var _loc2_:BrickSelectorPage = null;
         for each(_loc2_ in this.pages)
         {
            param1 = _loc2_.setMaxY(param1);
         }
         return param1;
      }
      
      public function get hasBlocks() : Boolean
      {
         if(this.pages.length == 0)
         {
            return false;
         }
         if(this.pages.length > 1)
         {
            return true;
         }
         return this.pages[0].hasBlocks;
      }
      
      public function currentPageHasBlock(param1:int) : Boolean
      {
         return this.pages[this.currentPage].hasBlock(param1);
      }
   }
}


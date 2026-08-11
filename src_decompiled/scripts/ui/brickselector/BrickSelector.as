package ui.brickselector
{
   import blitter.Bl;
   import com.greensock.*;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import items.ItemTab;
   import mx.utils.StringUtil;
   import ui2.tabBtnLock;
   import ui2.ui2brickselector;
   
   public class BrickSelector extends ui2brickselector
   {
      
      public var packages:Array;
      
      private var masker:Sprite;
      
      private var bg:Sprite;
      
      private var brickContainer:Sprite;
      
      private var selectedTabNum:int;
      
      private var tabs:Vector.<BrickSelectorTab>;
      
      private var tabBlocks:BrickSelectorTab;
      
      private var tabAction:BrickSelectorTab;
      
      private var tabDecorative:BrickSelectorTab;
      
      private var tabBackground:BrickSelectorTab;
      
      private var locked:Boolean = true;
      
      private var btnLock:tabBtnLock;
      
      private var totalHeight:int = 0;
      
      private var isup:Boolean = true;
      
      private var uix:UI2;
      
      public var search:BrickSelectorSearch;
      
      public function BrickSelector(param1:UI2)
      {
         var shadow:BitmapFilter;
         var uix:UI2 = param1;
         this.packages = [];
         this.masker = new Sprite();
         this.bg = new Sprite();
         this.brickContainer = new Sprite();
         this.tabs = new Vector.<BrickSelectorTab>();
         this.btnLock = new tabBtnLock();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         this.uix = uix;
         this.tabBlocks = new BrickSelectorTab(ItemTab.BLOCK,this.brickContainer,uix);
         this.tabs.push(this.tabBlocks);
         addChild(this.tabBlocks);
         this.tabAction = new BrickSelectorTab(ItemTab.ACTION,this.brickContainer,uix);
         this.tabs.push(this.tabAction);
         addChild(this.tabAction);
         this.tabDecorative = new BrickSelectorTab(ItemTab.DECORATIVE,this.brickContainer,uix);
         this.tabs.push(this.tabDecorative);
         addChild(this.tabDecorative);
         this.tabBackground = new BrickSelectorTab(ItemTab.BACKGROUND,this.brickContainer,uix);
         this.tabs.push(this.tabBackground);
         addChild(this.tabBackground);
         this.search = new BrickSelectorSearch(this,uix);
         addChild(this.search);
         this.positionTabs();
         this.btnLock.mouseEnabled = true;
         this.btnLock.buttonMode = true;
         this.btnLock.gotoAndStop(2);
         addChild(this.btnLock);
         addChild(this.bg);
         addChild(this.brickContainer);
         this.addEventListener(MouseEvent.ROLL_OVER,function(param1:MouseEvent):void
         {
            setHeight(true);
         });
         this.addEventListener(MouseEvent.ROLL_OUT,function(param1:MouseEvent):void
         {
            if(!locked && !Bl.data.showingproperties)
            {
               setHeight(false);
            }
         });
         this.setActiveTab(0);
         this.tabBlocks.onSelect(this.setActiveTab);
         this.tabAction.onSelect(this.setActiveTab);
         this.tabDecorative.onSelect(this.setActiveTab);
         this.tabBackground.onSelect(this.setActiveTab);
         this.btnLock.addEventListener(MouseEvent.CLICK,function():void
         {
            setLock(btnLock.currentFrame == 1);
         });
         shadow = new DropShadowFilter(0,45,0,1,4,4,1,3);
         this.bg.filters = this.tabBlocks.filters = this.tabAction.filters = this.tabDecorative.filters = this.tabBackground.filters = this.btnLock.filters = [shadow];
      }
      
      private function positionTabs() : void
      {
         var _loc2_:BrickSelectorTab = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.tabs)
         {
            if(!_loc2_.hasBlocks && this.selectedTabNum != _loc2_.tabId)
            {
               _loc2_.visible = false;
            }
            else
            {
               _loc2_.visible = true;
               _loc2_.setPosition(5 + _loc1_ * 120,-22);
               _loc1_ += 1;
            }
         }
         this.btnLock.x = 5 + _loc1_ * 120;
         this.btnLock.y = -22;
         this.search.x = this.btnLock.x + this.btnLock.width + 5;
         this.search.y = -22;
      }
      
      public function setActiveTab(param1:int) : void
      {
         var _loc2_:BrickSelectorTab = null;
         this.uix.hideAllProperties();
         this.selectedTabNum = param1;
         for each(_loc2_ in this.tabs)
         {
            _loc2_.selected = false;
         }
         this.tabs[param1].selected = true;
         this.uix.hideBrickPackagePopup();
      }
      
      public function currentPageHasBlock(param1:int) : Boolean
      {
         return this.tabs[this.selectedTabNum].currentPageHasBlock(param1);
      }
      
      public function cyclePagesAndTabs(param1:int = 1) : void
      {
         if(!this.tabs[this.selectedTabNum].visible || !this.tabs[this.selectedTabNum].cyclePages(param1))
         {
            this.selectedTabNum += param1;
            if(this.selectedTabNum < 0)
            {
               this.selectedTabNum = this.tabs.length - 1;
            }
            else if(this.selectedTabNum >= this.tabs.length)
            {
               this.selectedTabNum = 0;
            }
            if(this.tabs[this.selectedTabNum].visible)
            {
               this.setActiveTab(this.selectedTabNum);
               this.tabs[this.selectedTabNum].selectPage(param1 == 1 ? 0 : -1);
            }
            else
            {
               this.cyclePagesAndTabs(param1);
            }
         }
      }
      
      public function setLock(param1:Boolean) : void
      {
         this.btnLock.gotoAndStop(param1 ? 2 : 1);
         this.locked = param1;
      }
      
      private function getSearchArray(param1:String) : Array
      {
         var _loc4_:String = null;
         var _loc2_:Array = param1.split(" ");
         var _loc3_:Array = [];
         for each(_loc4_ in _loc2_)
         {
            _loc4_ = StringUtil.trim(_loc4_);
            if(_loc4_.length >= 2)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public function filterPackages(param1:String = "") : void
      {
         var _loc2_:BrickPackage = null;
         var _loc3_:Array = null;
         this.uix.hideBrickPackagePopup();
         this.removeAllPackages(false);
         param1 = StringUtil.trim(param1.toLowerCase());
         for each(_loc2_ in this.packages)
         {
            if(param1.length > 0 && _loc2_.isBlockIdMatch(param1))
            {
               this.removeAllPackages(false);
               this.tabs[this.selectedTabNum].addPackage(_loc2_);
               break;
            }
            _loc3_ = this.getSearchArray(param1);
            if(_loc3_.length == 0)
            {
               _loc2_.restoreContent();
               this.tabs[_loc2_.tabId].addPackage(_loc2_);
            }
            else if(_loc2_.isSearchMatch(_loc3_))
            {
               this.tabs[this.selectedTabNum].addPackage(_loc2_);
            }
         }
         this.redraw();
         this.tabs[this.selectedTabNum].selected = true;
         this.positionTabs();
      }
      
      public function addPackage(param1:BrickPackage) : void
      {
         this.packages.push(param1);
         this.tabs[param1.tabId].addPackage(param1);
         this.positionTabs();
      }
      
      public function removeAllPackages(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.tabs.length)
         {
            this.tabs[_loc2_].removePackages();
            _loc2_++;
         }
         while(this.brickContainer.numChildren > 0)
         {
            this.brickContainer.removeChildAt(0);
         }
         if(param1)
         {
            this.packages = [];
         }
      }
      
      public function getPosition(param1:int) : Point
      {
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.packages.length)
         {
            _loc2_ = this.packages[_loc3_].getPosition(param1) || _loc2_;
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function setSelected(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.packages.length)
         {
            this.packages[_loc2_].setSelected(param1);
            _loc2_++;
         }
      }
      
      override public function get width() : Number
      {
         return Global.fullWidth;
      }
      
      public function redraw() : void
      {
         var _loc1_:int = 0;
         var _loc2_:BrickSelectorTab = null;
         this.setActiveTab(this.selectedTabNum);
         _loc1_ = 0;
         for each(_loc2_ in this.tabs)
         {
            _loc1_ = _loc2_.setMaxY(_loc1_);
         }
         _loc1_ += Global.base.settings.showPackageNames ? 30 : 20;
         var _loc3_:Graphics = this.bg.graphics;
         _loc3_.clear();
         _loc3_.lineStyle(1,8092539,1);
         _loc3_.beginFill(3289649,0.85);
         _loc3_.drawRect(0,0,Global.fullWidth,_loc1_ + 5);
         this.y = -_loc1_ - 35;
         _loc3_ = this.masker.graphics;
         _loc3_.clear();
         _loc3_.beginFill(16777215,1);
         _loc3_.drawRect(-5,-5,Global.fullWidth + 1 + 10,_loc1_ + 10);
         this.totalHeight = _loc1_;
      }
      
      public function setHeight(param1:Boolean) : void
      {
         var isUp:Boolean = param1;
         if(this.isLocked)
         {
            return;
         }
         if(isUp)
         {
            TweenMax.killTweensOf(this);
            TweenMax.to(this,0.2,{"y":-this.totalHeight - 35});
         }
         else
         {
            TweenMax.to(this,0.2,{
               "delay":0.25,
               "y":-38,
               "onComplete":function():void
               {
                  Global.base.ui2instance.hideAllProperties();
               }
            });
         }
      }
      
      private function handleAttach(param1:Event) : void
      {
         this.redraw();
      }
      
      public function get isLocked() : Boolean
      {
         return this.locked;
      }
   }
}


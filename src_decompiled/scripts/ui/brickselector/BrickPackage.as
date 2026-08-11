package ui.brickselector
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import items.ItemBrick;
   import items.ItemId;
   import items.ItemManager;
   import items.ItemTab;
   import mx.utils.StringUtil;
   import ui.HoverLabel;
   import ui2.ui2selector;
   
   public class BrickPackage extends MovieClip
   {
      
      public var content:Vector.<ItemBrick>;
      
      public var tabId:int;
      
      public var title:String;
      
      protected var uix:UI2;
      
      private var tags:Array;
      
      private var highlight:Bitmap = new Bitmap(new ui2selector());
      
      private var rotatableHighlight:Bitmap = new Bitmap(new ui2selector());
      
      private var hoverLabel:HoverLabel = new HoverLabel();
      
      private var hoverTimer:uint;
      
      private var hoverId:int;
      
      private var visibleBlocks:int;
      
      private var defaultVisibleBlocks:int;
      
      private var isPopup:Boolean;
      
      private var textVisible:Boolean;
      
      private var bg:Sprite = new Sprite();
      
      protected var blocks:Sprite = new Sprite();
      
      protected var blocksBitmap:Bitmap;
      
      protected var textField:TextField = new TextField();
      
      private var temporaryContent:Vector.<ItemBrick>;
      
      private var selectedBlockId:int;
      
      public function BrickPackage(param1:String, param2:Vector.<ItemBrick>, param3:UI2, param4:int, param5:Array, param6:Boolean = true, param7:int = 0, param8:Boolean = false)
      {
         super();
         this.title = param1;
         this.content = param2;
         this.uix = param3;
         this.tabId = param4;
         this.tags = param5;
         this.visibleBlocks = param7 > 0 ? int(Math.min(param2.length,param7)) : int(param2.length);
         this.defaultVisibleBlocks = this.visibleBlocks;
         this.isPopup = param8;
         this.textVisible = param6 || param8;
         if(param8)
         {
            addChild(this.bg);
         }
         if(this.textVisible)
         {
            this.addText(param1);
         }
         this.hoverLabel.visible = false;
         this.blocksBitmap = new Bitmap();
         this.blocks.addChild(this.blocksBitmap);
         if(param8 || !param6)
         {
            this.blocks.x = 2;
         }
         else
         {
            this.blocks.x = this.textField.width >= 16 * this.visibleBlocks ? (this.textField.width - 16 * this.visibleBlocks) / 2 : 2;
         }
         this.blocks.y = this.textVisible ? 12 : 0;
         addChild(this.blocks);
         this.updateContent(param1,param2);
         this.blocks.useHandCursor = true;
         this.blocks.buttonMode = true;
         this.blocks.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown);
         if(!this.isCollapsed)
         {
            this.blocks.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            this.blocks.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
            this.blocks.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         }
         this.blocks.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this.blocks.addChild(this.highlight);
         this.blocks.addChild(this.rotatableHighlight);
         this.rotatableHighlight.bitmapData.colorTransform(this.rotatableHighlight.bitmapData.rect,new ColorTransform(0,0,1,1,30,230,255,0));
         this.rotatableHighlight.visible = false;
      }
      
      public function restoreContent() : void
      {
         this.visibleBlocks = this.defaultVisibleBlocks;
         this.updateContent(this.title,this.content,false,true);
      }
      
      private function isMatchIn(param1:String, param2:Array) : Boolean
      {
         var _loc4_:String = null;
         var _loc3_:String = param1.toLowerCase();
         for each(_loc4_ in param2)
         {
            if(StringUtil.trim(_loc3_).indexOf(_loc4_) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function getNonMatchingTerms(param1:Array, param2:Array) : Array
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param2)
         {
            _loc5_ = false;
            for each(_loc6_ in param1)
            {
               _loc6_ = _loc6_.toLowerCase();
               if(_loc6_.indexOf(_loc4_) != -1)
               {
                  _loc5_ = true;
                  break;
               }
            }
            if(!_loc5_)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public function isBlockIdMatch(param1:String) : Boolean
      {
         var _loc2_:ItemBrick = null;
         var _loc3_:Vector.<ItemBrick> = null;
         param1 = StringUtil.trim(param1);
         for each(_loc2_ in this.content)
         {
            if(_loc2_.id.toString() == param1)
            {
               _loc3_ = new Vector.<ItemBrick>();
               _loc3_.push(_loc2_);
               this.updateContent(this.title,_loc3_,true,true);
               return true;
            }
         }
         return false;
      }
      
      public function isSearchMatch(param1:Array) : Boolean
      {
         var _loc3_:ItemBrick = null;
         var _loc4_:Array = null;
         this.restoreContent();
         param1 = this.getNonMatchingTerms([this.title],param1);
         if(param1.length == 0)
         {
            return true;
         }
         param1 = this.getNonMatchingTerms(this.tags,param1);
         if(param1.length == 0)
         {
            return true;
         }
         var _loc2_:Vector.<ItemBrick> = new Vector.<ItemBrick>();
         for each(_loc3_ in this.content)
         {
            _loc4_ = this.getNonMatchingTerms(_loc3_.tags,param1);
            if(_loc4_.length == 0 || this.getNonMatchingTerms(ItemTab.toNamesArray(_loc3_.tab),_loc4_).length == 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(_loc2_.length > 0)
         {
            this.updateContent(this.title,_loc2_,true,true);
            return true;
         }
         return false;
      }
      
      public function updateContent(param1:String, param2:Vector.<ItemBrick>, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc6_:Graphics = null;
         var _loc7_:int = 0;
         if(param4)
         {
            this.temporaryContent = param2;
         }
         else
         {
            this.content = param2;
            this.temporaryContent = null;
         }
         if(param3)
         {
            this.visibleBlocks = param2.length;
         }
         this.updateText(param1);
         this.highlight.visible = false;
         this.highlight.x = 0;
         this.rotatableHighlight.visible = false;
         this.rotatableHighlight.x = 0;
         this.blocksBitmap.bitmapData = new BitmapData(16 * this.visibleBlocks,16,false,4294967295);
         var _loc5_:int = 0;
         while(_loc5_ < this.visibleBlocks)
         {
            ItemManager.bricks[param2[_loc5_].selectorBG].drawTo(this.blocksBitmap.bitmapData,_loc5_ * 16,0);
            param2[_loc5_].drawTo(this.blocksBitmap.bitmapData,_loc5_ * 16,0);
            _loc5_++;
         }
         if(this.isPopup)
         {
            _loc6_ = this.bg.graphics;
            _loc6_.clear();
            _loc6_.lineStyle(1,8092539,1);
            _loc6_.beginFill(3289649,0.85);
            _loc7_ = param2.length * 16 > this.textField.width ? int(param2.length * 16) : int(this.textField.width);
            _loc6_.drawRect(-3,-3,_loc7_ + 8,34);
         }
      }
      
      private function addText(param1:String) : void
      {
         this.textField.embedFonts = true;
         this.textField.selectable = true;
         this.textField.antiAliasType = AntiAliasType.ADVANCED;
         this.textField.mouseEnabled = false;
         this.textField.defaultTextFormat = new TextFormat("visitor",13,16777215);
         addChild(this.textField);
         this.updateText(param1);
      }
      
      private function updateText(param1:String) : void
      {
         if(!this.textVisible)
         {
            return;
         }
         this.textField.text = param1;
         this.textField.width = this.textField.textWidth + 5;
         this.textField.height = this.textField.textHeight + 5;
      }
      
      private function select(param1:int) : void
      {
         if(param1 >= this.visibleBlocks)
         {
            return;
         }
         var _loc2_:int = this.temporaryContent != null ? this.temporaryContent[param1].id : this.content[param1].id;
         this.uix.setSelected(_loc2_);
         this.setSelected(_loc2_);
      }
      
      public function getPosition(param1:int) : Point
      {
         if(!visible)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.visibleBlocks)
         {
            if(this.content[_loc2_].id == param1)
            {
               return new Point(x + _loc2_ * 16 + this.blocks.x + 8,y + this.blocks.y);
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setSelected(param1:int) : void
      {
         var _loc3_:int = 0;
         this.selectedBlockId = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.visibleBlocks)
         {
            _loc3_ = this.temporaryContent != null ? this.temporaryContent[_loc2_].id : this.content[_loc2_].id;
            if(_loc3_ == param1)
            {
               this.highlight.x = _loc2_ * 16;
               this.highlight.visible = true;
               return;
            }
            _loc2_++;
         }
         this.highlight.visible = false;
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:int = this.blocks.mouseX / 16 >> 0;
         if(_loc2_ >= this.visibleBlocks)
         {
            return;
         }
         var _loc3_:ItemBrick = this.temporaryContent != null ? this.temporaryContent[_loc2_] : this.content[_loc2_];
         if(this.isCollapsed)
         {
            this.uix.toggleBrickPackagePopup(this.title,this.content,_loc3_.id == this.selectedBlockId);
         }
         else if(!this.isPopup)
         {
            this.uix.hideBrickPackagePopup();
         }
         this.select(_loc2_);
         this.uix.dragIt(_loc3_);
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            _loc2_ = this.blocks.mouseX / 16 >> 0;
            if(_loc2_ >= this.visibleBlocks)
            {
               return;
            }
            this.hoverTimer = setTimeout(this.showHoverLabel,800);
            this.hoverId = this.temporaryContent != null ? this.temporaryContent[_loc2_].id : this.content[_loc2_].id;
         }
         else
         {
            this.hoverLabel.visible = false;
            clearInterval(this.hoverTimer);
            this.rotatableHighlight.visible = false;
         }
      }
      
      private function handleMouseMove(param1:MouseEvent = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc2_:int = this.blocks.mouseX / 16 >> 0;
         if(_loc2_ >= this.visibleBlocks)
         {
            return;
         }
         this.hoverId = this.temporaryContent != null ? this.temporaryContent[_loc2_].id : this.content[_loc2_].id;
         var _loc3_:Boolean = ItemId.isBlockRotateable(this.hoverId) || this.hoverId == ItemId.SPIKE || this.hoverId == ItemId.SPIKE_SILVER || this.hoverId == ItemId.SPIKE_BLACK || this.hoverId == ItemId.SPIKE_RED || this.hoverId == ItemId.SPIKE_GOLD || this.hoverId == ItemId.SPIKE_GREEN || this.hoverId == ItemId.SPIKE_BLUE || this.hoverId == ItemId.PORTAL || this.hoverId == ItemId.PORTAL_INVISIBLE || this.hoverId == ItemId.TEXT_SIGN;
         if(_loc3_)
         {
            this.rotatableHighlight.x = _loc2_ * 16;
            this.rotatableHighlight.visible = true;
         }
         else
         {
            this.rotatableHighlight.visible = false;
         }
         if(this.hoverLabel.visible)
         {
            _loc4_ = ItemManager.getBlockDescription(this.hoverId);
            _loc5_ = "";
            if(_loc4_.length > 0)
            {
               _loc5_ += _loc4_ + "\n\n";
            }
            _loc5_ += "id: " + this.hoverId;
            if(_loc3_)
            {
               _loc5_ += "\nmorphable";
            }
            if(ItemManager.getBrickById(this.hoverId).requiresOwnership)
            {
               _loc5_ += "\nowner-only";
            }
            if(ItemId.isClimbable(this.hoverId))
            {
               _loc5_ += "\nclimbable";
            }
            if(ItemId.isSlippery(this.hoverId))
            {
               _loc5_ += "\nslippery";
            }
            if(ItemId.canJumpThroughFromBelow(this.hoverId))
            {
               _loc5_ += "\none-way";
            }
            _loc6_ = this.tags.concat(ItemManager.getBlockTags(this.hoverId));
            if(_loc6_.length > 0)
            {
               _loc5_ += "\n\ntags:\n" + _loc6_.join(", ");
            }
            this.hoverLabel.draw(_loc5_);
            this.hoverLabel.x = this.uix.mouseX;
            if(this.hoverLabel.x > this.uix.width / 2)
            {
               this.hoverLabel.x -= this.hoverLabel.w + 12;
            }
            else
            {
               this.hoverLabel.x += 12;
            }
            if(this.uix.mouseY + this.hoverLabel.height / 2 > -12)
            {
               this.hoverLabel.y = -this.hoverLabel.height - 12;
            }
            else
            {
               this.hoverLabel.y = this.uix.mouseY - this.hoverLabel.height / 2;
            }
         }
      }
      
      private function handleKeyDown(param1:KeyboardEvent = null) : void
      {
         var _loc2_:int = 0;
         if(this.hoverId >= 0)
         {
            _loc2_ = param1.keyCode - 48;
            if(_loc2_ >= 1 && _loc2_ <= 9)
            {
               Global.base.ui2instance.favoriteBricks.setDefault(_loc2_,ItemManager.bricks[this.hoverId]);
            }
         }
      }
      
      private function showHoverLabel() : void
      {
         if(!this.uix.contains(this.hoverLabel))
         {
            this.uix.addChild(this.hoverLabel);
         }
         this.hoverLabel.alpha = 0;
         TweenMax.to(this.hoverLabel,0.25,{"alpha":1});
         this.hoverLabel.draw(this.hoverId.toString());
         this.hoverLabel.visible = true;
         this.handleMouseMove();
      }
      
      private function get isCollapsed() : Boolean
      {
         return this.visibleBlocks < this.content.length;
      }
   }
}


package ui
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import sample.ui.components.scroll.ScrollBox;
   import ui.profile.FillBox;
   
   public class DropDownList extends Sprite
   {
      
      private var arrow:Sprite;
      
      public var arrowContainer:Sprite;
      
      public var overlayContainer:Sprite;
      
      public var dropDownListContainer:Sprite;
      
      public var inputBox:TextField;
      
      public var ow:Number;
      
      public var oh:Number = 23;
      
      private var dropDownContainerHeight:Number = 140;
      
      private var canEditInput:Boolean;
      
      private var listOpen:Boolean = false;
      
      private var items:Array = null;
      
      private var scroll:ScrollBox;
      
      private var scrollContents:FillBox;
      
      private var dropShadow:DropShadowFilter;
      
      public function DropDownList(param1:Number, param2:Array, param3:Boolean = false)
      {
         var ow:Number = param1;
         var items:Array = param2;
         var canEditInput:Boolean = param3;
         super();
         this.ow = ow;
         this.items = items;
         this.canEditInput = canEditInput;
         this.dropShadow = new DropShadowFilter(1,75,0,1,5,5,0.5,1,true);
         this.arrowContainer = new Sprite();
         this.arrowContainer.buttonMode = true;
         this.arrowContainer.useHandCursor = true;
         this.arrowContainer.mouseEnabled = true;
         this.arrowContainer.addEventListener(MouseEvent.CLICK,function():void
         {
            showDropDownList(!listOpen);
         });
         addChild(this.arrowContainer);
         this.arrow = new Sprite();
         this.arrowContainer.addChild(this.arrow);
         this.arrowContainer.mouseChildren = false;
         this.inputBox = new TextField();
         this.inputBox.defaultTextFormat = new TextFormat("Trebuchet MS",14,0);
         this.inputBox.x = 10;
         this.inputBox.width = ow - (25 + this.inputBox.x);
         this.inputBox.height = this.oh;
         this.inputBox.type = canEditInput ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         this.inputBox.selectable = canEditInput;
         this.inputBox.filters = [this.dropShadow];
         addChild(this.inputBox);
         if(!canEditInput)
         {
            this.overlayContainer = new Sprite();
            this.overlayContainer.buttonMode = true;
            this.overlayContainer.useHandCursor = true;
            this.overlayContainer.mouseEnabled = true;
            this.overlayContainer.mouseChildren = false;
            this.overlayContainer.addEventListener(MouseEvent.CLICK,function():void
            {
               showDropDownList(!listOpen);
            });
            addChild(this.overlayContainer);
         }
         this.dropDownListContainer = new Sprite();
         this.dropDownListContainer.filters = [this.dropShadow];
         this.dropDownListContainer.visible = false;
         addChildAt(this.dropDownListContainer,0);
         this.initDropDownList();
         this.inputBox.text = (this.items[0] as DropDownListItem).text;
         this.redraw();
      }
      
      public function showItemNotFound(param1:String) : void
      {
         this.items = [];
         var _loc2_:DropDownListItem = new DropDownListItem(param1,this.ow,null);
         this.items.push(_loc2_);
         this.setItemsArray(this.items);
      }
      
      public function setItemsArray(param1:Array) : void
      {
         var i:int = 0;
         var isDropDownListItem:Boolean = false;
         var item:DropDownListItem = null;
         var newItems:Array = param1;
         this.scrollContents.removeAllChildren();
         this.items = [];
         if(newItems != null && newItems.length > 0)
         {
            i = 0;
            while(i < newItems.length)
            {
               isDropDownListItem = Boolean(newItems[i] as DropDownListItem);
               item = null;
               if(isDropDownListItem)
               {
                  item = newItems[i] as DropDownListItem;
               }
               else
               {
                  item = new DropDownListItem(newItems[i],this.ow,function(param1:MouseEvent):void
                  {
                     var _loc2_:* = param1.target as DropDownListItem;
                     inputBox.text = _loc2_.text;
                     showDropDownList(false);
                  });
               }
               this.items.push(item);
               this.scrollContents.addChild(item);
               this.scrollContents.refresh();
               this.scroll.refresh();
               if(this.scrollContents.numChildren < 7)
               {
                  this.scroll.height = item.height * this.scrollContents.numChildren + 10;
                  this.dropDownContainerHeight = this.scroll.height;
               }
               else
               {
                  this.scroll.height = this.dropDownContainerHeight;
               }
               i++;
            }
         }
         this.redraw();
      }
      
      private function initDropDownList() : void
      {
         this.scrollContents = new FillBox(0,this.ow);
         this.scrollContents.forceScale = false;
         this.scroll = new ScrollBox().margin(3,3,3,3).add(this.scrollContents);
         this.scroll.visible = false;
         this.scroll.scrollMultiplier = 6;
         this.scroll.width = this.ow - 5;
         this.dropDownListContainer.addChild(this.scroll);
         this.setItemsArray(this.items);
         this.redraw();
      }
      
      private function redraw() : void
      {
         graphics.clear();
         graphics.beginFill(16777215);
         graphics.drawRoundRect(0,0,this.ow,this.oh,5,5);
         graphics.endFill();
         if(!this.canEditInput)
         {
            this.overlayContainer.graphics.clear();
            this.overlayContainer.graphics.beginFill(0,0);
            this.overlayContainer.graphics.drawRoundRect(0,0,this.ow,this.oh,5,5);
            this.overlayContainer.graphics.endFill();
         }
         this.arrowContainer.graphics.clear();
         this.arrowContainer.graphics.beginFill(0,0);
         this.arrowContainer.graphics.drawRect(0,0,25,this.oh);
         this.arrowContainer.graphics.endFill();
         this.arrowContainer.x = this.ow - 25;
         this.arrow.graphics.clear();
         this.arrow.graphics.beginFill(12237498);
         this.arrow.graphics.moveTo(0,0);
         this.arrow.graphics.lineTo(13,0);
         this.arrow.graphics.lineTo(13 / 2,8);
         this.arrow.graphics.lineTo(0,0);
         this.arrow.graphics.endFill();
         this.arrow.x = (25 - 13) / 2;
         this.arrow.y = (this.oh - 8) / 2;
         this.dropDownListContainer.graphics.clear();
         this.dropDownListContainer.graphics.beginFill(16777215);
         this.dropDownListContainer.graphics.drawRoundRectComplex(0,0,this.ow - 5,this.dropDownContainerHeight,0,0,5,5);
         this.dropDownListContainer.x = 5;
         this.dropDownListContainer.y = this.oh;
      }
      
      private function flipArrow() : void
      {
         this.listOpen = !this.listOpen;
         switch(this.listOpen)
         {
            case true:
               this.arrow.graphics.clear();
               this.arrow.graphics.beginFill(12237498);
               this.arrow.graphics.moveTo(0,8);
               this.arrow.graphics.lineTo(13 / 2,0);
               this.arrow.graphics.lineTo(13,8);
               this.arrow.graphics.lineTo(0,8);
               this.arrow.graphics.endFill();
               break;
            case false:
               this.arrow.graphics.clear();
               this.arrow.graphics.beginFill(12237498);
               this.arrow.graphics.moveTo(0,0);
               this.arrow.graphics.lineTo(13,0);
               this.arrow.graphics.lineTo(13 / 2,8);
               this.arrow.graphics.lineTo(0,0);
               this.arrow.graphics.endFill();
         }
      }
      
      public function showDropDownList(param1:Boolean) : void
      {
         this.flipArrow();
         this.dropDownListContainer.visible = param1;
         TweenMax.to(this.dropDownListContainer,0.4,{"alpha":(param1 ? 1 : 0)});
         this.scroll.visible = param1;
         TweenMax.to(this.scroll,0.4,{"alpha":(param1 ? 1 : 0)});
      }
   }
}


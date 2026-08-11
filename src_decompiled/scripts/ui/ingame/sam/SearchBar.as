package ui.ingame.sam
{
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import mx.utils.StringUtil;
   
   public class SearchBar extends Sprite
   {
      
      private var smileySelector:SmileyMenu;
      
      private var search:TextField;
      
      public var oHeight:int = 28;
      
      public var oWidth:int = 240;
      
      private var cross:SimpleButton = new SimpleButton();
      
      private var tempSmileys:Array = [];
      
      public function SearchBar(param1:SmileyMenu)
      {
         super();
         this.smileySelector = param1;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
      }
      
      protected function updateFilter(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:SmileyInstance = null;
         var _loc4_:String = null;
         this.tempSmileys = [];
         if(this.search.text.length > 0)
         {
            _loc2_ = StringUtil.trim(this.search.text.toLowerCase());
            for each(_loc3_ in this.smileySelector.smilies)
            {
               _loc4_ = _loc3_.item.name.toLowerCase();
               if(_loc4_.indexOf(_loc2_) >= 0 || _loc3_.item.id.toString().indexOf(_loc2_) >= 0)
               {
                  if(this.tempSmileys.indexOf(_loc3_) == -1)
                  {
                     this.tempSmileys.push(_loc3_);
                  }
               }
            }
         }
         this.smileySelector.redraw(this.tempSmileys,this.search.text);
      }
      
      private function redraw() : void
      {
         graphics.clear();
         graphics.lineStyle(1,8092539);
         graphics.beginFill(3289650);
         graphics.drawRect(0,0,this.oWidth,this.oHeight);
         graphics.endFill();
         graphics.beginFill(4473924);
         graphics.drawRoundRect(this.search.x,this.search.y,this.search.width,this.search.height,5,5);
         graphics.endFill();
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,16,16);
         _loc1_.graphics.endFill();
         _loc1_.graphics.lineStyle(2,13421772);
         _loc1_.graphics.moveTo(3,3);
         _loc1_.graphics.lineTo(11,11);
         _loc1_.graphics.moveTo(3,11);
         _loc1_.graphics.lineTo(11,3);
         _loc1_.graphics.endFill();
         this.cross.overState = this.cross.downState = this.cross.upState = this.cross.hitTestState = _loc1_;
      }
      
      protected function handleAttach(param1:Event) : void
      {
         var handleEvent:Function = null;
         var e:Event = param1;
         handleEvent = function(param1:Event):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         };
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         this.search = new TextField();
         this.search.defaultTextFormat = new TextFormat("Arial",11,16777215);
         this.search.antiAliasType = AntiAliasType.NORMAL;
         this.search.restrict = "a-zA-Z0-9^ ";
         this.search.maxChars = 25;
         this.search.selectable = true;
         this.search.type = TextFieldType.INPUT;
         this.search.width = this.oWidth - 25;
         this.search.height = this.oHeight - 12;
         this.search.x = 5;
         this.search.y = (this.oHeight - this.search.height) / 2;
         this.blurred(null);
         addChild(this.search);
         this.search.addEventListener(Event.CHANGE,this.updateFilter);
         this.search.addEventListener(MouseEvent.MOUSE_DOWN,handleEvent);
         this.search.addEventListener(KeyboardEvent.KEY_UP,handleEvent);
         this.search.addEventListener(FocusEvent.FOCUS_IN,this.focused);
         this.search.addEventListener(FocusEvent.FOCUS_OUT,this.blurred);
         this.search.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            handleEvent(param1);
            if(param1.keyCode != Keyboard.ESCAPE)
            {
               return;
            }
            if(search.text == "")
            {
               Global.base.ui2instance.hideAll();
            }
            else
            {
               search.text = "";
               updateFilter(param1);
            }
         });
         this.cross.x = this.oWidth - 17;
         this.cross.y = 7;
         this.cross.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            search.text = "";
            updateFilter(null);
            stage.focus = search;
         });
         addChild(this.cross);
         this.redraw();
      }
      
      protected function focused(param1:FocusEvent) : void
      {
         this.search.textColor = 16777215;
         if(this.search.text.indexOf("Search...") != -1)
         {
            this.search.text = "";
         }
      }
      
      protected function blurred(param1:FocusEvent) : void
      {
         if(this.search.text == "")
         {
            this.search.text = "Search...";
            this.search.textColor = 11184810;
         }
      }
   }
}


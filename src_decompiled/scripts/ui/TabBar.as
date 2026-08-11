package ui
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TabBar extends Sprite
   {
      
      private var _spacing:Number = 0;
      
      public var tabs:Vector.<Tab>;
      
      private var _width:Number = 100;
      
      public function TabBar()
      {
         super();
         mouseEnabled = false;
         this.tabs = new Vector.<Tab>();
         addEventListener(MouseEvent.MOUSE_DOWN,this.handleTab,false,0,true);
      }
      
      protected function handleTab(param1:MouseEvent) : void
      {
         var _loc2_:Tab = param1.target as Tab;
         this.setSelected(_loc2_.id);
      }
      
      public function addTab(param1:int, param2:String, param3:int) : Tab
      {
         var _loc4_:Tab = new Tab(param1,param2,param3);
         this.tabs.push(_loc4_);
         addChild(_loc4_);
         return _loc4_;
      }
      
      public function setSelected(param1:int, param2:Boolean = true) : void
      {
         if(param2)
         {
            this.deselectAll();
         }
         this.getTab(param1).selected = true;
      }
      
      public function deselectAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.tabs.length)
         {
            this.tabs[_loc1_].selected = false;
            _loc1_++;
         }
      }
      
      public function getTab(param1:int) : Tab
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.tabs.length)
         {
            if(this.tabs[_loc2_].id == param1)
            {
               return this.tabs[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function redraw() : void
      {
         var _loc4_:int = 0;
         var _loc1_:int = this._width;
         var _loc2_:Number = (this._width - (this.tabs.length - 1) * this._spacing) / this.tabs.length;
         var _loc3_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < this.tabs.length)
         {
            this.tabs[_loc4_].x = (_loc2_ + this._spacing) * _loc4_ >> 0;
            this.tabs[_loc4_].width = _loc2_;
            _loc4_++;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this.redraw();
      }
      
      public function get spacing() : Number
      {
         return this._spacing;
      }
      
      public function set spacing(param1:Number) : void
      {
         this._spacing = param1;
      }
   }
}


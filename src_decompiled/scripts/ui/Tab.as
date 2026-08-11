package ui
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Tab extends asset_tab
   {
      
      public static const ICON_CROWN:uint = 1;
      
      public static const ICON_SMILEY:uint = 2;
      
      public static const ICON_BRICK:uint = 3;
      
      public static const ICON_WORLD:uint = 4;
      
      public static const ICON_BOOK:uint = 5;
      
      public static const ICON_LIGHTNING:uint = 6;
      
      public static const ICON_AURA:uint = 7;
      
      public static const ICON_CREW:uint = 8;
      
      public static const ICON_SERVICES:uint = 9;
      
      public static const ICON_NPC:uint = 10;
      
      private var _selected:Boolean = false;
      
      private var _width:Number;
      
      private var _id:int;
      
      public function Tab(param1:int, param2:String, param3:int)
      {
         super();
         mouseEnabled = true;
         mouseChildren = false;
         useHandCursor = true;
         buttonMode = true;
         this._id = param1;
         tf_label.text = param2;
         this.icon.gotoAndStop(param3);
         bg.stop();
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse,false,0,true);
      }
      
      protected function handleMouse(param1:Event) : void
      {
         if(!this._selected)
         {
            bg.gotoAndStop(param1.type == MouseEvent.MOUSE_OVER ? 2 : 1);
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         bg.gotoAndStop(this._selected ? 2 : 1);
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this.redraw();
      }
      
      public function redraw() : void
      {
         bg.width = this._width;
         tf_label.width = this._width - tf_label.x;
      }
      
      public function get id() : int
      {
         return this._id;
      }
   }
}


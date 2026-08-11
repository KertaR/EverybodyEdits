package ui
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class DropDownListItem extends Sprite
   {
      
      private var showHighlight:Boolean = false;
      
      public var text:String;
      
      private var title:TextField;
      
      private var ow:Number;
      
      private var callBack:Function;
      
      public function DropDownListItem(param1:String, param2:Number, param3:Function)
      {
         super();
         this.text = param1;
         this.ow = param2;
         this.title = new TextField();
         this.title.defaultTextFormat = new TextFormat("Trebuchet MS",14,0);
         this.title.text = param1;
         this.title.x = 20;
         this.title.autoSize = TextFieldAutoSize.LEFT;
         this.title.mouseEnabled = false;
         addChild(this.title);
         if(param3 != null)
         {
            this.callBack = param3;
            buttonMode = true;
            useHandCursor = true;
            mouseChildren = false;
            addEventListener(MouseEvent.CLICK,this.handleMouse);
            addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
         }
         mouseEnabled = param3 != null;
         this.redraw();
      }
      
      private function redraw() : void
      {
         graphics.clear();
         graphics.beginFill(this.showHighlight ? 13421772 : 16777215);
         graphics.drawRect(0,0,this.ow,height);
         graphics.endFill();
      }
      
      protected function handleMouse(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               this.callBack(param1);
               break;
            case MouseEvent.MOUSE_OVER:
               this.showHighlight = true;
               break;
            case MouseEvent.MOUSE_OUT:
               this.showHighlight = false;
         }
         this.redraw();
      }
   }
}


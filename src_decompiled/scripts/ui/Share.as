package ui
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class Share extends asset_share
   {
      
      public function Share(param1:String, param2:String)
      {
         var title:String = param1;
         var dtext:String = param2;
         super();
         this.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         headline.text = title;
         inputvar.text = dtext;
      }
      
      private function stopEvent(param1:Event) : void
      {
      }
   }
}


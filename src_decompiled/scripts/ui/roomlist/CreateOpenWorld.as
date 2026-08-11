package ui.roomlist
{
   import flash.events.MouseEvent;
   
   public class CreateOpenWorld extends assets_createopenworld
   {
      
      public function CreateOpenWorld()
      {
         super();
         btn.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.START_OPENWORLD,true,false);
            dispatchEvent(_loc2_);
         });
      }
   }
}


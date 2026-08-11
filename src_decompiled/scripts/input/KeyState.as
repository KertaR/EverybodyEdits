package input
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   
   public class KeyState
   {
      
      private static var stage:Stage;
      
      private static var key:Object;
      
      public function KeyState()
      {
         super();
      }
      
      public static function activate(param1:Stage) : void
      {
         stage = param1;
         key = {};
         stage.addEventListener(KeyboardEvent.KEY_DOWN,handleKey,false,0,true);
         stage.addEventListener(KeyboardEvent.KEY_UP,handleKey,false,0,true);
         stage.addEventListener(Event.DEACTIVATE,handleDeactivate,false,0,true);
      }
      
      protected static function handleDeactivate(param1:Event) : void
      {
         key = {};
      }
      
      public static function deactivate() : void
      {
         try
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleKey);
            stage.removeEventListener(KeyboardEvent.KEY_UP,handleKey);
         }
         catch(e:Error)
         {
         }
      }
      
      private static function handleKey(param1:KeyboardEvent) : void
      {
         key[param1.keyCode] = param1.type == KeyboardEvent.KEY_DOWN;
      }
      
      public static function isKeyDown(param1:uint) : Boolean
      {
         return key[param1] != null && Boolean(key[param1]);
      }
   }
}


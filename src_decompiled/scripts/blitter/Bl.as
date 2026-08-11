package blitter
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import playerio.DatabaseObject;
   
   public class Bl
   {
      
      public static var stage:Stage;
      
      public static var overlayContainer:Sprite;
      
      public static var screenContainer:Bitmap;
      
      public static var width:Number;
      
      public static var height:Number;
      
      private static var last:Number = 0;
      
      private static var keys:Object = {};
      
      public static var justPressedKeys:Object = {};
      
      public static var justReleasedKeys:Object = {};
      
      private static var mouseDown:Boolean = false;
      
      private static var mouseJustPressed:Boolean = false;
      
      private static var middleMouseJustPressed:Boolean = false;
      
      private static var middleMouseDown:Boolean = false;
      
      public static var data:Object = {};
      
      public static var StaffObject:DatabaseObject = null;
      
      public static var PatronsObject:DatabaseObject = null;
      
      private static var shiftState:Boolean = false;
      
      public function Bl()
      {
         super();
      }
      
      public static function init(param1:Stage, param2:Number, param3:Number) : void
      {
         width = param2;
         height = param3;
         stage = param1;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,handleKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,handleKeyUp);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
         stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
         stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,handleMiddleMouseDown);
         stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,handleMiddleMouseUp);
         last = new Date().time;
      }
      
      public static function get time() : Number
      {
         return last;
      }
      
      public static function set time(param1:Number) : void
      {
         last = param1;
      }
      
      public static function get mouseX() : Number
      {
         return (screenContainer || stage).mouseX;
      }
      
      public static function get mouseY() : Number
      {
         return (screenContainer || stage).mouseY;
      }
      
      public static function get isMouseDown() : Boolean
      {
         return mouseDown;
      }
      
      public static function get isMouseJustPressed() : Boolean
      {
         return mouseJustPressed;
      }
      
      public static function get isMiddleMouseDown() : Boolean
      {
         return middleMouseDown;
      }
      
      public static function get isMiddleMouseJustPressed() : Boolean
      {
         return middleMouseJustPressed;
      }
      
      public static function isKeyDown(param1:int) : Boolean
      {
         return keys[param1] ? true : false;
      }
      
      public static function isKeyJustPressed(param1:int) : Boolean
      {
         return justPressedKeys[param1] ? true : false;
      }
      
      public static function isKeyJustReleased(param1:int) : Boolean
      {
         return justReleasedKeys[param1] ? true : false;
      }
      
      public static function exitFrame() : void
      {
         resetJustPressed();
      }
      
      public static function resetJustPressed() : void
      {
         justPressedKeys = {};
         justReleasedKeys = {};
         mouseJustPressed = false;
         middleMouseJustPressed = false;
      }
      
      public static function get shiftKey() : Boolean
      {
         return shiftState;
      }
      
      protected static function handleMouseDown(param1:MouseEvent) : void
      {
         shiftState = param1.shiftKey;
         mouseDown = true;
         mouseJustPressed = true;
      }
      
      protected static function handleMouseUp(param1:MouseEvent) : void
      {
         shiftState = param1.shiftKey;
         mouseDown = false;
      }
      
      protected static function handleMiddleMouseDown(param1:MouseEvent) : void
      {
         middleMouseJustPressed = true;
         middleMouseDown = true;
      }
      
      protected static function handleMiddleMouseUp(param1:MouseEvent) : void
      {
         middleMouseDown = false;
      }
      
      protected static function handleKeyDown(param1:KeyboardEvent) : void
      {
         shiftState = param1.shiftKey;
         if(!keys[param1.keyCode] && !Global.inGameSettings)
         {
            justPressedKeys[param1.keyCode] = true;
            keys[param1.keyCode] = true;
         }
      }
      
      protected static function handleKeyUp(param1:KeyboardEvent) : void
      {
         shiftState = param1.shiftKey;
         if(Boolean(keys[param1.keyCode]) && !Global.inGameSettings)
         {
            justReleasedKeys[param1.keyCode] = true;
         }
         delete keys[param1.keyCode];
      }
   }
}


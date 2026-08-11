package ui.brickoverlays
{
   import ui2.ui2properties;
   
   public class PropertiesBackground extends ui2properties
   {
      
      public function PropertiesBackground()
      {
         super();
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         bg.width = param1;
         bg.height = param2 - 10;
         bg.x = -param1 / 2;
         bg.y = -param2;
         arrow.x = -arrow.width / 2;
         arrow.y = -10;
      }
      
      public function incrementValue(param1:int = 1) : void
      {
      }
      
      public function decrementValue(param1:int = 1) : void
      {
      }
   }
}


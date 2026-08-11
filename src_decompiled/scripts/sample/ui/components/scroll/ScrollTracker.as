package sample.ui.components.scroll
{
   import sample.ui.components.Box;
   import sample.ui.components.SampleButton;
   
   public class ScrollTracker extends SampleButton
   {
      
      public function ScrollTracker(param1:Function = null)
      {
         super(param1);
         _width = 20;
         _height = 20;
         this.upState = new Box().margin(0,0,0,0).fill(10066329,1,3);
         this.downState = new Box().margin(0,0,0,0).fill(8947848,1,3);
         this.overState = new Box().margin(0,0,0,0).fill(16777215,1,3);
         this.hitTestState = new Box().margin(0,0,0,0).fill(12303291,1,3);
      }
   }
}


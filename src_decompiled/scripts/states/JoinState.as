package states
{
   import blitter.BlState;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class JoinState extends BlState
   {
      
      protected static var bg:Class = JoinState_bg;
      
      protected var background:Bitmap = new bg();
      
      protected var p:Point = new Point();
      
      public function JoinState()
      {
         super();
         if(Global.stage != null)
         {
            try
            {
               if(Global.stage.numChildren > 1)
               {
                  Global.stage.addChildAt(this.background,1);
               }
               else
               {
                  Global.stage.addChild(this.background);
               }
            }
            catch(e:Error)
            {
               Global.stage.addChild(this.background);
            }
         }
      }
      
      override public function enterFrame() : void
      {
         if(Global.stage != null)
         {
            this.background.x = (Global.stage.stageWidth - this.background.width) / 2 >> 0;
         }
      }
      
      override public function draw(param1:BitmapData, param2:int, param3:int) : void
      {
         if(this.background != null && this.background.bitmapData != null)
         {
            param1.copyPixels(this.background.bitmapData,this.background.bitmapData.rect,this.p);
         }
      }
      
      override public function killed() : void
      {
         if(this.background != null && this.background.parent != null)
         {
            this.background.parent.removeChild(this.background);
         }
      }
   }
}

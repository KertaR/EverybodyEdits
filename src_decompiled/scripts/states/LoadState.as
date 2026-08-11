package states
{
   import blitter.BlState;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class LoadState extends BlState
   {
      
      private static var loadingscreen:Class = LoadState_loadingscreen;
      
      protected var bmdata:BitmapData = new loadingscreen().bitmapData;
      
      protected var color:Number = 0;
      
      protected var modifier:Number = 0.05;
      
      protected var p:Point = new Point();
      
      protected var callback:Function;
      
      protected var bmd:BitmapData = new BitmapData(850,500,true,0);
      
      protected var bm:Bitmap = new Bitmap(this.bmd);
      
      public function LoadState()
      {
         super();
         Global.stage.frameRate = 60;
      }
      
      public function removeBitmap() : void
      {
         this.color = 0;
         this.modifier = 0;
         if(this.bm != null && this.bm.parent != null)
         {
            this.bm.parent.removeChild(this.bm);
         }
      }

      override public function enterFrame() : void
      {
         if(this.color <= 0 && this.callback != null)
         {
            if(this.bm != null && this.bm.parent != null)
            {
               this.bm.parent.removeChild(this.bm);
            }
            var cb:Function = this.callback;
            this.callback = null;
            cb();
            return;
         }
         this.color += this.modifier;
         if(this.color > 1)
         {
            this.color = 1;
         }
         if(this.color < 0)
         {
            this.color = 0;
         }
         if(Global.base != null)
         {
            if(!this.bm.parent)
            {
               Global.base.addChildAt(this.bm, Math.min(1, Global.base.numChildren));
            }
            this.bm.x = (Global.base.stage ? (Global.base.stage.stageWidth - this.bm.width) / 2 : 0) >> 0;
         }
         else if(Global.stage != null && !this.bm.parent)
         {
            Global.stage.addChild(this.bm);
         }
         this.bmd.copyPixels(this.bmdata,this.bmdata.rect,this.p);
         this.bmd.colorTransform(this.bmd.rect,new ColorTransform(1,1,1,this.color));
         super.enterFrame();
      }
      
      override public function draw(param1:BitmapData, param2:int, param3:int) : void
      {
         param1.fillRect(param1.rect,0);
      }
      
      public function fadeOut(param1:Function) : void
      {
         this.color = 1;
         this.modifier = -0.05;
         this.callback = param1;
      }
   }
}

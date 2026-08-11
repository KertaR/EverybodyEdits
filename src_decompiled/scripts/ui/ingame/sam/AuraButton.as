package ui.ingame.sam
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class AuraButton extends MovieClip
   {
      
      private static var Aura:Class = AuraButton_Aura;
      
      private static var aura:BitmapData = new Aura().bitmapData;
      
      private var auraBMD:BitmapData = new BitmapData(30,28,true,0);
      
      private var auraBM:Bitmap;
      
      public function AuraButton()
      {
         super();
         buttonMode = true;
         useHandCursor = true;
         this.auraBMD = new BitmapData(30,28,true,0);
         this.auraBM = new Bitmap(this.auraBMD);
         addChild(this.auraBM);
         this.setActive(false);
      }
      
      public function setActive(param1:Boolean) : void
      {
         this.auraBMD.copyPixels(aura,new Rectangle(param1 ? 30 : 0,0,30,28),new Point());
      }
   }
}


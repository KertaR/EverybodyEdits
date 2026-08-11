package ui.ingame.sam
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import items.ItemManager;
   
   public class SmileyButton extends MovieClip
   {
      
      private static var Aura:Class = SmileyButton_Aura;
      
      private static var aura:BitmapData = new Aura().bitmapData;
      
      private var auraBMD:BitmapData = new BitmapData(30,28,true,0);
      
      private var auraBM:Bitmap;
      
      public var smiley:SmileyInstance;
      
      public function SmileyButton()
      {
         super();
         buttonMode = true;
         useHandCursor = true;
         this.auraBMD = new BitmapData(30,28,true,0);
         this.auraBM = new Bitmap(this.auraBMD);
         addChild(this.auraBM);
         this.setActive(false);
      }
      
      public function setSelectedSmiley(param1:int) : void
      {
         if(Boolean(this.smiley) && contains(this.smiley))
         {
            removeChild(this.smiley);
         }
         this.smiley = new SmileyInstance(ItemManager.getSmileyById(param1),null,Global.playerInstance.wearsGoldSmiley,-1,false);
         this.smiley.buttonMode = true;
         this.smiley.useHandCursor = true;
         this.smiley.x = (width - 26) / 2;
         this.smiley.y = (height - 26) / 2;
         addChild(this.smiley);
      }
      
      public function setActive(param1:Boolean) : void
      {
         this.auraBMD.copyPixels(aura,new Rectangle(param1 ? 30 : 0,0,30,28),new Point());
      }
   }
}


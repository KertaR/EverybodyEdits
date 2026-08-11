package ui.ingame.sam
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import items.ItemAuraColor;
   
   public class AuraColorButton extends MovieClip
   {
      
      private static var Aura:Class = AuraColorButton_Aura;
      
      private static var aura:BitmapData = new Aura().bitmapData;
      
      private var bmd:BitmapData;
      
      public var color:ItemAuraColor;
      
      public function AuraColorButton(param1:ItemAuraColor, param2:Function)
      {
         var bm:Bitmap;
         var color:ItemAuraColor = param1;
         var callback:Function = param2;
         this.bmd = new BitmapData(10,10,true,0);
         super();
         this.color = color;
         this.bmd.copyPixels(aura,new Rectangle(color.id * 10,0,10,10),new Point(0,0));
         bm = new Bitmap(this.bmd);
         addChild(bm);
         if(callback == null)
         {
            return;
         }
         addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            callback(color.id);
         });
      }
   }
}


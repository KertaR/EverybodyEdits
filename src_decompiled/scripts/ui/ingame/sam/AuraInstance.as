package ui.ingame.sam
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import items.ItemAuraShape;
   
   public class AuraInstance extends Sprite
   {
      
      private var _item:ItemAuraShape;
      
      private var ss:UI2;
      
      private var bm:Bitmap;
      
      public function AuraInstance(param1:ItemAuraShape, param2:UI2)
      {
         super();
         this._item = param1;
         this.ss = param2;
         this.bm = new Bitmap(param1.auras[param1.generated ? Global.playerObject.auraColor : 0].bmd);
         var _loc3_:Sprite = new Sprite();
         _loc3_.addChild(this.bm);
         addChild(_loc3_);
      }
      
      public function changeColor(param1:int) : void
      {
         this.bm.bitmapData = this.item.auras[this.item.generated ? param1 : 0].bmd;
      }
      
      public function get item() : ItemAuraShape
      {
         return this._item;
      }
   }
}


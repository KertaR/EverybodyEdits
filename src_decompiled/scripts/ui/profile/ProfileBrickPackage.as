package ui.profile
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import items.ItemBrick;
   import items.ItemBrickPackage;
   import items.ItemManager;
   import sample.ui.components.*;
   
   public class ProfileBrickPackage extends Box
   {
      
      private var bm:Bitmap;
      
      public function ProfileBrickPackage(param1:ItemBrickPackage, param2:Vector.<ItemBrick>)
      {
         var _loc6_:int = 0;
         super();
         border(1,3355443,1);
         fill(1118481,1,5);
         margin(NaN,NaN,0);
         var _loc3_:Label = new Label(param1.name,12,"left",16777215,false,"visitor");
         addChild(_loc3_);
         var _loc4_:BitmapData = new BitmapData(param2.length * 17 + 1,18,false,0);
         this.bm = new Bitmap(_loc4_);
         addChild(this.bm);
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc6_ = 0;
            _loc4_.copyPixels(ItemManager.bricks[_loc6_].bmd,ItemManager.bricks[_loc6_].bmd.rect,new Point(_loc5_ * 17 + 1,1));
            _loc4_.copyPixels(param2[_loc5_].bmd,param2[_loc5_].bmd.rect,new Point(_loc5_ * 17 + 1,1));
            _loc5_++;
         }
         this.width = width + 2;
         this.height = 31;
         _loc3_.x = 1;
         _loc3_.y = 1;
         this.bm.y = 12;
      }
   }
}


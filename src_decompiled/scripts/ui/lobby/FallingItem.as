package ui.lobby
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import items.ItemManager;
   
   public class FallingItem extends Sprite
   {
      
      private var rotSpeed:Number;
      
      private var fallSpeed:Number;
      
      private var particleMode:String;
      
      public function FallingItem(param1:int, param2:int, param3:int, param4:String)
      {
         var _loc5_:BitmapData = null;
         this.rotSpeed = Math.random() * 0.45 + 0.1;
         this.fallSpeed = Math.random() * 0.8 + 0.2;
         this.particleMode = FallingItemMode.NONE;
         super();
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.particleMode = param4;
         this.x = param2;
         this.y = param3;
         this.scaleX = this.scaleY = Math.random() * 2 + 0.5;
         if(param4 == FallingItemMode.LEAVES)
         {
            _loc5_ = new BitmapData(10,6);
            if(param1 == 14)
            {
               _loc5_.copyPixels(ItemManager.sprParticles.bmd,new Rectangle(70,0,10,6),new Point(0,0));
            }
            if(param1 == 15)
            {
               _loc5_.copyPixels(ItemManager.sprParticles.bmd,new Rectangle(80,0,10,6),new Point(0,0));
            }
         }
         else
         {
            _loc5_ = new BitmapData(5,5);
            ItemManager.sprParticles.frame = param1;
            ItemManager.sprParticles.drawPoint(_loc5_,new Point(0,0));
         }
         var _loc6_:Bitmap = new Bitmap(_loc5_);
         addChild(_loc6_);
      }
      
      public function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = 0;
         if(this.particleMode == FallingItemMode.SNOW)
         {
            _loc2_ = 0;
            this.rotation += this.rotSpeed;
            this.scaleX = this.scaleY = this.scaleY - 0.0005;
            if(this.scaleX < 0.5 || this.scaleY < 0.5)
            {
               this.scaleX = this.scaleY = 0.5;
            }
         }
         else if(this.particleMode == FallingItemMode.RAIN)
         {
            _loc2_ = 2.9;
            this.rotation = 10;
            this.x -= 0.5;
         }
         else if(this.particleMode == FallingItemMode.CONFETTI)
         {
            _loc2_ = 1.3;
            this.rotation += this.rotSpeed + 3;
         }
         else if(this.particleMode == FallingItemMode.LEAVES)
         {
            _loc2_ = 1.3;
            this.rotation += this.rotSpeed + 3;
         }
         this.y += this.fallSpeed + _loc2_;
         if(this.y > Global.height + 20)
         {
            this.die();
         }
      }
      
      public function die() : void
      {
         this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.parent.removeChild(this);
      }
   }
}


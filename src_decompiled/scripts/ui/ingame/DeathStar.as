package ui.ingame
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import utilities.MathUtil;
   
   public class DeathStar extends Sprite
   {
      
      public var max_dist:Number = 32;
      
      public var brake:Number = 0.7;
      
      public var speed:Number;
      
      public var speed_x:Number;
      
      public var speed_y:Number;
      
      public function DeathStar(param1:BitmapData)
      {
         super();
         var _loc2_:Bitmap = new Bitmap(param1);
         _loc2_.x -= _loc2_.width / 2 >> 0;
         _loc2_.y -= _loc2_.height / 2 >> 0;
         addChild(_loc2_);
      }
      
      public function tick(param1:int = 1) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            x += this.speed_x * this.speed;
            y += this.speed_y * this.speed;
            _loc3_ = Math.sqrt(Math.pow(x,2) + Math.pow(y,2));
            this.speed *= this.brake;
            if(parent)
            {
               if(!MathUtil.inRange(0,0,x,y,this.max_dist) || alpha <= 0 || this.speed <= 0.05)
               {
                  parent.removeChild(this);
               }
            }
            _loc2_++;
         }
      }
   }
}


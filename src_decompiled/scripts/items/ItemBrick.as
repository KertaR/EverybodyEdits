package items
{
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemBrick
   {
      
      public var id:int;
      
      public var payvaultid:String = null;
      
      public var layer:int;
      
      public var bmd:BitmapData;
      
      public var tab:int;
      
      public var requiresOwnership:Boolean;
      
      public var requiresAdmin:Boolean;
      
      public var requiresPurchase:Boolean = false;
      
      public var hasShadow:Boolean = false;
      
      public var description:String = "";
      
      public var tags:Array;
      
      public var selectorBG:int;
      
      public var minimapColor:Number;
      
      public function ItemBrick(param1:int, param2:int, param3:BitmapData, param4:String, param5:String, param6:int, param7:Boolean, param8:Boolean, param9:Boolean, param10:Boolean, param11:Number, param12:Array, param13:int = 0)
      {
         super();
         this.id = param1;
         this.layer = param2;
         this.minimapColor = param11 == -1 ? generateThumbColor(param3) : param11;
         this.bmd = param10 ? drawWithShadow(param3) : param3;
         this.payvaultid = param4;
         this.description = param5;
         this.tab = param6;
         this.requiresOwnership = param7;
         this.requiresAdmin = param8;
         this.requiresPurchase = param9;
         this.hasShadow = param10;
         this.tags = param12 || [];
         this.selectorBG = param13;
      }
      
      public static function drawWithShadow(param1:BitmapData) : BitmapData
      {
         var _loc2_:Rectangle = new Rectangle(0,0,18,18);
         var _loc3_:BitmapData = new BitmapData(18,18,true,0);
         var _loc4_:Matrix = new Matrix();
         _loc4_.translate(2,2);
         _loc3_.draw(param1,_loc4_,new ColorTransform(0,0,0,0.3,0,0,0,0));
         _loc3_.draw(param1);
         return _loc3_;
      }
      
      public static function generateThumbColor(param1:BitmapData) : uint
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         _loc5_ = _loc5_;
         while(_loc5_ < param1.height)
         {
            _loc6_ = 0;
            while(_loc6_ < param1.width)
            {
               _loc7_ = param1.getPixel(_loc6_,_loc5_);
               _loc2_ += (_loc7_ & 0xFF0000) >> 16;
               _loc3_ += (_loc7_ & 0xFF00) >> 8;
               _loc4_ += _loc7_ & 0xFF;
               _loc6_++;
            }
            _loc5_++;
         }
         _loc2_ /= param1.width * param1.height;
         _loc3_ /= param1.width * param1.height;
         _loc4_ /= param1.width * param1.height;
         return 0xFF000000 | _loc2_ << 16 | _loc3_ << 8 | _loc4_ << 0;
      }
      
      public function drawTo(param1:BitmapData, param2:int, param3:int) : void
      {
         param1.copyPixels(this.bmd,this.bmd.rect,new Point(param2,param3));
      }
   }
}


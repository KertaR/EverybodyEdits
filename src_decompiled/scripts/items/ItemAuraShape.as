package items
{
   import animations.AnimationManager;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ItemAuraShape
   {
      
      public var id:int;
      
      public var name:String;
      
      public var payvaultid:String;
      
      public var bmd:BitmapData;
      
      public var generated:Boolean;
      
      public var auras:Vector.<ItemAura>;
      
      public function ItemAuraShape(param1:int, param2:String, param3:BitmapData, param4:String, param5:int = 1, param6:Number = 0.2, param7:Boolean = false, param8:Boolean = true)
      {
         var _loc9_:Vector.<ItemAura> = null;
         var _loc10_:int = 0;
         var _loc11_:ItemAura = null;
         var _loc12_:BitmapData = null;
         var _loc13_:ItemAura = null;
         this.auras = new Vector.<ItemAura>();
         super();
         this.id = param1;
         this.name = param2;
         this.bmd = param3;
         this.payvaultid = param4;
         this.generated = param8;
         if(param8)
         {
            _loc9_ = this.applyColors(param3);
            _loc10_ = 0;
            while(_loc10_ < _loc9_.length)
            {
               _loc11_ = _loc9_[_loc10_];
               this.auras.push(_loc11_);
               if(param5 > 1)
               {
                  _loc12_ = new BitmapData(64 * param5,64,true,0);
                  _loc12_.copyPixels(_loc11_.fullbmd,new Rectangle(0,0,64 * param5,64),new Point(0,0));
                  _loc11_.setFramedAnimation(_loc12_,param5,param6);
               }
               else if(param7)
               {
                  _loc11_.setRotationAnimation(14,84);
               }
               _loc10_++;
            }
         }
         else
         {
            _loc13_ = new ItemAura(param1,0,param3);
            if(param5 > 1)
            {
               _loc13_.setFramedAnimation(param3,param5,param6);
            }
            this.auras.push(_loc13_);
         }
      }
      
      private function applyColors(param1:BitmapData) : Vector.<ItemAura>
      {
         var _loc2_:Vector.<ItemAura> = new Vector.<ItemAura>();
         _loc2_.push(this.createColoredAura(param1,0,ItemAuraColor.WHITE));
         _loc2_.push(this.createColoredAura(param1,1,ItemAuraColor.RED));
         _loc2_.push(this.createColoredAura(param1,2,ItemAuraColor.BLUE));
         _loc2_.push(this.createColoredAura(param1,3,ItemAuraColor.YELLOW));
         _loc2_.push(this.createColoredAura(param1,4,ItemAuraColor.GREEN));
         _loc2_.push(this.createColoredAura(param1,5,ItemAuraColor.PURPLE));
         _loc2_.push(this.createColoredAura(param1,6,ItemAuraColor.ORANGE));
         _loc2_.push(this.createColoredAura(param1,7,ItemAuraColor.CYAN));
         _loc2_.push(this.createColoredAura(param1,8,ItemAuraColor.GOLD));
         _loc2_.push(this.createColoredAura(param1,9,ItemAuraColor.PINK));
         _loc2_.push(this.createColoredAura(param1,10,ItemAuraColor.INDIGO));
         _loc2_.push(this.createColoredAura(param1,11,ItemAuraColor.LIME));
         _loc2_.push(this.createColoredAura(param1,12,ItemAuraColor.BLACK));
         _loc2_.push(this.createColoredAura(param1,13,ItemAuraColor.TEAL));
         _loc2_.push(this.createColoredAura(param1,14,ItemAuraColor.GREY));
         _loc2_.push(this.createColoredAura(param1,15,ItemAuraColor.AMARANTH));
         return _loc2_;
      }
      
      private function createColoredAura(param1:BitmapData, param2:int, param3:uint) : ItemAura
      {
         var _loc5_:BitmapData = null;
         var _loc6_:int = 0;
         if(param2 == 8)
         {
            _loc5_ = new BitmapData(param1.width,64,true,0);
            _loc5_.copyPixels(param1,new Rectangle(0,64,param1.width,64),new Point());
            return new ItemAura(this.id,param2,_loc5_);
         }
         var _loc4_:BitmapData = AnimationManager.colorize(param1,param3);
         if(this.id == 3)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc4_.width / 64)
            {
               _loc4_ = AnimationManager.combine(_loc4_,ItemManager.aurasOrnateBMD,new Point(_loc6_ * 64,0));
               _loc6_++;
            }
         }
         return new ItemAura(this.id,param2,_loc4_);
      }
   }
}


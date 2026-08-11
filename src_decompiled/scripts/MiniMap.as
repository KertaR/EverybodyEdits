package
{
   import blitter.Bl;
   import blitter.BlObject;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import items.ItemManager;
   import playerio.*;
   
   public class MiniMap extends BlObject
   {
      
      private var bmd:BitmapData;
      
      private var playermap:BitmapData;
      
      private var alphaData:BitmapData;
      
      private var alphaBox:Sprite;
      
      private var ct:ColorTransform;
      
      public function MiniMap(param1:World, param2:int, param3:int)
      {
         super();
         this.bmd = new BitmapData(param2,param3,true,0);
         this.playermap = new BitmapData(param2,param3,true,0);
         this.x = 640 - param2 - 2;
         this.y = 470 - param3 - 2;
         this.ct = new ColorTransform();
         this.alphaBox = new Sprite();
         this.alphaData = new BitmapData(param2,param3,true,0);
         this.setAlpha(Global.base.settings.minimapAlpha);
         this.reset(param1);
      }
      
      public static function fromDatabaseObject(param1:DatabaseObject) : BitmapData
      {
         var _loc10_:Object = null;
         var _loc11_:Number = NaN;
         var _loc12_:ByteArray = null;
         var _loc13_:ByteArray = null;
         var _loc14_:int = 0;
         var _loc15_:ByteArray = null;
         var _loc16_:ByteArray = null;
         var _loc17_:int = 0;
         var _loc2_:int = int(int(param1.width) || 0);
         var _loc3_:int = int(int(param1.height) || 0);
         if(_loc2_ == 0 || _loc3_ == 0)
         {
            switch(param1.type)
            {
               case 1:
                  _loc2_ = 50;
                  _loc3_ = 50;
                  break;
               case 2:
                  _loc2_ = 100;
                  _loc3_ = 100;
                  break;
               default:
               case 3:
                  _loc2_ = 200;
                  _loc3_ = 200;
                  break;
               case 4:
                  _loc2_ = 400;
                  _loc3_ = 50;
                  break;
               case 5:
                  _loc2_ = 400;
                  _loc3_ = 200;
                  break;
               case 6:
                  _loc2_ = 100;
                  _loc3_ = 400;
                  break;
               case 7:
                  _loc2_ = 636;
                  _loc3_ = 50;
                  break;
               case 8:
                  _loc2_ = 110;
                  _loc3_ = 110;
                  break;
               case 11:
                  _loc2_ = 300;
                  _loc3_ = 300;
                  break;
               case 12:
                  _loc2_ = 250;
                  _loc3_ = 150;
            }
         }
         var _loc4_:BitmapData = new BitmapData(_loc2_,_loc3_,true);
         var _loc5_:Vector.<uint> = new Vector.<uint>(_loc2_ * _loc3_,true);
         var _loc6_:uint = uint(uint(param1.backgroundColor) || uint(4278190080));
         var _loc7_:* = int(_loc2_ * _loc3_ - 1);
         while(_loc7_ >= 0)
         {
            _loc5_[_loc7_] = _loc6_;
            _loc7_--;
         }
         var _loc8_:Array = param1.worlddata || [];
         var _loc9_:* = int(_loc8_.length - 1);
         while(_loc9_ >= 0)
         {
            _loc10_ = _loc8_[_loc9_];
            if(_loc10_ != null)
            {
               _loc11_ = Number((ItemManager.bricks[_loc10_.type] || ItemManager.bricks[0]).minimapColor);
               if(Boolean(_loc10_.layer) || Boolean(_loc11_))
               {
                  if(_loc10_.x1)
                  {
                     _loc12_ = _loc10_.x1;
                     _loc13_ = _loc10_.y1;
                     _loc14_ = int(_loc12_.length);
                     while(true)
                     {
                        _loc14_ = _loc14_ - 1;
                        if(_loc14_ < 0)
                        {
                           break;
                        }
                        _loc5_[_loc13_[_loc14_] * _loc2_ + _loc12_[_loc14_]] = _loc11_;
                     }
                  }
                  if(_loc10_.x)
                  {
                     _loc15_ = _loc10_.x;
                     _loc16_ = _loc10_.y;
                     _loc17_ = int(_loc15_.length);
                     while(true)
                     {
                        _loc17_ = _loc17_ - 2;
                        if(_loc17_ < 0)
                        {
                           break;
                        }
                        _loc5_[((_loc16_[_loc17_] << 8) + _loc16_[_loc17_ + 1]) * _loc2_ + (_loc15_[_loc17_] << 8) + _loc15_[_loc17_ + 1]] = _loc11_;
                     }
                  }
               }
            }
            _loc9_--;
         }
         _loc4_.setVector(_loc4_.rect,_loc5_);
         return _loc4_;
      }
      
      public function updatePixel(param1:int, param2:int, param3:Number) : void
      {
         this.bmd.setPixel32(param1,param2,param3);
      }
      
      public function showPlayer(param1:Player, param2:uint) : void
      {
         this.playermap.setPixel32(param1.x >> 4,param1.y >> 4,param2);
      }
      
      public function clear() : void
      {
         this.playermap.colorTransform(this.playermap.rect,new ColorTransform(1,1,1,1 - 1 / 64));
      }
      
      public function reset(param1:World) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.width)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.height)
            {
               this.bmd.setPixel32(_loc2_,_loc3_,param1.getMinimapColor(_loc2_,_loc3_));
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function drawDirect(param1:BitmapData) : void
      {
         param1.copyPixels(this.bmd,this.bmd.rect,new Point(0,0));
      }
      
      public function setAlpha(param1:Number) : void
      {
         this.ct.alphaMultiplier = param1;
         this.alphaBox.graphics.clear();
         this.alphaBox.graphics.beginFill(0,1);
         this.alphaBox.graphics.drawRect(0,0,this.bmd.width,this.bmd.height);
         this.alphaBox.graphics.endFill();
         this.alphaData = new BitmapData(this.bmd.width,this.bmd.height,true,0);
         this.alphaData.draw(this.alphaBox,null,this.ct);
      }
      
      override public function draw(param1:BitmapData, param2:int, param3:int) : void
      {
         var _loc4_:Point = new Point(x,y - 3);
         if(Bl.data.moreisvisible)
         {
            _loc4_.y = y + Bl.data.bselector.y;
            if(this.bmd.width > 150)
            {
               _loc4_.y -= 15;
            }
         }
         param1.copyPixels(this.bmd,this.bmd.rect,_loc4_,this.alphaData,new Point(),true);
         if(Bl.data.showPlayer)
         {
            param1.copyPixels(this.playermap,this.playermap.rect,_loc4_,this.alphaData,new Point(),true);
         }
         this.clear();
      }
      
      public function getBitmapData() : BitmapData
      {
         return this.bmd;
      }
   }
}


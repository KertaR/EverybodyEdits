package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   
   public class ImageBlock
   {
      
      private static var query:Vector.<String> = new Vector.<String>();
      
      private static var queryBlocks:Vector.<ImageBlock> = new Vector.<ImageBlock>();
      
      private var bmd:BitmapData;
      
      public var name:String;
      
      public var x:int;
      
      public var y:int;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var area:Rectangle;
      
      public function ImageBlock(param1:String, param2:int, param3:int, param4:Boolean = true)
      {
         super();
         this.name = param1;
         this.x = param2;
         this.y = param3;
         if(param4)
         {
            requestImage(this);
         }
      }
      
      private static function requestImage(param1:ImageBlock) : void
      {
         var imageLink:String;
         var item:ImageBlock = null;
         var load:Loader = null;
         var block:ImageBlock = param1;
         for each(item in Global.cachedImages)
         {
            if(item.name == block.name)
            {
               block.handleLoaded(item.bmd);
               return;
            }
         }
         queryBlocks.push(block);
         if(query.indexOf(block.name) != -1)
         {
            return;
         }
         query.push(block.name);
         imageLink = Config.site + "/Images/" + block.name + ".png";
         load = new Loader();
         load.load(new URLRequest(imageLink));
         load.contentLoaderInfo.addEventListener("complete",function(param1:Event):void
         {
            var _loc5_:ImageBlock = null;
            var _loc2_:BitmapData = new BitmapData(load.width,load.height,true,0);
            _loc2_.draw(Bitmap(load.content));
            var _loc3_:ImageBlock = new ImageBlock(block.name,0,0,false);
            _loc3_.bmd = _loc2_;
            Global.cachedImages.push(_loc3_);
            query.removeAt(query.indexOf(block.name));
            var _loc4_:* = int(queryBlocks.length - 1);
            while(_loc4_ >= 0)
            {
               _loc5_ = queryBlocks[_loc4_];
               if(_loc5_.name == block.name)
               {
                  _loc5_.handleLoaded(_loc2_);
                  queryBlocks.removeAt(queryBlocks.indexOf(_loc5_));
               }
               _loc4_--;
            }
         });
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function get height() : Number
      {
         return this._width;
      }
      
      public function get rect() : Rectangle
      {
         return this.area;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this.bmd;
      }
      
      public function get bitmap() : Bitmap
      {
         return new Bitmap(this.bmd);
      }
      
      public function get loaded() : Boolean
      {
         return this.bmd != null;
      }
      
      private function handleLoaded(param1:BitmapData) : void
      {
         this.bmd = param1;
         this._width = param1.width;
         this._height = param1.height;
         this.area = new Rectangle(0,0,this._width,this._height);
      }
      
      public function isInbounds(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         var _loc5_:Rectangle = new Rectangle(this.x * 16,this.y * 16,this.width,this.height);
         var _loc6_:Rectangle = new Rectangle(param1 * 16,param2 * 16,param3 * 16,param4 * 16);
         return _loc5_.intersects(_loc6_);
      }
   }
}


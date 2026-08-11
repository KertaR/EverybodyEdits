package ui.screens
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import items.ItemManager;
   import ui.screens.gx.PixelBlock;
   
   public class WelcomeGold extends assets_welcomegold
   {
      
      private var arrowlayers:Vector.<Sprite> = new <Sprite>[new Sprite(),new Sprite(),new Sprite()];
      
      private var arrowoffset_x:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      private var arrowoffset_y:Vector.<Vector.<int>> = new Vector.<Vector.<int>>();
      
      private var image:Sprite = new Sprite();
      
      public function WelcomeGold()
      {
         super();
         btn_exit.buttonMode = true;
         btn_exit.addEventListener(MouseEvent.CLICK,this.close,false,0,true);
         btn_close.buttonMode = true;
         btn_close.addEventListener(MouseEvent.CLICK,this.close,false,0,true);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,1,true);
      }
      
      private function close(param1:Event) : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      override public function get width() : Number
      {
         return bg.width;
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         var g:int;
         var i:int;
         var sheet:BitmapData;
         var bmd:BitmapData;
         var a:PixelBlock = null;
         var w:Number = NaN;
         var h:Number = NaN;
         var hor:Number = NaN;
         var ver:Number = NaN;
         var baseoffset_x:Number = NaN;
         var k:int = 0;
         var l:int = 0;
         var j:int = 0;
         var nexty:int = 0;
         var event:Event = param1;
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.ENTER_FRAME,this.doArrowTick,false,0,true);
         memberstats.tf_expires.text = "Expires: " + Global.toPrettyDate(Global.playerObject.goldexpire);
         memberstats.tf_since.text = "Since: " + Global.toPrettyDate(Global.playerObject.goldjoin);
         g = 0;
         while(g < this.arrowlayers.length)
         {
            this.arrowlayers[g].cacheAsBitmap = true;
            brickholder.addChild(this.arrowlayers[g]);
            g++;
         }
         i = 0;
         while(i < 3)
         {
            a = new PixelBlock(i);
            w = a.width;
            h = a.height;
            hor = Math.floor(400 / w);
            ver = Math.floor(400 / h);
            baseoffset_x = 76 + (400 - hor * w) / 2;
            this.arrowoffset_x[i] = new Vector.<int>();
            this.arrowoffset_y[i] = new Vector.<int>();
            k = 0;
            while(k < hor)
            {
               this.arrowoffset_x[i].push(baseoffset_x + k * w >> 0);
               k++;
            }
            this.arrowoffset_x[i].sort(function(param1:int, param2:int):Boolean
            {
               return Math.random() > 0.5;
            });
            l = 0;
            while(l < ver)
            {
               this.arrowoffset_y[i].push(l * h >> 0);
               l++;
            }
            this.arrowoffset_y[i].sort(function(param1:int, param2:int):Boolean
            {
               return Math.random() > 0.5;
            });
            j = 0;
            while(j < 8 - i * 3)
            {
               nexty = this.arrowoffset_y[i].shift();
               this.arrowoffset_y[i].push(nexty);
               this.createBlock(i,nexty);
               j++;
            }
            i++;
         }
         sheet = ItemManager.shopBMD;
         bmd = new BitmapData(194,sheet.height,true,0);
         bmd.copyPixels(sheet,new Rectangle(194,0,194,sheet.height),new Point(0,0));
         this.image.addChild(new Bitmap(bmd));
         addChild(this.image);
         this.image.x = memberstats.x + memberstats.width / 2 - this.image.width / 2 - 25;
         this.image.y = memberstats.y - 135;
         TweenMax.to(this.image,0.2,{"dropShadowFilter":{
            "blurX":3,
            "blurY":3,
            "distance":3,
            "alpha":0.6
         }});
      }
      
      private function createBlock(param1:int, param2:Number = -64) : PixelBlock
      {
         var _loc3_:PixelBlock = new PixelBlock(param1);
         _loc3_.x = this.arrowoffset_x[param1].shift();
         _loc3_.y = param2;
         this.arrowlayers[param1].addChild(_loc3_);
         return _loc3_;
      }
      
      protected function doArrowTick(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PixelBlock = null;
         var _loc2_:uint = 0;
         while(_loc2_ < brickholder.numChildren)
         {
            _loc3_ = this.arrowlayers[_loc2_].numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = this.arrowlayers[_loc2_].getChildAt(_loc4_) as PixelBlock;
               _loc5_.tick();
               if(_loc5_.y > 400 + _loc5_.height)
               {
                  this.arrowoffset_x[_loc5_.layer].push(_loc5_.x);
                  this.arrowlayers[_loc2_].removeChild(_loc5_);
                  this.createBlock(_loc5_.layer);
               }
               _loc4_++;
            }
            _loc2_++;
         }
      }
   }
}


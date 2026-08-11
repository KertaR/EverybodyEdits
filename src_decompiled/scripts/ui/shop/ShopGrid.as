package ui.shop
{
   import data.ShopItemData;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ShopGrid extends Sprite
   {
      
      public static const ITEM_WIDTH:int = 645;
      
      public static const ITEM_HEIGHT:int = 75;
      
      private var _span:int;
      
      private var rows:int = 0;
      
      private var shopitems:Vector.<ShopItem>;
      
      private var itemsHash:Object;
      
      private var itemdata:Vector.<ShopItemData> = new Vector.<ShopItemData>();
      
      private var h_spacing:Number = 0;
      
      private var v_spacing:Number = 0;
      
      public function ShopGrid(param1:int, param2:Number, param3:Number)
      {
         super();
         this.span = param1;
         this.h_spacing = param2;
         this.v_spacing = param3;
         addEventListener(ShopItemEvent.MOUSE_OVER,this.handleShopItemMouseOver,false,0,true);
      }
      
      public function get span() : int
      {
         return this._span;
      }
      
      public function set span(param1:int) : void
      {
         this._span = param1;
         this.arrangeItemData();
         this.render();
      }
      
      public function setSpacing(param1:Number, param2:Number) : void
      {
         this.h_spacing = param1;
         this.v_spacing = param2;
         this.render();
      }
      
      override public function set width(param1:Number) : void
      {
      }
      
      override public function get height() : Number
      {
         return (this.rows + 1) * (ITEM_HEIGHT + this.v_spacing) - this.v_spacing + 1;
      }
      
      public function setItems(param1:Vector.<ShopItemData>) : void
      {
         Global.log("ShopGrid.setItems() count=" + (param1 ? param1.length : 0));
         this.itemdata = param1;
         this.sortItemData();
         this.arrangeItemData();
      }
      
      public function refreshItems(param1:Vector.<ShopItemData>) : void
      {
         var _loc3_:ShopItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(this.itemsHash[param1[_loc2_].id] != null)
            {
               _loc3_ = this.itemsHash[param1[_loc2_].id];
               _loc3_.setItemdata(param1[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      private function sortItemData() : void
      {
         try
         {
            this.itemdata.sort(function(param1:ShopItemData, param2:ShopItemData):int
            {
               var isGold:Boolean = Global.playerObject && Global.playerObject.goldmember;
               if(param1.type == ShopItemData.TYPE_GOLD && param2.type != ShopItemData.TYPE_GOLD)
               {
                  return isGold ? 1 : -1;
               }
               if(param1.type != ShopItemData.TYPE_GOLD && param2.type == ShopItemData.TYPE_GOLD)
               {
                  return isGold ? -1 : 1;
               }
               if(param1.isNew && !param2.isNew)
               {
                  return -1;
               }
               if(!param1.isNew && param2.isNew)
               {
                  return 1;
               }
               if(param1.isOnSale && !param2.isOnSale)
               {
                  return -1;
               }
               if(!param1.isOnSale && param2.isOnSale)
               {
                  return 1;
               }
               if(param1.type == ShopItemData.TYPE_OTHER && param2.type != ShopItemData.TYPE_OTHER)
               {
                  return 1;
               }
               if(param1.type != ShopItemData.TYPE_OTHER && param2.type == ShopItemData.TYPE_OTHER)
               {
                  return -1;
               }
               if(param1.energyUsed > param2.energyUsed)
               {
                  return -1;
               }
               if(param1.energyUsed < param2.energyUsed)
               {
                  return 1;
               }
               return param1.priceGems < param2.priceGems ? -1 : 1;
            });
         }
         catch(e:Error) {}
      }
      
      private function arrangeItemData() : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:ShopItemData = null;
         var _loc1_:Vector.<ShopItemData> = new Vector.<ShopItemData>();
         this.rows = 0;
         var _loc2_:int = 0;
         while(this.itemdata.length > 0)
         {
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < this.itemdata.length)
            {
               if(this.itemdata[_loc4_].span + _loc2_ <= this.span)
               {
                  _loc5_ = this.itemdata.splice(_loc4_,1)[0];
                  _loc5_.grid_x = _loc2_;
                  _loc5_.grid_y = this.rows;
                  _loc1_.push(_loc5_);
                  _loc2_ += _loc5_.span;
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
            if(!_loc3_)
            {
               _loc2_ += this.span - _loc2_;
            }
            ++this.rows;
            _loc2_ = 0;
         }
         if(_loc2_ == 0)
         {
            --this.rows;
         }
         this.itemdata = _loc1_;
      }
      
      public function render() : void
      {
         Global.log("ShopGrid.render() rendering " + (this.itemdata ? this.itemdata.length : 0) + " items");
         var _loc1_:int = 0;
         var _loc2_:ShopItem = null;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         this.shopitems = new Vector.<ShopItem>();
         this.itemsHash = {};
         _loc1_ = 0;
         while(_loc1_ < this.itemdata.length)
         {
            try
            {
               _loc2_ = new ShopItem(this.itemdata[_loc1_],this.itemdata[_loc1_].span * ITEM_WIDTH + (this.itemdata[_loc1_].span - 1) * this.h_spacing,ITEM_HEIGHT);
               _loc2_.x = this.itemdata[_loc1_].grid_x * (ITEM_WIDTH + this.h_spacing) + 65;
               _loc2_.y = this.itemdata[_loc1_].grid_y * (ITEM_HEIGHT + this.v_spacing);
               this.shopitems.push(_loc2_);
               this.itemsHash[this.itemdata[_loc1_].id] = _loc2_;
               addChild(_loc2_);
               Global.log("ShopGrid.render: added item " + this.itemdata[_loc1_].id + " at y=" + _loc2_.y);
            }
            catch(err:Error)
            {
               Global.log("ShopGrid.render error adding item " + this.itemdata[_loc1_].id + ": " + err.message);
            }
            _loc1_++;
         }
         Global.log("ShopGrid.render() completed, total Children=" + numChildren);
      }
      
      protected function handleShopItemMouseOver(param1:Event) : void
      {
      }
   }
}


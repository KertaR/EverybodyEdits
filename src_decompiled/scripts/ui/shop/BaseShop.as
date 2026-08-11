package ui.shop
{
   import data.ShopItemData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sample.ui.components.Box;
   import sample.ui.components.scroll.ScrollBox;
   import states.LobbyState;
   import ui.TabBar;
   
   public class BaseShop extends MovieClip
   {
      
      protected const GRID_SPACING_H:int = 10;
      
      protected const GRID_SPACING_V:int = 10;
      
      private var tabbar:TabBar;
      
      protected var grid:ShopGrid;
      
      protected var all_items:Vector.<ShopItemData>;
      
      private var current_items:Vector.<ShopItemData>;
      
      protected var scrollbox:ScrollBox;
      
      protected var content:Box;
      
      protected var scrollcontainer:GridScrollContaioner;
      
      protected var mouseovercontainer:Sprite;
      
      public function BaseShop(param1:int, param2:Number = 10, param3:Number = 10)
      {
         var span:int = param1;
         var spacing_h:Number = param2;
         var spacing_v:Number = param3;
         super();
         this.grid = new ShopGrid(span,spacing_h,spacing_v);
         this.content = new Box();
         this.content.margin(0,0,0,0);
         addChild(this.content);
         this.scrollcontainer = new GridScrollContaioner();
         this.scrollbox = new ScrollBox(false,this.scrollcontainer).margin(0,0,0,0);
         this.scrollbox.scrollMultiplier = 15;
         this.content.add(this.scrollbox);
         this.mouseovercontainer = new Sprite();
         addChild(this.mouseovercontainer);
         addEventListener(MouseEvent.MOUSE_WHEEL,function(param1:MouseEvent):void
         {
            scrollbox.scrollY -= param1.delta * 15;
            mouseovercontainer.y = content.y + scrollcontainer.y;
         });
         addEventListener(ShopItemEvent.MOUSE_OVER,this.handleShopItemMouse,false,0,true);
         addEventListener(ShopItemEvent.MOUSE_OUT,this.handleShopItemMouse,false,0,true);
         addEventListener(ShopItemEvent.BUY_ITEM,this.handleBuyItem,false,0,true);
         addEventListener(ShopItemEvent.BUY_ITEM_MONEY,this.handleBuyItemMoney,false,0,true);
         addEventListener(ShopItemEvent.USE_ENERGY,this.handleUseEnergy,false,0,true);
         addEventListener(ShopItemEvent.USE_ALL_ENERGY,this.handleUseAllEnergy,false,0,true);
         Shop.addEventListener(ShopEvent.UPDATE,this.handleShopUpdate);
      }
      
      protected function setContentSize(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.content.x = param1;
         this.content.y = param2;
         this.content.width = param3;
         this.content.height = param4;
      }
      
      protected function showItems(param1:Vector.<ShopItemData>) : void
      {
         Global.log("BaseShop.showItems() called with " + (param1 ? param1.length : 0) + " items");
         while(this.mouseovercontainer.numChildren > 0)
         {
            this.mouseovercontainer.removeChildAt(0);
         }
         while(this.scrollcontainer.numChildren > 0)
         {
            this.scrollcontainer.removeChildAt(0);
         }
         this.scrollbox.scrollY = 0;
         this.current_items = param1;
         this.grid.setItems(this.current_items);
         this.grid.render();
         this.scrollbox.add(this.grid);
         Global.log("BaseShop.showItems() completed. Grid children=" + this.grid.numChildren + ", scrollcontainer children=" + this.scrollcontainer.numChildren);
      }
      
      protected function handleShopUpdate(param1:ShopEvent) : void
      {
         this.refreshShopItems();
         if(this.current_items != null && this.current_items.length > 0)
         {
            this.refreshGridItems();
         }
         else
         {
            this.showItems(this.all_items);
         }
          if(Global.base != null && Global.base.state is LobbyState)
          {
             var ls:LobbyState = Global.base.state as LobbyState;
             if(ls.shopbar != null) ls.shopbar.refreshTopBar();
          }
      }
      
      protected function refreshGridItems() : void
      {
         this.grid.refreshItems(Shop.getAllShopItems());
      }
      
      protected function refreshShopItems() : void
      {
         this.all_items = Shop.getAllShopItems();
      }
      
      protected function handleUseEnergy(param1:ShopItemEvent) : void
      {
         var _loc2_:ShopItemData = (param1.target as ShopItem).itemdata;
         Shop.useEnergy(_loc2_.id,false,_loc2_.isCrewOnly,this.onShopInteractionComplete);
      }
      
      protected function handleUseAllEnergy(param1:ShopItemEvent) : void
      {
         var _loc2_:ShopItemData = (param1.target as ShopItem).itemdata;
         Shop.useEnergy(_loc2_.id,true,_loc2_.isCrewOnly,this.onShopInteractionComplete);
      }
      
      protected function handleBuyItem(param1:ShopItemEvent) : void
      {
         var _loc2_:ShopItemData = (param1.target as ShopItem).itemdata;
         Shop.useGems(_loc2_.id,_loc2_.priceGems,_loc2_.isCrewOnly,this.onShopInteractionComplete);
      }
      
      protected function handleBuyItemMoney(param1:ShopItemEvent) : void
      {
         var _loc2_:ShopItemData = (param1.target as ShopItem).itemdata;
         Shop.buyItem(_loc2_.id,this.onShopInteractionComplete);
      }
      
      protected function onShopInteractionComplete(param1:Boolean) : void
      {
         if(!param1)
         {
            this.refreshGridItems();
         }
      }
      
      protected function handleShopItemMouse(param1:ShopItemEvent) : void
      {
         var _loc2_:ShopItem = null;
         if(param1.type == ShopItemEvent.MOUSE_OVER)
         {
            _loc2_ = param1.target as ShopItem;
            if(this.scrollcontainer.y + _loc2_.y < 0)
            {
               this.scrollbox.scrollY = _loc2_.y;
            }
            else if(this.scrollcontainer.y + _loc2_.y + ShopGrid.ITEM_HEIGHT > this.scrollbox.height)
            {
               this.scrollbox.scrollY = _loc2_.y + ShopGrid.ITEM_HEIGHT - this.scrollbox.height + 1;
            }
            this.mouseovercontainer.x = this.content.x;
            this.mouseovercontainer.y = this.content.y + this.scrollcontainer.y;
            this.mouseovercontainer.addChild(param1.target as ShopItem);
         }
         else
         {
            this.grid.addChild(param1.target as ShopItem);
         }
      }
   }
}


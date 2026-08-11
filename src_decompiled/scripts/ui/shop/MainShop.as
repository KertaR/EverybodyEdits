package ui.shop
{
   import data.ShopItemData;
   import flash.events.MouseEvent;
   import states.LobbyState;
   import ui.Tab;
   import ui.TabBar;
   
   public class MainShop extends BaseShop
   {
      
      private static const ALL:int = -1;
      
      public static const TAB_FEATURED:int = 0;
      
      public static const TAB_SMILEYS:int = 1;
      
      public static const TAB_BLOCKS:int = 2;
      
      public static const TAB_WORLDS:int = 3;
      
      public static const TAB_AURAS:int = 4;
      
      public static const TAB_NPCS:int = 5;
      
      public static const TAB_CLASSIC:int = 6;
      
      public static const TAB_CREW:int = 7;
      
      public static const TAB_SERVICES:int = 8;
      
      private var tabbar:TabBar;
      
      private var current_content_id:int;
      
      public function MainShop()
      {
         super(4);
         setContentSize(10,40,800,349);
         this.tabbar = new TabBar();
         addChildAt(this.tabbar,0);
         this.tabbar.spacing = 4;
         this.tabbar.addTab(TAB_FEATURED,"Featured",Tab.ICON_CROWN);
         this.tabbar.addTab(TAB_SMILEYS,"Smileys",Tab.ICON_SMILEY);
         this.tabbar.addTab(TAB_BLOCKS,"Blocks",Tab.ICON_BRICK);
         this.tabbar.addTab(TAB_AURAS,"Auras",Tab.ICON_AURA);
         this.tabbar.addTab(TAB_WORLDS,"Worlds",Tab.ICON_WORLD);
         this.tabbar.addTab(TAB_NPCS,"NPCs",Tab.ICON_NPC);
         this.tabbar.addTab(TAB_SERVICES,"Services",Tab.ICON_SERVICES);
         this.tabbar.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseTab,false,0,true);
         this.tabbar.setSelected(0);
         this.tabbar.width = 805;
         this.showContent(0);
      }
      
      protected function handleMouseTab(param1:MouseEvent) : void
      {
         var _loc2_:Tab = param1.target as Tab;
         if(_loc2_ == null && param1.target != null && param1.target.parent is Tab)
         {
            _loc2_ = param1.target.parent as Tab;
         }
         if(_loc2_ == null && param1.currentTarget is Tab)
         {
            _loc2_ = param1.currentTarget as Tab;
         }
         if(_loc2_ != null)
         {
            this.showContent(_loc2_.id);
         }
      }
      
      public function refreshTab() : void
      {
         this.showTab(this.current_content_id);
      }
      
      public function showTab(param1:int) : void
      {
         this.tabbar.setSelected(param1);
         this.showContent(param1);
      }
      
      private function showContent(param1:int) : void
      {
         Global.log("MainShop.showContent(" + param1 + ") called");
         refreshShopItems();
         Global.log("MainShop.showContent: refreshShopItems done, all_items count=" + (all_items ? all_items.length : 0));
         this.current_content_id = param1;
         var tabItems:Vector.<ShopItemData> = this.getItemsOnTab(param1);
         Global.log("MainShop.showContent: getItemsOnTab(" + param1 + ") returned " + (tabItems ? tabItems.length : 0) + " items");
         showItems(tabItems);
      }
      
      override protected function handleShopUpdate(param1:ShopEvent) : void
      {
         Global.log("MainShop.handleShopUpdate() received ShopEvent.UPDATE");
         this.showContent(this.current_content_id);
      }
      
      protected function getItemsOnTab(param1:int) : Vector.<ShopItemData>
      {
         var _loc2_:Vector.<ShopItemData> = new Vector.<ShopItemData>();
         var _loc3_:int = 0;
         while(_loc3_ < all_items.length)
         {
            if(this.shouldShowOnTab(all_items[_loc3_],param1))
            {
               _loc2_.push(all_items[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function shouldShowOnTab(param1:ShopItemData, param2:int) : Boolean
      {
         switch(param2)
         {
            case -1:
               return true;
            case TAB_FEATURED:
               if(param1.isFeatured)
               {
                  return true;
               }
               break;
            case TAB_SMILEYS:
               if(param1.type == ShopItemData.TYPE_SMILEY && !param1.isClassic)
               {
                  return true;
               }
               break;
            case TAB_BLOCKS:
               if(param1.type == ShopItemData.TYPE_BRICK && !param1.isClassic)
               {
                  return true;
               }
               break;
            case TAB_WORLDS:
               if(param1.type == ShopItemData.TYPE_WORLD && !param1.isClassic)
               {
                  return true;
               }
               break;
            case TAB_CREW:
               if(param1.type == ShopItemData.TYPE_CREW && !param1.isClassic)
               {
                  return true;
               }
               break;
            case TAB_AURAS:
               if((param1.type == ShopItemData.TYPE_AURA_COLOR || param1.type == ShopItemData.TYPE_AURA_SHAPE) && !param1.isClassic)
               {
                  return true;
               }
               break;
            case TAB_NPCS:
               if(param1.type == ShopItemData.TYPE_NPC && !param1.isClassic)
               {
                  return true;
               }
               break;
            case TAB_CLASSIC:
               if(param1.isClassic)
               {
                  return true;
               }
               break;
            case TAB_SERVICES:
               if(param1.type == ShopItemData.TYPE_SERVICE || param1.type == ShopItemData.TYPE_GOLD)
               {
                  return true;
               }
               break;
            case TAB_CREW:
               if(param1.isCrewOnly)
               {
                  return true;
               }
         }
         return false;
      }
      
      public function refreshSubtext() : void
      {
         var _loc1_:Array = [];
         var _loc2_:Vector.<ShopItemData> = Shop.getImportantShopItems();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_.push((_loc2_[_loc3_].isOnSale ? "SALE" : "NEW") + " - " + _loc2_[_loc3_].text_header);
            _loc3_++;
         }
         if(_loc1_.length == 0)
         {
            _loc1_[0] = "Buy cool new smileys, blocks, and more!";
         }
         (Global.base.state as LobbyState).setSubtextArray(_loc1_);
      }
   }
}


package ui
{
   import flash.events.MouseEvent;
   
   public class KeyBindingItem extends assets_keybindingitem
   {
      
      public var binding:KeyBinding;
      
      public var menu:KeyBindingsMenu;
      
      public var keyTemp:Key;
      
      public function KeyBindingItem(param1:KeyBinding, param2:KeyBindingsMenu)
      {
         var item:KeyBindingItem = null;
         var binding:KeyBinding = param1;
         var menu:KeyBindingsMenu = param2;
         super();
         this.binding = binding;
         this.menu = menu;
         fieldName.text = (binding.staffOnly ? "* " : "") + binding.name;
         fieldKey.mouseEnabled = false;
         this.keyTemp = binding.keyCustom;
         this.update();
         item = this;
         btnBinding.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            menu.rebindKey(item);
         });
         btnReset.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(menu.bindingItem)
            {
               return;
            }
            keyTemp = null;
            update();
            menu.testConflicts();
         });
      }
      
      public function update() : void
      {
         fieldKey.text = (this.keyTemp ? this.keyTemp : (this.menu.azertyEnabled && Boolean(this.binding.keyAzerty) ? this.binding.keyAzerty : this.binding.keyDefault)).print();
         fieldName.alpha = fieldKey.alpha = this.keyTemp ? 1 : 0.4;
         btnReset.visible = this.keyTemp != null;
      }
   }
}


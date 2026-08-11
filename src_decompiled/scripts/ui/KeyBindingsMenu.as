package ui
{
   import blitter.Bl;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import sample.ui.components.Rows;
   import sample.ui.components.scroll.ScrollBox;
   
   public class KeyBindingsMenu extends assets_keybindingsmenu
   {
      
      public var initW:Number;
      
      public var initH:Number;
      
      public var closeCallback:Function;
      
      private var rows:Rows;
      
      private var scroll:ScrollBox;
      
      public var azertyEnabled:Boolean;
      
      private var bindingItems:Vector.<KeyBindingItem>;
      
      public var bindingItem:KeyBindingItem = null;
      
      public function KeyBindingsMenu(param1:Function)
      {
         var _loc2_:KeyBinding = null;
         var _loc3_:KeyBindingItem = null;
         this.rows = new Rows();
         this.scroll = new ScrollBox();
         this.bindingItems = new Vector.<KeyBindingItem>();
         super();
         gotoAndStop(1);
         this.initW = width;
         this.initH = height;
         this.closeCallback = param1;
         this.azertyEnabled = Global.base.settings.azerty;
         azertyCheck.gotoAndStop(this.azertyEnabled ? 2 : 1);
         azertyCheck.addEventListener(MouseEvent.CLICK,this.handleAzerty);
         this.scroll.x = 18;
         this.scroll.y = 49;
         this.scroll.width = 427;
         this.scroll.height = 205;
         this.scroll.scrollMultiplier = 10;
         addChild(this.scroll);
         this.rows.spacing(0);
         this.scroll.add(this.rows);
         for each(_loc2_ in KeyBinding._all)
         {
            if(!(_loc2_.staffOnly && !Bl.data.isStaffMember))
            {
               _loc3_ = new KeyBindingItem(_loc2_,this);
               this.bindingItems.push(_loc3_);
               this.rows.addChild(_loc3_);
            }
         }
         this.testConflicts();
         this.scroll.refresh();
         btnCancel.addEventListener(MouseEvent.CLICK,this.handleCancel);
         btnSave.addEventListener(MouseEvent.CLICK,this.handleSave);
         btnResetAll.addEventListener(MouseEvent.CLICK,this.handleResetAll);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAdded);
      }
      
      private function handleAdded(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAdded);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeys,false,0,true);
         addEventListener(Event.ENTER_FRAME,this.handleFrame);
      }
      
      private function handleAzerty(param1:MouseEvent) : void
      {
         var _loc2_:KeyBindingItem = null;
         if(this.bindingItem)
         {
            return;
         }
         this.azertyEnabled = !this.azertyEnabled;
         azertyCheck.gotoAndStop(this.azertyEnabled ? 2 : 1);
         for each(_loc2_ in this.bindingItems)
         {
            _loc2_.update();
         }
         this.testConflicts();
      }
      
      private function handleCancel(param1:MouseEvent) : void
      {
         if(!this.bindingItem)
         {
            this.closeCallback();
         }
      }
      
      private function handleSave(param1:MouseEvent) : void
      {
         var _loc2_:KeyBindingItem = null;
         if(this.bindingItem)
         {
            return;
         }
         Global.base.settings.azerty = this.azertyEnabled;
         for each(_loc2_ in this.bindingItems)
         {
            _loc2_.binding.keyCustom = _loc2_.keyTemp;
         }
         KeyBinding.save();
         this.handleCancel(null);
      }
      
      private function handleResetAll(param1:MouseEvent) : void
      {
         var _loc2_:KeyBindingItem = null;
         if(this.bindingItem)
         {
            return;
         }
         for each(_loc2_ in this.bindingItems)
         {
            _loc2_.keyTemp = null;
            _loc2_.update();
            _loc2_.fieldKey.textColor = _loc2_.fieldName.textColor = 16777215;
         }
         this.updateResetAll(false);
      }
      
      public function rebindKey(param1:KeyBindingItem) : void
      {
         if(this.bindingItem)
         {
            return;
         }
         this.bindingItem = param1;
         this.bindingItem.fieldKey.alpha = 0.75;
         this.bindingItem.fieldKey.text = "Press key...";
         this.bindingItem.fieldKey.textColor = 16777215;
         mouseChildren = false;
      }
      
      private function handleKeys(param1:KeyboardEvent) : void
      {
         var _loc2_:Key = null;
         if(!this.bindingItem || !Key.isValidKey(param1.keyCode))
         {
            return;
         }
         if(this.bindingItem.keyTemp == null || this.bindingItem.keyTemp.keyCode != param1.keyCode || this.bindingItem.keyTemp.needsShift != param1.shiftKey)
         {
            _loc2_ = this.azertyEnabled && Boolean(this.bindingItem.binding.keyAzerty) ? this.bindingItem.binding.keyAzerty : this.bindingItem.binding.keyDefault;
            if(_loc2_.keyCode == param1.keyCode && _loc2_.needsShift == param1.shiftKey)
            {
               this.bindingItem.keyTemp = null;
            }
            else if(!this.bindingItem.keyTemp)
            {
               this.bindingItem.keyTemp = new Key(param1.keyCode,param1.shiftKey);
            }
            else
            {
               this.bindingItem.keyTemp.keyCode = param1.keyCode;
               this.bindingItem.keyTemp.needsShift = param1.shiftKey;
            }
         }
         this.bindingItem.update();
         this.bindingItem = null;
         this.testConflicts();
         mouseChildren = true;
      }
      
      private function handleFrame(param1:Event) : void
      {
         if(Boolean(this.bindingItem) && Boolean(stage))
         {
            stage.focus = stage;
         }
      }
      
      public function testConflicts() : void
      {
         var _loc3_:KeyBindingItem = null;
         var _loc4_:String = null;
         var _loc5_:KeyBindingItem = null;
         var _loc1_:Boolean = false;
         var _loc2_:Object = {};
         for each(_loc3_ in this.bindingItems)
         {
            if(_loc3_.keyTemp)
            {
               _loc1_ = true;
            }
            _loc4_ = (_loc3_.keyTemp ? _loc3_.keyTemp : (this.azertyEnabled && Boolean(_loc3_.binding.keyAzerty) ? _loc3_.binding.keyAzerty : _loc3_.binding.keyDefault)).print();
            _loc5_ = _loc2_[_loc4_] as KeyBindingItem;
            if(_loc5_)
            {
               _loc5_.fieldKey.textColor = _loc5_.fieldName.textColor = _loc3_.fieldKey.textColor = _loc3_.fieldName.textColor = 16732240;
            }
            else
            {
               _loc3_.fieldKey.textColor = _loc3_.fieldName.textColor = 16777215;
               _loc2_[_loc4_] = _loc3_;
            }
         }
         this.updateResetAll(_loc1_);
      }
      
      private function updateResetAll(param1:Boolean) : void
      {
         btnResetAll.mouseEnabled = param1;
         btnResetAll.alpha = param1 ? 1 : 0.4;
      }
   }
}


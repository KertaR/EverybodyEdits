package ui.brickselector
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import ui2.tabPageSearch;
   
   public class BrickSelectorSearch extends tabPageSearch
   {
      
      private var bselector:BrickSelector;
      
      private var uix:UI2;
      
      public function BrickSelectorSearch(param1:BrickSelector, param2:UI2)
      {
         super();
         this.bselector = param1;
         this.uix = param2;
         textfield.text = "";
         textfield.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.handleTabRequest);
         textfield.addEventListener(Event.CHANGE,this.handleInput);
         textfield.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         textfield.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
      }
      
      private function handleTabRequest(param1:FocusEvent) : void
      {
         param1.preventDefault();
         this.bselector.cyclePagesAndTabs(param1.shiftKey ? -1 : 1);
      }
      
      private function handleInput(param1:Event) : void
      {
         this.bselector.filterPackages(textfield.text);
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            if(textfield.text == "")
            {
               if(this.bselector.isLocked)
               {
                  this.uix.toggleMore(false);
               }
               else
               {
                  this.uix.stage.focus = this.uix.stage;
                  this.bselector.setHeight(false);
               }
            }
            else
            {
               textfield.text = "";
               this.bselector.filterPackages();
            }
         }
      }
      
      private function handleKeyUp(param1:KeyboardEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
   }
}


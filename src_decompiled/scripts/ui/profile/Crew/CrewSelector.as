package ui.profile.Crew
{
   import com.greensock.*;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sample.ui.components.Label;
   import ui.DropDownList;
   import ui.DropDownListItem;
   import ui.button.Button;
   
   public class CrewSelector extends Sprite
   {
      
      private var optionsList:DropDownList;
      
      private var callback:Function;
      
      private var selectedCrew:String;
      
      private var crewItems:Array;
      
      private var crews:Array;
      
      private var selectButton:Button;
      
      private var title:Label;
      
      public function CrewSelector(param1:Array, param2:Array, param3:Function)
      {
         var _loc5_:DropDownListItem = null;
         this.crewItems = [];
         this.crews = [];
         super();
         this.crews = param1;
         this.callback = param3;
         this.selectButton = new Button("Select");
         this.selectButton.x = 63;
         this.selectButton.y = 76;
         this.selectButton.addEventListener(MouseEvent.CLICK,this.handleSelectCrew);
         addChild(this.selectButton);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = new DropDownListItem(param2[_loc4_],345,this.handleScrollItemClick);
            this.crewItems.push(_loc5_);
            _loc4_++;
         }
         this.optionsList = new DropDownList(345,this.crewItems);
         this.optionsList.x = 2;
         this.optionsList.y = 38;
         addChild(this.optionsList);
         this.title = new Label("Select a Crew",18,"left",16777215,false,"system");
         this.title.x = this.optionsList.x + (this.optionsList.width - this.title.width) / 2;
         this.title.y = this.optionsList.y - this.title.height - 10;
         addChild(this.title);
         this.selectedCrew = param1[0];
      }
      
      protected function handleScrollItemClick(param1:MouseEvent) : void
      {
         var _loc2_:DropDownListItem = param1.target as DropDownListItem;
         var _loc3_:int = this.crewItems.indexOf(_loc2_);
         this.selectedCrew = this.crews[_loc3_];
         this.optionsList.inputBox.text = _loc2_.text;
         this.optionsList.showDropDownList(false);
      }
      
      protected function handleSelectCrew(param1:MouseEvent) : void
      {
         this.callback(this.selectedCrew);
      }
   }
}


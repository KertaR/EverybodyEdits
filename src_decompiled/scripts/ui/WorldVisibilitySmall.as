package ui
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import playerio.Connection;
   
   public class WorldVisibilitySmall extends assets_worldvisibility
   {
      
      private var optionsList:DropDownList;
      
      private var connection:Connection;
      
      private var statusItems:Array;
      
      private var statusInfos:Array;
      
      private var newVisibility:int;
      
      public function WorldVisibilitySmall(param1:Connection)
      {
         var con:Connection = param1;
         this.statusItems = [];
         this.statusInfos = ["World is accessible just for you","World is accessible for friends only","World is accessible by everyone"];
         super();
         this.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.addEventListener(KeyboardEvent.KEY_DOWN,function(param1:KeyboardEvent):void
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            param1.stopPropagation();
         });
         this.connection = con;
         this.bg_mail.visible = false;
         btn_dropdown.visible = false;
         dropdownContainer.visible = false;
         this.statusItems = [new DropDownListItem("Nobody",dropdownContainer.width,this.handleClick),new DropDownListItem("Friends",dropdownContainer.width,this.handleClick),new DropDownListItem("Anyone",dropdownContainer.width,this.handleClick)];
         this.optionsList = new DropDownList(Math.round(dropdownContainer.width),this.statusItems);
         this.optionsList.x = Math.round(btn_dropdown.x);
         this.optionsList.y = Math.round(btn_dropdown.y);
         addChild(this.optionsList);
         this.newVisibility = Global.currentLevelVisibility;
         this.setVisibility(this.newVisibility);
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         var _loc2_:DropDownListItem = param1.target as DropDownListItem;
         var _loc3_:int = this.statusItems.indexOf(_loc2_);
         this.setVisibility(_loc3_);
         this.optionsList.showDropDownList(false);
      }
      
      public function handleSave() : void
      {
         if(this.newVisibility == Global.currentLevelVisibility)
         {
            return;
         }
         if(this.newVisibility == 0)
         {
            this.connection.send("say","/visible false");
         }
         else if(this.newVisibility == 1)
         {
            this.connection.send("say","/visible friends");
         }
         else if(this.newVisibility == 2)
         {
            this.connection.send("say","/visible true");
         }
         Global.currentLevelVisibility = this.newVisibility;
      }
      
      private function setVisibility(param1:int) : void
      {
         var _loc2_:DropDownListItem = this.statusItems[param1] as DropDownListItem;
         status_info.text = this.statusInfos[param1];
         this.optionsList.inputBox.text = _loc2_.text;
         this.newVisibility = param1;
      }
   }
}


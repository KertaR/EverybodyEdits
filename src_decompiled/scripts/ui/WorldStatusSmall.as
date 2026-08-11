package ui
{
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import playerio.Connection;
   
   public class WorldStatusSmall extends assets_statusoptions
   {
      
      private var connection:Connection;
      
      private var optionsList:DropDownList;
      
      private var statusItems:Array;
      
      private var statusInfos:Array;
      
      private var newStatus:int;
      
      public function WorldStatusSmall(param1:Connection)
      {
         var con:Connection = param1;
         this.statusItems = [];
         this.statusInfos = ["World is under construction. Only crew members can join.","World is accessible by everyone and crew members with required rank can still save it.","World is accessible by everyone and only world hoster can save the world."];
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
         this.statusItems = [new DropDownListItem("Work in Progress",dropdownContainer.width,this.handleClick),new DropDownListItem("Open",dropdownContainer.width,this.handleClick),new DropDownListItem("Released",dropdownContainer.width,this.handleClick)];
         this.optionsList = new DropDownList(Math.round(dropdownContainer.width),this.statusItems);
         this.optionsList.x = Math.round(btn_dropdown.x);
         this.optionsList.y = Math.round(btn_dropdown.y);
         addChild(this.optionsList);
         this.newStatus = Global.currentLevelStatus;
         this.setStatus(Global.currentLevelStatus);
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         var _loc2_:DropDownListItem = param1.target as DropDownListItem;
         var _loc3_:int = this.statusItems.indexOf(_loc2_);
         this.setStatus(_loc3_);
         this.optionsList.showDropDownList(false);
      }
      
      public function handleSave() : void
      {
         var pro:ConfirmPrompt = null;
         if(this.newStatus == Global.currentLevelStatus)
         {
            return;
         }
         if(this.newStatus == 2)
         {
            pro = new ConfirmPrompt("You\'re about to release this world. This can\'t be undone and will send notification to all crew subscribers.",true,"Release");
            Global.base.showOnTop(pro);
            pro.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               connection.send("setStatus",newStatus);
               Global.currentLevelStatus = newStatus;
               pro.close();
            });
         }
         else
         {
            this.connection.send("setStatus",this.newStatus);
            Global.currentLevelStatus = this.newStatus;
         }
      }
      
      private function setStatus(param1:int) : void
      {
         var _loc2_:DropDownListItem = this.statusItems[param1] as DropDownListItem;
         status_info.text = this.statusInfos[param1];
         this.optionsList.inputBox.text = _loc2_.text;
         this.newStatus = param1;
      }
   }
}


package ui.crews
{
   import com.greensock.*;
   import flash.events.MouseEvent;
   import ui.DropDownList;
   import ui.DropDownListItem;
   
   public class FaceplateSelector extends assets_faceplateselector
   {
      
      private var colorsList:Array;
      
      private var faceplateItems:Array;
      
      private var faceplates:Array;
      
      private var faceplateId:String;
      
      private var colorId:int = 0;
      
      private var callback:Function;
      
      private var saveCallback:Function;
      
      private var optionsList:DropDownList;
      
      public function FaceplateSelector(param1:String, param2:int, param3:Array, param4:Boolean, param5:Function, param6:Function)
      {
         var i:int;
         var item:DropDownListItem = null;
         var currentFaceplate:String = param1;
         var currentFaceplateColor:int = param2;
         var faceplates:Array = param3;
         var enabled:Boolean = param4;
         var callback:Function = param5;
         var saveCallback:Function = param6;
         this.colorsList = ["Purple","Red","Orange","Yellow","Green","Cyan","Blue","White","Gray","Black"];
         this.faceplateItems = [];
         this.faceplates = [];
         super();
         disabledOverlay.visible = !enabled;
         this.faceplates = faceplates;
         faceplates.unshift("None");
         this.callback = callback;
         this.saveCallback = saveCallback;
         this.faceplateId = currentFaceplate;
         this.colorId = currentFaceplateColor;
         tf_color.text = this.colorsList[this.colorId];
         this.btn_dropdown.visible = false;
         this.dropdownContainer.visible = false;
         this.bg_mail.visible = false;
         i = 0;
         while(i < faceplates.length)
         {
            item = new DropDownListItem(faceplates[i],dropdownContainer.width,this.handleScrollItemClick);
            this.faceplateItems.push(item);
            i++;
         }
         this.optionsList = new DropDownList(dropdownContainer.width,this.faceplateItems);
         this.optionsList.inputBox.text = currentFaceplate || "None";
         this.optionsList.x = btn_dropdown.x;
         this.optionsList.y = btn_dropdown.y;
         addChildAt(this.optionsList,getChildIndex(disabledOverlay) - 1);
         btn_left.visible = true;
         btn_right.visible = true;
         btn_left.addEventListener(MouseEvent.CLICK,function():void
         {
            changeColor(-1);
         });
         btn_right.addEventListener(MouseEvent.CLICK,function():void
         {
            changeColor(1);
         });
         btn_save.buttonMode = true;
         btn_save.useHandCursor = true;
         btn_save.mouseChildren = false;
         btn_save.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            currentFaceplateColor = colorId;
            saveCallback();
         });
      }
      
      private function changeColor(param1:int) : void
      {
         this.colorId += param1;
         if(param1 < 0 && this.colorId < 0)
         {
            this.colorId = this.colorsList.length - 1;
         }
         if(param1 > 0 && this.colorId >= this.colorsList.length)
         {
            this.colorId = 0;
         }
         tf_color.text = this.colorsList[this.colorId];
         this.callback(this.faceplateId,this.colorId);
      }
      
      private function handleScrollItemClick(param1:MouseEvent) : void
      {
         var _loc2_:DropDownListItem = param1.target as DropDownListItem;
         this.optionsList.inputBox.text = _loc2_.text;
         this.faceplateId = _loc2_.text;
         if(_loc2_.text == "Confetti" || _loc2_.text == "None" || _loc2_.text == "Gold")
         {
            btn_left.visible = false;
            btn_right.visible = false;
            tf_color.visible = false;
            this.colorId = 0;
         }
         else
         {
            btn_left.visible = true;
            btn_right.visible = true;
            tf_color.visible = true;
         }
         this.callback(this.faceplateId,this.colorId);
         this.optionsList.showDropDownList(false);
      }
   }
}


package ui.crews
{
   import com.greensock.TweenMax;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import playerio.Connection;
   import playerio.Message;
   import ui.ConfirmPrompt;
   import ui.DropDownList;
   import ui.DropDownListItem;
   import ui.Prompts.BasePrompt;
   import ui.button.Button;
   
   public class CrewPrompt extends BasePrompt
   {
      
      private var optionsList:DropDownList;
      
      private var selectedCrew:String;
      
      private var crews:Array;
      
      private var crewItems:Array;
      
      private var con:Connection;
      
      private var saveButton:Button;
      
      public function CrewPrompt(param1:Connection, param2:Array, param3:Array)
      {
         var _loc5_:DropDownListItem = null;
         this.crews = [];
         this.crewItems = [];
         super("Add this world to a crew",400,150);
         this.con = param1;
         this.crews = param2;
         this.saveButton = new Button("Save");
         this.saveButton.x = (width - this.saveButton.width) / 2;
         this.saveButton.y = height - this.saveButton.height - 15;
         this.saveButton.addEventListener(MouseEvent.MOUSE_DOWN,this.sendRequest);
         addChild(this.saveButton);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = new DropDownListItem(param3[_loc4_],width - 40,this.handleClick);
            this.crewItems.push(_loc5_);
            _loc4_++;
         }
         this.optionsList = new DropDownList(width - 40,this.crewItems);
         this.optionsList.x = (width - (width - 40)) / 2;
         this.optionsList.y = title.y + title.height + 20;
         addChild(this.optionsList);
         this.selectedCrew = param2[0];
         param1.addMessageHandler("crewAddRequestFailed",this.handleError);
      }
      
      protected function handleClick(param1:MouseEvent) : void
      {
         var _loc2_:DropDownListItem = param1.target as DropDownListItem;
         var _loc3_:int = this.crewItems.indexOf(_loc2_);
         this.selectedCrew = this.crews[_loc3_];
         this.optionsList.inputBox.text = _loc2_.text;
         this.optionsList.showDropDownList(false);
      }
      
      private function sendRequest(param1:MouseEvent = null) : void
      {
         var confirm:ConfirmPrompt = null;
         var e:MouseEvent = param1;
         confirm = new ConfirmPrompt("Are you sure you want to add this world to " + this.optionsList.inputBox.text + "?\nWARNING: This cannot be undone!",true);
         Global.base.showOnTop(confirm);
         confirm.btn_yes.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
         {
            con.send("requestAddToCrew",selectedCrew);
            confirm.close();
         });
      }
      
      private function handleError(param1:Message) : void
      {
         setError(param1.getString(0));
      }
      
      override public function close(param1:Event = null) : void
      {
         var pm:CrewPrompt;
         var e:Event = param1;
         if(parent == null || !parent.contains(this))
         {
            return;
         }
         pm = this;
         TweenMax.to(pm,0.4,{
            "alpha":0,
            "onComplete":function(param1:CrewPrompt):void
            {
               if(stage)
               {
                  stage.focus = Global.base;
               }
               param1.parent.removeChild(param1);
            },
            "onCompleteParams":[pm]
         });
         this.con.removeMessageHandler("crewAddRequestFailed",this.handleError);
      }
   }
}


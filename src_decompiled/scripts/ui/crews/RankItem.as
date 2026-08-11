package ui.crews
{
   import com.greensock.*;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.utils.StringUtil;
   import playerio.Message;
   import ui.DropDownList;
   import ui.DropDownListItem;
   
   public class RankItem extends assets_rankcreation
   {
      
      private var checkBoxes:Array;
      
      private var powers:Array;
      
      private var crewId:String;
      
      private var ranks:CrewRanks;
      
      private var rank:CrewRank;
      
      private var optionsList:DropDownList;
      
      private var rankItems:Array;
      
      public function RankItem(param1:String, param2:CrewRanks)
      {
         var dropdownContainerWidth:Number;
         var i:int;
         var item:DropDownListItem = null;
         var crewId:String = param1;
         var ranks:CrewRanks = param2;
         this.checkBoxes = [];
         this.rankItems = [];
         super();
         this.crewId = crewId;
         this.ranks = ranks;
         this.rank = ranks.myRank;
         this.powers = this.rank.powers;
         tf_error.alpha = 0;
         button.gotoAndStop(2);
         button.btn_save.gotoAndStop(1);
         dropdownContainerWidth = 365;
         i = 0;
         while(i < ranks.ranks.length)
         {
            item = new DropDownListItem((ranks.ranks[i] as CrewRank).name,dropdownContainerWidth,this.handleRankItemClick);
            this.rankItems.push(item);
            i++;
         }
         this.optionsList = new DropDownList(dropdownContainerWidth,this.rankItems,true);
         this.optionsList.inputBox.maxChars = 20;
         this.optionsList.inputBox.addEventListener(Event.CHANGE,this.handleRankText);
         this.optionsList.inputBox.text = this.rank.name;
         this.optionsList.x = 238;
         this.optionsList.y = 181;
         addChild(this.optionsList);
         btn_clear.addEventListener(MouseEvent.CLICK,this.handleRemoveButton);
         button.buttonMode = true;
         button.useHandCursor = true;
         button.mouseChildren = false;
         button.addEventListener(MouseEvent.CLICK,this.handleSaveButton);
         btn_close.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            Global.base.hideRankItem();
         });
         this.initCheckBoxListeners();
         this.setRankState(this.rank);
         button.visible = ranks.myRank.canManageRanks;
         btn_clear.visible = ranks.myRank.canManageRanks;
      }
      
      private function handleRankText(param1:Event) : void
      {
         var _loc2_:String = null;
         if(button.currentFrame == 2)
         {
            _loc2_ = StringUtil.trim(this.optionsList.inputBox.text);
            if(_loc2_.length < 3 || _loc2_.length > 20)
            {
               if(button.btn_save.currentFrame != 2)
               {
                  button.btn_save.gotoAndStop(2);
               }
            }
            else if(button.btn_save.currentFrame != 1)
            {
               button.btn_save.gotoAndStop(1);
            }
         }
      }
      
      private function handleRankItemClick(param1:MouseEvent) : void
      {
         var _loc2_:DropDownListItem = param1.target as DropDownListItem;
         var _loc3_:int = this.rankItems.indexOf(_loc2_);
         this.rank = this.ranks.getRank(_loc3_);
         this.setRankState(this.rank);
         this.optionsList.showDropDownList(false);
      }
      
      private function setRankState(param1:CrewRank) : void
      {
         var _loc2_:int = 0;
         this.optionsList.inputBox.text = param1.name;
         title.text = (this.ranks.myRank.canManageRanks ? "Editing" : "Viewing") + " \'" + param1.name + "\' rank";
         this.resetCheckBoxes();
         for each(_loc2_ in param1.powers)
         {
            (this.checkBoxes[_loc2_] as MovieClip).gotoAndStop(2);
         }
         if(this.ranks.myRank.canEditPowersOf(param1))
         {
            this.enableCheckBoxes();
         }
         else
         {
            this.disableCheckBoxes();
         }
      }
      
      private function enableCheckBoxes() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.checkBoxes.length)
         {
            _loc2_ = this.checkBoxes[_loc1_] as MovieClip;
            _loc2_.alpha = 1;
            if(!_loc2_.hasEventListener(MouseEvent.CLICK))
            {
               _loc2_.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
            }
            _loc1_++;
         }
         btn_clear.visible = true;
      }
      
      private function disableCheckBoxes() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.checkBoxes.length)
         {
            _loc2_ = this.checkBoxes[_loc1_] as MovieClip;
            _loc2_.alpha = 0.5;
            if(_loc2_.hasEventListener(MouseEvent.CLICK))
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
            }
            _loc1_++;
         }
         btn_clear.visible = false;
      }
      
      private function initCheckBoxListeners() : void
      {
         this.checkBoxes.push(editaccess);
         this.checkBoxes.push(worldoptions);
         this.checkBoxes.push(logoaccess);
         this.checkBoxes.push(shopaccess);
         this.checkBoxes.push(worldmanagement);
         this.checkBoxes.push(membermanagement);
         this.checkBoxes.push(rankmanagement);
         this.checkBoxes.push(profileCustomization);
         this.checkBoxes.push(alertsending);
         var _loc1_:int = 0;
         while(_loc1_ < this.checkBoxes.length)
         {
            this.checkBoxes[_loc1_].addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
            _loc1_++;
         }
      }
      
      private function resetCheckBoxes() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.checkBoxes.length)
         {
            if((this.checkBoxes[_loc1_] as MovieClip).currentFrame == 2)
            {
               (this.checkBoxes[_loc1_] as MovieClip).gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      private function handleSaveButton(param1:MouseEvent) : void
      {
         var newName:String;
         var i:int;
         var e:MouseEvent = param1;
         Global.base.showLoadingScreen("Saving");
         newName = this.optionsList.inputBox.text;
         this.powers = [];
         i = 0;
         while(i < this.checkBoxes.length)
         {
            if((this.checkBoxes[i] as MovieClip).currentFrame == 2)
            {
               this.powers.push(i);
            }
            i++;
         }
         Global.base.requestCrewLobbyMethod("crew" + this.crewId,"editRank",function(param1:Message):void
         {
            if(param1.getBoolean(0))
            {
               rank.update(param1.getString(1),param1.getString(2));
               setRankState(rank);
               optionsList.setItemsArray(rankItems);
               Global.base.hideLoadingScreen();
               Global.base.updateMemberItems(false);
            }
            else
            {
               showError(param1.getString(1));
               Global.base.hideLoadingScreen();
            }
         },null,this.rank.id,newName,this.powers.join(","));
      }
      
      private function handleRemoveButton(param1:MouseEvent) : void
      {
         this.resetCheckBoxes();
      }
      
      private function handleCheckBoxes(param1:MouseEvent) : void
      {
         this.flipFrame(param1.target as MovieClip);
      }
      
      private function flipFrame(param1:MovieClip) : void
      {
         var _loc2_:int = param1.currentFrame;
         if(++_loc2_ > 2)
         {
            _loc2_ = 1;
         }
         param1.gotoAndStop(_loc2_);
      }
      
      public function showError(param1:String) : void
      {
         var text:String = param1;
         tf_error.text = text;
         TweenMax.to(tf_error,0.4,{
            "alpha":1,
            "onComplete":function():void
            {
               TweenMax.to(tf_error,1,{
                  "alpha":0,
                  "delay":10
               });
            }
         });
      }
   }
}


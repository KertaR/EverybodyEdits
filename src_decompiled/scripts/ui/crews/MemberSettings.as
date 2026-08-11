package ui.crews
{
   import com.greensock.*;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldType;
   import playerio.*;
   import sample.ui.components.Label;
   import ui.ConfirmPrompt;
   import ui.DropDownList;
   import ui.DropDownListItem;
   
   public class MemberSettings extends assets_membersettings
   {
      
      private var rankCreation:RankItem;
      
      private var username:String;
      
      private var description:String;
      
      private var rank:CrewRank;
      
      private var crewId:String;
      
      private var rankItems:Array;
      
      private var ranks:CrewRanks;
      
      private var optionsList:DropDownList;
      
      private var descriptionOverlay:Sprite;
      
      private var disabledLabel:Label;
      
      public function MemberSettings(param1:String, param2:String, param3:CrewRank, param4:CrewRanks, param5:String = "")
      {
         var i:int;
         var item:DropDownListItem = null;
         var crewId:String = param1;
         var username:String = param2;
         var rank:CrewRank = param3;
         var ranks:CrewRanks = param4;
         var description:String = param5;
         this.rankItems = [];
         super();
         this.crewId = crewId;
         this.username = username;
         this.description = description;
         this.rank = rank;
         this.ranks = ranks;
         this.buttonMode = false;
         this.useHandCursor = false;
         usernameText.text = username.toUpperCase();
         descriptionBox.text = description || "";
         btn_close.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            Global.base.hideMemberSettings();
         });
         descriptionBox.maxChars = 100;
         chars.text = descriptionBox.text.length + " of 100 characters";
         btn_save.gotoAndStop(1);
         if(ranks.canEditDescriptions)
         {
            descriptionBox.addEventListener(Event.CHANGE,function(param1:Event):void
            {
               var _loc2_:int = 0;
               btn_save.buttonMode = true;
               btn_save.useHandCursor = true;
               chars.text = descriptionBox.text.length + " of 100 characters";
               if(descriptionBox.text.length >= 100)
               {
                  btn_save.buttonMode = false;
                  btn_save.useHandCursor = false;
                  chars.textColor = 16711680;
               }
               else if(descriptionBox.text.length >= 90)
               {
                  chars.textColor = 16750848;
               }
               else if(descriptionBox.text.length >= 80)
               {
                  chars.textColor = 16776960;
               }
               else
               {
                  chars.textColor = 65280;
               }
               if(descriptionBox.numLines > 3)
               {
                  _loc2_ = descriptionBox.getLineOffset(3) - 1;
                  _loc2_ = descriptionBox.text.substring(0,_loc2_ + 1).search(/\S\s*$/);
                  descriptionBox.text = descriptionBox.text.substring(0,_loc2_ + 1);
               }
            });
         }
         else
         {
            descriptionBox.mouseEnabled = false;
            descriptionBox.selectable = false;
            descriptionBox.type = TextFieldType.DYNAMIC;
            this.descriptionOverlay = new Sprite();
            this.descriptionOverlay.graphics.clear();
            this.descriptionOverlay.graphics.beginFill(0,0.5);
            this.descriptionOverlay.graphics.drawRect(0,0,descriptionBox.width + 7,descriptionBox.height + 7);
            this.descriptionOverlay.graphics.endFill();
            this.descriptionOverlay.x = descriptionBox.x - 3;
            this.descriptionOverlay.y = descriptionBox.y - 4;
            addChild(this.descriptionOverlay);
            this.disabledLabel = new Label("Disabled",15,"left",16777215,false,"system");
            this.disabledLabel.x = (this.descriptionOverlay.width - this.disabledLabel.width) / 2;
            this.disabledLabel.y = (this.descriptionOverlay.height - this.disabledLabel.height) / 2;
            this.descriptionOverlay.addChild(this.disabledLabel);
         }
         btn_save.addEventListener(MouseEvent.CLICK,this.handleSaveButton);
         if(ranks.myRank.canRemoveMember(rank))
         {
            btn_remove.addEventListener(MouseEvent.CLICK,this.handleRemoveMember);
         }
         else
         {
            btn_remove.visible = false;
         }
         this.btn_dropdown.visible = false;
         this.dropdownContainer.visible = false;
         i = 0;
         while(i < ranks.ranks.length)
         {
            item = new DropDownListItem((ranks.ranks[i] as CrewRank).name,dropdownContainer.width,this.handleRankItemClick);
            this.rankItems.push(item);
            i++;
         }
         this.optionsList = new DropDownList(dropdownContainer.width,this.rankItems);
         this.optionsList.inputBox.text = rank.name;
         this.optionsList.x = btn_dropdown.x;
         --btn_dropdown.y;
         this.optionsList.arrowContainer.visible = ranks.myRank.canChangeRankOf(rank);
         this.optionsList.overlayContainer.visible = ranks.myRank.canChangeRankOf(rank);
         addChild(this.optionsList);
         if(!ranks.myRank.canManageMembers)
         {
            btn_save.visible = false;
            btn_remove.visible = false;
         }
      }
      
      private function handleRemoveMember(param1:MouseEvent) : void
      {
         var prompt:ConfirmPrompt = null;
         var e:MouseEvent = param1;
         prompt = new ConfirmPrompt("Are you sure you want to remove this member from the crew?",true,"Remove",false);
         Global.base.showOnTop(prompt);
         prompt.btn_yes.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            var e:MouseEvent = param1;
            Global.base.showLoadingScreen("Removing user from crew...");
            Global.base.requestCrewLobbyMethod("crew" + crewId,"removeMember",function(param1:Message):void
            {
               Global.base.updateMemberItems();
               Global.base.hideLoadingScreen();
               prompt.close();
               Global.base.hideMemberSettings();
            },null,username);
         });
      }
      
      private function handleRankItemClick(param1:MouseEvent) : void
      {
         var _loc2_:DropDownListItem = param1.target as DropDownListItem;
         var _loc3_:int = this.rankItems.indexOf(_loc2_);
         this.rank = this.ranks.getRank(_loc3_);
         this.optionsList.inputBox.text = _loc2_.text;
         this.optionsList.showDropDownList(false);
      }
      
      private function handleSaveButton(param1:MouseEvent) : void
      {
         var maxA:int = 0;
         var e:MouseEvent = param1;
         var a:int = 0;
         maxA = 2;
         Global.base.showLoadingScreen("Saving");
         Global.base.requestCrewLobbyMethod("crew" + this.crewId,"setMemberInfo",function(param1:Message):void
         {
            if(param1.getBoolean(0))
            {
               description = param1.getString(1);
            }
            if(++a == maxA)
            {
               finishedSaving();
            }
         },null,this.username,descriptionBox.text);
         if(this.optionsList.inputBox.text.length > 0 && this.ranks.myRank.canChangeRankOf(this.rank))
         {
            Global.base.requestCrewLobbyMethod("crew" + this.crewId,"setMemberRank",function(param1:Message):void
            {
               if(param1.getBoolean(0))
               {
                  rank = ranks.getRank(param1.getInt(1));
                  optionsList.inputBox.text = rank.name;
               }
               if(++a == maxA)
               {
                  finishedSaving();
               }
            },null,this.username,this.rank.id);
         }
         else
         {
            maxA--;
         }
         if(maxA == 0)
         {
            this.finishedSaving();
         }
      }
      
      private function finishedSaving() : void
      {
         if(Global.base.crewProfile != null && Global.base.overlayContainer.contains(Global.base.crewProfile))
         {
            Global.base.updateMemberItems(true,this.username,this.description,this.rank.id);
         }
         else
         {
            Global.base.updateMemberItems(false);
         }
         Global.base.hideLoadingScreen();
      }
   }
}


package ui
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.*;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import items.ItemAuraColor;
   import items.ItemAuraShape;
   import items.ItemManager;
   import items.ItemSmiley;
   import playerio.*;
   import sample.ui.components.Label;
   import states.PlayState;
   import ui.ingame.sam.AuraColorButton;
   import ui.ingame.sam.AuraInstance;
   import ui.ingame.sam.SmileyInstance;
   
   public class SettingsPage extends assets_settingsitem
   {
      
      private static var Arrows:Class = SettingsPage_Arrows;
      
      public static var arrowsBMD:BitmapData = new Arrows().bitmapData;
      
      private var smileys:Vector.<SmileyInstance>;
      
      private var auras:Vector.<AuraInstance>;
      
      private var badges:Vector.<BadgeInstance>;
      
      private var currentSmiley:SmileyInstance;
      
      private var currentAura:AuraInstance;
      
      private var currentBadge:BadgeInstance;
      
      private var smileyId:int = 0;
      
      private var auraId:int = 0;
      
      private var badgeId:int = 0;
      
      private var minimapTransparentValue:Number;
      
      private var greenOnMinimap:Boolean;
      
      private var blockPicker:Boolean;
      
      private var wordFilter:Boolean;
      
      private var hideChatBubbles:Boolean;
      
      private var hideProfile:Boolean;
      
      private var hideUsernames:Boolean;
      
      private var particlesEnabled:Boolean;
      
      private var blockInvites:Boolean;
      
      private var packageNames:Boolean;
      
      private var collapsedMode:Boolean;
      
      private var coloredUsernames:Boolean;
      
      private var first:Boolean = true;
      
      private var ss:UI2;
      
      private var hoverlabel:HoverLabel;
      
      private var hovertimer:uint;
      
      private var currentHover:*;
      
      private var names:Array;
      
      private var closeButton:ProfileCloseButton;
      
      private var inGame:Boolean;
      
      private var blackBG:BlackBG;
      
      private var that:SettingsPage;
      
      private var ui2:UI2;
      
      private var buttonsContainer:Sprite;
      
      private var minRows:int = 3;
      
      private var maxRows:int = 10;
      
      private var currentRows:int;
      
      private var keyBindingsMenu:KeyBindingsMenu;
      
      private var ox:Number = 0;
      
      private var oy:Number = 0;
      
      public function SettingsPage(param1:Boolean = false, param2:UI2 = null)
      {
         var foundBadge:Boolean;
         var k:int;
         var i:int = 0;
         var j:int = 0;
         var inGame:Boolean = param1;
         var ui2:UI2 = param2;
         this.smileys = new Vector.<SmileyInstance>();
         this.auras = new Vector.<AuraInstance>();
         this.badges = new Vector.<BadgeInstance>();
         this.names = ["minimap","particles","transparent","filter","usernames","chatbubbles","showprofile","blockinvites","packagenames","vrows","collapsed","coloredusernames","blockpicker"];
         this.currentRows = Global.base.settings.visibleRows;
         super();
         this.that = this;
         this.inGame = inGame;
         this.ui2 = ui2;
         this.hoverlabel = new HoverLabel(250);
         this.hoverlabel.visible = false;
         gotoAndStop(inGame ? 2 : 1);
         this.ss = Global.base.ui2instance;
         minimapTransparency.restrict = "0-9 %";
         historyLimitAmount.restrict = "0-9";
         if(inGame)
         {
            this.blackBG = new BlackBG();
            this.blackBG.y = -50;
            addChildAt(this.blackBG,0);
            this.closeButton = new ProfileCloseButton();
            this.closeButton.x = x + bg.width - this.closeButton.width / 2;
            this.closeButton.y = y - this.closeButton.height / 2;
            this.closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseButton);
            addChild(this.closeButton);
            visibleRowsNum.selectable = false;
            visibleRowsNum.text = "" + this.currentRows;
         }
         this.initItems();
         if(!inGame)
         {
            i = 0;
            while(i < this.smileys.length)
            {
               if(Boolean(this.smileys[i]) && SmileyInstance(this.smileys[i]).item.id == Global.playerObject.smiley)
               {
                  this.setSelectedSmiley(i);
                  break;
               }
               i++;
            }
            j = 0;
            while(j < this.auras.length)
            {
               if(Boolean(this.auras[j]) && AuraInstance(this.auras[j]).item.id == Global.playerObject.aura)
               {
                  this.setSelectedAura(j,Global.playerObject.auraColor);
                  break;
               }
               j++;
            }
         }
         foundBadge = false;
         k = 0;
         while(k < this.badges.length)
         {
            if(Boolean(this.badges[k]) && BadgeInstance(this.badges[k]).id == Global.playerObject.badge)
            {
               this.setSelectedBadge(k);
               foundBadge = true;
               break;
            }
            k++;
         }
         if(!foundBadge)
         {
            this.setSelectedBadge(0);
         }
         this.initCheckBoxStates();
         this.initEventListeners();
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
      }
      
      private function initItems() : void
      {
         var _loc1_:Vector.<ItemSmiley> = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<ItemAuraShape> = null;
         var _loc4_:int = 0;
         var _loc5_:ItemSmiley = null;
         var _loc6_:ItemAuraShape = null;
         if(!this.inGame)
         {
            _loc1_ = ItemManager.smilies;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc5_ = _loc1_[_loc2_];
               if(_loc5_.payvaultid == "" || Global.base.client.payVault.has(_loc5_.payvaultid) || _loc5_.payvaultid == "pro" && Global.player_is_beta_member || Global.playerObject.goldmember && _loc5_.payvaultid == "goldmember")
               {
                  this.addSmiley(new SmileyInstance(_loc5_,this.ss,Global.playerObject.wearsGoldSmiley));
               }
               _loc2_++;
            }
            _loc3_ = ItemManager.auraShapes;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc6_ = _loc3_[_loc4_];
               if(_loc6_.payvaultid == "" || Global.base.client.payVault.has(_loc6_.payvaultid) || Global.playerObject.goldmember && _loc6_.payvaultid == "goldmember")
               {
                  this.addAura(new AuraInstance(_loc6_,this.ss));
               }
               _loc4_++;
            }
         }
         this.badges = new Vector.<BadgeInstance>();
         this.badges.push(new BadgeInstance());
         this.badges = this.badges.concat(Badges.getCompletedBadges());
      }
      
      private function initCheckBoxStates() : void
      {
         this.greenOnMinimap = Global.base.settings.greenOnMinimap;
         greenOnMinimapCheck.gotoAndStop(int(this.greenOnMinimap) + 1);
         this.minimapTransparentValue = 100 - Global.base.settings.minimapAlpha * 100;
         minimapTransparency.text = Math.ceil(this.minimapTransparentValue) + "%";
         historyLimitAmount.text = Global.base.settings.historyLimit.toString();
         this.wordFilter = Global.base.settings.wordFilter;
         wordFilterCheck.gotoAndStop(int(this.wordFilter) + 1);
         this.hideChatBubbles = Global.base.settings.hideBubbles;
         hideChatBubblesCheck.gotoAndStop(int(this.hideChatBubbles) + 1);
         this.hideUsernames = Global.base.settings.hideUsernames;
         hideUsernamesCheck.gotoAndStop(int(this.hideUsernames) + 1);
         this.particlesEnabled = Global.base.settings.particles;
         particleCheck.gotoAndStop(int(this.particlesEnabled) + 1);
         this.coloredUsernames = Global.base.settings.coloredNames;
         coloredUsernamesCheck.gotoAndStop(int(this.coloredUsernames) + 1);
         if(this.inGame)
         {
            this.packageNames = Global.base.settings.showPackageNames;
            packageNamesCheck.gotoAndStop(int(this.packageNames) + 1);
            this.currentRows = Global.base.settings.visibleRows;
            visibleRowsNum.text = Global.base.settings.visibleRows.toString();
            this.collapsedMode = Global.base.settings.collapsed;
            collapsedCheck.gotoAndStop(int(this.collapsedMode) + 1);
            this.blockPicker = Global.base.settings.blockPicker;
            blockPickerCheck.gotoAndStop(int(this.blockPicker) + 1);
         }
         Global.base.requestRemoteMethod("getBlockStatus",function(param1:Message):void
         {
            blockInvites = param1.getBoolean(0);
            blockInvitesCheck.gotoAndStop(int(blockInvites) + 1);
         });
         Global.base.requestRemoteMethod("getProfile",function(param1:Message):void
         {
            hideProfile = param1.getBoolean(0);
            hideProfileCheck.gotoAndStop(int(hideProfile) + 1);
         });
      }
      
      protected function handleChangeRowsCount(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case visibleRowsRemove:
               this.setRows(-1);
               break;
            case visibleRowsAdd:
               this.setRows(1);
         }
      }
      
      private function setRows(param1:int) : void
      {
         this.currentRows += param1;
         this.currentRows = Math.max(this.minRows,Math.min(this.currentRows,this.maxRows));
         visibleRowsNum.text = "" + this.currentRows;
         Global.base.settings.visibleRows = this.currentRows;
         if(this.inGame && this.ui2 != null)
         {
            this.ui2.updateSelectorBricks();
         }
      }
      
      private function initEventListeners() : void
      {
         var _loc2_:int = 0;
         var _loc3_:ItemAuraColor = null;
         var _loc4_:AuraColorButton = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         greenOnMinimapCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         minimapTransparency.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyPresses);
         minimapTransparency.addEventListener(FocusEvent.FOCUS_IN,this.handleTransparencyBox);
         minimapTransparency.addEventListener(FocusEvent.FOCUS_OUT,this.handleTransparencyBox);
         historyLimitAmount.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyPresses);
         historyLimitAmount.addEventListener(FocusEvent.FOCUS_IN,this.handleHistoryBox);
         historyLimitAmount.addEventListener(FocusEvent.FOCUS_OUT,this.handleHistoryBox);
         wordFilterCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         hideChatBubblesCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         hideProfileCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         hideUsernamesCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         particleCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         blockInvitesCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         coloredUsernamesCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         if(!this.inGame)
         {
            smileyBox.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            smileyBox.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
            smileyBox.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
            auraBox.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            auraBox.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
            auraBox.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
            auraName.mouseEnabled = false;
            auraName.y -= 10;
            this.buttonsContainer = new Sprite();
            auraBox.addChild(this.buttonsContainer);
            _loc2_ = 0;
            while(_loc2_ < ItemManager.auraColors.length)
            {
               _loc3_ = ItemManager.auraColors[_loc2_];
               if(_loc3_.payVaultId == "" || Global.base.client.payVault.has(_loc3_.payVaultId) || Global.playerObject.goldmember && _loc3_.payVaultId == "goldmember")
               {
                  _loc4_ = new AuraColorButton(_loc3_,this.handleChangeAuraColor);
                  this.addColor(_loc4_);
               }
               _loc2_++;
            }
         }
         else
         {
            packageNamesCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
            collapsedCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
            visibleRowsRemove.addEventListener(MouseEvent.CLICK,this.handleChangeRowsCount);
            visibleRowsAdd.addEventListener(MouseEvent.CLICK,this.handleChangeRowsCount);
            blockPickerCheck.addEventListener(MouseEvent.CLICK,this.handleCheckBoxes);
         }
         badgeBox.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
         badgeBox.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
         badgeBox.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
         var _loc1_:int = 0;
         while(_loc1_ < this.names.length)
         {
            _loc5_ = "tf_" + this.names[_loc1_];
            if(_loc1_ >= this.names.length - 5 && !this.inGame)
            {
               break;
            }
            _loc6_ = getChildByName("tf_" + this.names[_loc1_]);
            _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouse);
            _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouse);
            _loc6_.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
            _loc1_++;
         }
         btnKeybindings.addEventListener(MouseEvent.CLICK,this.handleKeyBindings);
         addEventListener(Event.REMOVED_FROM_STAGE,this.closeKeyBindings);
      }
      
      protected function handleChangeAuraColor(param1:int) : void
      {
         this.setSelectedAura(this.auraId,param1);
      }
      
      private function addColor(param1:AuraColorButton) : void
      {
         param1.x = this.ox;
         param1.y = this.oy;
         this.ox += 13;
         param1.useHandCursor = true;
         param1.mouseEnabled = true;
         param1.buttonMode = true;
         this.buttonsContainer.addChild(param1);
         this.buttonsContainer.x = (auraBox.width - this.buttonsContainer.width) / 2;
         this.buttonsContainer.y = auraBox.height - this.buttonsContainer.height - 3;
      }
      
      private function addArrows() : void
      {
         var rightBMD:BitmapData;
         var smileyLeftBM:Bitmap = null;
         var smileyRightBM:Bitmap = null;
         var smileyLeft:Sprite = null;
         var smileyRight:Sprite = null;
         var auraLeftBM:Bitmap = null;
         var auraRightBM:Bitmap = null;
         var auraLeft:Sprite = null;
         var auraRight:Sprite = null;
         var badgeLeftBM:Bitmap = null;
         var badgeRightBM:Bitmap = null;
         var badgeLeft:Sprite = null;
         var badgeRight:Sprite = null;
         var leftBMD:BitmapData = new BitmapData(20,64,true,0);
         leftBMD.copyPixels(arrowsBMD,new Rectangle(0,0,20,64),new Point(0,0));
         rightBMD = new BitmapData(20,64,true,0);
         rightBMD.copyPixels(arrowsBMD,new Rectangle(20,0,20,64),new Point(0,0));
         if(!this.inGame)
         {
            smileyLeftBM = new Bitmap(leftBMD);
            smileyRightBM = new Bitmap(rightBMD);
            smileyLeft = new Sprite();
            smileyRight = new Sprite();
            smileyLeft.addChild(smileyLeftBM);
            smileyRight.addChild(smileyRightBM);
            smileyLeft.x = this.currentSmiley.x - 29;
            smileyLeft.y = this.currentSmiley.y + (this.currentSmiley.height - smileyLeft.height) / 2;
            smileyLeft.addEventListener(MouseEvent.CLICK,function():void
            {
               switchSmiley(-1);
            });
            smileyRight.x = this.currentSmiley.x + this.currentSmiley.width + 10;
            smileyRight.y = this.currentSmiley.y + (this.currentSmiley.height - smileyRight.height) / 2;
            smileyRight.addEventListener(MouseEvent.CLICK,function():void
            {
               switchSmiley(1);
            });
            addChild(smileyLeft);
            addChild(smileyRight);
            if(this.auras.length > 1)
            {
               auraLeftBM = new Bitmap(leftBMD);
               auraRightBM = new Bitmap(rightBMD);
               auraLeft = new Sprite();
               auraRight = new Sprite();
               auraLeft.addChild(auraLeftBM);
               auraRight.addChild(auraRightBM);
               auraLeft.x = this.currentAura.x - 29;
               auraLeft.y = this.currentAura.y + (this.currentAura.height - auraLeft.height) / 2;
               auraLeft.addEventListener(MouseEvent.CLICK,function():void
               {
                  switchAura(-1);
               });
               auraRight.x = this.currentAura.x + this.currentAura.width + 10;
               auraRight.y = this.currentAura.y + (this.currentAura.height - auraRight.height) / 2;
               auraRight.addEventListener(MouseEvent.CLICK,function():void
               {
                  switchAura(1);
               });
               addChild(auraLeft);
               addChild(auraRight);
            }
         }
         if(this.badges.length > 1)
         {
            badgeLeftBM = new Bitmap(leftBMD);
            badgeRightBM = new Bitmap(rightBMD);
            badgeLeft = new Sprite();
            badgeRight = new Sprite();
            badgeLeft.addChild(badgeLeftBM);
            badgeRight.addChild(badgeRightBM);
            badgeLeft.x = this.currentBadge.x - 29;
            badgeLeft.y = this.currentBadge.y + (this.currentBadge.height - badgeLeft.height) / 2;
            badgeLeft.addEventListener(MouseEvent.CLICK,function():void
            {
               switchBadge(-1);
            });
            badgeRight.x = this.currentBadge.x + this.currentBadge.width + 10;
            badgeRight.y = this.currentBadge.y + (this.currentBadge.height - badgeRight.height) / 2;
            badgeRight.addEventListener(MouseEvent.CLICK,function():void
            {
               switchBadge(1);
            });
            addChild(badgeLeft);
            addChild(badgeRight);
         }
      }
      
      public function setSelectedSmiley(param1:int) : void
      {
         if(param1 >= this.smileys.length || param1 < 0)
         {
            param1 = 0;
         }
         this.smileyId = param1;
         this.currentSmiley = this.smileys[param1];
         this.currentSmiley.mouseChildren = false;
         addChild(this.currentSmiley);
         Global.playerObject.smiley = this.currentSmiley.item.id;
         Global.base.requestRemoteMethod("changeSmiley",null,this.currentSmiley.item.id);
         smileyName.text = this.currentSmiley.item.name;
         this.redraw();
      }
      
      public function setSelectedAura(param1:int, param2:int) : void
      {
         if(param1 >= this.auras.length || param1 < 0)
         {
            param1 = 0;
         }
         this.auraId = param1;
         this.currentAura = this.auras[param1];
         addChild(this.currentAura);
         Global.playerObject.aura = this.currentAura.item.id;
         Global.playerObject.auraColor = param2;
         this.currentAura.changeColor(param2);
         Global.base.requestRemoteMethod("changeAura",null,this.currentAura.item.id,param2);
         auraName.text = this.currentAura.item.name + " Aura";
         this.redraw();
      }
      
      public function setSelectedBadge(param1:int) : void
      {
         if(param1 >= this.badges.length || param1 < 0)
         {
            param1 = 0;
         }
         this.badgeId = param1;
         this.currentBadge = this.badges[param1];
         addChild(this.currentBadge);
         Global.playerObject.badge = this.currentBadge.id;
         if(this.inGame)
         {
            this.ui2.connection.send("changeBadge",this.currentBadge.id);
         }
         else
         {
            Global.base.requestRemoteMethod("changeBadge",null,this.currentBadge.id);
         }
         badgeName.text = this.currentBadge.title + " Badge";
         this.redraw();
      }
      
      private function switchSmiley(param1:int = 1) : void
      {
         this.clearSmiley();
         this.smileyId += param1;
         if(param1 < 0 && this.smileyId < 0)
         {
            this.smileyId = this.smileys.length - 1;
         }
         if(param1 > 0 && this.smileyId >= this.smileys.length)
         {
            this.smileyId = 0;
         }
         this.setSelectedSmiley(this.smileyId);
      }
      
      private function switchAura(param1:int = 1) : void
      {
         this.clearAura();
         this.auraId += param1;
         if(param1 < 0 && this.auraId < 0)
         {
            this.auraId = this.auras.length - 1;
         }
         if(param1 > 0 && this.auraId >= this.auras.length)
         {
            this.auraId = 0;
         }
         this.setSelectedAura(this.auraId,Global.playerObject.auraColor);
      }
      
      private function switchBadge(param1:int = 1) : void
      {
         this.clearBadge();
         this.badgeId += param1;
         if(param1 < 0 && this.badgeId < 0)
         {
            this.badgeId = this.badges.length - 1;
         }
         if(param1 > 0 && this.badgeId >= this.badges.length)
         {
            this.badgeId = 0;
         }
         this.setSelectedBadge(this.badgeId);
      }
      
      public function clearSmiley() : void
      {
         if(this.currentSmiley)
         {
            removeChild(this.currentSmiley);
            this.currentSmiley = null;
         }
      }
      
      public function clearAura() : void
      {
         if(this.currentAura)
         {
            removeChild(this.currentAura);
            this.currentAura = null;
         }
      }
      
      public function clearBadge() : void
      {
         if(this.currentBadge)
         {
            removeChild(this.currentBadge);
            this.currentBadge = null;
         }
      }
      
      private function handleCheckBoxes(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         switch(e.target)
         {
            case greenOnMinimapCheck:
               this.greenOnMinimap = !this.greenOnMinimap;
               greenOnMinimapCheck.gotoAndStop(int(this.greenOnMinimap) + 1);
               Global.base.settings.greenOnMinimap = this.greenOnMinimap;
               break;
            case blockPickerCheck:
               this.blockPicker = !this.blockPicker;
               blockPickerCheck.gotoAndStop(int(this.blockPicker) + 1);
               Global.base.settings.blockPicker = this.blockPicker;
               break;
            case wordFilterCheck:
               this.wordFilter = !this.wordFilter;
               wordFilterCheck.gotoAndStop(int(this.wordFilter) + 1);
               Global.base.settings.wordFilter = this.wordFilter;
               Global.base.filterbadwords = this.wordFilter;
               break;
            case hideChatBubblesCheck:
               this.hideChatBubbles = !this.hideChatBubbles;
               hideChatBubblesCheck.gotoAndStop(int(this.hideChatBubbles) + 1);
               Global.base.settings.hideBubbles = this.hideChatBubbles;
               break;
            case hideProfileCheck:
               Global.base.requestRemoteMethod("toggleProfile",function(param1:Message):void
               {
                  hideProfile = !hideProfile;
                  hideProfileCheck.gotoAndStop(int(hideProfile) + 1);
               },!this.hideProfile);
               break;
            case hideUsernamesCheck:
               this.hideUsernames = !this.hideUsernames;
               hideUsernamesCheck.gotoAndStop(int(this.hideUsernames) + 1);
               Global.base.settings.hideUsernames = this.hideUsernames;
               break;
            case blockInvitesCheck:
               Global.base.requestRemoteMethod("blockAllInvites",function(param1:Message):void
               {
                  blockInvites = param1.getBoolean(0);
                  blockInvitesCheck.gotoAndStop(int(blockInvites) + 1);
               },!this.blockInvites);
               break;
            case particleCheck:
               this.particlesEnabled = !this.particlesEnabled;
               particleCheck.gotoAndStop(int(this.particlesEnabled) + 1);
               Global.base.settings.particles = this.particlesEnabled;
               break;
            case coloredUsernamesCheck:
               this.coloredUsernames = !this.coloredUsernames;
               coloredUsernamesCheck.gotoAndStop(int(this.coloredUsernames) + 1);
               Global.base.settings.coloredNames = this.coloredUsernames;
               break;
            case packageNamesCheck:
               this.packageNames = !this.packageNames;
               packageNamesCheck.gotoAndStop(int(this.packageNames) + 1);
               Global.base.settings.showPackageNames = this.packageNames;
               if(this.inGame && this.ui2 != null)
               {
                  this.ui2.updateSelectorBricks();
               }
               break;
            case collapsedCheck:
               this.collapsedMode = !this.collapsedMode;
               collapsedCheck.gotoAndStop(int(this.collapsedMode) + 1);
               Global.base.settings.collapsed = this.collapsedMode;
               if(this.inGame && this.ui2 != null)
               {
                  this.ui2.updateSelectorBricks();
               }
         }
      }
      
      private function handleKeyPresses(param1:KeyboardEvent) : void
      {
         switch(param1.target)
         {
            case minimapTransparency:
               if(param1.keyCode == 13)
               {
                  this.setTransparency();
               }
               break;
            case historyLimitAmount:
               if(param1.keyCode == 13)
               {
                  this.setHistoryLimit();
               }
         }
      }
      
      private function handleHistoryBox(param1:FocusEvent) : void
      {
         if(param1.type == FocusEvent.FOCUS_OUT)
         {
            this.setHistoryLimit();
         }
      }
      
      private function setHistoryLimit() : void
      {
         var _loc1_:int = 0;
         stage.stageFocusRect = false;
         stage.focus = this;
         if(historyLimitAmount.text.length > 0)
         {
            _loc1_ = int(historyLimitAmount.text);
            Global.base.settings.historyLimit = _loc1_;
         }
      }
      
      private function handleTransparencyBox(param1:FocusEvent) : void
      {
         if(param1.type == FocusEvent.FOCUS_OUT)
         {
            this.setTransparency();
         }
      }
      
      private function setTransparency() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         stage.stageFocusRect = false;
         stage.focus = this;
         if(minimapTransparency.text.length > 0)
         {
            _loc1_ = 90;
            _loc2_ = int(minimapTransparency.text.replace("%",""));
            if(_loc2_ > 90)
            {
               _loc2_ = 90;
            }
            if(_loc2_ < 1)
            {
               _loc2_ = 1;
            }
            _loc3_ = 100 - _loc2_;
            minimapTransparency.text = _loc2_ + "%";
            Global.base.settings.minimapAlpha = _loc3_ / 100;
            if(this.inGame)
            {
               (Global.base.state as PlayState).minimap.setAlpha(Global.base.settings.minimapAlpha);
            }
         }
      }
      
      private function handleCrewCustomize(param1:MouseEvent) : void
      {
         var _loc2_:NavigationEvent = new NavigationEvent(NavigationEvent.SHOW_CREW_PROFILE,true,false);
         _loc2_.crewname = "Crew Name";
         dispatchEvent(param1);
      }
      
      private function handleKeyBindings(param1:MouseEvent) : void
      {
         if(this.keyBindingsMenu)
         {
            return;
         }
         this.keyBindingsMenu = new KeyBindingsMenu(this.closeKeyBindings);
         this.keyBindingsMenu.x = (bg.width - this.keyBindingsMenu.initW) / 2;
         this.keyBindingsMenu.y = (bg.height - this.keyBindingsMenu.initH) / 2;
         addChild(this.keyBindingsMenu);
         if(this.inGame)
         {
            this.closeButton.visible = false;
         }
         this.keyBindingsMenu.graphics.beginFill(this.inGame ? 1184274 : 0,0.67);
         this.keyBindingsMenu.graphics.drawRect(-this.keyBindingsMenu.x + 10,-this.keyBindingsMenu.y + 10,bg.width - 20,bg.height - 20);
      }
      
      public function closeKeyBindings(param1:Event = null) : void
      {
         if(this.keyBindingsMenu)
         {
            removeChild(this.keyBindingsMenu);
         }
         this.keyBindingsMenu = null;
         if(this.inGame)
         {
            this.closeButton.visible = true;
         }
      }
      
      private function redraw() : void
      {
         var _loc1_:Label = null;
         if(!this.inGame)
         {
            if(this.currentSmiley)
            {
               this.scaleImage(this.currentSmiley,2);
               this.currentSmiley.x = smileyBox.x + (smileyBox.width - this.currentSmiley.width) / 2;
               this.currentSmiley.y = smileyBox.y + (smileyBox.height - this.currentSmiley.height) / 2;
            }
            if(this.currentAura)
            {
               this.scaleImage(this.currentAura,2);
               this.currentAura.x = auraBox.x + (auraBox.width - this.currentAura.width) / 2;
               this.currentAura.y = auraBox.y + (auraBox.height - this.currentAura.height) / 2 - 10;
            }
         }
         if(this.currentBadge)
         {
            this.currentBadge.x = badgeBox.x + (badgeBox.width - this.currentBadge.width) / 2;
            this.currentBadge.y = badgeBox.y + (badgeBox.height - this.currentBadge.height) / 2;
         }
         if(this.first && this.badges.length == 0)
         {
            _loc1_ = new Label("You have no badges to display. Complete a campaign to earn a badge!",12,"center",16777215,true,"system");
            _loc1_.width = badgeBox.width - 20;
            _loc1_.x = badgeBox.x + (badgeBox.width - _loc1_.width) / 2;
            _loc1_.y = badgeBox.y + (badgeBox.height - _loc1_.height) / 2;
            addChild(_loc1_);
            badgeName.visible = false;
         }
         if(!this.inGame)
         {
            if(this.first && (Boolean(this.currentSmiley && this.currentAura) && Boolean(this.currentBadge)))
            {
               this.first = false;
               this.addArrows();
            }
         }
         else if(this.first && Boolean(this.currentBadge))
         {
            this.first = false;
            this.addArrows();
         }
      }
      
      private function addSmiley(param1:SmileyInstance) : void
      {
         this.smileys.push(param1);
      }
      
      private function addAura(param1:AuraInstance) : void
      {
         this.auras.push(param1);
      }
      
      protected function scaleImage(param1:*, param2:Number) : void
      {
         TweenMax.to(param1,0,{
            "scaleX":param2,
            "scaleY":param2
         });
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.MOUSE_OVER)
         {
            if(this.currentHover != param1.target && (Boolean(param1.target.parent) && Boolean(param1.target.parent != this.buttonsContainer)))
            {
               this.currentHover = param1.target;
            }
            this.hovertimer = setTimeout(this.showHoverLabel,800);
         }
         else
         {
            this.hoverlabel.visible = false;
            clearInterval(this.hovertimer);
         }
      }
      
      protected function handleMouseMove(param1:MouseEvent = null) : void
      {
         if(this.hoverlabel.visible)
         {
            this.hoverlabel.draw(this.getTextFromCurrentObject(this.currentHover));
            this.hoverlabel.x = parent.mouseX;
            if(this.hoverlabel.x > width / 2)
            {
               this.hoverlabel.x -= this.hoverlabel.w + 12;
            }
            else
            {
               this.hoverlabel.x += 12;
            }
            this.hoverlabel.y = parent.mouseY - this.hoverlabel.height / 2;
         }
      }
      
      public function showHoverLabel() : void
      {
         parent.addChild(this.hoverlabel);
         this.hoverlabel.alpha = 0;
         TweenMax.to(this.hoverlabel,0.25,{"alpha":1});
         this.hoverlabel.draw("" + this.getTextFromCurrentObject(this.currentHover));
         this.hoverlabel.visible = true;
         this.handleMouseMove();
      }
      
      public function getTextFromCurrentObject(param1:*) : String
      {
         switch(param1)
         {
            case tf_minimap:
               return "Toggle whether you see your trail as green on the minimap.";
            case this.tf_blockpicker:
               return "Do you like working quickly by using the block picker, but you want to do boss levels as well? Turn the block picker on or off here.";
            case this.tf_particles:
               return "Enable/disable some fancy animations ingame. Note: enabling this can cause some performance issues on slower computers.";
            case this.tf_transparent:
               return "Enable a custom amount of minimap transparency, up to 90%. This way you can work your levels without blocking a part of your screen.";
            case this.tf_filter:
               return "Enable or disable the word filter. Note: while we don\'t encourage swearing, occasionally slipping is acceptable. However, insulting, harassing or bypassing the word filter isn\'t! Respect the ones who like to keep the word filter enabled.";
            case this.tf_usernames:
               return "Toggle whether you see the users\' usernames in the playscreen.\n\nThis can also be toggled in game by pressing Shift+U";
            case this.tf_chatbubbles:
               return "Toggle whether you see chat bubbles in the playscreen.\n\nThis can also be toggled in game by pressing Shift+I";
            case this.tf_showprofile:
               return "Toggle whether other users can see your profile.";
            case this.tf_blockinvites:
               return "Toggle whether users can send you friend invites.";
            case this.smileyBox:
               return "Select your current smiley without having to join a world.";
            case this.auraBox:
               return "Select your current aura without having to join a world.";
            case this.badgeBox:
               return "Select which badge to display when people click your username on the user list, show off your skills!";
            case this.tf_packagenames:
               return "Show package names ontop of packages in the block selector.";
            case this.tf_coloredusernames:
               return "Toggle whether unique username colors are displayed. Green for friends, purple for moderators, gold for admins.";
            case this.tf_vrows:
               return "Customize the amount of rows displayed on your block bar.";
            case this.tf_collapsed:
               return "Enable the ultra-compact block bar style.";
            default:
               return "";
         }
      }
      
      protected function handleCloseButton(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         TweenMax.to(this,0.2,{
            "alpha":0,
            "onComplete":function():void
            {
               Global.base.overlayContainer.removeChild(that);
               Global.inGameSettings = false;
            }
         });
         Global.base.settings.save();
         stage.focus = Global.base;
      }
   }
}


package ui.ingame.settings
{
   import blitter.Bl;
   import com.greensock.TweenMax;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.MouseEvent;
   import ui.LevelOptions;
   import ui.SettingsPage;
   import ui.ingame.sam.SoundSlider;
   
   public class SettingsMenu extends SettingsButton
   {
      
      private static var FullScreen:Class = SettingsMenu_FullScreen;
      
      private static var fullScreenBMD:BitmapData = new FullScreen().bitmapData;
      
      private var fullScreenButton:SettingsButton;
      
      private var soundButton:SoundSlider;
      
      private var buttonsContainer:Sprite;
      
      private var ui2:UI2;
      
      private var that:SettingsMenu;
      
      private var lastButtons:Array;
      
      public var levelOptions:LevelOptions;
      
      public function SettingsMenu(param1:String, param2:UI2)
      {
         var text:String = param1;
         var ui2:UI2 = param2;
         this.lastButtons = [];
         this.that = this;
         super(text,null,function():void
         {
            toggleVisible(!buttonsContainer.visible);
         });
         this.that.ui2 = ui2;
         this.buttonsContainer = new Sprite();
         this.buttonsContainer.visible = false;
         this.ui2.above.addChild(this.buttonsContainer);
         this.addButton(new SettingsButton("Game\nSettings",null,this.handleSettings));
         if(Bl.data.canChangeWorldOptions)
         {
            this.addButton(new SettingsButton("World\nOptions",null,this.handleWorldOptions));
            this.addButton(new SettingsButton("Save\nWorld",null,this.handleSaveWorld));
         }
         if(this.that.ui2.crewPrompt != null)
         {
            this.addButton(new SettingsButton("Add\nTo Crew",null,this.handleAddToCrew));
         }
         this.soundButton = new SoundSlider();
         this.soundButton.x = SettingsButton.DEFAULT_WIDTH;
         this.addButton(this.soundButton);
         this.lastButtons.push(this.soundButton);
         this.fullScreenButton = new SettingsButton("",fullScreenBMD,this.handleFullScreenClick);
         this.fullScreenButton.x = SettingsButton.DEFAULT_WIDTH;
         this.fullScreenButton.y = -SettingsButton.DEFAULT_HEIGHT;
         this.addButton(this.fullScreenButton);
         this.lastButtons.push(this.fullScreenButton);
      }
      
      public function addButton(param1:Sprite) : void
      {
         this.buttonsContainer.addChild(param1);
         this.redraw();
      }
      
      public function removeButton(param1:Sprite) : void
      {
         this.buttonsContainer.removeChild(param1);
         this.redraw();
      }
      
      protected function handleFullScreenClick(param1:MouseEvent) : void
      {
         if(!Config.isMobile)
         {
            try
            {
               if(Bl.stage.displayState == StageDisplayState.NORMAL)
               {
                  Bl.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
               }
               else
               {
                  Bl.stage.displayState = StageDisplayState.NORMAL;
               }
            }
            catch(e:Error)
            {
            }
         }
      }
      
      protected function handleSaveWorld(param1:MouseEvent) : void
      {
         this.toggleVisible(false);
         Global.base.showLoadingScreen("Saving World");
         this.that.ui2.connection.send("save");
      }
      
      protected function handleAddToCrew(param1:MouseEvent) : void
      {
         this.toggleVisible(false);
         if(this.that.ui2.crewPrompt != null)
         {
            Global.base.overlayContainer.addChild(this.that.ui2.crewPrompt);
            TweenMax.to(this.that.ui2.crewPrompt,0,{"alpha":0});
            TweenMax.to(this.that.ui2.crewPrompt,0.2,{"alpha":1});
         }
      }
      
      protected function handleSettings(param1:MouseEvent) : void
      {
         var _loc2_:SettingsPage = null;
         this.toggleVisible(false);
         if(Global.inGameSettings)
         {
            return;
         }
         _loc2_ = new SettingsPage(true,this.ui2);
         _loc2_.x = (Config.maxwidth - _loc2_.bg.width) / 2;
         _loc2_.y = (500 - _loc2_.bg.height) / 2;
         Global.base.overlayContainer.addChild(_loc2_);
         Global.inGameSettings = true;
      }
      
      protected function handleWorldOptions(param1:MouseEvent) : void
      {
         this.toggleVisible(false);
         var _loc2_:Boolean = Global.playerObject.goldmember;
         this.levelOptions = new LevelOptions(this.that.ui2.connection,Global.currentLevelname,this.that.ui2.editKey,this.that.ui2.roomVisible,this.that.ui2.roomHiddenFromLobby,this.that.ui2.allowSpectating,this.that.ui2.description,this.that.ui2.curseLimit,this.that.ui2.zombieLimit,this.that.ui2.worldMapEnabled,this.that.ui2.lobbyPreviewEnabled,_loc2_ || Global.base.client.payVault.has("brickeffectcurse"),_loc2_ || Global.base.client.payVault.has("brickeffectzombie"),this.that.ui2);
         Global.base.showOnTop(this.levelOptions);
      }
      
      public function toggleVisible(param1:Boolean) : void
      {
         if(param1)
         {
            this.that.ui2.hideAll();
         }
         this.buttonsContainer.visible = param1;
         var _loc2_:Boolean = this.buttonsContainer.x > Config.width - this.buttonsContainer.width + 5;
         this.soundButton.x = _loc2_ ? -this.soundButton.WIDTH : SettingsButton.DEFAULT_WIDTH;
         this.fullScreenButton.x = _loc2_ ? -this.fullScreenButton.WIDTH : SettingsButton.DEFAULT_WIDTH;
      }
      
      public function redraw() : void
      {
         var _loc3_:Sprite = null;
         if(this.ui2.settingsMenu)
         {
            this.buttonsContainer.x = this.ui2.settingsMenu.x;
            this.buttonsContainer.y = this.ui2.settingsMenu.y - 29;
         }
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.buttonsContainer.numChildren)
         {
            _loc3_ = this.buttonsContainer.getChildAt(_loc2_) as Sprite;
            if(_loc3_.x == 0)
            {
               _loc3_.y = _loc1_ * -29;
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      public function remove() : void
      {
         if(this.buttonsContainer.parent)
         {
            this.ui2.above.removeChild(this.buttonsContainer);
         }
      }
   }
}


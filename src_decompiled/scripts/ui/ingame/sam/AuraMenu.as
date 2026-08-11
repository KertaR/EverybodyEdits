package ui.ingame.sam
{
   import blitter.Bl;
   import flash.display.Sprite;
   import flash.events.Event;
   import items.ItemAuraColor;
   import items.ItemAuraShape;
   import states.PlayState;
   
   public class AuraMenu extends Sprite
   {
      
      private var auraContainer:Sprite;
      
      public var auraSelector:AuraSelector;
      
      private var containerWidth:int = 240;
      
      private var containerHeight:int = 65;
      
      private var ui2:UI2;
      
      private var auras:Array;
      
      public function AuraMenu(param1:UI2)
      {
         super();
         visible = false;
         this.ui2 = param1;
         this.auras = [];
         this.auraContainer = new Sprite();
         addChild(this.auraContainer);
         this.auraSelector = new AuraSelector(this.ui2);
         addChild(this.auraSelector);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
      }
      
      public function redraw() : void
      {
         var _loc1_:Boolean = Boolean(Bl.data.canToggleGodMode) && !Global.player_is_guest && !Bl.data.isOpenWorld;
         var _loc2_:PlayState = Global.base.state as PlayState;
         if(Boolean(_loc2_) && _loc2_.player.isInGodMode)
         {
            _loc1_ = true;
         }
         this.auraContainer.graphics.clear();
         if(_loc1_)
         {
            this.auraContainer.graphics.lineStyle(1,8092539,1);
            this.auraContainer.graphics.beginFill(3289650,1);
            this.auraContainer.graphics.drawRect(0,0,this.containerWidth,this.containerHeight);
            this.auraContainer.graphics.endFill();
         }
         this.auraSelector.x = this.containerWidth / 2 - this.auraSelector.width;
         this.auraSelector.visible = _loc1_;
         x = 35;
         y = -(this.containerHeight + 30);
      }
      
      public function addShape(param1:ItemAuraShape) : void
      {
         this.auraSelector.addAura(new AuraInstance(param1,this.ui2));
      }
      
      public function addColor(param1:ItemAuraColor) : void
      {
         var color:ItemAuraColor = param1;
         this.auraSelector.addColor(new AuraColorButton(color,function(param1:int):void
         {
            ui2.setSelectedAuraColor(param1);
         }));
      }
      
      protected function handleAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         this.redraw();
      }
   }
}


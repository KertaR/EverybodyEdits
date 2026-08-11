package ui.ingame.sam
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import sample.ui.components.Label;
   
   public class AuraSelector extends MovieClip
   {
      
      private static var Arrows:Class = AuraSelector_Arrows;
      
      public static var arrowsBMD:BitmapData = new Arrows().bitmapData;
      
      private var buttonsContainer:Sprite;
      
      private var buttonsContainerWidth:int = 105;
      
      private var buttonsContainerHeight:int = 45;
      
      private var auras:Vector.<AuraInstance> = new Vector.<AuraInstance>();
      
      public var basiswidth:int = 104;
      
      private var selectedAura:AuraInstance;
      
      private var id:int = 0;
      
      private var ui2s:UI2;
      
      private var colorsLabel:Label;
      
      private var shapeLabel:Label;
      
      private var shapeName:Label;
      
      private var left:Sprite;
      
      private var ox:int = 0;
      
      private var oy:int = 5;
      
      public function AuraSelector(param1:UI2)
      {
         super();
         this.ui2s = param1;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAttach);
         this.buttonsContainer = new Sprite();
         addChild(this.buttonsContainer);
         this.colorsLabel = new Label("Aura Color",12,"left",16777215,false,"visitor");
         this.colorsLabel.x = 84 + (224 - 84 - this.colorsLabel.textWidth) / 2;
         this.colorsLabel.y = 3;
         addChild(this.colorsLabel);
         this.shapeLabel = new Label("Aura Shape",12,"left",16777215,false,"visitor");
         this.shapeLabel.x = (224 - 124 - this.shapeLabel.textWidth) / 2;
         this.shapeLabel.y = 3;
         addChild(this.shapeLabel);
         this.shapeName = new Label("<Name>",12,"left",16777215,false,"visitor");
         this.shapeName.x = (224 - 124 - this.shapeName.textWidth) / 2;
         this.shapeName.y = 50;
         addChild(this.shapeName);
      }
      
      private function addArrows() : void
      {
         var rightBMD:BitmapData;
         var leftBM:Bitmap;
         var rightBM:Bitmap;
         var right:Sprite;
         var leftBMD:BitmapData = new BitmapData(20,64,true,0);
         leftBMD.copyPixels(arrowsBMD,new Rectangle(0,0,20,64),new Point(0,0));
         rightBMD = new BitmapData(20,64,true,0);
         rightBMD.copyPixels(arrowsBMD,new Rectangle(20,0,20,64),new Point(0,0));
         leftBM = new Bitmap(leftBMD);
         rightBM = new Bitmap(rightBMD);
         this.left = new Sprite();
         right = new Sprite();
         this.left.y = 1;
         right.y = 1;
         right.x = 84;
         this.left.addChild(leftBM);
         this.left.addEventListener(MouseEvent.CLICK,function():void
         {
            switchAura(-1);
         });
         right.addChild(rightBM);
         right.addEventListener(MouseEvent.CLICK,function():void
         {
            switchAura(1);
         });
         addChild(this.left);
         addChild(right);
      }
      
      private function switchAura(param1:int = 1) : void
      {
         this.clearAura();
         this.id += param1;
         if(param1 < 0 && this.id < 0)
         {
            this.id = this.auras.length - 1;
         }
         if(param1 > 0 && this.id >= this.auras.length)
         {
            this.id = 0;
         }
         this.selectedAura = this.auras[this.id];
         addChild(this.selectedAura);
         this.redraw();
         this.ui2s.setSelectedAura(this.selectedAura.item.id);
      }
      
      override public function get width() : Number
      {
         return this.basiswidth;
      }
      
      override public function set width(param1:Number) : void
      {
         this.basiswidth = param1;
         this.redraw();
      }
      
      public function setSelectedAura(param1:int) : void
      {
         this.clearAura();
         var _loc2_:int = 0;
         while(_loc2_ < this.auras.length)
         {
            if(Boolean(this.auras[_loc2_]) && AuraInstance(this.auras[_loc2_]).item.id == param1)
            {
               this.id = _loc2_;
               this.selectedAura = this.auras[_loc2_];
               break;
            }
            _loc2_++;
         }
         if(this.selectedAura == null)
         {
            this.id = 0;
            this.selectedAura = this.auras[0];
         }
         this.selectedAura.changeColor(Global.playerObject.auraColor);
         this.shapeName.text = this.selectedAura.item.name;
         this.shapeName.x = (224 - 124 - this.shapeName.textWidth) / 2;
         addChild(this.selectedAura);
         this.redraw();
      }
      
      public function addAura(param1:AuraInstance) : void
      {
         this.auras.push(param1);
         if(this.auras.length > 1 && this.left == null)
         {
            this.addArrows();
         }
      }
      
      public function addColor(param1:AuraColorButton) : void
      {
         if(this.ox + 20 > this.buttonsContainerWidth)
         {
            this.ox = 0;
            this.oy += 15;
         }
         param1.x = this.ox;
         param1.y = this.oy;
         this.ox += 15;
         param1.useHandCursor = true;
         param1.mouseEnabled = true;
         param1.buttonMode = true;
         this.buttonsContainer.addChild(param1);
         this.buttonsContainer.x = 84 + (224 - 84 - this.buttonsContainer.width) / 2;
         this.buttonsContainer.y = (65 - this.buttonsContainer.height) / 2;
      }
      
      public function clearAura() : void
      {
         if(this.selectedAura)
         {
            removeChild(this.selectedAura);
            this.selectedAura = null;
         }
      }
      
      public function redraw() : void
      {
         if(this.selectedAura)
         {
            this.selectedAura.x = 20;
         }
      }
      
      private function handleAttach(param1:Event) : void
      {
         this.redraw();
      }
   }
}


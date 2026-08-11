package ui.brickoverlays
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import sounds.SoundManager;
   
   public class DrumProperties extends PropertiesBackground
   {
      
      protected static var drumBM:Class = DrumProperties_drumBM;
      
      private static var drum:Bitmap = new drumBM();
      
      private static var mark:Sprite = new Sprite();
      
      private var selectors:Array = [];
      
      public function DrumProperties()
      {
         super();
         addChild(drum);
         drum.x = -(drum.width / 2);
         drum.y = -70;
         mark.graphics.clear();
         mark.graphics.beginFill(16711680,0.5);
         mark.graphics.drawCircle(0,0,4);
         mark.graphics.endFill();
         mark.mouseEnabled = false;
         var _loc1_:int = -(drum.width / 2) - 42;
         var _loc2_:int = -35;
         addChild(this.createDrumBox(0,_loc1_ = _loc1_ + 40));
         addChild(this.createDrumBox(2,_loc1_ = _loc1_ + 40));
         addChild(this.createDrumBox(10,_loc1_ = _loc1_ + 40));
         addChild(this.createDrumBox(4,_loc1_ = _loc1_ + 40));
         addChild(this.createDrumBox(8,_loc1_ = _loc1_ + 40));
         addChild(this.createDrumBox(17,_loc1_ = _loc1_ + 40));
         addChild(this.createDrumBox(7,_loc1_ = _loc1_ + 40));
         addChild(this.createDrumBox(9,_loc1_ = _loc1_ + 40));
         addChild(this.createDrumBox(19,_loc1_ = _loc1_ + 40));
         _loc1_ = -(drum.width / 2) - 9;
         addChild(this.createDrumSelector(0,_loc1_ = _loc1_ + 15,_loc2_));
         addChild(this.createDrumSelector(1,_loc1_ = _loc1_ + 15,_loc2_));
         addChild(this.createDrumSelector(2,_loc1_ = _loc1_ + (15 + 9),_loc2_));
         addChild(this.createDrumSelector(3,_loc1_ = _loc1_ + 15,_loc2_));
         addChild(this.createDrumSelector(10,_loc1_ = _loc1_ + (12 + 10),_loc2_));
         addChild(this.createDrumSelector(11,_loc1_ = _loc1_ + 12,_loc2_));
         addChild(this.createDrumSelector(12,_loc1_ = _loc1_ + 12,_loc2_));
         addChild(this.createDrumSelector(13,_loc1_ = _loc1_ - 12,_loc2_ = _loc2_ + 11));
         addChild(this.createDrumSelector(4,_loc1_ = _loc1_ + (12 + 12 + 3),_loc2_ = _loc2_ - 11));
         addChild(this.createDrumSelector(5,_loc1_ = _loc1_ + 12,_loc2_));
         addChild(this.createDrumSelector(6,_loc1_ = _loc1_ + 12,_loc2_));
         addChild(this.createDrumSelector(14,_loc1_ = _loc1_ - 18,_loc2_ = _loc2_ + 11));
         addChild(this.createDrumSelector(15,_loc1_ = _loc1_ + 12,_loc2_));
         addChild(this.createDrumSelector(8,_loc1_ = _loc1_ + (15 + 10),_loc2_ = _loc2_ - 11));
         addChild(this.createDrumSelector(16,_loc1_ = _loc1_ + 15,_loc2_));
         addChild(this.createDrumSelector(17,_loc1_ = _loc1_ + (15 + 10),_loc2_));
         addChild(this.createDrumSelector(18,_loc1_ = _loc1_ + 15,_loc2_));
         addChild(this.createDrumSelector(7,_loc1_ = _loc1_ + 32,_loc2_));
         addChild(this.createDrumSelector(9,_loc1_ = _loc1_ + 40,_loc2_));
         addChild(this.createDrumSelector(19,_loc1_ = _loc1_ + 40,_loc2_));
         setSize(drum.width + 5,72);
         this.filters = [new DropShadowFilter(0,0,0,1,6,6,2)];
         addChild(mark);
      }
      
      private function createDrumBox(param1:int, param2:int) : Sprite
      {
         var id:int = param1;
         var xx:int = param2;
         var s:Sprite = new Sprite();
         s.x = xx;
         s.y = -70;
         s.graphics.beginFill(16711680,0);
         s.graphics.drawRect(0,0,42,42);
         s.graphics.endFill();
         s.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            SoundManager.playDrumSound(id);
            selectSound(id);
         });
         return s;
      }
      
      private function createDrumSelector(param1:int, param2:int, param3:int) : Sprite
      {
         var id:int = param1;
         var xx:int = param2;
         var yy:int = param3;
         var s:Sprite = new Sprite();
         s.x = xx;
         s.y = yy;
         s.graphics.beginFill(255,0);
         s.graphics.drawRect(0,0,12,11);
         s.graphics.endFill();
         this.selectors[id] = s;
         s.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            SoundManager.playDrumSound(id);
            selectSound(id);
         });
         if(id == Global.drumOffset)
         {
            this.selectSound(id);
         }
         return s;
      }
      
      private function selectSound(param1:int) : void
      {
         Global.drumOffset = param1;
         mark.x = this.selectors[param1].x + 6;
         mark.y = this.selectors[param1].y + 5.5;
      }
   }
}


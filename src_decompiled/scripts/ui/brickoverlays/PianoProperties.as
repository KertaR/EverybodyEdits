package ui.brickoverlays
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import sounds.SoundManager;
   
   public class PianoProperties extends PropertiesBackground
   {
      
      protected static var pianoBM:Class = PianoProperties_pianoBM;
      
      private static var piano:Bitmap = new pianoBM();
      
      private static var mark:Sprite = new Sprite();
      
      public function PianoProperties()
      {
         super();
         addChild(piano);
         piano.x = -(piano.width / 2) - 1;
         piano.y = -70;
         mark.graphics.clear();
         mark.graphics.beginFill(16711680,0.5);
         mark.graphics.drawCircle(0,0,4);
         mark.graphics.endFill();
         mark.mouseEnabled = false;
         var _loc1_:int = -(piano.width / 2) - 13;
         addChild(this.createWhiteKey(-27,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-25,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-24,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-22,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-20,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-19,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-17,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-15,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-13,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-12,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-10,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-8,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-7,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-5,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-3,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(-1,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(0,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(2,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(4,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(5,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(7,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(9,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(11,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(12,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(14,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(16,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(17,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(19,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(21,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(23,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(24,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(26,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(28,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(29,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(31,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(33,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(35,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(36,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(38,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(40,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(41,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(43,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(45,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(47,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(48,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(50,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(52,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(53,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(55,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(57,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(59,_loc1_ = _loc1_ + 12));
         addChild(this.createWhiteKey(60,_loc1_ = _loc1_ + 12));
         _loc1_ = -(piano.width / 2) - 6;
         addChild(this.createBlackKey(-26,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(-23,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(-21,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(-18,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(-16,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(-14,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(-11,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(-9,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(-6,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(-4,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(-2,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(1,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(3,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(6,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(8,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(10,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(13,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(15,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(18,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(20,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(22,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(25,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(27,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(30,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(32,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(34,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(37,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(39,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(42,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(44,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(46,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(49,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(51,_loc1_ = _loc1_ + 12));
         _loc1_ += 12;
         addChild(this.createBlackKey(54,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(56,_loc1_ = _loc1_ + 12));
         addChild(this.createBlackKey(58,_loc1_ = _loc1_ + 12));
         setSize(piano.width + 4,72);
         this.filters = [new DropShadowFilter(0,0,0,1,6,6,2)];
         addChild(mark);
      }
      
      private function createWhiteKey(param1:int, param2:int) : Sprite
      {
         var s:Sprite = null;
         var id:int = param1;
         var xx:int = param2;
         s = new Sprite();
         s.x = xx;
         s.y = -61;
         if(Global.pianoOffset == id)
         {
            mark.x = s.x + 17 / 2 - 2;
            mark.y = s.y + 30;
         }
         s.graphics.beginFill(16711680,0);
         s.graphics.drawRect(0,0,12,39);
         s.graphics.endFill();
         s.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            Global.pianoOffset = id;
            SoundManager.playPianoSound(id);
            mark.x = s.x + 17 / 2 - 2;
            mark.y = s.y + 30;
         });
         return s;
      }
      
      private function createBlackKey(param1:int, param2:int) : Sprite
      {
         var s:Sprite = null;
         var id:int = param1;
         var xx:int = param2;
         s = new Sprite();
         s.x = xx;
         s.y = -61;
         s.graphics.beginFill(255,0);
         s.graphics.drawRect(0,0,8,25);
         s.graphics.endFill();
         s.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            Global.pianoOffset = id;
            SoundManager.playPianoSound(id);
            mark.x = s.x + 4.4;
            mark.y = s.y + 19;
         });
         return s;
      }
   }
}


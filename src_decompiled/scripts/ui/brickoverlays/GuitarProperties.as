package ui.brickoverlays
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import sounds.SoundManager;
   
   public class GuitarProperties extends PropertiesBackground
   {
      
      protected static var GuitarBM:Class = GuitarProperties_GuitarBM;
      
      private static var guitar:Bitmap = new GuitarBM();
      
      protected static var GuitarMarkBM:Class = GuitarProperties_GuitarMarkBM;
      
      private static var mark:Bitmap = new GuitarMarkBM();
      
      public function GuitarProperties()
      {
         var _loc2_:int = 0;
         super();
         addChild(guitar);
         guitar.x = -(guitar.width / 2) - 1;
         guitar.y = -guitar.height - 12;
         addChild(mark);
         mark.x = -237;
         mark.y = -110;
         setSize(guitar.width + 4,guitar.height + 14);
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = 0;
            while(_loc2_ < 20)
            {
               addChild(this.createFret(_loc2_ * 23 - 237 - (_loc2_ == 0 ? 0 : 3),_loc1_ * 14 - 110,_loc1_ * 20 + _loc2_));
               _loc2_++;
            }
            _loc1_++;
         }
         addChild(mark);
      }
      
      private function createFret(param1:int, param2:int, param3:int) : Sprite
      {
         var s:Sprite = null;
         var x:int = param1;
         var y:int = param2;
         var id:int = param3;
         s = new Sprite();
         s.x = x;
         s.y = y;
         if(Global.guitarOffset == id)
         {
            mark.x = s.x;
            mark.y = s.y;
         }
         s.graphics.beginFill(16711680,0);
         s.graphics.drawRect(0,0,12,8);
         s.graphics.endFill();
         s.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            Global.guitarOffset = id;
            SoundManager.playGuitarSound(SoundManager.guitarMap[id]);
            mark.x = s.x;
            mark.y = s.y;
         });
         return s;
      }
   }
}


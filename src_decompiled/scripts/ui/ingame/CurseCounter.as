package ui.ingame
{
   import states.PlayState;
   
   public class CurseCounter extends assets_cursecounter
   {
      
      private var limit:int;
      
      public function CurseCounter(param1:int)
      {
         super();
         this.visible = false;
         this.limit = param1;
      }
      
      public function update() : void
      {
         this.countPlayers();
      }
      
      public function setLimit(param1:int) : void
      {
         this.limit = param1;
         this.update();
      }
      
      private function countPlayers() : void
      {
         var _loc5_:String = null;
         var _loc6_:Player = null;
         var _loc1_:PlayState = Global.base.state as PlayState;
         var _loc2_:Object = _loc1_.getPlayers();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         for(_loc5_ in _loc2_)
         {
            _loc6_ = _loc2_[_loc5_] as Player;
            if(_loc6_.cursed)
            {
               _loc3_++;
            }
            if(this.limit == 0 || _loc4_ < this.limit)
            {
               _loc4_++;
            }
         }
         this.tf_curses.text = _loc3_ + "/" + _loc4_;
         if(_loc3_ == 0)
         {
            this.visible = false;
         }
         else
         {
            this.visible = true;
         }
      }
   }
}


package ui.ingame
{
   public class MultiJumpCounter extends assets_multijumpcounter
   {
      
      public function MultiJumpCounter()
      {
         super();
         this.visible = Global.playerInstance.maxJumps != 1;
         Global.playerInstance.multiJumpEffectDisplay = this;
      }
      
      public function update() : void
      {
         this.visible = Global.playerInstance.maxJumps != 1;
         var _loc1_:int = Global.playerInstance.jumpCount;
         var _loc2_:int = Global.playerInstance.maxJumps;
         if(Global.playerInstance.maxJumps == 1000)
         {
            this.tf_jumps.text = "Inf.";
         }
         else if(Global.playerInstance.maxJumps == 0)
         {
            this.tf_jumps.text = "None";
         }
         else
         {
            this.tf_jumps.text = (_loc1_ > _loc2_ ? 0 : _loc2_ - _loc1_).toString();
         }
      }
   }
}


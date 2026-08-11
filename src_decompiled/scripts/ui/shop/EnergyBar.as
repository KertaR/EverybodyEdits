package ui.shop
{
   import com.greensock.TweenMax;
   
   public class EnergyBar extends assets_energybar
   {
      
      private var amount:Number = 0;
      
      private var max:Number = 1000;
      
      public function EnergyBar(param1:Number)
      {
         super();
         this.max = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         this.setEnergy(this.amount);
      }
      
      public function setEnergy(param1:Number, param2:Boolean = true) : void
      {
         this.amount = param1;
         text.text = param1 + "/" + this.max;
         if(param2)
         {
            TweenMax.to(masker,0.3,{"width":(width - 2) * Math.min(param1 / this.max,1)});
         }
         else
         {
            masker.width = (width - 2) * Math.min(param1 / this.max,1);
         }
      }
      
      public function getEnergy() : Number
      {
         return this.amount;
      }
   }
}


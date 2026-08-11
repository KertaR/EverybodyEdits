package ui.shop
{
   public class ButtonEnergy extends assets_energybutton
   {
      
      public function ButtonEnergy(param1:Number)
      {
         super();
         this.mouseEnabled = true;
         mouseChildren = false;
         buttonMode = true;
         this.title = "+" + param1;
      }
      
      public function set title(param1:String) : void
      {
         super.text.text = param1;
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         super.mouseEnabled = param1;
      }
      
      public function setEnergy(param1:Number, param2:Number) : void
      {
         if(param1 > param2)
         {
            (parent as ShopItem).doAddEnergyAnim(param1 - param2);
         }
      }
   }
}


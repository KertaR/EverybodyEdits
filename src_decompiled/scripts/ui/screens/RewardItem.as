package ui.screens
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import sample.ui.components.Label;
   
   public class RewardItem extends Sprite
   {
      
      protected var GemClass:Class;
      
      private var gemBMD:BitmapData;
      
      private var energy:MovieClip;
      
      private var gem:Bitmap;
      
      private var _type:String;
      
      private var label:Label;
      
      private var yMax:Number;
      
      private var yMin:Number;
      
      private var delay:Number;
      
      private var flip:Boolean = false;
      
      private var glow:GlowFilter;
      
      public function RewardItem(param1:String, param2:uint)
      {
         var _loc3_:String = null;
         this.GemClass = RewardItem_GemClass;
         this.gemBMD = new this.GemClass().bitmapData;
         super();
         this._type = param1;
         this.label = new Label("+" + param2.toString(),8,"left",16777215,false,"system");
         switch(param1)
         {
            case "maxEnergy":
            case "energyRefill":
            case "energy":
               _loc3_ = "";
               if(param1 == "maxEnergy")
               {
                  _loc3_ = "+" + param2 + " Max";
               }
               if(param1 == "energyRefill")
               {
                  _loc3_ = "Refill";
               }
               if(param1 == "energy")
               {
                  _loc3_ = "+" + param2;
               }
               this.label.text = _loc3_;
               this.energy = new assets_lightning();
               this.energy.width = 16;
               this.energy.height = 27;
               this.label.x = (this.energy.width - this.label.width) / 2;
               this.label.y = this.energy.height;
               addChild(this.energy);
               break;
            case "gems":
               this.gem = new Bitmap(this.gemBMD);
               this.gem.x = -5;
               this.gem.scaleX = 2;
               this.gem.scaleY = 2;
               this.label.x = this.gem.x + (this.gem.width - this.label.width) / 2;
               this.label.y = this.gem.height + 3;
               addChild(this.gem);
         }
         addChild(this.label);
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}


package ui.campaigns
{
   import com.greensock.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import items.ItemAura;
   import items.ItemAuraColor;
   import items.ItemBrick;
   import items.ItemManager;
   import items.ItemNpc;
   import items.ItemSmiley;
   import sample.ui.components.Label;
   
   public class CampaignReward extends Sprite
   {
      
      protected static var GemClass:Class = CampaignReward_GemClass;
      
      private static var gemBMD:BitmapData = new GemClass().bitmapData;
      
      private var energy:MovieClip;
      
      private var gem:Bitmap;
      
      private var _type:String;
      
      private var label:Label;
      
      public function CampaignReward(param1:String, param2:uint)
      {
         var _loc3_:String = null;
         var _loc4_:ItemBrick = null;
         var _loc5_:Bitmap = null;
         var _loc6_:ItemAuraColor = null;
         var _loc7_:int = 0;
         var _loc8_:ItemAura = null;
         var _loc9_:Bitmap = null;
         var _loc10_:ItemSmiley = null;
         var _loc11_:Bitmap = null;
         var _loc12_:ItemNpc = null;
         var _loc13_:Bitmap = null;
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
               this.gem = new Bitmap(gemBMD);
               this.gem.x -= 5;
               this.gem.scaleX = 2;
               this.gem.scaleY = 2;
               this.label.x = this.gem.x + (this.gem.width - this.label.width) / 2;
               this.label.y = this.gem.height + 3;
               addChild(this.gem);
               break;
            default:
               if(param1.substring(0,5) == "brick")
               {
                  _loc4_ = null;
                  switch(param1)
                  {
                     case "brickbgdark":
                        _loc4_ = ItemManager.getBrickById(526);
                        break;
                     default:
                        _loc4_ = ItemManager.getBrickByPayvaultId(param1);
                  }
                  if(_loc4_ == null)
                  {
                     _loc4_ = ItemManager.getBrickById(9);
                  }
                  _loc5_ = new Bitmap(_loc4_.bmd);
                  _loc5_.y = 5;
                  this.label.text = "Block";
                  this.label.x = (_loc5_.width - this.label.width) / 2 + 2;
                  this.label.y = _loc5_.y + _loc5_.height + 5;
                  addChild(_loc5_);
               }
               else if(param1.substring(0,4) == "aura")
               {
                  _loc6_ = null;
                  _loc7_ = 0;
                  while(_loc7_ < ItemManager.auraColors.length)
                  {
                     if(param1.toLowerCase().indexOf(ItemManager.auraColors[_loc7_].name.toLowerCase()) >= 0)
                     {
                        _loc6_ = ItemManager.auraColors[_loc7_];
                        break;
                     }
                     _loc7_++;
                  }
                  _loc8_ = ItemManager.getAuraByIdAndColor(0,_loc6_ == null ? 0 : _loc6_.id);
                  _loc9_ = new Bitmap(_loc8_.bmd);
                  _loc9_.y = 5;
                  this.label.text = "Aura";
                  this.label.x = (_loc9_.width - this.label.width) / 2 + 2;
                  this.label.y = _loc9_.y + _loc9_.height + 5;
                  addChild(_loc9_);
               }
               else if(param1.substring(0,6) == "smiley")
               {
                  _loc10_ = ItemManager.getSmileyByPayvaultId(param1);
                  if(_loc10_ == null)
                  {
                     _loc10_ = ItemManager.getSmileyById(18);
                     this.label.text = "Unknown";
                  }
                  else
                  {
                     this.label.text = _loc10_.name;
                  }
                  _loc11_ = new Bitmap(_loc10_.bmd);
                  _loc11_.y += 3;
                  _loc11_.x += 3;
                  this.label.x = _loc11_.x + (_loc11_.width - this.label.width) / 2 + 2;
                  this.label.y = _loc11_.y + _loc11_.height - 2;
                  addChild(_loc11_);
               }
               else if(param1.substring(0,5) == "world")
               {
                  this.label = new Label("+" + this.getWorldSizeByType(param1),8,"left",16777215,false,"system");
               }
               else if(param1.substring(0,3) == "npc")
               {
                  _loc12_ = ItemManager.getNpcByPayvaultId(param1);
                  if(_loc12_ == null)
                  {
                     _loc12_ = ItemManager.getNpcById(0);
                     this.label.text = "Unknown";
                  }
                  _loc13_ = new Bitmap(ItemManager.getBrickByPayvaultId(param1).bmd);
                  _loc13_.y = 5;
                  this.label.text = "NPC (+" + param2 + ")";
                  this.label.x = (_loc13_.width - this.label.width) / 2 + 2;
                  this.label.y = _loc13_.y + _loc13_.height + 5;
                  addChild(_loc13_);
               }
         }
         addChild(this.label);
      }
      
      public function getWorldSizeByType(param1:String) : String
      {
         switch(param1)
         {
            case "world0":
               return "25x25 World";
            case "world1":
               return "50x50 World";
            case "world2":
               return "100x100 World";
            case "world3":
               return "200x200 World";
            case "world4":
               return "400x50 World";
            case "world5":
               return "400x200 World";
            case "world6":
               return "100x400 World";
            case "world7":
               return "636x50 World";
            case "world8":
               return "110x110 World";
            case "world11":
               return "300x300 World";
            case "world12":
               return "200x400 World";
            case "world13":
               return "150x150 World";
            default:
               return "";
         }
      }
      
      public function beginAnimation() : void
      {
         y = 500;
         TweenMax.to(this,0.8,{"y":415});
      }
      
      public function get type() : String
      {
         return this._type;
      }
   }
}


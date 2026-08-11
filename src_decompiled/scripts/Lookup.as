package
{
   import flash.geom.Point;
   import items.ItemNpc;
   
   public class Lookup
   {
      
      private var lookup:Object = {};
      
      private var placerLookup:Object = {};
      
      private var portalLookup:Object = {};
      
      private var worldPortalLookup:Object = {};
      
      private var secretsLookup:Object = {};
      
      private var labelLookup:Object = {};
      
      private var blinkLookup:Object = {};
      
      private var signLookup:Object = {};
      
      private var npcLookup:Object = {};
      
      public function Lookup()
      {
         super();
      }
      
      public function reset() : void
      {
         this.lookup = {};
         this.placerLookup = {};
         this.portalLookup = {};
         this.worldPortalLookup = {};
         this.labelLookup = {};
         this.blinkLookup = {};
         this.signLookup = {};
         this.npcLookup = {};
         this.resetSecrets();
      }
      
      public function resetSecrets() : void
      {
         this.secretsLookup = {};
      }
      
      public function resetSign(param1:int, param2:int) : void
      {
         this.signLookup[this.getLookupId(param1,param2)] = null;
      }
      
      public function deleteLookup(param1:int, param2:int) : void
      {
         var _loc3_:String = this.getLookupId(param1,param2);
         delete this.lookup[_loc3_];
         delete this.portalLookup[_loc3_];
         delete this.worldPortalLookup[_loc3_];
         delete this.placerLookup[_loc3_];
         delete this.secretsLookup[_loc3_];
         delete this.blinkLookup[_loc3_];
         delete this.signLookup[_loc3_];
      }
      
      public function deleteBlink(param1:int, param2:int) : void
      {
         delete this.blinkLookup[this.getLookupId(param1,param2)];
      }
      
      public function getPlacer(param1:int, param2:int, param3:int) : String
      {
         return this.placerLookup[this.getLookupId(param1,param2) + "x" + param3] || "";
      }
      
      public function setPlacer(param1:int, param2:int, param3:int, param4:String) : void
      {
         this.placerLookup[this.getLookupId(param1,param2) + "x" + param3] = param4;
      }
      
      public function getInt(param1:int, param2:int) : int
      {
         return int(this.getLookup(param1,param2)) || 0;
      }
      
      public function getSignType(param1:int, param2:int) : int
      {
         return int(this.signLookup[this.getLookupId(param1,param2)].type) || 0;
      }
      
      public function setInt(param1:int, param2:int, param3:int) : void
      {
         this.setLookup(param1,param2,param3);
      }
      
      public function getNumber(param1:int, param2:int) : Number
      {
         return Number(this.getLookup(param1,param2)) || 0;
      }
      
      public function setNumber(param1:int, param2:int, param3:Number) : void
      {
         this.setLookup(param1,param2,param3);
      }
      
      public function getBoolean(param1:int, param2:int) : Boolean
      {
         return Boolean(this.getLookup(param1,param2));
      }
      
      public function setBoolean(param1:int, param2:int, param3:Boolean) : void
      {
         this.setLookup(param1,param2,param3);
      }
      
      public function getText(param1:int, param2:int) : String
      {
         return this.getLookup(param1,param2) || "";
      }
      
      public function getTextSign(param1:int, param2:int) : TextSign
      {
         return this.signLookup[this.getLookupId(param1,param2)] || new TextSign("Undefined",-1);
      }
      
      public function setText(param1:int, param2:int, param3:String) : void
      {
         this.setLookup(param1,param2,param3);
      }
      
      public function setTextSign(param1:int, param2:int, param3:TextSign) : void
      {
         this.signLookup[this.getLookupId(param1,param2)] = param3;
      }
      
      public function setLabel(param1:int, param2:int, param3:String, param4:String, param5:int) : void
      {
         this.labelLookup[this.getLookupId(param1,param2)] = new LabelLookup(param3,param4,param5);
      }
      
      public function getLabel(param1:int, param2:int) : LabelLookup
      {
         return this.labelLookup[this.getLookupId(param1,param2)] || new LabelLookup(":)","#FFFFFF",200);
      }
      
      public function getPortal(param1:int, param2:int) : Portal
      {
         return this.portalLookup[this.getLookupId(param1,param2)] || new Portal(0,0,0);
      }
      
      public function setPortal(param1:int, param2:int, param3:Portal) : void
      {
         this.portalLookup[this.getLookupId(param1,param2)] = param3;
      }
      
      public function getWorldPortal(param1:int, param2:int) : WorldPortal
      {
         return this.worldPortalLookup[this.getLookupId(param1,param2)] || new WorldPortal("",0);
      }
      
      public function setWorldPortal(param1:int, param2:int, param3:WorldPortal) : void
      {
         this.worldPortalLookup[this.getLookupId(param1,param2)] = param3;
      }
      
      public function getPortals(param1:int) : Vector.<Point>
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         for(_loc3_ in this.portalLookup)
         {
            _loc4_ = _loc3_.split("x");
            if(this.portalLookup[_loc3_].id == param1)
            {
               _loc2_.push(new Point(parseInt(_loc4_[0]) << 4,parseInt(_loc4_[1]) << 4));
            }
         }
         return _loc2_;
      }
      
      public function getSecret(param1:int, param2:int) : Boolean
      {
         return Boolean(this.secretsLookup[this.getLookupId(param1,param2)]);
      }
      
      public function setSecret(param1:int, param2:int, param3:Boolean) : void
      {
         this.secretsLookup[this.getLookupId(param1,param2)] = param3;
      }
      
      public function getBlink(param1:int, param2:int) : Number
      {
         return this.blinkLookup[this.getLookupId(param1,param2)];
      }
      
      public function setBlink(param1:int, param2:int, param3:Number) : void
      {
         this.blinkLookup[this.getLookupId(param1,param2)] = param3;
      }
      
      public function isBlink(param1:int, param2:int) : Boolean
      {
         return this.blinkLookup[this.getLookupId(param1,param2)] != null;
      }
      
      public function updateBlink(param1:int, param2:int, param3:Number) : Number
      {
         var _loc4_:Number = this.getBlink(param1,param2);
         var _loc5_:Number = _loc4_ + param3;
         this.setBlink(param1,param2,_loc5_);
         return _loc5_;
      }
      
      private function getLookup(param1:int, param2:int) : *
      {
         return this.lookup[this.getLookupId(param1,param2)];
      }
      
      private function setLookup(param1:int, param2:int, param3:*) : void
      {
         this.lookup[this.getLookupId(param1,param2)] = param3;
      }
      
      private function getLookupId(param1:int, param2:int) : String
      {
         return param1 + "x" + param2;
      }
      
      public function getNpc(param1:int, param2:int) : Npc
      {
         return this.npcLookup[this.getLookupId(param1,param2)] || new Npc("&invalid&",["r","i","p"],new Point(param1,param2),null);
      }
      
      public function setNpc(param1:int, param2:int, param3:String, param4:Array, param5:ItemNpc) : void
      {
         this.npcLookup[this.getLookupId(param1,param2)] = new Npc(param3,param4,new Point(param1,param2),param5);
      }
   }
}


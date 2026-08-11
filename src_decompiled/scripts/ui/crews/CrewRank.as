package ui.crews
{
   public class CrewRank
   {
      
      private var _id:int;
      
      private var _name:String;
      
      private var _powers:Array;
      
      public function CrewRank(param1:int, param2:String, param3:String)
      {
         super();
         this._id = param1;
         this._name = param2;
         this.setPowers(param3);
      }
      
      private function setPowers(param1:String) : void
      {
         var _loc2_:String = null;
         this._powers = [];
         if(param1.length > 0)
         {
            for each(_loc2_ in param1.split(","))
            {
               this.powers.push(parseInt(_loc2_));
            }
         }
      }
      
      public function update(param1:String, param2:String) : void
      {
         this._name = param1;
         this.setPowers(param2);
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get powers() : Array
      {
         return this._powers;
      }
      
      public function get powersString() : String
      {
         return this.powers.join(",");
      }
      
      public function get canManageMembers() : Boolean
      {
         return this.hasPower(CrewPower.MEMBERS_MANAGEMENT);
      }
      
      public function get canManageRanks() : Boolean
      {
         return this.hasPower(CrewPower.RANKS_MANAGEMENT);
      }
      
      public function get canEditLogo() : Boolean
      {
         return this.hasPower(CrewPower.LOGO_WORLD_ACCESS);
      }
      
      public function get canCustomizeProfile() : Boolean
      {
         return this.hasPower(CrewPower.PROFILE_CUSTOMIZATION);
      }
      
      public function get canSendAlerts() : Boolean
      {
         return this.hasPower(CrewPower.ALERT_SENDING);
      }
      
      private function hasPower(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         if(this.id == -1)
         {
            return false;
         }
         if(this.id == 0)
         {
            return true;
         }
         for each(_loc2_ in this.powers)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function canEditPowersOf(param1:CrewRank) : Boolean
      {
         if(!this.canManageRanks)
         {
            return false;
         }
         if(param1.id == 0)
         {
            return false;
         }
         if(this.id == param1.id)
         {
            return false;
         }
         return this.id == 0 || !param1.canManageRanks;
      }
      
      public function canChangeRankOf(param1:CrewRank) : Boolean
      {
         if(!this.canManageMembers)
         {
            return false;
         }
         if(param1.id == 0)
         {
            return false;
         }
         if(this.id == param1.id)
         {
            return false;
         }
         return this.id == 0 || !param1.canManageMembers;
      }
      
      public function canRemoveMember(param1:CrewRank) : Boolean
      {
         if(!this.canManageMembers)
         {
            return false;
         }
         if(param1.id == 0)
         {
            return false;
         }
         return this.id == 0 || !param1.canManageMembers;
      }
   }
}


package ui.crews
{
   import playerio.Message;
   
   public class CrewRanks
   {
      
      private var _ranks:Array = [];
      
      private var myRankId:int;
      
      private var _canEditDesc:Boolean;
      
      public function CrewRanks(param1:Message, param2:int, param3:int, param4:int, param5:Boolean = false)
      {
         super();
         var _loc6_:* = 0;
         var _loc7_:int = param2;
         while(_loc7_ < param2 + param3 * 2)
         {
            this.ranks.push(new CrewRank(_loc6_++,param1.getString(_loc7_),param1.getString(_loc7_ + 1)));
            _loc7_ += 2;
         }
         this.myRankId = param4;
         this._canEditDesc = param5;
      }
      
      public function get ranks() : Array
      {
         return this._ranks;
      }
      
      public function getRank(param1:int) : CrewRank
      {
         var _loc2_:CrewRank = null;
         for each(_loc2_ in this.ranks)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return new CrewRank(-1,"Missing rank?!","");
      }
      
      public function get myRank() : CrewRank
      {
         if(this.myRankId == -1)
         {
            return new CrewRank(-1,"NOT a member!","");
         }
         return this.getRank(this.myRankId);
      }
      
      public function get canEditDescriptions() : Boolean
      {
         return this._canEditDesc;
      }
   }
}


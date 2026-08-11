package
{
   public class WorldPortal
   {
      
      private var _id:String = "";
      
      private var _target:int = 0;
      
      public function WorldPortal(param1:String, param2:int)
      {
         super();
         this._id = param1;
         this._target = param2;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get target() : int
      {
         return this._target;
      }
   }
}


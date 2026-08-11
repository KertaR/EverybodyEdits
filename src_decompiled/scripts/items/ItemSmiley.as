package items
{
   import flash.display.BitmapData;
   
   public class ItemSmiley
   {
      
      public var id:int;
      
      public var name:String;
      
      public var payvaultid:String = null;
      
      public var description:String;
      
      public var bmd:BitmapData;
      
      public var minimapcolor:uint;
      
      public var bmdGold:BitmapData;
      
      public function ItemSmiley(param1:int, param2:String, param3:String, param4:BitmapData, param5:String, param6:uint, param7:BitmapData)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.description = param3;
         this.bmd = param4;
         this.payvaultid = param5;
         this.minimapcolor = param6;
         this.bmdGold = param7;
      }
   }
}


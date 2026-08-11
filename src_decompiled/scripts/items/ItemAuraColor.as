package items
{
   public class ItemAuraColor
   {
      
      public static const WHITE:uint = 16777215;
      
      public static const RED:uint = 16711680;
      
      public static const BLUE:uint = 33023;
      
      public static const YELLOW:uint = 16765952;
      
      public static const GREEN:uint = 1298963;
      
      public static const PURPLE:uint = 11141375;
      
      public static const ORANGE:uint = 16733440;
      
      public static const CYAN:uint = 65535;
      
      public static const GOLD:uint = 16766720;
      
      public static const PINK:uint = 16744640;
      
      public static const INDIGO:uint = 255;
      
      public static const LIME:uint = 11206400;
      
      public static const BLACK:uint = 0;
      
      public static const TEAL:uint = 9038265;
      
      public static const GREY:uint = 8355711;
      
      public static const AMARANTH:uint = 16711751;
      
      public var id:int;
      
      public var name:String;
      
      public var payVaultId:String;
      
      public function ItemAuraColor(param1:int, param2:String, param3:String)
      {
         super();
         this.id = param1;
         this.name = param2;
         this.payVaultId = param3;
      }
   }
}


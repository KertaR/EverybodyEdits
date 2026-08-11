package
{
   public class Key
   {
      
      public var needsShift:Boolean;
      
      public var keyCode:int;
      
      public function Key(param1:int, param2:Boolean = false)
      {
         super();
         this.keyCode = param1;
         this.needsShift = param2;
      }
      
      public static function isValidKey(param1:int) : Boolean
      {
         return param1 >= 65 && param1 <= 90 || param1 >= 96 && param1 <= 111 || param1 >= 186 && param1 <= 192 && param1 != 191 || param1 >= 219 && param1 <= 222 || param1 == 32;
      }
      
      public static function printKey(param1:int) : String
      {
         if(param1 >= 65 && param1 <= 90)
         {
            return String.fromCharCode(param1);
         }
         if(param1 >= 96 && param1 <= 111)
         {
            return "Numpad " + String.fromCharCode(param1 - (param1 <= 105 ? 48 : 64));
         }
         switch(param1)
         {
            case 186:
               return ";:";
            case 187:
               return "=+";
            case 188:
               return ",<";
            case 189:
               return "-_";
            case 190:
               return ".>";
            case 192:
               return "`~";
            case 219:
               return "[{";
            case 220:
               return "\\|";
            case 221:
               return "]}";
            case 222:
               return "\'\"";
            case 32:
               return "Space";
            default:
               return null;
         }
      }
      
      public function print() : String
      {
         var _loc1_:String = printKey(this.keyCode);
         return _loc1_ ? (this.needsShift ? "Shift + " : "") + _loc1_ : "???";
      }
   }
}


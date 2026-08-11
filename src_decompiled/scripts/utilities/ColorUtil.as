package utilities
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ColorUtil
   {
      
      private static var hexArray:Array = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
      
      public static var gradientNames:Object = {
         "oxidizer":[782924,2283876,4050050,6012840,8170188,9340120,10314469,11355379],
         "xenonetix":[11599779,12582103,11403231,10747883,10878951,9895907,8641249,7390944,6729983]
      };
      
      public function ColorUtil()
      {
         super();
      }
      
      public static function DecimalToHex(param1:Number, param2:Boolean = true) : String
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Number = param1;
         var _loc4_:String = "";
         while(Math.floor(_loc3_) != 0)
         {
            _loc3_ /= 16;
            _loc6_ = (_loc3_ - Math.floor(_loc3_)) * 16;
            _loc4_ += hexArray[_loc6_];
         }
         var _loc5_:Array = _loc4_.split("");
         _loc5_.reverse();
         _loc4_ = _loc5_.join("");
         if(param2)
         {
            if(_loc4_.length == 8)
            {
               _loc4_ = _loc4_.slice(2,8);
            }
            if(_loc4_.length < 6)
            {
               _loc7_ = _loc4_.length;
               while(_loc7_ < 6)
               {
                  _loc4_ = "0" + _loc4_;
                  _loc7_++;
               }
            }
         }
         return _loc4_;
      }
      
      public static function colorizeUsername(param1:TextField, param2:int = 0, param3:int = -1) : void
      {
         var _loc5_:int = 0;
         var _loc4_:String = param1.text.toLowerCase();
         if(param3 < 0)
         {
            param3 = _loc4_.length - param2;
         }
         if(param3 != _loc4_.length)
         {
            _loc4_ = _loc4_.substring(param2,param2 + param3);
         }
         if(gradientNames[_loc4_])
         {
            _loc5_ = 0;
            while(_loc5_ < param3)
            {
               param1.setTextFormat(new TextFormat(null,null,gradientNames[_loc4_][_loc5_]),param2 + _loc5_,param2 + _loc5_ + 1);
               _loc5_++;
            }
         }
      }
   }
}


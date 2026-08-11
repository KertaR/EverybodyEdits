package ui.profile.Information
{
   import flash.text.TextFieldAutoSize;
   
   public class GoldInformation extends assets_goldinformation
   {
      
      public function GoldInformation(param1:String, param2:String, param3:String)
      {
         super();
         tf_text.autoSize = TextFieldAutoSize.CENTER;
         tf_text.text = param1.toUpperCase() + " is a Gold Member!";
         tf_expires.text = "Expires: " + param2;
         tf_since.text = "Since: " + param3;
      }
   }
}


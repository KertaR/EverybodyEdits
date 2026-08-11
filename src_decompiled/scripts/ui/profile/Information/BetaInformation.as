package ui.profile.Information
{
   public class BetaInformation extends assets_betainformation
   {
      
      public function BetaInformation(param1:String)
      {
         super();
         tf_text.text = param1.toUpperCase() + " is a Beta member!";
      }
   }
}


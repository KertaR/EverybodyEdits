package playerio.generated.messages
{
   import com.protobuf.Message;
   
   public final class PayVaultConsumeArgs extends Message
   {
      
      public var ids:Array = [];
      
      public function PayVaultConsumeArgs(param1:Array)
      {
         super();
         registerField("ids","",9,3,1);
         this.ids = param1;
      }
   }
}


package playerio.generated.messages
{
   import com.protobuf.Message;
   
   public final class PayVaultReadHistoryArgs extends Message
   {
      
      public var page:uint;
      
      public var pageSize:uint;
      
      public function PayVaultReadHistoryArgs(param1:uint, param2:uint)
      {
         super();
         registerField("page","",13,1,1);
         registerField("pageSize","",13,1,2);
         this.page = param1;
         this.pageSize = param2;
      }
   }
}


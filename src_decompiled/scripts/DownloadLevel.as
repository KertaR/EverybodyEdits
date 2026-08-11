package
{
   import flash.events.MouseEvent;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   import playerio.Message;
   
   public class DownloadLevel
   {
      
      public function DownloadLevel()
      {
         super();
      }
      
      public static function SaveLevel(param1:MouseEvent) : void
      {
         var m:Message = null;
         var data:ByteArray = null;
         var i:int = 0;
         var serialiser:Object = null;
         var e:MouseEvent = param1;
         var fileReference:FileReference = new FileReference();
         if(e.buttonDown)
         {
            m = Global.worldData;
            data = new ByteArray();
            i = 0;
            serialiser = {"Add":function(param1:*):void
            {
               var _loc2_:* = undefined;
               if(i++ >= 42)
               {
                  switch(Class(Object(param1).constructor))
                  {
                     case Number:
                        data.writeInt(param1);
                        break;
                     case String:
                        data.writeUTF(param1);
                        break;
                     case Boolean:
                        data.writeBoolean(param1);
                        break;
                     case ByteArray:
                        _loc2_ = param1;
                        data.writeUnsignedInt(_loc2_.length);
                        data.writeBytes(_loc2_);
                        break;
                     default:
                        throw "error";
                  }
               }
            }};
            data.writeUTF(m.getString(0));
            data.writeUTF(m.getString(1));
            data.writeInt(m.getInt(18));
            data.writeInt(m.getInt(19));
            data.writeFloat(m.getNumber(20));
            data.writeUnsignedInt(m.getUInt(21));
            data.writeUTF(m.getString(25));
            data.writeBoolean(m.getBoolean(28));
            data.writeUTF(m.getString(29));
            data.writeUTF(m.getString(30));
            data.writeInt(m.getInt(32));
            data.writeBoolean(m.getBoolean(35));
            data.writeUTF(m.getString(39));
            m.clone(serialiser);
            data.length -= 4;
            data.deflate();
            fileReference.save(data,RemoveCharacters(Global.currentLevelname + " - " + Global.worldOwner + " - " + Global.roomid) + ".eelvl");
         }
      }
      
      public static function RemoveCharacters(param1:String) : String
      {
         return param1.replace(/[\/\\?%*:|"<>]/g,"");
      }
   }
}


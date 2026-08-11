package ui.roomlist
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public class CreateOpenWorldPrompt extends CreateRoom
   {
      
      private var nameSuggestions:Array;
      
      public function CreateOpenWorldPrompt(param1:Function)
      {
         var self:CreateOpenWorldPrompt = null;
         var callback:Function = param1;
         this.nameSuggestions = [["My ","Our ","The "],["Amazing ","Fantastic ","Great ","Spectacular ","Pretty ","Wild ","Fun ","Awesome ","Cool ",""],["World","Room","Area","Realm"]];
         super();
         this.roomname.embedFonts = true;
         this.roomname.defaultTextFormat = new TextFormat(new system().fontName,14);
         this.roomname.maxChars = 25;
         this.roomname.text = this.getRandomName();
         this.editkey.embedFonts = true;
         this.editkey.defaultTextFormat = new TextFormat(new system().fontName,14);
         this.editkey.maxChars = 25;
         this.editkey.text = "";
         this.editkey.addEventListener(Event.CHANGE,function():void
         {
            if(editkey.text.length > 0)
            {
               warn_edit.text = "Remember:\nYou cannot change the edit key after creating the world!";
            }
            else
            {
               warn_edit.text = "Remember:\nAnyone will be able to edit your world and you won\'t be able to use god mode!";
            }
         });
         warn_edit.text = "Remember:\nAnyone will be able to edit your world and you won\'t be able to use god mode!";
         self = this;
         this.start.buttonMode = true;
         this.start.useHandCursor = true;
         this.start.mouseChildren = false;
         this.start.addEventListener(MouseEvent.CLICK,function():void
         {
            if(roomname.text.replace(/ /gi,"") != "")
            {
               self.parent.removeChild(self);
               callback(roomname.text,editkey.text,true);
            }
         });
         this.closebtn.addEventListener(MouseEvent.CLICK,function():void
         {
            self.parent.removeChild(self);
         });
      }
      
      private function getRandomName() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.nameSuggestions.length)
         {
            _loc1_ += this.nameSuggestions[_loc2_][Math.random() * (this.nameSuggestions[_loc2_].length - 1) >> 0];
            _loc2_++;
         }
         return _loc1_;
      }
   }
}


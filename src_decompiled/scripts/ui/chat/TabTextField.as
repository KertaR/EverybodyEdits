package ui.chat
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class TabTextField extends Sprite
   {
      
      public var field:TextField;
      
      private var defaultCheckWords:Object = {};
      
      private var matches:Array;
      
      private var before:String = "";
      
      private var after:String = "";
      
      private var resetText:Boolean = false;
      
      private var componentHeight:Number;
      
      private var gw:Function = null;
      
      public function TabTextField()
      {
         super();
         this.field = new TextField();
         this.addChild(this.field);
         this.field.useRichTextClipboard = false;
         this.field.type = TextFieldType.INPUT;
         this.field.multiline = false;
         this.field.maxChars = 140;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.font = "Arial";
         _loc1_.color = 0;
         _loc1_.size = 12;
         this.field.defaultTextFormat = _loc1_;
         this.componentHeight = this.field.height;
         this.realign();
         this.field.width = 20;
         this.field.height = this.field.textHeight + 5;
         this.field.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.handleTabRequest);
         this.field.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         this.field.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
         this.field.text = "";
         this.matches = null;
      }
      
      private function get checkWords() : Object
      {
         return this.gw != null ? this.gw() : {};
      }
      
      public function SetWordFunction(param1:Function) : void
      {
         this.gw = param1;
      }
      
      public function AddCheckWords(param1:Object) : void
      {
         this.defaultCheckWords = param1;
      }
      
      override public function set width(param1:Number) : void
      {
         this.field.width = param1;
      }
      
      override public function set height(param1:Number) : void
      {
         this.componentHeight = param1;
         this.realign();
      }
      
      public function set text(param1:String) : void
      {
         this.field.text = param1;
      }
      
      public function get text() : String
      {
         return this.field.text;
      }
      
      private function realign() : void
      {
         this.field.y = (this.componentHeight - this.field.height) / 2;
      }
      
      private function handleTabRequest(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         param1.preventDefault();
         if(!this.matches)
         {
            _loc2_ = this.field.text;
            _loc3_ = this.getCaretWord();
            if(_loc3_.text != "")
            {
               this.matches = this.getWordlist(_loc3_.text);
               this.matches.sortOn("weight",Array.NUMERIC | Array.DESCENDING);
               this.before = _loc2_.substring(0,_loc3_.start);
               this.after = _loc2_.substring(_loc3_.end);
            }
         }
         if(Boolean(this.matches) && this.matches.length > 0)
         {
            _loc4_ = this.after.replace(/\W/g,"");
            _loc5_ = _loc4_ == "" ? (this.before == "" ? ": " + this.after : " " + this.after) : this.after;
            if(this.field.text.indexOf("/") >= 0)
            {
               _loc5_ = " ";
            }
            this.field.text = this.before + this.matches[0].word + _loc5_;
            _loc6_ = this.matches[0].word.length + this.before.length + _loc5_.length;
            if(this.matches.length > 1)
            {
               this.field.setSelection(this.field.selectionBeginIndex,_loc6_);
            }
            else
            {
               _loc7_ = _loc6_;
               this.field.setSelection(_loc7_,_loc7_);
            }
            this.matches.push(this.matches.shift());
         }
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case 9:
               break;
            case 32:
               this.doMatch();
               break;
            default:
               this.matches = null;
         }
      }
      
      private function doMatch() : void
      {
         var _loc1_:String = null;
         if(this.matches != null && this.matches.length > 0 && this.field.selectionBeginIndex != this.field.selectionEndIndex)
         {
            _loc1_ = this.field.text;
            this.field.type = TextFieldType.DYNAMIC;
            this.resetText = true;
         }
         this.matches = null;
      }
      
      private function handleKeyUp(param1:KeyboardEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         if(this.resetText)
         {
            this.field.type = TextFieldType.INPUT;
            this.field.setSelection(this.field.selectionEndIndex + 1,this.field.selectionEndIndex + 1);
         }
         this.resetText = false;
      }
      
      private function getWordlist(param1:String) : Array
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in this.checkWords)
         {
            if(_loc3_.toLowerCase().indexOf(param1.toLowerCase()) == 0)
            {
               _loc2_.push({
                  "word":_loc3_,
                  "weight":this.checkWords[_loc3_]
               });
            }
         }
         for(_loc4_ in this.defaultCheckWords)
         {
            if(_loc4_.toLowerCase().indexOf(param1.toLowerCase()) == 0)
            {
               _loc2_.push({
                  "word":_loc4_,
                  "weight":this.checkWords[_loc4_]
               });
            }
         }
         return _loc2_;
      }
      
      private function getCaretWord() : Object
      {
         var _loc1_:String = this.field.text;
         var _loc2_:* = this.field.caretIndex;
         var _loc3_:int = this.field.caretIndex;
         var _loc4_:Object = {};
         _loc4_[" "] = true;
         _loc4_["\n"] = true;
         _loc4_["\t"] = true;
         _loc4_[String.fromCharCode(13)] = true;
         while(_loc2_ - 1 >= 0 && !_loc4_[_loc1_.charAt(_loc2_ - 1)])
         {
            _loc2_--;
         }
         while(_loc3_ < _loc1_.length && !_loc4_[_loc1_.charAt(_loc3_)])
         {
            _loc3_++;
         }
         return {
            "end":_loc3_,
            "start":_loc2_,
            "text":_loc1_.substring(_loc2_,_loc3_)
         };
      }
   }
}


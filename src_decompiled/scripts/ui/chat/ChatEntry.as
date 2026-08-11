package ui.chat
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import utilities.ColorUtil;
   
   public class ChatEntry extends Sprite
   {
      
      private var t:TextField;
      
      private var text:String;
      
      private var preTextLength:int;
      
      public function ChatEntry(param1:String, param2:String, param3:Number, param4:Number, param5:Boolean)
      {
         var _loc7_:Sprite = null;
         super();
         this.text = param2;
         this.preTextLength = param1 == "" ? 0 : int(param1.length + 2);
         this.t = new TextField();
         this.t.multiline = true;
         this.t.selectable = true;
         this.t.wordWrap = true;
         this.t.width = 190;
         this.t.height = 500;
         this.t.sharpness = 1;
         this.t.condenseWhite = true;
         if(param3 != 0)
         {
            this.t.background = true;
            this.t.backgroundColor = param3;
         }
         var _loc6_:TextFormat = new TextFormat("Tahoma",9,param4,false,false,false);
         _loc6_.indent = param1 == "" ? 0 : -8;
         _loc6_.blockIndent = 8;
         _loc6_.align = TextFormatAlign.LEFT;
         this.t.defaultTextFormat = _loc6_;
         this.t.text = param1.toUpperCase();
         ColorUtil.colorizeUsername(this.t);
         this.t.appendText((param1 == "" ? "" : ": ") + param2);
         this.t.setTextFormat(new TextFormat(null,null,8947848),param1 != "" ? param1.length : 0,this.t.text.length);
         this.t.x = 2;
         this.t.y = 1;
         this.t.height = this.t.textHeight + 5;
         addChild(this.t);
         this.cacheAsBitmap = true;
         if(param5)
         {
            _loc7_ = new Sprite();
            _loc7_.mouseEnabled = false;
            _loc7_.graphics.beginFill(0,0.25);
            _loc7_.graphics.drawRect(0,0,width + 20,height + 1);
            addChild(_loc7_);
         }
      }
      
      public function highlightWords(param1:RegExp, param2:TextFormat) : void
      {
         var _loc3_:Object = null;
         while(true)
         {
            _loc3_ = param1.exec(this.text);
            if(!_loc3_)
            {
               break;
            }
            this.t.setTextFormat(param2,this.preTextLength + _loc3_.index,this.preTextLength + _loc3_.index + _loc3_[0].length);
            if(Global.base.settings.coloredNames)
            {
               ColorUtil.colorizeUsername(this.t,this.preTextLength + _loc3_.index,_loc3_[0].length);
            }
         }
      }
      
      override public function set width(param1:Number) : void
      {
         this.t.width = param1;
         this.t.height = 200;
         this.t.height = this.t.textHeight + 5;
      }
   }
}


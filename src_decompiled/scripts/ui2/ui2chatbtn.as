package ui2
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol390")]
   public dynamic class ui2chatbtn extends MovieClip
   {
      
      public var btn:SimpleButton;
      
      public function ui2chatbtn()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}


package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1181")]
   public dynamic class asset_tab extends MovieClip
   {
      
      public var bg:MovieClip;
      
      public var icon:MovieClip;
      
      public var tf_label:TextField;
      
      public function asset_tab()
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


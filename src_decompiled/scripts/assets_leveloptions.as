package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1107")]
   public dynamic class assets_leveloptions extends MovieClip
   {
      
      public var Actions:assets_leveloptions_actions;
      
      public var Info:assets_leveloptions_info;
      
      public var Permissions:assets_leveloptions_perms;
      
      public var Settings:assets_leveloptions_settings;
      
      public var btn_actions:MovieClip;
      
      public var btn_info:MovieClip;
      
      public var btn_perms:MovieClip;
      
      public var btn_settings:MovieClip;
      
      public var closebtn:SimpleButton;
      
      public var save_all:SimpleButton;
      
      public var status:TextField;
      
      public function assets_leveloptions()
      {
         super();
      }
   }
}


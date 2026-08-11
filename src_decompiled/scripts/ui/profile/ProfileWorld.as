package ui.profile
{
   import io.player.tools.Badwords;
   import playerio.DatabaseObject;
   import sample.ui.components.Label;
   import ui.WorldPreview;
   
   public class ProfileWorld extends WorldPreview
   {
      
      private var label:Label;
      
      public function ProfileWorld(param1:DatabaseObject, param2:Boolean, param3:Boolean = false, param4:Function = null)
      {
         super(param1,param2,param3,param4);
         border(1,3355443,1);
         fill(1118481,1,5);
         this.label = new Label(Badwords.Filter(param1.name == null ? "Untitled World" : param1.name) + "\nplayed " + ((param1.plays || 0) < 2 ? 2 : param1.plays) + " times",12,"left",16777215,false,"visitor");
         addChild(this.label);
         this.width = width + 6;
         this.height = bitmap.height + 7 + this.label.height;
         bitmap.x = 3;
         bitmap.y = this.label.height + 3;
         this.label.x = 2;
         this.label.y = 2;
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         bitmap.width = Math.min(bitmap.width,param1 - 6);
         this.label.x = 2;
         this.label.y = 2;
         bitmap.x = 3;
         bitmap.y = this.label.height + 3;
      }
   }
}


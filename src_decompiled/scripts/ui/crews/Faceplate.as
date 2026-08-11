package ui.crews
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Faceplate extends Sprite
   {
      
      private var Dots:Class = Faceplate_Dots;
      
      private var dotsBMD:BitmapData = new this.Dots().bitmapData;
      
      private var Electric:Class = Faceplate_Electric;
      
      private var electricBMD:BitmapData = new this.Electric().bitmapData;
      
      private var Confetti:Class = Faceplate_Confetti;
      
      private var confettiBMD:BitmapData = new this.Confetti().bitmapData;
      
      private var Fog:Class = Faceplate_Fog;
      
      private var fogBMD:BitmapData = new this.Fog().bitmapData;
      
      private var Paint:Class = Faceplate_Paint;
      
      private var paintBMD:BitmapData = new this.Paint().bitmapData;
      
      private var Stripes:Class = Faceplate_Stripes;
      
      private var stripesBMD:BitmapData = new this.Stripes().bitmapData;
      
      private var Code:Class = Faceplate_Code;
      
      private var codeBMD:BitmapData = new this.Code().bitmapData;
      
      private var Tile:Class = Faceplate_Tile;
      
      private var tileBMD:BitmapData = new this.Tile().bitmapData;
      
      private var Checker:Class = Faceplate_Checker;
      
      private var checkerBMD:BitmapData = new this.Checker().bitmapData;
      
      private var FullMoon:Class = Faceplate_FullMoon;
      
      private var fullMoonBMD:BitmapData = new this.FullMoon().bitmapData;
      
      private var SpiderWeb:Class = Faceplate_SpiderWeb;
      
      private var spiderWebBMD:BitmapData = new this.SpiderWeb().bitmapData;
      
      private var Castle:Class = Faceplate_Castle;
      
      private var castleBMD:BitmapData = new this.Castle().bitmapData;
      
      private var Gold:Class = Faceplate_Gold;
      
      private var goldBMD:BitmapData = new this.Gold().bitmapData;
      
      private var faceplates:Object = {
         "dots":this.dotsBMD,
         "electric":this.electricBMD,
         "confetti":this.confettiBMD,
         "fog":this.fogBMD,
         "paint":this.paintBMD,
         "stripes":this.stripesBMD,
         "code":this.codeBMD,
         "tile":this.tileBMD,
         "checker":this.checkerBMD,
         "fullmoon":this.fullMoonBMD,
         "spiderweb":this.spiderWebBMD,
         "castle":this.castleBMD,
         "gold":this.goldBMD
      };
      
      private var bmd:BitmapData = new BitmapData(830,65,true,0);
      
      private var _type:String;
      
      private var _color:int;
      
      public function Faceplate(param1:String = "", param2:int = 0)
      {
         super();
         this.setFaceplate(param1,param2);
         addChild(new Bitmap(this.bmd));
      }
      
      public function setFaceplate(param1:String, param2:int) : void
      {
         var _loc3_:BitmapData = this.faceplates[param1.toLowerCase()];
         if(_loc3_ != null)
         {
            this.bmd.copyPixels(_loc3_,new Rectangle(830 * param2,0,830,65),new Point(0,0));
         }
         this._type = param1;
         this._color = param2;
         visible = param1 != "None" && param1 != "";
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get color() : int
      {
         return this._color;
      }
   }
}


package
{
   import mx.core.IFlexModuleFactory;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.skins.halo.BusyCursor;
   import mx.skins.halo.HaloFocusRect;
   import mx.skins.halo.ToolTipBorder;
   import mx.styles.CSSCondition;
   import mx.styles.CSSSelector;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.IStyleManager2;
   import mx.utils.ObjectUtil;
   
   public class _WebClient_Styles
   {
      
      private static var _embed_css_Assets_swf__1648770466_mx_skins_cursor_BusyCursor_686709515:Class = _class_embed_css_Assets_swf__1648770466_mx_skins_cursor_BusyCursor_686709515;
      
      public function _WebClient_Styles()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var style:CSSStyleDeclaration = null;
         var effects:Array = null;
         var mergedStyle:CSSStyleDeclaration = null;
         var fbs:IFlexModuleFactory = param1;
         var styleManager:IStyleManager2 = fbs.getImplementation("mx.styles::IStyleManager2") as IStyleManager2;
         var conditions:Array = null;
         var condition:CSSCondition = null;
         var selector:CSSSelector = null;
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("global",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("global");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.paragraphStartIndent = 0;
               this.shadowDistance = 2;
               this.breakOpportunity = "auto";
               this.kerning = "default";
               this.selectionDuration = 250;
               this.leading = 2;
               this.paddingRight = 0;
               this.rollOverOpenDelay = 200;
               this.liveDragging = true;
               this.slideDuration = 300;
               this.iconPlacement = "left";
               this.textFieldClass = UITextField;
               this.layoutDirection = "ltr";
               this.borderStyle = "inset";
               this.ligatureLevel = "common";
               this.repeatDelay = 500;
               this.dropShadowColor = 0;
               this.shadowColor = 15658734;
               this.verticalAlign = "top";
               this.interactionMode = "mouse";
               this.dominantBaseline = "auto";
               this.focusAlpha = 0.55;
               this.fontSharpness = 0;
               this.justificationStyle = "auto";
               this.whiteSpaceCollapse = "collapse";
               this.textDecoration = "none";
               this.fontStyle = "normal";
               this.shadowDirection = "center";
               this.version = "4.0.0";
               this.horizontalScrollPolicy = "auto";
               this.digitWidth = "default";
               this.indicatorGap = 14;
               this.lineBreak = "toFit";
               this.borderCapColor = 9542041;
               this.focusColor = 7385838;
               this.themeColor = 7385838;
               this.fontSize = 12;
               this.textAlignLast = "start";
               this.paddingLeft = 0;
               this.selectionDisabledColor = 14540253;
               this.trackingRight = 0;
               this.smoothScrolling = true;
               this.showErrorSkin = true;
               this.useRollOver = true;
               this.unfocusedTextSelectionColor = 15263976;
               this.backgroundAlpha = 1;
               this.baselineShift = 0;
               this.textAlpha = 1;
               this.verticalGap = 6;
               this.closeDuration = 50;
               this.disabledAlpha = 0.5;
               this.fillColor = 16777215;
               this.roundedBottomCorners = true;
               this.highlightAlphas = [0.3,0];
               this.horizontalAlign = "left";
               this.verticalGridLines = true;
               this.textRotation = "auto";
               this.dropShadowVisible = false;
               this.backgroundSize = "auto";
               this.horizontalGridLines = false;
               this.tabStops = null;
               this.firstBaselineOffset = "auto";
               this.focusRoundedCorners = "tl tr bl br";
               this.lineThrough = false;
               this.focusSkin = HaloFocusRect;
               this.focusedTextSelectionColor = 11060974;
               this.symbolColor = 0;
               this.borderAlpha = 1;
               this.filled = true;
               this.openDuration = 1;
               this.disabledColor = 11187123;
               this.alignmentBaseline = "useDominantBaseline";
               this.modalTransparencyColor = 14540253;
               this.embedFonts = false;
               this.modalTransparencyDuration = 100;
               this.modalTransparency = 0.5;
               this.backgroundImageFillMode = "scale";
               this.lineHeight = "120%";
               this.typographicCase = "default";
               this.borderColor = 6908265;
               this.fontAntiAliasType = "advanced";
               this.selectionColor = 11060974;
               this.cffHinting = "horizontalStem";
               this.contentBackgroundAlpha = 1;
               this.cornerRadius = 2;
               this.borderThickness = 1;
               this.fontFamily = "Arial";
               this.indentation = 17;
               this.paddingBottom = 0;
               this.digitCase = "default";
               this.repeatInterval = 35;
               this.textSelectedColor = 0;
               this.paragraphEndIndent = 0;
               this.disabledIconColor = 10066329;
               this.fontWeight = "normal";
               this.borderVisible = true;
               this.focusBlendMode = "normal";
               this.textAlign = "start";
               this.accentColor = 39423;
               this.shadowCapColor = 14015965;
               this.contentBackgroundColor = 16777215;
               this.fontLookup = "embeddedCFF";
               this.chromeColor = 13421772;
               this.columnGap = 20;
               this.focusThickness = 2;
               this.verticalGridLineColor = 14015965;
               this.blockProgression = "tb";
               this.textRollOverColor = 0;
               this.fillAlphas = [0.6,0.4,0.75,0.65];
               this.horizontalGridLineColor = 16250871;
               this.strokeWidth = 1;
               this.fontGridFitType = "pixel";
               this.errorColor = 16646144;
               this.paragraphSpaceAfter = 0;
               this.justificationRule = "auto";
               this.borderSides = "left top right bottom";
               this.color = 0;
               this.buttonColor = 7305079;
               this.fillColors = [16777215,13421772,16777215,15658734];
               this.paragraphSpaceBefore = 0;
               this.locale = "en";
               this.textIndent = 0;
               this.fontThickness = 0;
               this.renderingMode = "cff";
               this.textJustify = "interWord";
               this.fullScreenHideControlsDelay = 3000;
               this.columnWidth = "auto";
               this.paddingTop = 0;
               this.direction = "ltr";
               this.fixedThumbSize = false;
               this.caretColor = 92159;
               this.letterSpacing = 0;
               this.borderWeight = 1;
               this.columnCount = "auto";
               this.bevel = true;
               this.verticalScrollPolicy = "auto";
               this.trackingLeft = 0;
               this.horizontalGap = 8;
               this.rollOverColor = 13556719;
               this.modalTransparencyBlur = 3;
               this.stroked = false;
               this.iconColor = 1118481;
               this.inactiveTextSelectionColor = 15263976;
               this.leadingModel = "auto";
               this.showErrorTip = true;
               this.autoThumbVisibility = true;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","errorTip");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".errorTip");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.borderColor = 13510953;
               this.paddingBottom = 4;
               this.color = 16777215;
               this.paddingRight = 4;
               this.fontSize = 10;
               this.paddingTop = 4;
               this.borderStyle = "errorTipRight";
               this.shadowColor = 0;
               this.paddingLeft = 4;
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = [];
         condition = new CSSCondition("class","headerDragProxyStyle");
         conditions.push(condition);
         selector = new CSSSelector("",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration(".headerDragProxyStyle");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.fontWeight = "bold";
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.managers.CursorManager",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.managers.CursorManager");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.busyCursor = BusyCursor;
               this.busyCursorBackground = _embed_css_Assets_swf__1648770466_mx_skins_cursor_BusyCursor_686709515;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
         selector = null;
         conditions = null;
         conditions = null;
         selector = new CSSSelector("mx.controls.ToolTip",conditions,selector);
         mergedStyle = styleManager.getMergedStyleDeclaration("mx.controls.ToolTip");
         style = new CSSStyleDeclaration(selector,styleManager,mergedStyle == null);
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.backgroundColor = 16777164;
               this.borderColor = 9542041;
               this.paddingBottom = 2;
               this.paddingRight = 4;
               this.backgroundAlpha = 0.95;
               this.fontSize = 10;
               this.paddingTop = 2;
               this.borderSkin = ToolTipBorder;
               this.borderStyle = "toolTip";
               this.paddingLeft = 4;
               this.cornerRadius = 2;
            };
         }
         if(mergedStyle != null && (Boolean(mergedStyle.defaultFactory == null) || Boolean(ObjectUtil.compare(new style.defaultFactory(),new mergedStyle.defaultFactory()))))
         {
            styleManager.setStyleDeclaration(style.mx_internal::selectorString,style,false);
         }
      }
   }
}


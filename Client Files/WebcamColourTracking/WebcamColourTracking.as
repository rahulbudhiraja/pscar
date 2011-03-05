package {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import nl.interactionfigure.DrawAndMove;
	
	import flash.display.Loader; 
    import flash.net.URLRequest; 
    import flash.utils.setInterval;
	
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.*;
	import flash.utils.Timer;
    import flash.events.TimerEvent;

	
	import flash.system.fscommand;


	public class WebcamColourTracking extends Sprite
	{
		private const WIDTH:Number = 600;
		private const HEIGHT:Number = 450;
		private var i:int=0;
		private var cam:Camera;
		private var vid:Video;
		private var clearVid:Video;
		private var bmd:BitmapData;
		private var cbRect:Sprite;
		private var colour:Number = 0xFF0000;
		private var aRed:Array;
		private var aGreen:Array;
		private var aBlue:Array;
		private var drawAndMove:DrawAndMove;
		public var square2:Sprite = new Sprite();
		public var imageLoader:Loader = new Loader(); 
		public var imageLoader2:Loader = new Loader(); 
		public var timedelay:int=100;
		private var F:int=1;
		private var f:String=new String;
		private var uline:int=0;
		private var myTimer:Timer = new Timer(1000);
		private var variables:URLVariables = new URLVariables();
		private var myData:URLRequest;		
		private var pagno:int;
		
		public function WebcamColourTracking()
		{
			this.stage.align = StageAlign.TOP_LEFT;
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;			
			this.stage.addEventListener(MouseEvent.MOUSE_UP, startMe);			
			myTimer.start(); 
            
			black_screen.visible=false;
     
			
						
			// 
		}
		private function startMe(e:MouseEvent):void {
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, startMe);
			black_screen.visible=true;
			
			//fscommand("exec","tutoriak_speech.exe");
			f=F.toString();
			cam = Camera.getCamera();
			cam.setMode(WIDTH,HEIGHT,15);
			vid = new Video(WIDTH,HEIGHT);
			vid.attachCamera(cam);
			vid.filters = [new BlurFilter(10,10,1)];
			
			bmd = new BitmapData(WIDTH,HEIGHT,false);
			//this.addChild(new Bitmap(bmd));
			
			clearVid = new Video(WIDTH,HEIGHT);
			clearVid.attachCamera(cam);
			clearVid.x = WIDTH;
			clearVid.scaleX = -1;
			this.addChild(clearVid);
			
			this.addChild(black_screen);     // Please not this rahul this is the latest change .
			    
			cbRect = new Sprite();
			this.addChild(cbRect);
			
			pdf_loader();
			this.addChild(imageLoader);
			
			makePaletteArrays();
			
			drawAndMove = new DrawAndMove(this);
			this.addChild(drawAndMove);
			this.addChild(quest);
			questionclip.visible=false;
			this.addChild(questionclip);
			this.addChild(savebut);
			
			
			
			this.addEventListener(Event.ENTER_FRAME, updateStage);
			
		}
		private function makePaletteArrays():void {
			aRed = [];
			aGreen = [];
			aBlue = [];
			var levels:Number = 8;
			var div:Number = 256 / levels;
			for(var i:Number=0;i<256;i++){
				var value:Number = Math.floor(i/div) * div;
				aRed[i] = value << 16;
				aGreen[i] = value << 8;
				aBlue[i] = value;
			}
		}
		private function stageClicked(e:MouseEvent):void {
			colour = bmd.getPixel(this.mouseX, this.mouseY);
			trace(colour);
		}
		private function updateStage(e:Event):void {
			
          if(!uline)
		  {
			  square2.graphics.clear();
		  }
			
			bmd.draw(vid, new Matrix(-1,0,0,1,bmd.width,0));
			bmd.paletteMap(bmd, bmd.rect, new Point(), aRed, aGreen, aBlue);
			var rect:Rectangle = bmd.getColorBoundsRect(0xffffff, colour,true);
			/*cbRect.graphics.clear();
			cbRect.graphics.lineStyle(1, 0x00ff00);
			cbRect.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);*/
			///
			
			//trace(rect.x,rect.y);
			
			
		   // myTimer.addEventListener(TimerEvent.TIMER, notepad_initialize);
			
		var urlRequest:URLRequest = new URLRequest("http://172.20.135.100/1.txt");
		var urlLoader:URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
		urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
		urlLoader.load(urlRequest);
		 
		function urlLoader_complete(evt:Event):void 
		{

        


		rect.x=urlLoader.data.xpos;
		rect.y=urlLoader.data.ypos;
		pagno=urlLoader.data.pgno;
		//trace(rect.x,rect.y,str);
		uline=urlLoader.data.undline;      
		//trace(uline);
		
		
		        
		        square2.graphics.lineStyle(3,0xFF0000);
				square2.graphics.beginFill(0xFF0000);
				square2.graphics.drawCircle(rect.x,rect.y,1);
				square2.graphics.endFill();
				if(rect.x!=0 &&rect.y!=0)
				addChild(square2);
				
							
				
				
		
		}
					 
			quest.addEventListener(MouseEvent.MOUSE_UP,doubtq);			
			savebut.addEventListener(MouseEvent.MOUSE_UP,savepdf);			
				
				
			    //else square2.graphics.clear();


		
		/*
		Notepad check...
		taking action if on notepad..
		drawPointer func..
			*/
			
			
			//drawAndMove.updateStage();
		
		
		}
		//////////////
		public function get camWidth():Number {
			return WIDTH;
		}
		public function get camHeight():Number {
			return HEIGHT;
		}
		public function get pickedColour():Number {
			return colour;
		}
		
		public function doubtq(e:MouseEvent):void
		{
			questionclip.visible=true;
			
			questionclip.submit.addEventListener(MouseEvent.MOUSE_UP, click_event);
			
			function click_event(e:MouseEvent)
			{
				 questionclip.visible=false;
			}
			
			
			
			
		}
		
		public function pdf_loader():void
		{
			
            var image:URLRequest = new URLRequest("tp_Page_"+f+".jpg");  // Your ip Address here!
		    imageLoader.load(image); 
			imageLoader.x=camWidth/18+2*imageLoader.width;
 		    imageLoader.scaleX=0.25;
			imageLoader.scaleY=0.20;
			imageLoader.alpha =10;
			trace(image);
						       
		}
		
		public function savepdf(e:MouseEvent):void
		{
		
		var urlRequest:URLRequest = new URLRequest("http://localhost/file.php");
		var urlLoader:URLLoader = new URLLoader();
		urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
		urlLoader.load(urlRequest);
		 
		function urlLoader_complete(evt:Event):void 
		{
           trace("success");
			
			
		}
		
		}
			
		public function notepad_initialize(e:TimerEvent):void
		{
			i++;
			
			var str1:String=new String("back");
			var str2:String=new String("scale");
			var str3:String=new String("next");
			var str4:String=new String("uline");
			var str5:String=new String(" ");
			var str6:String=new String("initial");
			
		var urlRequest:URLRequest = new URLRequest("./fscommand/1.txt");
		var urlLoader:URLLoader = new URLLoader();
		urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
		urlLoader.addEventListener(Event.COMPLETE, urlLoader_complete);
		urlLoader.load(urlRequest);
		 
		function urlLoader_complete(evt:Event):void 
		{
     
		str6=String(urlLoader.data.val);
		
		if(str6==str1)
		{
			F--;
			f=F.toString();
			fscommand("exec","change.exe");
			pdf_loader(); 
			trace(F.toString());
		    addChild(imageLoader); 
			trace("Back");
		}
			
				
		if(str6==str2)   // for Scaling
		{
			
			imageLoader.scaleX+=0.02;
			imageLoader.scaleY+=0.02;
			fscommand("exec","change.exe");
		    trace("Scaling!");
		}
		
		if(str6==str3)   // for Next 
		{   
		   
		    F++;
			f=F.toString();
			fscommand("exec","change.exe");
			pdf_loader(); 
			trace(F.toString());
		    addChild(imageLoader); 
			//pdf_initialize2();
			//fscommand("exec","change.exe");
			trace("Next");
		
		
		}
		
		if(str6==str4)
		{
			timedelay=i;
			uline=1;
			fscommand("exec","change.exe");
			trace("Underlining");
		}
		
		if(str6==str5)
		{
			timedelay=i;
			uline=0;
			trace("Underlining stopped");
			fscommand("exec","change.exe");
		}
		
		
			
		}
	}
	
	
	
  }
}

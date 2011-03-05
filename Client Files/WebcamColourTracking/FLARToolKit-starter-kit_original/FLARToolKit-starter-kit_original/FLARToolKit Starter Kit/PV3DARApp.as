package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.papervision3d.objects.parsers.DAE;
    import flash.display.Loader; 
    import flash.net.URLRequest; 
    import flash.utils.setInterval;

	
	public class PV3DARApp extends ARAppBase {
		
		protected var _base:Sprite;
		protected var _viewport:Viewport3D;
		protected var _camera3d:FLARCamera3D;
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;
		protected var _markerNode:FLARBaseNode;
		public var i:int=0;
		public var j:int=0;
		private var _earth:DAE;
		public var sq:FLARSquare;	
     	public var square:Sprite = new Sprite();
		
		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		
		public function PV3DARApp() {
		}
		
		protected override function init(cameraFile:String, codeFile:String, canvasWidth:int = 320, canvasHeight:int = 240, codeWidth:int = 80):void {
			addEventListener(Event.INIT, _onInit, false, int.MAX_VALUE);
			super.init(cameraFile, codeFile, canvasWidth, canvasHeight, codeWidth);
		}
		
		private function _onInit(e:Event):void {
			_base = addChild(new Sprite()) as Sprite;
			
			_capture.width = 640;
			_capture.height = 480;
			_base.addChild(_capture);
			
			_viewport = _base.addChild(new Viewport3D(320, 240)) as Viewport3D;
			_viewport.scaleX = 640 / 320;
			_viewport.scaleY = 480 / 240;
			_viewport.x = -4; // 4pix ???
			
			_camera3d = new FLARCamera3D(_param);
			
			_scene = new Scene3D();
			_markerNode = _scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			_renderer = new LazyRenderEngine(_scene, _camera3d, _viewport);
			
			var imageLoader:Loader = new Loader(); 
            var image:URLRequest = new URLRequest("http://172.20.130.112/1.jpg"); 
		    imageLoader.load(image); 
 		    imageLoader.scaleX=0.25;
			imageLoader.scaleY=0.25;
			imageLoader.alpha =10;
			
			addChild (imageLoader); 

          
			
			
			
			var square2:Sprite = new Sprite();
				
				square2.graphics.lineStyle(3,0x00ff00);
				square2.graphics.beginFill(0x0000FF);
				square2.graphics.drawRect(320,0,520,400);
				square2.graphics.endFill();
				//addChild(square2);
			
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event = null):void {
			if(j==1)
			square.graphics.clear();
			
			_capture.bitmapData.draw(_video);
			
			var detected:Boolean = false;
			try {
				detected = _detector.detectMarkerLite(_raster, 80) && _detector.getConfidence() > 0.35;
			} catch (e:Error) {}
			
			if (detected) {
				
				
				_earth = new DAE();
					_earth.load('model/earth.dae');
					_earth.rotationX = 90;
					
				sq= _detector.getSquare (); 
				
				
				_detector.getTransformMatrix(_resultMat);
				_markerNode.setTransformMatrix(_resultMat);
				_markerNode.visible = true;
				
				
				
				square.visible=false;
				
				square.graphics.lineStyle(3,0x00ff00);
				square.graphics.beginFill(0x0000FF);
				square.graphics.drawRect(sq.sqvertex[1].x+sq.sqvertex[0].x,sq.sqvertex[1].y+sq.sqvertex[0].y,2*(sq.sqvertex[0].y-sq.sqvertex[1].y),0);
				square.graphics.endFill();
				
				var newMovie:MovieClip = new MovieClip();
				newMovie.addChild(square);
				
				
				square.visible=true;
				addChild(square);
				
				j=1;
				
				//_markerNode.addChild(_earth);
				
				
				trace(sq.sqvertex[0].x-20,sq.sqvertex[0].y-20,sq.sqvertex[0].x+20,sq.sqvertex[0].y+20);
				
				
				
			} else {
				 j=0;
				_markerNode.visible = false;
			}
			
			_renderer.render();
		}
		
		public function set mirror(value:Boolean):void {
			if (value) {
				_base.scaleX = -1;
				_base.x = 640;
			} else {
				_base.scaleX = 1;
				_base.x = 0;
			}
		}
		
		public function get mirror():Boolean {
			return _base.scaleX < 0;
		}
	}
}
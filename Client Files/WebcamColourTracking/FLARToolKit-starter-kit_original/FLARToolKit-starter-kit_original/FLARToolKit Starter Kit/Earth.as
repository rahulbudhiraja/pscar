﻿package {

	import flash.events.Event;
	import org.papervision3d.objects.parsers.DAE;
	import org.libspark.flartoolkit.core.FLARSquare;
	//import flash.display.gr
	
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	
	public class Earth extends PV3DARApp {
		
		//private var _earth:DAE;
		
		public function Earth() {
			addEventListener(Event.INIT, _onInit);
			init('Data/camera_para.dat', 'Data/mikko.pat');
		}
		
		private function _onInit(e:Event):void {
			//_earth = new DAE();
//			_earth.load('model/earth.dae');
//			_earth.scale = 10;
//			_earth.rotationX = 90;
//			
			
			//addChild(but);
			//_markerNode.addChild(_earth);
			addEventListener(Event.ENTER_FRAME, _update);
		}
		
		private function _update(e:Event):void {
			
		}
	}
}

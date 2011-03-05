package nl.interactionfigure
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DrawAndMove extends Sprite
	{
		private var bmd:BitmapData;
		private var wct:WebcamColourTracking;
		private var drawSprite:Sprite;
		private var pDirection:Point;
		private var nRedCount:Number;
		private var nGreenCount:Number;
		private var nBlueCount:Number;
		private var pSpeed:Point;
		private var pLastPos:Point;
		
		public function DrawAndMove(_wct:WebcamColourTracking)
		{
			super();
			nRedCount = Math.random() * 2 * Math.PI;;
			nGreenCount = Math.random() * 2 * Math.PI;
			nBlueCount = Math.random() * 2 * Math.PI;
			wct = _wct;
			drawSprite = new Sprite();
			bmd = new BitmapData(wct.camWidth, wct.camHeight,true,0x00000000);
			drawSprite.filters = [new BlurFilter(15,15)];
			pDirection = new Point();
			pLastPos = new Point();
			pSpeed = new Point();
			this.addChild(new Bitmap(bmd));
		}
		private function fadeOut(n:Number = 1.0):void {
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, 0]);// red
			matrix = matrix.concat([0, 1, 0, 0, 0]);// green
			matrix = matrix.concat([0, 0, 1, 0, 0]);// blue
			matrix = matrix.concat([0, 0, 0, n, 0]);// alpha
			//
			doCMF(matrix);
		}
		private function doCMF(matrix:Array):void {
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			bmd.applyFilter(bmd, bmd.rect, new Point(), filter);
		}
		public function drawThisRect(_rect:Rectangle):void {
			drawSprite.graphics.clear();
			drawSprite.graphics.beginFill(wct.pickedColour,1);
			//drawSprite.graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
			drawSprite.graphics.drawEllipse(_rect.x, _rect.y, _rect.width, _rect.height);
			drawSprite.graphics.endFill();
			//
			bmd.draw(drawSprite);
			/////
			
			
			
			//pDirection.x = ((wct.camWidth * 0.5) - (_rect.x + (_rect.width * 0.5)))*0.1;
			//pDirection.y = ((wct.camHeight * 0.5) - (_rect.y + (_rect.height * 0.5)))*0.1;
			//
			//pSpeed.x = _rect.x - pLastPos.x;
			//pSpeed.y = _rect.y - pLastPos.y;
			
			pLastPos.x = _rect.x;
			pLastPos.y = _rect.y;
			
			
			
		}
		//
		public function updateStage():void {
			nRedCount+=(0.01 * pSpeed.length);
			nGreenCount+=(0.005 * pSpeed.length);
			nBlueCount+=(0.015 * pSpeed.length);
			
			var matrix:Array = new Array();
matrix = matrix.concat([1, 0, 0, 0, 0]);// red
			matrix = matrix.concat([0, 0, 0, 0, 0]);// green  i have changed these 2 to make sure that only red would be displayed !
			matrix = matrix.concat([0, 0, 0, 0, 0]);// blue
			matrix = matrix.concat([0, 0, 0, 0.95, 0]);// alpha
			doCMF(matrix);
			
			//bmd.scroll(pDirection.x, pDirection.y); Rahul Commented this part 
		}
	}
}
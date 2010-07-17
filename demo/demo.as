//import flash.external.ExternalInterface;

class Demo {

	static var app : Demo;
	
	function Demo() {
	    
	    var changeText = function(str:String) {
    	    var fmt : TextFormat = new TextFormat();
            fmt.color = 0x000000;
            fmt.size = 16;
            fmt.underline = true;
            _root.tf2.text = str;
            _root.tf2.setTextFormat(fmt);
    	};
    	
	    _root.createTextField("tf",_root.getNextHighestDepth(),0,0,200,20);
	    var fmt : TextFormat = new TextFormat();
        fmt.color = 0x0000ff;
        fmt.size = 16;
        fmt.align = "center";
        _root.tf.text = "cEI Demo";
        _root.tf.setTextFormat(fmt);
        
        _root.createTextField("tf2",_root.getNextHighestDepth(),0,30,200,20);
        _root.tf2.onSetFocus = function() {
            ExternalInterface.call("changeText", "This is from flash!");
        }
        changeText("Click Me!");
        
        ExternalInterface.addCallback("changeText", this, changeText);
	}
	
	// entry point
	static function main(mc) {
		app = new Demo();
	}
}
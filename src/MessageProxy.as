/**
 * Created by António Afonso (antonio.afonso@gmail.com), Opera Software ASA
 * This code is offered under the Open Source BSD license.
 * 
 * Copyright © 2006-2010, Opera Software
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of Opera Software nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
 
class MessageProxy {

	static var app : MessageProxy;
	static var lc:LocalConnection = new LocalConnection();
	
	function MessageProxy() {
	    //MessageProxy.log('MessageProxy: ' + _root.methodName + "[" + _root.seq + "]");
	    var methodArgs = "";
	    
	    for( var i = 0; _root['methodArgs'+i] != undefined; i++ )
	    {
	        methodArgs += _root['methodArgs'+i];
	    }
	    
	    MessageProxy.log(_root.seq + ':Message forwarded => ' + _root.methodName + "(" + methodArgs + ")");
	    
	    var args = (new JSON()).parse(methodArgs);
	    args.unshift(_root.seq);
	    args.unshift(_root.id);
        MessageProxy.lc.send("_wii", _root.methodName, args);
        MessageProxy.log('MessageProxy: ' + _root.methodName + "[" + _root.seq + "]");
	}
    
    static function log(str)
    {
        str = str.split('"').join('\\"');
        //getURL('javascript:log("'+str+'")');
    }

	// entry point
	static function main(mc) {
		app = new MessageProxy();
	}
}
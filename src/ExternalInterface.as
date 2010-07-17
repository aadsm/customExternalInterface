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

/*
window.callFlash = function(methodName, methodArgs) {
    var id = 'sender' + (new Date().getTime()) + '_' + Math.round(Math.random()*100);
    var seq = callFlash.seq || 0;
    var methodArgsArr = [];

    // flashVars has a 255char restriction per parameter.
    for( var i = 0, j = 0; i < methodArgs.length; i += 255, j++ ) {
        methodArgsArr.push( '&methodArgs'+j+'='+encodeURIComponent(methodArgs.slice(i, i+255)) );
    }
    
    var embed = document.createElement('embed');
    embed.setAttribute('id', id);
    embed.setAttribute('type', 'application/x-shockwave-flash');
    embed.setAttribute('bgcolor', '#ff6600');
    embed.setAttribute('quality', 'hight');
    embed.setAttribute('flashvars', 'methodName=' + methodName + methodArgsArr.join("") + '&id=' + id + '&seq=' + seq);
    embed.setAttribute('style', 'z-index:1;position:fixed;bottom:10px;right:20px;width:1px;height:1px');
    embed.setAttribute('src', cEIConfig.proxyUrl+'?1'+id);
    
    log('flashId: ' + id + ' [' + seq + '], embeb: ' + window.callFlash.embed );

    document.body.insertBefore(embed, document.body.firstChild);
    embed.focus();
    
    callFlash.seq = seq+1;
    window.callFlash.embed++;
};

window.callFlash.embed = 0;

window.removeFlash = function(id) {
    document.getElementById(id).parentNode.removeChild( document.getElementById(id) );
    window.callFlash.embed--;
};

window.canCallFlash = function() {
    log('canCallFlash: ' + window.callFlash.embed);
    return window.callFlash.embed == 0;
};

window.log = function(msg) {
    //$('log').innerHTML += '<p style="margin: 0">' + msg + '</p>';
    //$('log').scrollTop = $('log').scrollHeight;
};

*/

class ExternalInterface {

    static var available:Boolean = true;
    static var lc:LocalConnection = new LocalConnection();
    static var messages:Array = [];
    static var base = 0;
    static var initValue:Boolean = init();
    
    static function init() : Boolean {
        lc.connect("_wii");
        js('cEIConfig.proxyUrl = cEIConfig.proxyUrl || "MessageProxy.swf";'); js('window.callFlash%20=%20function(methodName,%20methodArgs){var%20id%20=%20%27sender%27%20+%20(new%20Date().getTime())%20+%20%27_%27%20+%20Math.round(Math.random()*100);var%20seq%20=%20callFlash.seq%20||%200;var%20methodArgsArr%20=%20[];for(%20var%20i%20=%200,%20j%20=%200;%20i%20<%20methodArgs.length;%20i%20+=%20255,%20j++%20){methodArgsArr.push(%20%27&methodArgs%27+j+%27=%27+encodeURIComponent(methodArgs.slice(i,%20i+255))%20);}var%20embed%20=%20document.createElement(%27embed%27);embed.setAttribute(%27id%27,%20id);embed.setAttribute(%27type%27,%20%27application/x-shockwave-flash%27);embed.setAttribute(%27bgcolor%27,%20%27#ff6600%27);embed.setAttribute(%27quality%27,%20%27hight%27);embed.setAttribute(%27flashvars%27,%20%27methodName=%27%20+%20methodName%20+%20methodArgsArr.join(%22%22)%20+%20%27&id=%27%20+%20id%20+%20%27&seq=%27%20+%20seq);embed.setAttribute(%27style%27,%20%27z-index:1;position:fixed;bottom:10px;right:20px;width:1px;height:1px%27);embed.setAttribute(%27src%27,%20cEIConfig.proxyUrl+%27?1%27+id);document.body.insertBefore(embed,%20document.body.firstChild);embed.focus();callFlash.seq%20=%20seq+1;window.callFlash.embed++;};window.callFlash.embed%20=%200;window.removeFlash%20=%20function(id){document.getElementById(id).parentNode.removeChild(%20document.getElementById(id)%20);window.callFlash.embed--;};window.canCallFlash%20=%20function(){log(%27canCallFlash:%20%27%20+%20window.callFlash.embed);return%20window.callFlash.embed%20==%200;};');
        return true;
    }
    
    static function addCallback( methodName : String, instance : Object, method : Function) : Boolean
    {
        var script = "document.getElementById(cEIConfig.flashId)."+methodName+" = function()";
        script += "{";
        //script += '    var args = arguments; setTimeout(function(){callFlash("' + methodName + '",  JSON.stringify(Array.prototype.slice.call(args, 0)) )}, 0);';
        script += '    callFlash("' + methodName + '",  JSON.stringify(Array.prototype.slice.call(arguments, 0)) );';
        script += "}";
        lc[methodName] = function(args)
        {
            ExternalInterface.log("ExternalInterface");
            var flashId = args.shift();
            var seq = parseInt(args.shift());
            var messages = ExternalInterface.messages;
            var base = ExternalInterface.base;
            
            ExternalInterface.log("ExternalInterface: got message [" + seq + "]");
            ExternalInterface.js('removeFlash("' + flashId + '")');
            
            if( base == seq && messages.length == 0 )
            {
                method.apply( instance, args );
                ExternalInterface.base++;
                //ExternalInterface.log('Message executed => ' + seq);
                ExternalInterface.log('ExternalInterface: '+methodName + " " + (new JSON()).stringify(args) + " [" + seq + "]");
            }
            else
            {
                ExternalInterface.log("ExternalInterface: messages in queue: " + messages.length)
                messages[seq-base] = {
                    instance    : instance,
                    method      : method,
                    args        : args,
                    seq         : seq
                    ,debug: methodName + " " + (new JSON()).stringify(args) + " [" + seq + "]"
                };
                ExternalInterface.log('ExternalInterface: [' + seq + '] added to queue');
                while( messages[0] != undefined )
                {
                    var message = messages.shift();
                    message.method.apply( message.instance, message.args );
                    ExternalInterface.base++;
                    //ExternalInterface.log('Message executed => ' + message.seq + '-');
                    ExternalInterface.log('ExternalInterface: ' + message.debug);
                }
            }            
        }
        
        js(script);
        
        return null;
    }
    
    static function call( methodName : String ) : Object
    {
        var string:String = methodName+'(';
        var args:Array = [];
        
        for( var i = 1; i < arguments.length; i++ )
        {
            if( typeof(arguments[i]) == 'string' )
            {
                args.push('"' + arguments[i].split('"').join('\\"') + '"')
            }
            else
            {
                args.push(arguments[i]);
            }
        }
    
        string += args.join(',') + ')';
        js(string);
        //ExternalInterface.log("ExternalInterface: call("+string+")");
        return null;
    }
    
    static function log(str)
    {
        str = str.split('"').join('\\"');
        //js('log("'+str+'")');
    }

    static function js(str)
    {
        getURL('javascript:' + str);
    }
}
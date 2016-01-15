var msf =
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_RESULT__;"use strict";

	var msf = __webpack_require__(1);

	msf.version = '{{version}}';

	if (true) {
	    !(__WEBPACK_AMD_DEFINE_RESULT__ = function() { return msf; }.call(exports, __webpack_require__, exports, module), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
	} else if (typeof module !== 'undefined' && module.exports) {
	    module.exports = msf;
	} else {
	    window.msf = msf;
	}

	module.exports = msf;

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var util = __webpack_require__(5);
	var EventEmitter = __webpack_require__(2);
	var Service = __webpack_require__(3);
	var Search = __webpack_require__(4);

	// We will use a singleton for search so that we don't create multiple frames in the page
	var search = null;


	/**
	 * The 'msf' module/object is the entry point for the API.
	 * If including the library via script tag it will be a global object attached to the window
	 * or the export of the module if using amd/commonjs (requirejs/browserify)
	 *
	 * @module msf
	 *
	 */


	/*
	 Can be used to debug if there is an issue
	 msf.logger.level = 'error'|'warn'|'info'|'verbose'|'debug'|'silly'
	 */
	module.exports.logger  = util.logger;


	/**
	 * Searches the local network for compatible multiscreen services
	 *
	 * @param {Function} [callback] If a callback is passed the search is immediately started.
	 * @param {Error} callback.err The callback handler
	 * @param {Service[]} callback.result An array of {@link Service} instances found on the network
	 * @returns {Search} A search instance (a singleton is used to reduce page resources)
	 *
	 * @example
	 * msf.search(function(err, services){
	 *   if(err) return console.error('something went wrong', err.message);
	 *   console.log('found '+services.length+' services');
	 * }
	 *
	 * // OR
	 *
	 * var search = msf.search();
	 * search.on('found', function(service){
	 *    console.log('found service '+service.name);
	 * }
	 * search.start();
	 *
	 */
	module.exports.search = function(callback){

	    // Create the single instance if we don't already have one
	    if(!search) search = new Search();

	    // If there is a callback defined, listen once for results and start the search
	    if(callback) {
	        search.once('found',function(services){
	            callback(null, services);
	        });

	        // start on next tick to support search callbacks and events
	        setTimeout(function(){ search.start(); },0);

	    }

	    return search;

	};


	/**
	 * Retrieves a reference to the service running on the current device. This is typically only used on the 'host' device.
	 *
	 * @param {Function} callback The callback handler
	 * @param {Error} callback.error
	 * @param {Service} callback.service The service instance
	 *
	 * @example
	 * msf.local(function(err, service){
	 *   console.log('my service name is '+service.name);
	 * }
	 */
	module.exports.local = function(callback){

	    Service.getLocal(callback);

	};

	/**
	 * Retrieves a service instance by it's uri
	 *
	 * @param {String} uri The uri of the service (http://host:port/api/v2/)
	 * @param {Function} callback The callback handler
	 * @param {Error} callback.error
	 * @param {Service} callback.service The service instance
	 *
	 * @example
	 * msf.remote('http://host:port/api/v2/',function(err, service){
	 *   console.log('the service name is '+service.name);
	 * }
	 */
	module.exports.remote = function(uri, callback){

	    Service.getByURI(uri, callback);

	};




/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	/* jshint newcap: false, -W040: false, -W004: false, -W003 : false */
	"use strict";

	// Copyright Joyent, Inc. and other Node contributors.
	//
	// Permission is hereby granted, free of charge, to any person obtaining a
	// copy of this software and associated documentation files (the
	// "Software"), to deal in the Software without restriction, including
	// without limitation the rights to use, copy, modify, merge, publish,
	// distribute, sublicense, and/or sell copies of the Software, and to permit
	// persons to whom the Software is furnished to do so, subject to the
	// following conditions:
	//
	// The above copyright notice and this permission notice shall be included
	// in all copies or substantial portions of the Software.
	//
	// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
	// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
	// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
	// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
	// USE OR OTHER DEALINGS IN THE SOFTWARE.


	/**
	 * All objects which emit events are instances of EventEmitter.
	 * The EventEmitter class is derived from the nodejs EventEmitter.
	 *
	 * For simplicity only the most used members are documented here, for full documentation read {@link http://nodejs.org/api/events.html}
	 * @class EventEmitter
	 * @hide-constructor
	 */
	function EventEmitter() {
	 this._events = this._events || {};
	 this._maxListeners = this._maxListeners || undefined;
	}
	module.exports = EventEmitter;

	// Backwards-compat with node 0.10.x
	EventEmitter.EventEmitter = EventEmitter;

	EventEmitter.prototype._disabledEvents = {};
	EventEmitter.prototype._events = undefined;
	EventEmitter.prototype._maxListeners = undefined;

	// By default EventEmitters will print a warning if more than 10 listeners are
	// added to it. This is a useful default which helps finding memory leaks.
	EventEmitter.defaultMaxListeners = 10;

	// Obviously not all Emitters should be limited to 10. This function allows
	// that to be increased. Set to zero for unlimited.
	EventEmitter.prototype.setMaxListeners = function(n) {
	 if (!isNumber(n) || n < 0 || isNaN(n))
	  throw TypeError('n must be a positive number');
	 this._maxListeners = n;
	 return this;
	};

	EventEmitter.prototype.emit = function(type) {
	 var er, handler, len, args, i, listeners;

	 if (!this._events){
	     this._events = {};
	 }

	 if(this._disabledEvents[type]) return false;

	 // If there is no 'error' event listener then throw.
	 if (type === 'error') {
	  if (!this._events.error ||
	      (isObject(this._events.error) && !this._events.error.length)) {
	   er = arguments[1];
	   if (er instanceof Error) {
	    throw er; // Unhandled 'error' event
	   }
	   throw TypeError('Uncaught, unspecified "error" event.');
	  }
	 }

	 handler = this._events[type];

	 if (isUndefined(handler))
	  return false;

	 if (isFunction(handler)) {
	  switch (arguments.length) {
	   // fast cases
	   case 1:
	    handler.call(this);
	    break;
	   case 2:
	    handler.call(this, arguments[1]);
	    break;
	   case 3:
	    handler.call(this, arguments[1], arguments[2]);
	    break;
	   // slower
	   default:
	    len = arguments.length;
	    args = new Array(len - 1);
	    for (i = 1; i < len; i++)
	     args[i - 1] = arguments[i];
	    handler.apply(this, args);
	  }
	 } else if (isObject(handler)) {
	  len = arguments.length;
	  args = new Array(len - 1);
	  for (i = 1; i < len; i++)
	   args[i - 1] = arguments[i];

	  listeners = handler.slice();
	  len = listeners.length;
	  for (i = 0; i < len; i++){
	      // a small hack put in to be able to stop event emission
	      var r = listeners[i].apply(this, args);
	      if(r === 'stopEvent') break;
	  }

	 }

	 return true;
	};

	EventEmitter.prototype.addListener = function(type, listener) {
	 var m;

	 if (!isFunction(listener))
	  throw TypeError('listener must be a function');

	 if (!this._events)
	  this._events = {};

	 // To avoid recursion in the case that type === "newListener"! Before
	 // adding it to the listeners, first emit "newListener".
	 if (this._events.newListener)
	  this.emit('newListener', type,
	      isFunction(listener.listener) ?
	          listener.listener : listener);

	 if (!this._events[type])
	 // Optimize the case of one listener. Don't need the extra array object.
	  this._events[type] = listener;
	 else if (isObject(this._events[type]))
	 // If we've already got an array, just append.
	  this._events[type].push(listener);
	 else
	 // Adding the second element, need to change to array.
	  this._events[type] = [this._events[type], listener];

	 // Check for listener leak
	 if (isObject(this._events[type]) && !this._events[type].warned) {
	  var m;
	  if (!isUndefined(this._maxListeners)) {
	   m = this._maxListeners;
	  } else {
	   m = EventEmitter.defaultMaxListeners;
	  }

	  if (m && m > 0 && this._events[type].length > m) {
	   this._events[type].warned = true;
	   console.error('(node) warning: possible EventEmitter memory ' +
	       'leak detected. %d listeners added. ' +
	       'Use emitter.setMaxListeners() to increase limit.',
	       this._events[type].length);
	   if (typeof console.trace === 'function') {
	    // not supported in IE 10
	    console.trace();
	   }
	  }
	 }

	 return this;
	};

	/**
	 * Adds a listener for the event.
	 * @param {String} type The event name to listen to
	 * @param {Function} listener The function to invoke when the event occurs
	 * @returns EventEmitter
	 *
	 */
	EventEmitter.prototype.on = function(type, listener){
	    EventEmitter.prototype.addListener.apply(this,arguments);
	};

	/**
	 * Adds a one time listener for the event. This listener is invoked only the next time the event is fired, after which it is removed.
	 * @param {String} type The event name to listen to
	 * @param {Function} listener The function to invoke when the event occurs
	 * @returns EventEmitter
	 *
	 */
	EventEmitter.prototype.once = function(type, listener) {
	 if (!isFunction(listener))
	  throw TypeError('listener must be a function');

	 var fired = false;

	 function g() {
	  this.removeListener(type, g);

	  if (!fired) {
	   fired = true;
	   listener.apply(this, arguments);
	  }
	 }

	 g.listener = listener;
	 this.on(type, g);

	 return this;
	};

	// emits a 'removeListener' event iff the listener was removed
	EventEmitter.prototype.removeListener = function(type, listener) {
	 var list, position, length, i;

	 if (!isFunction(listener))
	  throw TypeError('listener must be a function');

	 if (!this._events || !this._events[type])
	  return this;

	 list = this._events[type];
	 length = list.length;
	 position = -1;

	 if (list === listener ||
	     (isFunction(list.listener) && list.listener === listener)) {
	  delete this._events[type];
	  if (this._events.removeListener)
	   this.emit('removeListener', type, listener);

	 } else if (isObject(list)) {
	  for (i = length; i-- > 0;) {
	   if (list[i] === listener ||
	       (list[i].listener && list[i].listener === listener)) {
	    position = i;
	    break;
	   }
	  }

	  if (position < 0)
	   return this;

	  if (list.length === 1) {
	   list.length = 0;
	   delete this._events[type];
	  } else {
	   list.splice(position, 1);
	  }

	  if (this._events.removeListener)
	   this.emit('removeListener', type, listener);
	 }

	 return this;
	};

	/**
	 * Alias for removeListener
	 * @param {String} type The event name to stop listening to
	 * @param {Function} listener The function that was originally add to handle the event
	 * @returns EventEmitter
	 *
	 */
	EventEmitter.prototype.off = function(type, listener){
	    EventEmitter.prototype.removeListener.apply(this,arguments);
	};


	/**
	 * Removes all listeners, or those of the specified event.
	 * @param {String} event The event name to stop listening to
	 * @returns EventEmitter
	 *
	 */
	EventEmitter.prototype.removeAllListeners = function(type) {
	 var key, listeners;

	 if (!this._events)
	  return this;

	 // not listening for removeListener, no need to emit
	 if (!this._events.removeListener) {
	  if (arguments.length === 0)
	   this._events = {};
	  else if (this._events[type])
	   delete this._events[type];
	  return this;
	 }

	 // emit removeListener for all listeners on all events
	 if (arguments.length === 0) {
	  for (key in this._events) {
	   if (key === 'removeListener') continue;
	   this.removeAllListeners(key);
	  }
	  this.removeAllListeners('removeListener');
	  this._events = {};
	  return this;
	 }

	 listeners = this._events[type];

	 if (isFunction(listeners)) {
	  this.removeListener(type, listeners);
	 } else {
	  // LIFO order
	  while (listeners.length)
	   this.removeListener(type, listeners[listeners.length - 1]);
	 }
	 delete this._events[type];

	 return this;
	};

	EventEmitter.prototype.listeners = function(type) {
	 var ret;
	 if (!this._events || !this._events[type])
	  ret = [];
	 else if (isFunction(this._events[type]))
	  ret = [this._events[type]];
	 else
	  ret = this._events[type].slice();
	 return ret;
	};

	EventEmitter.prototype.disableEvent = function(type) {
	    if(type && typeof type === 'string'){
	        this._disabledEvents[type] = true;
	    }
	};

	EventEmitter.prototype.enableEvent = function(type) {
	    if(type && typeof type === 'string'){
	        delete this._disabledEvents[type];
	    }
	};

	EventEmitter.listenerCount = function(emitter, type) {
	 var ret;
	 if (!emitter._events || !emitter._events[type])
	  ret = 0;
	 else if (isFunction(emitter._events[type]))
	  ret = 1;
	 else
	  ret = emitter._events[type].length;
	 return ret;
	};

	function isFunction(arg) {
	 return typeof arg === 'function';
	}

	function isNumber(arg) {
	 return typeof arg === 'number';
	}

	function isObject(arg) {
	 return typeof arg === 'object' && arg !== null;
	}

	function isUndefined(arg) {
	 return arg === void 0;
	}


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var util = __webpack_require__(5);
	var props = util.props;
	var Application = __webpack_require__(6);
	var Channel = __webpack_require__(7);


	/**
	 * A Service instance represents the multiscreen service running on the remote device, such as a SmartTV
	 *
	 * @class Service
	 * @hide-constructor
	 *
	 */

	function Service(description){

	    /**
	     * The id of the service
	     *
	     * @member {String} Service#id
	     * @readonly
	     */
	    this.id = description.id;

	    /**
	     * The name of the service (Living Room TV)
	     *
	     * @member {String} Service#name
	     * @readonly
	     */
	    this.name = description.name;

	    /**
	     * The version of the service (x.x.x)
	     *
	     * @member {String} Service#version
	     * @readonly
	     */
	    this.version = description.version;

	    /**
	     * The type of the service (Samsung SmartTV)
	     *
	     * @member {String} Service#type
	     * @readonly
	     */
	    this.type = description.type;

	    /**
	     * The uri of the service (http://<ip>:<port>/api/v2/)
	     *
	     * @member {String} Service#uri
	     * @readonly
	     */
	    this.uri = description.uri;

	    /**
	     * A hash of additional information about the device the service is running on
	     *
	     * @member {String} Service#device
	     * @readonly
	     */
	    this.device = description.device;

	    props.readOnly(this,['id','name','version','type','uri','device']);

	}

	/**
	 * Creates {@link Application} instances belonging to that service
	 *
	 * @param {String} id An installed application id or url of the web application
	 * @param {String} channelUri The URI of the channel to connect to.
	 * @returns {Application}
	 *
	 * @example
	 var application = service.application('http://mydomain/myapp/', 'com.mydomain.myapp');
	 */
	Service.prototype.application = function(id, channelUri){

	    return new Application(this, id, channelUri);

	};

	/**
	 * creates a channel of the service ('mychannel')
	 *
	 * @param {String} uri The uri of the Channel
	 * @returns {Channel}
	 *
	 * @example
	 var channel = service.channel('com.mydomain.myapp');
	 */
	Service.prototype.channel = function(uri){

	    return new Channel(this, uri);

	};


	/***
	 * Retrieves a reference to the service running on the current device
	 * (public api should use msf.local)
	 *
	 * @protected
	 *
	 * @param {Function} callback The callback handler
	 * @param {Error} callback.err The callback handler
	 * @param {Service} callback.service The service instance
	 *
	 */
	Service.getLocal = function(callback){

	    Service.getByURI('http://127.0.0.1:8001/api/v2/', callback);

	};

	/***
	 * Retrieves a service instance by it's uri
	 * (public api should use msf.remote)
	 *
	 * @protected
	 *
	 * @param {String} uri The uri of the service (http://<ip>:<port>/api/v2/)
	 * @param {Function} callback The callback handler
	 * @param {Error} callback.err The callback handler
	 * @param {Service} callback.service The service instance
	 *
	 */
	Service.getByURI = function(uri, callback){

	    var oReq = new XMLHttpRequest();
	    oReq.timeout = 5000;
	    oReq.ontimeout = function(){callback();};
	    oReq.onload = function() {

	        if(this.status === 200){
	            try{
	                var result = JSON.parse(this.responseText);
	                callback(null, new Service(result));
	            }catch(e){  callback(e); }
	        }else{
	            callback();
	        }
	    };
	    oReq.open("get", uri, true);
	    oReq.send();

	};


	module.exports = Service;



/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var util = __webpack_require__(5);
	var props = util.props;
	var EventEmitter = __webpack_require__(2);


	/**
	 * Provides members related to {@link Service} discovery.
	 *
	 * @class Search
	 * @extends EventEmitter
	 * @hide-constructor
	 *
	 */

	function Search(){


	    Search.super_.call(this);

	    this.discoveryFrame = null;
	    this.status = Search.STATUS_STOPPED;

	    var self = this;

	    /* Create the discovery iframe and load the search page */

	    var frame = document.createElement('iframe');
	    frame.setAttribute('width', '1');
	    frame.setAttribute('height', '1');
	    frame.style.display = "none";
	    frame.src = 'http://multiscreen.samsung.com/discoveryservice/v2/discover';
	    document.body.appendChild(frame);

	    /* Add a 'message' listener to the window that checks incoming messages */

	    this.windowMessageListener = function(event){

	        if(event.source === frame.contentWindow){

	            // ready message
	            if(event.data && event.data.event === 'discovery.ready'){
	                self.discoveryFrame = event.source;
	                self.onSearchReady();
	            }

	            // result message
	            else if(event.data && event.data.event === 'discovery.result'){
	                var results = [];
	                var Service = __webpack_require__(3);
	                for(var i=0; i<event.data.result.length; i++){
	                    results.push(new Service(event.data.result[i]));
	                }
	                self.onSearchResult(results);
	            }

	            // error message
	            else if(event.data && event.data.event === 'discovery.error'){
	                self.onSearchError(event.data.error);
	                this.status = Search.STATUS_STOPPED;
	            }
	        }
	    };
	    window.addEventListener('message', this.windowMessageListener);

	    props.private(this,['discoveryFrame','windowMessageListener']);

	}

	util.inherits(Search, EventEmitter);


	/***
	 * @constant {string}
	 * @private
	 */
	Search.STATUS_STOPPED = 'stopped';

	/***
	 * @constant {string}
	 * @private
	 */
	Search.STATUS_STARTED = 'started';


	/**
	 * Starts the search, looking for devices it can reach on the network
	 * If a search is already in progress it will NOT begin a new search
	 *
	 * @example
	 *
	 * var search = msf.search();
	 * search.on('found', function(service){
	 *    console.log('found service '+service.name);
	 * }
	 * search.start();
	 *
	 */
	Search.prototype.start = function(){
	    if(this.status === Search.STATUS_STOPPED){
	        if(this.discoveryFrame){
	            this.discoveryFrame.postMessage({method:'discovery.search'}, "*");
	        }else{
	            var self = this;
	            this.once('ready',function(){
	                self.discoveryFrame.postMessage({method:'discovery.search'}, "*");
	            });
	        }
	        this.onSearchStart();
	    }else{
	        console.warn('a previous search is already in progress');
	    }
	};

	/**
	 * Stops the current search in progress (no 'found' events or search callbacks will fire)
	 *
	 * @example

	 search.stop();

	 */
	Search.prototype.stop = function(){
	    this.onSearchStop();
	};


	/**
	 * Fired when a search has discovered compatible services
	 *
	 * @event Search#found
	 * @type {Array}
	 * @example
	 * search.on('found', function(service){
	 *    console.log('found '+service.name);
	 * });
	 */


	Search.prototype.onSearchResult = function(results){
	    if(this.status !== Search.STATUS_STOPPED){
	        this.emit('found',results);
	    }
	    this.status = Search.STATUS_STOPPED;
	};


	/**
	 * Fired when a search error has occurred
	 *
	 * @event Search#error
	 * @type {Error}
	 * @example
	 * search.on('error', function(err){
	 *    console.error('something went wrong', err.message);
	 * });
	 */

	Search.prototype.onSearchError = function(error){
	    this.emit('error',error);
	    this.status = Search.STATUS_STOPPED;
	};

	/**
	 * Fired when a search has been started
	 *
	 * @event Search#start
	 * @type {Search}
	 *
	 * @example
	 * search.on('start', function(){
	 *    ui.setState('searching');
	 * });
	 */
	Search.prototype.onSearchStart = function(){
	    this.status = Search.STATUS_STARTED;
	    this.emit('start', this);
	};

	/**
	 * Fired when a search has been stopped
	 *
	 * @event Search#stop
	 * @type {Search}
	 * @example
	 * search.on('stop', function(){
	 *    ui.setState('stopped');
	 * });
	 */
	Search.prototype.onSearchStop = function(){
	    this.status = Search.STATUS_STOPPED;
	    this.emit('stop', this);
	};


	module.exports = Search;



/***/ },
/* 5 */
/***/ function(module, exports, __webpack_require__) {

	module.exports = {

	    logger      : __webpack_require__(8),
	    url         : __webpack_require__(9),
	    inherits    : __webpack_require__(10),
	    props       : __webpack_require__(11),
	    types       : __webpack_require__(12),
	    queryString : __webpack_require__(13)

	};

/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var util    = __webpack_require__(5);
	var logger  = util.logger;
	var types   = util.types;
	var props   = util.props;
	var Channel = __webpack_require__(7);


	var TYPE_APP = 'applications';
	var TYPE_WEB_APP = 'webapplication';


	/**
	 * An Application represents an application on the remote device.
	 * Use the class to control various aspects of the application such launching the app or getting information
	 *
	 * @class Application
	 * @extends Channel
	 *
	 * @param {Service} service the underlying service
	 * @param {String} id can be an installed app id or url for a webapp
	 * @param {String} channelURI a unique channel id (com.myapp.mychannel)
	 *
	 * @hide-constructor
	 */

	function Application(service, id, channelURI){

	    /* Type checking */
	    if(!types.isObject(service)) throw new TypeError('service must be of type Service');
	    if(!types.isString(id)) throw new TypeError('id must be a valid string');
	    if(!types.isString(channelURI)) throw new TypeError('channelId must be a valid string');

	    /***
	     * The type of application (web application or installable app)
	     * @member {String} Application#type
	     * @private
	     */
	    this.type = id.match(/(file:\/\/|http(s)?:\/\/)/gmi) ? TYPE_WEB_APP : TYPE_APP;

	    /* Super Constructor */
	    Application.super_.call(this, service, channelURI);


	    /**
	     * The id of the application (this can be a url or installed application id)
	     * @member {String} Application#id
	     * @readonly
	     */
	    this.id = id;


	    /***
	     * The underlying of the application
	     * @member {String} Application#service
	     * @private
	     */
	    this.service = service;


	    /*
	    Listen for clientDisconnect events and disconnect if host disconnects
	    */
	    this.on('clientDisconnect', function(client){
	        if(client.isHost) this.disconnect();
	    }.bind(this));

	    /*
	     Turn off emitting the connect event from super as the application will provide its own
	    */
	    this.disableEvent('connect');


	    props.readOnly(this,'id');
	    props.private(this,'type','service');

	}

	util.inherits(Application, Channel);



	/**
	 * Starts and connects to the application on the remote device. Similar to the Channel 'connect' method but
	 * within an Application the 'connect' callback and event will be called when the remoted application has
	 * launched and is ready to receive messages.
	 *
	 * @param {Object} attributes Any attributes to attach to your client
	 * @param {Function} callback The callback handler
	 * @param {Error} callback.error Any error that may have occurred during the connection or application startup
	 * @param {Client} callback.client Your client object
	 *
	 * @example
	 * app.connect({displayName:'Wheezy'},function(err, client){
	 *   if(err) return console.error('something went wrong : ', error.code, error.message);
	 *   console.info('You are now connected');
	 * });
	 */
	Application.prototype.connect = function(attributes, callback){

	    /*
	     This gets a little tricky because in an app instance we dont want connect to fire until the remote device is connected.
	     We also want to start the remote application and provide any errors from the launch
	     .... so we need to block the default connect event from Channel, have ready event trigger connect event, and start the app.
	     */

	    /*
	     Call connect on the super (which will never callback or fire connect event until the TV app starts)
	    */
	    Channel.prototype.connect.call(this, attributes, function(err, client){

	        /*
	         Create a once listener for the ready event and that will callback and fire the connect event
	         */
	        this.once('ready',function(){

	            // call the connect callback
	            if(callback) {
	                logger.debug('application.connect->callback', null, client);
	                callback(null, client);
	                // null it so it can't be called again
	                callback = null;
	            }

	            // enable the connect event, fire it, disable it again
	            logger.debug('application.emit("connect")', client);
	            this.enableEvent('connect');
	            this.emit('connect',client);
	            this.disableEvent('connect');

	        }.bind(this));

	        /*
	         Create a callback to handle the application starting
	         If there is an error with the application start callback with the error
	         */
	        var startCallback = function(err){
	            logger.debug('application->startCallback', err);
	            if(err && callback) {
	                callback(err);
	                callback = null; // null it so it can't be called again
	            }
	        }.bind(this);

	        /*
	         Start the application or webapp with the callback
	         */
	        if(this.type === 'webapplication'){
	            this.invoke('ms.webapplication.start', { url : this.id }, startCallback);
	        }else{
	            this.invoke('ms.application.start', { id : this.id }, startCallback);
	        }

	    }.bind(this));

	};

	/**
	 * Disconnects your client from the remote application.
	 * If the first argument is an optional param and can be used close the remote application
	 * The stop/exit command is only sent if you are the last connected client
	 *
	 * @param {Boolean} [exitOnRemote=true] Issues a stop/exit on the remote application before disconnecting
	 * @param {Function} [callback] The callback handler
	 * @param {Error} callback.error Any error that may have occurred during the connection or application startup
	 * @param {Client} callback.client Your client object
	 *
	 * @example
	 * app.disconnect(function(err){
	 *     if(err) return console.error('something went wrong');
	 *     console.info('You are now disconnected');
	 * });
	 */
	Application.prototype.disconnect = function(exitOnRemote, callback){

	    if(types.isFunction(exitOnRemote)){
	        callback = exitOnRemote;
	        exitOnRemote = true;
	    }

	    if(types.isUndefined(exitOnRemote)) exitOnRemote = true;


	    if(exitOnRemote && this.clients.length <= 2) {

	        var stopCallback = function(err){
	            // still disconnect even if there was an error
	            Channel.prototype.disconnect.call(this, callback);
	        }.bind(this);

	        if(this.type === 'webapplication'){
	            this.invoke('ms.webapplication.stop', { url : this.id }, stopCallback);
	        }else{
	            this.invoke('ms.application.stop', { id : this.id }, stopCallback);
	        }

	    }else{
	        Channel.prototype.disconnect.call(this, callback);
	    }

	};

	/**
	 * Installs the application on the remote device.
	 *
	 * @param {Function} callback The callback handler
	 * @param {Function} callback.err The callback handler
	 *
	 * @example
	 *  app.connect({name:'Jason'}, function(err, client){
	 *    if(err.code === 404){
	 *      var install = confirm('Would you like to install the MyApp on your TV?');
	 *      if(install){
	 *         app.install(function(err){
	 *            alert('Please follow the prompts on your TV to install the application');
	 *         });
	 *     }
	 *   }
	 *  });
	 */
	Application.prototype.install = function(callback){

	    if(this.type === TYPE_WEB_APP) return callback(new Error('web application cannot be installed'));

	    var e;

	    var oReq = new XMLHttpRequest();
	    oReq.timeout = 5000;
	    oReq.ontimeout = function(){
	        e = new Error('Request Timeout');
	        e.code = 408;
	        callback(e);
	    };
	    oReq.onload = function() {
	        if(this.status === 200){
	            callback(null, true);
	        }
	        else {
	            e = new Error(this.statusText);
	            e.code = this.status;
	            callback(e);
	        }
	    };
	    oReq.open("get", this.service.uri + 'applications/'+this.id, true);
	    oReq.send();

	};




	module.exports = Application;



/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var util    = __webpack_require__(5);
	var logger  = util.logger;
	var types   = util.types;
	var props   = util.props;
	var EventEmitter = __webpack_require__(2);
	var Client = __webpack_require__(14);
	var ClientList = __webpack_require__(15);


	/**
	 * A Channel is a discreet connection where multiple clients can communicate
	 * @class Channel
	 * @extends EventEmitter
	 *
	 * @hide-constructor
	 */
	function Channel(service, uri){

	    logger.debug('new Channel',arguments);

	    /* Type checking */
	    if(!types.isObject(service)) throw new TypeError('service must be of type Service');
	    if(!types.isString(uri)) throw new TypeError('uri must be a valid string');

	    /* Super Construction */
	    Channel.super_.call(this);

	    var self = this;
	    var oServiceUrl = util.url.parse(service.uri);


	    /**
	     * The collection of clients currently connected to the channel
	     *
	     * @member {ClientList} Channel#clients
	     * @readonly
	     *
	     */
	    this.clients = new ClientList(this);

	    /**
	     * The connection status of the channel
	     *
	     * @member {Boolean} Channel#isConnected
	     * @readonly
	     *
	     */
	    Object.defineProperty(this, 'isConnected', {
	        get : function(){
	            return self.connection && self.connection.readyState === 1;
	        }
	    });


	    /***
	     * The id assigned to your client upon connection
	     *
	     * @member {String} Channel#clientId
	     * @private
	     *
	     */
	    this.clientId = null;

	    /***
	     * The underlying web socket connection
	     *
	     * @member {WebSocket} Channel#connection
	     * @private
	     *
	     */
	    this.connection = null;

	    /***
	     * A map of message handler still waiting for responses
	     *
	     * @member {Object} Channel#resultHandlers
	     * @private
	     *
	     */
	    this.resultHandlers = {};

	    /***
	     * The url for the websocket to connect to
	     *
	     * @member {Object} Channel#connectionUrl
	     * @private
	     *
	     */
	    this.connectionUrl = 'ws://' + oServiceUrl.host + oServiceUrl.pathname + 'channels/' + uri;

	    props.readOnly(this, ['clients']);
	    props.private(this, ['clientId','connection','resultHandlers','connectionUrl','connectCallback']);

	}


	util.inherits(Channel, EventEmitter);




	/***
	 * Invokes and RPC method on the server
	 *
	 * @protected
	 *
	 * @param {String} method The name of the method to invoke
	 * @param {Object} params Named params to pass to the method
	 * @param {Function} [callback] The success callback handler
	 * @param {Error} callback.error Any error that may have occurred
	 * @param {Boolean} callback.success
	 * @param {Boolean} [isNotification=false] If true the message will have no id and no response handler will be stored
	 * @param {ArrayBuffer|Blob} [payload] Any binary data to send along with the message
	 *
	 */
	Channel.prototype.invoke = function(method, params, callback, isNotification, payload){

	    logger.debug('channel.invoke',arguments);

	    if(!this.isConnected) throw new Error("the channel is disconnected");
	    if(!types.isString(method))throw new TypeError('method must be a valid string');

	    params = params || {};

	    var msg = {
	        method  : method,
	        params  : params
	    };

	    if(callback && !isNotification){
	        msg.id = Date.now();
	        this.resultHandlers[msg.id] = callback;
	    }

	    if(payload){
	        msg = Channel.packMessage(msg,payload);
	    }else{
	        msg = JSON.stringify(msg);
	    }

	    this.connection.send(msg);
	};

	/**
	 * Connects to the channel
	 *
	 * @param {Object} attributes Any attributes you want to associate with the client (ie. {name:"FooBar"}
	 * @param {Function} callback The success callback handler
	 * @param {Error} callback.error Any error that may have occurred
	 * @param {Channel} callback.channel The channel instance that connected
	 *
	 */
	Channel.prototype.connect = function(attributes, callback){

	    logger.debug('channel.connect',arguments);

	    if(types.isFunction(attributes) && !callback){
	        callback = attributes;
	        attributes = {};
	    }else{
	        attributes = attributes || {};
	    }

	    // Validate arguments and connection state
	    if(!types.isObject(attributes))throw new TypeError('attributes must be a valid object');
	    if(callback && !types.isFunction(callback))throw new TypeError('callback must be a valid function');
	    if(this.isConnected) return console.warn('Channel is already connected.');

	    // Store the callback
	    this.connectCallback = callback;

	    // TODO : Need to merge query string just in case the connection url already has a query (although it shouldn't)
	    var u = this.connectionUrl + '?' + util.queryString.stringify(attributes);

	    // Clean up any old connections
	    if(this.connection){
	        this.connection.onopen = null;
	        this.connection.onerror = null;
	        this.connection.onclose = null;
	        this.connection.onmessage = null;
	    }

	    // Connect the websocket and add our listeners
	    this.connection = new WebSocket(u);
	    this.connection.binaryType = "arraybuffer";
	    this.connection.onopen = this._onSocketOpen.bind(this);
	    this.connection.onerror = this._onSocketError.bind(this);
	    this.connection.onclose = this._onSocketClose.bind(this);
	    this.connection.onmessage = this._onSocketMessage.bind(this);
	};

	/**
	 * Disconnects from the channel
	 *
	 * @param {Function} callback The success callback handler
	 * @param {Error} callback.error Any error that may have occurred
	 * @param {Channel} callback.channel The channel instance
	 *
	 */
	Channel.prototype.disconnect = function(callback){

	    logger.debug('channel.disconnect',arguments);

	    if(!this.isConnected) console.warn("the channel is already disconnected");
	    this.connection.close();
	    var self = this;
	    setTimeout(function(){
	        if(callback) callback(null, self);
	    },0);

	};

	/**
	 * Publish an event message to the specified target or targets.
	 * Targets can be in the for of a clients id, an array of client ids or one of the special message target strings (ie. "all" or "host"}
	 *
	 * @param {String} event The name of the event to emit
	 * @param {any} [message] Any data associated with the event
	 * @param {String|Array} [target='broadcast'] The target recipient(s) of the message
	 * @param {Blob|ArrayBuffer} [payload] Any binary data to send with the message
	 *
	 */
	Channel.prototype.publish = function(event, message, target, payload){

	    logger.silly('channel.publish',arguments);

	    target = target || 'broadcast';
	    message = message || null;

	    if(!this.isConnected) throw new Error(" the channel is not connected");
	    if(!types.isString(event))throw new TypeError('event must be a valid string');

	    if(!(types.isString(target) || types.isArray(target))) throw new TypeError('targets must be a valid string or array');

	    this.invoke('ms.channel.emit',{
	        event   : event,
	        data    : message,
	        to      : target
	    }, null, true, payload);

	};


	/*
	 Packs messages with payloads into binary message
	 */
	Channel.packMessage = function(oMsg, payload){

	    logger.debug('channel.packMessage',arguments);

	    // convert js object to string
	    var msg = JSON.stringify(oMsg);

	    // get byte length of the string
	    var msgByteLength = new Blob([msg]).size;

	    // create 2 byte header which contains the length of the string (json) message
	    var hBuff = new ArrayBuffer(2);
	    var hView = new DataView(hBuff);
	    hView.setUint16(0,msgByteLength);

	    // binary packed message and payload
	    return new Blob([hBuff, msg, payload]);

	};

	/*
	 Unpacks binary messages
	 */
	Channel.unpackMessage = function(buffer){

	    logger.debug('channel.unpackMessage',arguments);

	    var json = '';
	    var view = new DataView(buffer);
	    var msgByteLen = view.getUint16(0);

	    for (var i = 0; i < msgByteLen; i++) {
	        json += String.fromCharCode(view.getUint8(i+2));
	    }

	    var payload = buffer.slice(2+msgByteLen);
	    var message = JSON.parse(json);

	    return {payload : payload, message : message};

	};



	/*
	 PRIVATE handlers
	 */

	/**
	 * Fired when a channel makes a connection
	 *
	 * @event Channel#connect
	 * @type {Client}
	 */
	Channel.prototype._onConnect = function(data) {

	    logger.silly('channel._onSocketOpen');

	    // Store my id
	    this.clientId = data.id;

	    // Store the current connected client
	    data.clients.forEach(function(clientInfo){

	        // Create a client and add to our list
	        var client = new Client(clientInfo.id, clientInfo.attributes, clientInfo.isHost);
	        this.clients.push(client);

	    },this);

	    // call the connect callback if present and reset
	    if(this.connectCallback) {
	        logger.debug('channel.connect->callback',this.clients.me);
	        this.connectCallback(null, this.clients.me);
	        this.connectCallback = null;
	    }


	    logger.debug('channel.emit("connect")',this.clients.me);
	    this.emit('connect',this.clients.me);

	};

	/**
	 * Fired when a peer client channel makes a connection
	 *
	 * @event Channel#clientConnect
	 * @type {Client}
	 */
	Channel.prototype._onClientConnect = function(data) {
	    logger.silly('channel._onSocketOpen');

	    var client = new Client(data.id, data.attributes, data.isHost);
	    this.clients.push(client);


	    logger.debug('channel.emit("clientConnect")',client);
	    this.emit('clientConnect',client);
	};

	/**
	 * Fired when a peer client disconnects
	 *
	 * @event Channel#clientDisconnect
	 * @type {Client}
	 */
	Channel.prototype._onClientDisconnect = function(data) {
	    logger.silly('channel._onSocketOpen');

	    var client = this.clients.getById(data.id);
	    if(client) this.clients.remove(client);
	    else {
	        logger.warn('client '+data.id+' could not be found, so it was not removed from the client list');
	        client = new Client(data.id, data.attributes, data.isHost);
	    }


	    logger.debug('channel.emit("clientDisconnect")',client);
	    this.emit('clientDisconnect',client);
	};

	/***
	 * Fired when the host has connected and is ready to accept messages
	 * @deprecated since version 2.0.18 (please use the connect event)
	 *
	 * @event Channel#ready
	 */
	Channel.prototype._onReady = function(data){

	    logger.debug('channel.emit("ready")');
	    this.emit('ready');
	};

	Channel.prototype._onUserEvent = function(msg){

	    var client = this.clients.getById(msg.from);
	    var event = msg.event;
	    var data  = msg.data;
	    var payload = msg.payload;

	    logger.debug('channel.emit("'+event+'")',data, client, payload);
	    this.emit(event, data, client, payload);
	};

	Channel.prototype._onSocketOpen = function() {
	    logger.silly('channel._onSocketOpen');
	};

	Channel.prototype._onSocketClose = function() {
	    logger.silly('channel._onSocketClose');
	    /**
	     * Fired when a channel disconnects
	     *
	     * @event Channel#disconnect
	     * @type {Client}
	     */
	    var client = this.clients.me;
	    this.clients.clear();
	    this.emit('disconnect',client);
	};

	Channel.prototype._onSocketError = function(e) {
	    logger.silly('channel._onSocketError',e);
	    this.emit('error', new Error("WebSocket error"));
	};


	Channel.prototype._onSocketMessage = function(msg){

	    logger.silly('channel._onSocketMessage',msg);

	    // Serialize the message
	    try{
	        if(typeof msg.data === "string"){
	            msg = JSON.parse(msg.data);
	        }else{
	            var unpacked = Channel.unpackMessage(msg.data);
	            msg = unpacked.message;
	            msg.payload = unpacked.payload;
	        }
	    } catch (e) {
	        logger.warn('unable to parse message', msg);
	        return;
	    }

	    // RPC Response?
	    if(msg.id && (msg.result || msg.error)){

	        if(!this.resultHandlers[msg.id]){
	            logger.warn('unable to find result handler for result message ', msg);
	            return;
	        }

	        this.resultHandlers[msg.id](msg.error,msg.result);

	    }
	    // Event?
	    else if (msg.event){

	        switch(msg.event){

	            case 'ms.channel.connect' :
	                this._onConnect(msg.data);
	                break;

	            case 'ms.channel.clientConnect' :
	                this._onClientConnect(msg.data);
	                break;

	            case 'ms.channel.clientDisconnect' :
	                this._onClientDisconnect(msg.data);
	                break;

	            case 'ms.channel.ready' :
	                this._onReady(msg.data);
	                break;

	            default :
	                this._onUserEvent(msg);
	                break;
	        }
	    }
	    // Unrecognized
	    else{
	        logger.warn('unrecognized message type', msg);
	    }

	};

	module.exports = Channel;



/***/ },
/* 8 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var levels = ['error','warn','info','verbose','debug','silly'];

	var logger = {

	    level : 'disabled',

	    log : function(level /* ,....args*/){
	        if(logger.level !== 'disabled' && (levels.indexOf(level) <= levels.indexOf(logger.level))){
	            var args = Array.prototype.slice.call(arguments,1);
	            args.unshift('[MSF:'+level.toUpperCase()+']');
	            if(console[level]){
	                console[level].apply(console,args);
	            }else{
	                console.log.apply(console,args);
	            }

	        }
	    }

	};

	function createLevel(level){
	    return function(/*args*/){
	        var args = Array.prototype.slice.call(arguments);
	        args.unshift(level);
	        logger.log.apply(logger,args);
	    };
	}

	// Create logger methods based on levels
	for(var i=0; i<levels.length; i++){
	    var level = levels[i];
	    logger[level] = createLevel(level);
	}

	module.exports = logger;

/***/ },
/* 9 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var queryString = __webpack_require__(13);

	var url = {

	    isValid : function(u){

	        var pattern = /^(?:([A-Za-z]+):)?(\/{0,3})([0-9.\-A-Za-z]+)(?::(\d+))?(?:\/([^?#]*))?(?:\?([^#]*))?(?:#(.*))?$/;
	        return u.match(pattern) ? true : false;
	    },

	    parse : function(u){

	        var oUrl = {};
	        var parser = document.createElement('a');
	        parser.href = u; // "http://example.com:3000/pathname/?search=test#hash";

	        oUrl.href = parser.href; // => "http://ip:port/path/page?query=string#hash"
	        oUrl.protocol = parser.protocol; // => "http:"
	        oUrl.hostname = parser.hostname; // => "example.com"
	        oUrl.port = parser.port;     // => "3000"
	        oUrl.pathname = parser.pathname; // => "/pathname/"
	        oUrl.search = parser.search;   // => "?search=test"
	        oUrl.hash = parser.hash;     // => "#hash"
	        oUrl.host = parser.host;     // => "example.com:3000"
	        oUrl.queryString = queryString.parse(parser.search);

	        return oUrl;
	    }


	};

	module.exports = url;

/***/ },
/* 10 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	if (typeof Object.create === 'function') {
	    // implementation from standard node.js 'util' module
	    module.exports = function inherits(ctor, superCtor) {
	        ctor.super_ = superCtor;
	        ctor.prototype = Object.create(superCtor.prototype, {
	            constructor: {
	                value: ctor,
	                enumerable: false,
	                writable: true,
	                configurable: true
	            }
	        });
	    };
	} else {
	    // old school shim for old browsers
	    module.exports = function inherits(ctor, superCtor) {
	        ctor.super_ = superCtor;
	        var TempCtor = function () {};
	        TempCtor.prototype = superCtor.prototype;
	        ctor.prototype = new TempCtor();
	        ctor.prototype.constructor = ctor;
	    };
	}

/***/ },
/* 11 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	function createDescriptor(e,c,w,v){
	    return {
	        enumerable : e,
	        configurable : c,
	        writable : w,
	        value : v
	    };
	}

	module.exports = {

	    readOnly : function(obj, key){

	        if(Array.isArray(key)){
	            key.forEach(function(k){
	                Object.defineProperty(obj, k, createDescriptor(true,true,false,obj[k]));
	            });
	        }else{
	            Object.defineProperty(obj, key, createDescriptor(true,true,false,obj[key]));
	        }

	    },

	    private : function(obj, key){

	        if(Array.isArray(key)){
	            key.forEach(function(k){ Object.defineProperty(obj, k, createDescriptor(false,true,true,obj[k])); });
	        }else{
	            Object.defineProperty(obj, key, createDescriptor(false,true,true,obj[key]));
	        }
	    }
	};

/***/ },
/* 12 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	module.exports = {

	    isString : function(obj){
	        return typeof obj === 'string';
	    },

	    isNull : function(obj){
	        return obj === null;
	    },

	    isBoolean : function(obj){
	        return typeof obj === 'boolean';
	    },

	    isNumber : function(obj){
	        return typeof obj === 'number';
	    },

	    isObject : function(obj){
	        return obj === Object(obj);
	    },

	    isArray : function(obj){
	        return obj.constructor === Array;
	    },

	    isFunction : function(obj){
	        return typeof obj === 'function';
	    },

	    isUndefined : function(obj){
	        return typeof obj === 'undefined';
	    }



	};

/***/ },
/* 13 */
/***/ function(module, exports, __webpack_require__) {

	'use strict';

	/*
	    Derived work from Sidre Sorhus (https://github.com/sindresorhus/query-string)
	 */

	/*!
	 query-string
	 Parse and stringify URL query strings
	 https://github.com/sindresorhus/query-string
	 by Sindre Sorhus
	 MIT License
	 */

	var queryString = {};

	queryString.parse = function (str) {
	    if (typeof str !== 'string') {
	        return {};
	    }

	    str = str.trim().replace(/^(\?|#)/, '');

	    if (!str) {
	        return {};
	    }

	    return str.trim().split('&').reduce(function (ret, param) {
	        var parts = param.replace(/\+/g, ' ').split('=');
	        var key = parts[0];
	        var val = parts[1];

	        key = decodeURIComponent(key);
	        // missing `=` should be `null`:
	        // http://w3.org/TR/2012/WD-url-20120524/#collect-url-parameters
	        val = val === undefined ? null : decodeURIComponent(val);

	        if (!ret.hasOwnProperty(key)) {
	            ret[key] = val;
	        } else if (Array.isArray(ret[key])) {
	            ret[key].push(val);
	        } else {
	            ret[key] = [ret[key], val];
	        }

	        return ret;
	    }, {});
	};

	queryString.stringify = function (obj) {
	    return obj ? Object.keys(obj).map(function (key) {
	        var val = obj[key];

	        if (Array.isArray(val)) {
	            return val.map(function (val2) {
	                return encodeURIComponent(key) + '=' + encodeURIComponent(val2);
	            }).join('&');
	        }

	        return encodeURIComponent(key) + '=' + encodeURIComponent(val);
	    }).join('&') : '';
	};

	module.exports = queryString;


/***/ },
/* 14 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var util = __webpack_require__(5);
	var types = util.types;


	/**
	 * A representation of an individual device or user connected to a channel.
	 * Clients can have user defined attributes that are readable by all other clients.
	 * @class Client
	 *
	 * @hide-constructor
	 *
	 */
	function ChannelClient(id, attributes, isHost, connectTime){

	    if(!types.isString(id)) throw new TypeError('id must be a valid string');
	    if(attributes && !types.isObject(attributes)) throw new TypeError('attributes must be a valid object');

	    /**
	     * The id of the client
	     *
	     * @name id
	     * @memberOf Client.prototype
	     * @type {String}
	     * @readonly
	     *
	     */
	    this.id = id;

	    /**
	     * A map of attributes passed by the client when connecting
	     *
	     * @name attributes
	     * @memberOf Client.prototype
	     * @type {Object}
	     * @readonly
	     *
	     */
	    this.attributes = attributes || {};

	    /**
	     * Flag for determining if the client is the host
	     *
	     * @name isHost
	     * @memberOf Client.prototype
	     * @type {Boolean}
	     * @readonly
	     *
	     */
	    this.isHost = isHost;

	    /**
	     * The time which the client connected in epoch milliseconds
	     *
	     * @name connectTime
	     * @memberOf Client.prototype
	     * @type {Number}
	     * @readonly
	     *
	     */
	    this.connectTime = connectTime || Date.now();

	    Object.freeze(this.attributes);
	    Object.freeze(this);

	}

	module.exports = ChannelClient;



/***/ },
/* 15 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";

	var util = __webpack_require__(5);
	var types = util.types;

	/**
	 * A list of {@link Client|clients} accessible through {@link Channel#clients|channel.clients}.
	 * This list is managed by the channel and automatically adds and removes clients as they connect and disconnect
	 * @class ClientList
	 * @extends Array
	 * @hide-constructor
	 */

	function ClientList(channel){

	    if(!types.isObject(channel))throw new TypeError('channel must be of type Channel');

	    this.channel = channel;

	    ClientList.super_.call(this);

	}

	util.inherits(ClientList, Array);

	/**
	 * A reference to your client
	 *
	 * @member {Client} ClientList#me
	 * @readonly
	 */
	Object.defineProperty(ClientList.prototype, 'me', {
	    get : function(){
	        return this.getById(this.channel.clientId);
	    }
	});

	/***
	 * Clears the list
	 * @protected
	 */
	ClientList.prototype.clear = function(){
	    this.length = 0;
	};

	/***
	 * Removes an client from the list
	 * @protected
	 */
	ClientList.prototype.remove = function(item){
	    var i = this.indexOf(item);
	    if(i !== -1) {
	        this.splice(i, 1);
	        return item;
	    }
	    return null;
	};


	/**
	 * Returns a client by id
	 *
	 * @param {String} id The client
	 * @return {Client}
	 *
	 */
	ClientList.prototype.getById = function(id){

	    if(!types.isString(id) && !types.isNumber(id)) throw new TypeError('id must be a valid string or number');
	    for(var i=0; i<this.length; i++){
	        if(this[i].id === id) return this[i];
	    }
	    return null;
	};


	module.exports = ClientList;



/***/ }
/******/ ]);
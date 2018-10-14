var SPEvent = (function () {
    function SPEvent() {
        //"use strict";
        this._defaultPrevented = false;
        this._propagationStopped = false;
        this.EVENT_INITIALIZE = 0 /* EVENT_INITIALIZE */;
        this.CAPTURING_PHASE = 1 /* CAPTURING_PHASE */;
        this.AT_TARGET = 2 /* AT_TARGET */;
        this.BUBBLING_PHASE = 3 /* BUBBLING_PHASE */;

        this.type = "";
        this.target = null;
        this.currentTarget = null;
        this.eventPhase = 0 /* EVENT_INITIALIZE */;
        this.bubbles = true;
        this.cancelable = true;
        this.timeStamp = (new Date()).valueOf();
        this.detail = null;
    }
    SPEvent.prototype.stopPropagation = function () {
        this._propagationStopped = true;
    };

    SPEvent.prototype.preventDefault = function () {
        if (this.cancelable) {
            this._defaultPrevented = true;
        }
    };

    SPEvent.prototype.initEvent = function (eventTypeArg, canBubbleArg, cancelableArg) {
        this.type = eventTypeArg;
        this.bubbles = canBubbleArg;
        this.cancelable = cancelableArg;
    };
    return SPEvent;
})();

var SPEventException = (function () {
    function SPEventException() {
        this.UNSPECIFIED_EVENT_TYPE_ERR = 0 /* UNSPECIFIED_EVENT_TYPE_ERR */;
        this.code = 0 /* UNSPECIFIED_EVENT_TYPE_ERR */;
    }
    return SPEventException;
})();

var SPEventListener = (function () {
    function SPEventListener(eventHandler) {
        this.eventHandler = eventHandler;
    }
    SPEventListener.prototype.handleEvent = function (tsEvent) {
        if (tsEvent.eventPhase === tsEvent.CAPTURING_PHASE) {
            tsEvent.eventPhase = tsEvent.AT_TARGET;
        } else if (tsEvent.eventPhase === tsEvent.AT_TARGET) {
            tsEvent.eventPhase = tsEvent.BUBBLING_PHASE;
        }
        this.eventHandler(tsEvent);
    };
    return SPEventListener;
})();

var SPEventTarget = (function () {
    function SPEventTarget() {
        this._eventListeners = {};
        this._eventListeners["true"] = {};
        this._eventListeners["false"] = {};
    }
    SPEventTarget.prototype.addEventListener = function (eventType, eventListener, useCapture) {
        var currentCapture = (useCapture === true).toString();

        if (!this._eventListeners[currentCapture][eventType]) {
            this._eventListeners[currentCapture][eventType] = [];
        }
        this._eventListeners[currentCapture][eventType].push(eventListener);
    };

    SPEventTarget.prototype.removeEventListener = function (eventType, eventListener, useCapture) {
        var currentCapture = (useCapture === true).toString();

        if (this._eventListeners[currentCapture][eventType]) {
            var index = this._eventListeners[currentCapture][eventType].indexOf(eventListener);

            if (index !== -1) {
                this._eventListeners[currentCapture][eventType].splice(index, 1);
            }
        }
    };

    SPEventTarget.prototype.dispatchEvent = function (tsEvent) {
        var listeners = this._getListenersByType(tsEvent.type);

        tsEvent.currentTarget = this;

        if (tsEvent.eventPhase === tsEvent.EVENT_INITIALIZE) {
            tsEvent.target = this;
            tsEvent.eventPhase = tsEvent.CAPTURING_PHASE;
        }
        for (var idx = 0; idx < listeners.length; idx++) {
            if (!tsEvent["_propagationStopped"]) {
                listeners[idx].handleEvent(tsEvent);
            }
        }
        if (tsEvent.bubbles && !tsEvent["_propagationStopped"]) {
        }
        return !tsEvent["_defaultPrevented"];
    };

    SPEventTarget.prototype._getListenersByType = function (eventType) {
        var listeners = [];

        if (this._eventListeners["true"][eventType]) {
            listeners = listeners.concat(this._eventListeners["true"][eventType]);
        }
        if (this._eventListeners["false"][eventType]) {
            listeners = listeners.concat(this._eventListeners["false"][eventType]);
        }
        return listeners;
    };
    return SPEventTarget;
})();

var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var SPBase = (function (_super) {
    __extends(SPBase, _super);
    function SPBase() {
        _super.call(this);
    }
    SPBase.prototype.clone = function () {
        var cloneFn = function () {
            var newObj = {};

            for (var index in this) {
                if (this.hasOwnProperty(index)) {
                    if (index == 'clone')
                        continue;
                    if (this[index] && typeof this[index] == 'object')
                        newObj[index] = cloneFn.apply(this[index]);
                    else {
                        if (typeof (this[index]) == 'string')
                            newObj[index] = this[index];
                        else
                            newObj[index] = this[index];
                    }
                }
            }
            return newObj;
        };
        return cloneFn.apply(this);
    };

    SPBase.prototype.getKeys = function () {
        var thisKeys = [];

        for (var propertyName in this) {
            thisKeys.push(propertyName);
        }
        return thisKeys;
    };

    SPBase.prototype.concatObjects = function (obj1, obj2) {
        var cloneFn = function (obj1, obj2) {
            var newObj = {};

            var obj1keys = obj1.getKeys();
            var obj2keys = obj2.getKeys();

            var objskeys = obj1keys.concat(obj2keys);

            for (var i = 0; i < objskeys.length; i++) {
                var index = objskeys[i];
                if (index == 'clone')
                    continue;
                if (obj1[index] && typeof obj1[index] == 'object') {
                    if (obj2[index] && typeof obj2[index] == 'object') {
                        newObj[index] = cloneFn(obj1, obj2);
                    } else {
                        newObj[index] = cloneFn(obj1[index], {});
                    }
                } else if (obj2[index] && typeof obj2[index] == 'object') {
                    newObj[index] = cloneFn({}, obj2[index]);
                } else {
                    if (typeof (obj2[index]) == 'string')
                        newObj[index] = obj2[index];
                    else if (typeof (obj1[index]) == 'string')
                        newObj[index] = obj1[index];
                }
            }
            return newObj;
        };
        return cloneFn(obj1, obj2);
    };

    SPBase.prototype.dispatchDOMEvent = function (domElement, eventName, eventData) {
        var oEvent = document.createEvent("CustomEvent");

        if (domElement.dispatchEvent) {
            oEvent.initCustomEvent(eventName, false, false, eventData);

            domElement.dispatchEvent(oEvent);
        }
    };
    return SPBase;
})(SPEventTarget);

var SPBIEvents = (function (_super) {
    __extends(SPBIEvents, _super);
    function SPBIEvents() {
        _super.call(this);

        this.p_pseudoImage = document.createElement("img");
    }
    SPBIEvents.prototype.setUrl = function (biServiceUrl) {
        this.biServiceUrl = biServiceUrl;
    };

    SPBIEvents.prototype.sendEvent = function (biEvent) {
        var paramsString;

        paramsString += "?appId=" + biEvent.applicationId;
        paramsString += "&catId=" + biEvent.categoryId;
        paramsString += "&evtId=" + biEvent.eventId;

        if (biEvent.eventData) {
            paramsString += "&data=" + JSON.stringify(biEvent.eventData);
        }

        if (this.offlineMode !== true) {
            this.p_pseudoImage.src = this.biServiceUrl + paramsString;
        }
    };
    return SPBIEvents;
})(SPBase);
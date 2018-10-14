var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var SPRpcCall = (function (_super) {
    __extends(SPRpcCall, _super);
    function SPRpcCall(rpcCallBaseUrl) {
        _super.call(this);
        this.rpcCallBaseUrl = rpcCallBaseUrl;
        /* Constants */
        this.CREATE_SNAPSHOT = "createSnapshot";
        this.GENERAL_CALL_METHOD = "generalCallMethod";
        this.GET_FAVORITE_INSIGHTS = "getFavoriteInsights";
        this.GET_NAMESPACE_PARAMETERS = "getAllParameters";
        this.GET_PARAMETER_SEGMENTS = "getSegments";
        this.GET_ALL_NAMESPACES = "getNamespaces";
        this.UPDATE_FAVORITE_FLAG = "updateFavoriteFlag";
        this.RENAME_PARAMETER = "renameParameter";

        this.rpcCallRequest = this.getRpcCall();
    }
    SPRpcCall.prototype.getCallStringIdentifier = function () {
        var callIdentifier;

        callIdentifier = this.rpcCallRequest.method + ":" + JSON.stringify(this.rpcCallRequest.params);

        return callIdentifier;
    };

    SPRpcCall.prototype.checkCache = function () {
        var callIdentifier = this.getCallStringIdentifier();

        if (!SPRpcCall.rpcCallCache[this.rpcCallRequest.method]) {
            SPRpcCall.rpcCallCache[this.rpcCallRequest.method] = {};
        }

        return (typeof (SPRpcCall.rpcCallCache[this.rpcCallRequest.method][callIdentifier]) !== 'undefined');
    };

    SPRpcCall.prototype.getCache = function () {
        var callIdentifier = this.getCallStringIdentifier();

        return SPRpcCall.rpcCallCache[this.rpcCallRequest.method][callIdentifier];
    };

    SPRpcCall.prototype.setCache = function (cacheData) {
        var callIdentifier = this.getCallStringIdentifier();

        if (!SPRpcCall.rpcCallCache[this.rpcCallRequest.method]) {
            SPRpcCall.rpcCallCache[this.rpcCallRequest.method] = {};
        }

        SPRpcCall.rpcCallCache[this.rpcCallRequest.method][callIdentifier] = cacheData;
    };

    SPRpcCall.prototype.clearCache = function () {
        SPRpcCall.rpcCallCache[this.rpcCallRequest.method] = {};
    };

    SPRpcCall.prototype.onRpcCallSuccessEvent = function (result) {
        var tsEvent = new SPEvent();

        this.setCache(result);

        tsEvent.initEvent("success", true, false);
        tsEvent.detail = result;
        this.dispatchEvent(tsEvent);

        this.onRpcCallSuccess(result);
    };

    SPRpcCall.prototype.onRpcCallErrorEvent = function (result) {
        var tsEvent = new SPEvent();

        tsEvent.initEvent("error", true, false);
        tsEvent.detail = result;
        this.dispatchEvent(tsEvent);

        this.onRpcCallError(result);
    };

    SPRpcCall.prototype.onRpcCallSuccess = function (result) {
    };

    SPRpcCall.prototype.onRpcCallError = function (result) {
    };

    SPRpcCall.prototype.getRpcParams = function () {
        return this.rpcCallRequest.params;
    };

    SPRpcCall.prototype.setRpcParams = function (params) {
        this.rpcCallRequest.params = params;
    };

    SPRpcCall.prototype.execute = function (cacheControl) {
        var tsEvent = new SPEvent();
        var params = [this.getRpcCall(), [this.getRpcParams()]];

        tsEvent.initEvent("execute", true, false);
        tsEvent.detail = params;
        this.dispatchEvent(tsEvent);

        if (cacheControl.cacheCurrentState === false) {
            this.clearCache();
        }
        if (cacheControl.cacheCurrentState && this.checkCache()) {
            this.onRpcCallSuccessEvent(this.getCache());
        } else {
            jQuery.jsonRPC.request(this.rpcCallRequest.method, this.rpcCallRequest);
        }
    };

    SPRpcCall.prototype.getRpcCall = function () {
        var _this = this;
        return {
            jsonrpc: "2.0",
            id: Math.floor(Math.random() * 2147483648).toString(),
            method: this.GENERAL_CALL_METHOD,
            params: {},
            endPoint: this.rpcCallBaseUrl,
            success: function (result) {
                return _this.onRpcCallSuccessEvent(result);
            },
            error: function (result) {
                return _this.onRpcCallErrorEvent(result);
            }
        };
    };
    SPRpcCall.rpcCallCache = {};
    return SPRpcCall;
})(SPBase);
var SPRpcCacheControl = (function (_super) {
    __extends(SPRpcCacheControl, _super);
    function SPRpcCacheControl(rpcCall, alwaysTrue, alwaysFalse, changeOnError, changeOnSuccess) {
        var _this = this;
        _super.call(this);
        this.rpcCall = rpcCall;
        this.cacheAlwaysTrue = false;
        this.cacheAlwaysFalse = false;
        this.cacheCurrentState = false;
        this.cacheChangeOnError = false;
        this.cacheChangeOnSuccess = true;

        var successListener = new SPEventListener(function () {
            return _this.onRpcCallSuccess();
        });
        var errorListener = new SPEventListener(function () {
            return _this.onRpcCallError();
        });
        var executeListener = new SPEventListener(function () {
            return _this.onRpcCallExecute();
        });

        rpcCall.addEventListener("success", successListener, false);
        rpcCall.addEventListener("error", errorListener, false);
        rpcCall.addEventListener("execute", executeListener, false);

        if (alwaysTrue !== undefined)
            this.cacheAlwaysTrue = alwaysTrue;
        if (alwaysFalse !== undefined)
            this.cacheAlwaysFalse = alwaysFalse;
        if (changeOnError !== undefined)
            this.cacheChangeOnError = changeOnError;
        if (changeOnSuccess !== undefined)
            this.cacheChangeOnSuccess = changeOnSuccess;
    }
    SPRpcCacheControl.prototype.onRpcCallExecute = function () {
        if (this.cacheAlwaysFalse) {
            this.cacheCurrentState = false;
        } else if (this.cacheAlwaysTrue) {
            this.cacheCurrentState = true;
        }
    };
    SPRpcCacheControl.prototype.onRpcCallSuccess = function () {
        if (this.cacheChangeOnSuccess && this.cacheAlwaysFalse) {
            this.cacheCurrentState = false;
        } else if (this.cacheChangeOnSuccess) {
            this.cacheCurrentState = true;
        }
    };

    SPRpcCacheControl.prototype.onRpcCallError = function () {
        if (this.cacheChangeOnError && this.cacheAlwaysFalse) {
            this.cacheCurrentState = false;
        } else if (this.cacheChangeOnError) {
            this.cacheCurrentState = true;
        }
    };
    return SPRpcCacheControl;
})(SPBase);

var SPRpcCallCreateSnapshot = (function (_super) {
    __extends(SPRpcCallCreateSnapshot, _super);
    function SPRpcCallCreateSnapshot(rpcCallBaseUrl) {
        _super.call(this, rpcCallBaseUrl);
    }
    SPRpcCallCreateSnapshot.prototype.getRpcCall = function () {
        var _this = this;
        return {
            jsonrpc: "2.0",
            id: Math.floor(Math.random() * 2147483648).toString(),
            method: this.CREATE_SNAPSHOT,
            params: {},
            endPoint: this.rpcCallBaseUrl,
            success: function (result) {
                return _this.onRpcCallSuccessEvent(result);
            },
            error: function (result) {
                return _this.onRpcCallErrorEvent(result);
            }
        };
    };
    return SPRpcCallCreateSnapshot;
})(SPRpcCall);

var SPRpcCallGetNamespaces = (function (_super) {
    __extends(SPRpcCallGetNamespaces, _super);
    function SPRpcCallGetNamespaces(rpcCallBaseUrl) {
        _super.call(this, rpcCallBaseUrl);
    }
    SPRpcCallGetNamespaces.prototype.getRpcCall = function () {
        var _this = this;
        return {
            jsonrpc: "2.0",
            id: Math.floor(Math.random() * 2147483648).toString(),
            method: this.GET_ALL_NAMESPACES,
            params: {},
            endPoint: this.rpcCallBaseUrl,
            success: function (result) {
                return _this.onRpcCallSuccessEvent(result);
            },
            error: function (result) {
                return _this.onRpcCallErrorEvent(result);
            }
        };
    };
    return SPRpcCallGetNamespaces;
})(SPRpcCall);

var SPRpcCallGetFavoriteInsights = (function (_super) {
    __extends(SPRpcCallGetFavoriteInsights, _super);
    function SPRpcCallGetFavoriteInsights(rpcCallBaseUrl) {
        _super.call(this, rpcCallBaseUrl);
    }
    SPRpcCallGetFavoriteInsights.prototype.getRpcCall = function () {
        var _this = this;
        return {
            jsonrpc: "2.0",
            id: Math.floor(Math.random() * 2147483648).toString(),
            method: this.GET_FAVORITE_INSIGHTS,
            params: {},
            endPoint: this.rpcCallBaseUrl,
            success: function (result) {
                return _this.onRpcCallSuccessEvent(result);
            },
            error: function (result) {
                return _this.onRpcCallErrorEvent(result);
            }
        };
    };
    return SPRpcCallGetFavoriteInsights;
})(SPRpcCall);

var SPRpcCallGetAllParameters = (function (_super) {
    __extends(SPRpcCallGetAllParameters, _super);
    function SPRpcCallGetAllParameters(rpcCallBaseUrl) {
        _super.call(this, rpcCallBaseUrl);
    }
    SPRpcCallGetAllParameters.prototype.getRpcCall = function () {
        var _this = this;
        return {
            jsonrpc: "2.0",
            id: Math.floor(Math.random() * 2147483648).toString(),
            method: this.GET_NAMESPACE_PARAMETERS,
            params: {},
            endPoint: this.rpcCallBaseUrl,
            success: function (result) {
                return _this.onRpcCallSuccessEvent(result);
            },
            error: function (result) {
                return _this.onRpcCallErrorEvent(result);
            }
        };
    };
    return SPRpcCallGetAllParameters;
})(SPRpcCall);

var SPRpcCallGetSegments = (function (_super) {
    __extends(SPRpcCallGetSegments, _super);
    function SPRpcCallGetSegments(rpcCallBaseUrl) {
        _super.call(this, rpcCallBaseUrl);
    }
    SPRpcCallGetSegments.prototype.getRpcCall = function () {
        var _this = this;
        return {
            jsonrpc: "2.0",
            id: Math.floor(Math.random() * 2147483648).toString(),
            method: this.GET_PARAMETER_SEGMENTS,
            params: {},
            endPoint: this.rpcCallBaseUrl,
            success: function (result) {
                return _this.onRpcCallSuccessEvent(result);
            },
            error: function (result) {
                return _this.onRpcCallErrorEvent(result);
            }
        };
    };
    return SPRpcCallGetSegments;
})(SPRpcCall);

var SPRpcCallUpdateFavoriteFlag = (function (_super) {
    __extends(SPRpcCallUpdateFavoriteFlag, _super);
    function SPRpcCallUpdateFavoriteFlag(rpcCallBaseUrl) {
        _super.call(this, rpcCallBaseUrl);
    }
    SPRpcCallUpdateFavoriteFlag.prototype.getRpcCall = function () {
        var _this = this;
        return {
            jsonrpc: "2.0",
            id: Math.floor(Math.random() * 2147483648).toString(),
            method: this.UPDATE_FAVORITE_FLAG,
            params: {},
            endPoint: this.rpcCallBaseUrl,
            success: function (result) {
                return _this.onRpcCallSuccessEvent(result);
            },
            error: function (result) {
                return _this.onRpcCallErrorEvent(result);
            }
        };
    };
    return SPRpcCallUpdateFavoriteFlag;
})(SPRpcCall);

var SPRpcCallRenameParameter = (function (_super) {
    __extends(SPRpcCallRenameParameter, _super);
    function SPRpcCallRenameParameter(rpcCallBaseUrl) {
        _super.call(this, rpcCallBaseUrl);
    }
    SPRpcCallRenameParameter.prototype.getRpcCall = function () {
        var _this = this;
        return {
            jsonrpc: "2.0",
            id: Math.floor(Math.random() * 2147483648).toString(),
            method: this.RENAME_PARAMETER,
            params: {},
            endPoint: this.rpcCallBaseUrl,
            success: function (result) {
                return _this.onRpcCallSuccessEvent(result);
            },
            error: function (result) {
                return _this.onRpcCallErrorEvent(result);
            }
        };
    };
    return SPRpcCallRenameParameter;
})(SPRpcCall);

var SPRpcRequestProvider = (function (_super) {
    __extends(SPRpcRequestProvider, _super);
    function SPRpcRequestProvider() {
        _super.call(this);
        /* Constants */
        this.CREATE_SNAPSHOT = "createSnapshot";
        this.GENERAL_CALL_METHOD = "generalCallMethod";
        this.GET_FAVORITE_INSIGHTS = "getFavoriteInsights";
        this.GET_NAMESPACE_PARAMETERS = "getAllParameters";
        this.GET_PARAMETER_SEGMENTS = "getSegments";
        this.GET_ALL_NAMESPACES = "getNamespaces";
        this.UPDATE_FAVORITE_FLAG = "updateFavoriteFlag";
        this.RENAME_PARAMETER = "renameParameter";
        this.URL_createSnapshot = "/dashboard/rest/rpc/insights";
        this.URL_getAllParameters = "/dashboard/rest/rpc/insights";
        this.URL_getFavoriteInsights = "/dashboard/rest/rpc/insights";
        this.URL_getNamespaces = "/dashboard/rest/rpc/general";
        this.URL_getSegments = "/dashboard/rest/rpc/insights";
        this.URL_updateFavoriteFlag = "/dashboard/rest/rpc/insights";
        this.URL_renameParameter = "/dashboard/rest/rpc/insights";
    }
    SPRpcRequestProvider.prototype.getRpcCall = function (rpcCallType) {
        var rpcCall;

        switch (rpcCallType) {
            case this.CREATE_SNAPSHOT:
                rpcCall = new SPRpcCallCreateSnapshot(this.URL_createSnapshot);
                break;
            case this.GET_FAVORITE_INSIGHTS:
                rpcCall = new SPRpcCallGetFavoriteInsights(this.URL_getFavoriteInsights);
                break;
            case this.GET_ALL_NAMESPACES:
                rpcCall = new SPRpcCallGetNamespaces(this.URL_getNamespaces);
                break;
            case this.GET_NAMESPACE_PARAMETERS:
                rpcCall = new SPRpcCallGetAllParameters(this.URL_getAllParameters);
                break;
            case this.GET_PARAMETER_SEGMENTS:
                rpcCall = new SPRpcCallGetSegments(this.URL_getSegments);
                break;
            case this.UPDATE_FAVORITE_FLAG:
                rpcCall = new SPRpcCallUpdateFavoriteFlag(this.URL_updateFavoriteFlag);
                break;
            case this.RENAME_PARAMETER:
                rpcCall = new SPRpcCallRenameParameter(this.URL_renameParameter);
                break;
        }
        return rpcCall;
    };
    return SPRpcRequestProvider;
})(SPBase);
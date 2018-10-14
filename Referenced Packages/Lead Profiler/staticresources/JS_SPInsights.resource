var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};

var insights;
(function (insights) {
    "use strict";

    var SPInsightsModel = (function (_super) {
        __extends(SPInsightsModel, _super);
        function SPInsightsModel(rpcProvider) {
            var _this = this;
            _super.call(this);
            this.rpcProvider = rpcProvider;

            this.rpcCallCreateSnapshot = this.rpcProvider.getRpcCall(this.rpcProvider.CREATE_SNAPSHOT);
            this.rpcCallGetNamespaces = this.rpcProvider.getRpcCall(this.rpcProvider.GET_ALL_NAMESPACES);
            this.rpcCallGetFavoriteInsights = this.rpcProvider.getRpcCall(this.rpcProvider.GET_FAVORITE_INSIGHTS);
            this.rpcCallGetAllParameters = this.rpcProvider.getRpcCall(this.rpcProvider.GET_NAMESPACE_PARAMETERS);
            this.rpcCallGetSegments = this.rpcProvider.getRpcCall(this.rpcProvider.GET_PARAMETER_SEGMENTS);
            this.rpcCallUpdateFavoriteFlag = this.rpcProvider.getRpcCall(this.rpcProvider.UPDATE_FAVORITE_FLAG);
            this.rpcCallRenameParameter = this.rpcProvider.getRpcCall(this.rpcProvider.RENAME_PARAMETER);

            this.cacheControlCreateSnapshot = new SPRpcCacheControl(this.rpcCallCreateSnapshot, false, true);
            this.cacheControlRetrieveNamespaces = new SPRpcCacheControl(this.rpcCallGetNamespaces, true);
            this.cacheControlRetrieveFavoriteInsights = new SPRpcCacheControl(this.rpcCallGetFavoriteInsights, true);
            this.cacheControlRetrieveAllParameters = new SPRpcCacheControl(this.rpcCallGetAllParameters, false, false);
            this.cacheControlRetrieveSegments = new SPRpcCacheControl(this.rpcCallGetSegments, false);
            this.cacheControlUpdateFavoriteFlag = new SPRpcCacheControl(this.rpcCallUpdateFavoriteFlag, false, true);
            this.cacheControlRenameParameter = new SPRpcCacheControl(this.rpcCallRenameParameter, false, false);

            this.attachEventsToRpcCall(this.rpcCallCreateSnapshot, "CreateSnapshot", function () {
                return _this.onCreateSnapshot_success();
            });
            this.attachEventsToRpcCall(this.rpcCallGetNamespaces, "GetNamespaces");
            this.attachEventsToRpcCall(this.rpcCallGetFavoriteInsights, "GetFavoriteInsights");
            this.attachEventsToRpcCall(this.rpcCallGetAllParameters, "GetAllParameters");
            this.attachEventsToRpcCall(this.rpcCallGetSegments, "GetSegments");
            this.attachEventsToRpcCall(this.rpcCallUpdateFavoriteFlag, "UpdateFavoriteFlag");
            this.attachEventsToRpcCall(this.rpcCallRenameParameter, "RenameParameter");
        }
        SPInsightsModel.prototype.onCreateSnapshot_success = function () {
            this.cacheControlRetrieveAllParameters.cacheCurrentState = false;
            this.cacheControlRetrieveSegments.cacheCurrentState = false;
        };

        SPInsightsModel.prototype.createSnapshot = function (organizationId, flowType) {
            var rpcCallParams = this.rpcCallCreateSnapshot.getRpcParams();

            rpcCallParams.organizationId = organizationId;
            rpcCallParams.flowType = flowType;

            this.rpcCallCreateSnapshot.execute(this.cacheControlCreateSnapshot);
        };

        SPInsightsModel.prototype.retrieveNamespaces = function () {
            this.rpcCallGetNamespaces.execute(this.cacheControlRetrieveNamespaces);
        };

        SPInsightsModel.prototype.retrieveFavoriteInsights = function (organizationId, flowType, insightsViewType) {
            var rpcCallParams = this.rpcCallGetFavoriteInsights.getRpcParams();

            rpcCallParams.organizationId = organizationId;
            rpcCallParams.flowType = flowType;
            rpcCallParams.insightType = insightsViewType;

            this.rpcCallGetFavoriteInsights.execute(this.cacheControlRetrieveFavoriteInsights);
        };

        SPInsightsModel.prototype.retrieveAllParameters = function (organizationId, flowType, timeFrame, insightsViewType) {
            var rpcCallParams = this.rpcCallGetAllParameters.getRpcParams();

            rpcCallParams.insightType = insightsViewType;
            rpcCallParams.organizationId = organizationId;
            rpcCallParams.flowType = flowType;
            rpcCallParams.timeFrame = timeFrame;

            this.rpcCallGetAllParameters.execute(this.cacheControlRetrieveAllParameters);
        };

        SPInsightsModel.prototype.retrieveSegments = function (organizationId, flowType, parameterId) {
            var rpcCallParams = this.rpcCallGetSegments.getRpcParams();

            rpcCallParams.organizationId = organizationId;
            rpcCallParams.flowType = flowType;
            rpcCallParams.parameterId = parameterId;

            this.rpcCallGetSegments.execute(this.cacheControlRetrieveSegments);
        };

        SPInsightsModel.prototype.updateFavoriteFlag = function (organizationId, flowType, segmentId, favorite) {
            var rpcCallParams = this.rpcCallUpdateFavoriteFlag.getRpcParams();

            rpcCallParams.organizationId = organizationId;
            rpcCallParams.flowType = flowType;
            rpcCallParams.segmentId = segmentId;
            rpcCallParams.favorite = favorite;

            this.rpcCallUpdateFavoriteFlag.execute(this.cacheControlUpdateFavoriteFlag);
        };

        SPInsightsModel.prototype.renameParameter = function (organizationId, flowType, parameterName, newDisplayName) {
            var rpcCallParams = this.rpcCallRenameParameter.getRpcParams();

            rpcCallParams.organizationId = organizationId;
            rpcCallParams.flowType = flowType;
            rpcCallParams.parameterName = parameterName;
            rpcCallParams.newDisplayName = newDisplayName;

            this.rpcCallRenameParameter.execute(this.cacheControlRenameParameter);
        };

        SPInsightsModel.prototype.attachEventsToRpcCall = function (rpcCall, eventPrefix, callback) {
            var successCallback = this.getRpcEventCallbackFunction(eventPrefix + "_onDataRetrieve", callback);
            var errorCallback = this.getRpcEventCallbackFunction(eventPrefix + "_onDataError");

            var successListener = new SPEventListener(successCallback);
            var errorListener = new SPEventListener(errorCallback);

            rpcCall.addEventListener("success", successListener, false);
            rpcCall.addEventListener("error", errorListener, false);
        };

        SPInsightsModel.prototype.getRpcEventCallbackFunction = function (eventToRaise, callback) {
            var _this = this;
            return function (event) {
                var tsEvent = new SPEvent();

                tsEvent.initEvent(eventToRaise, true, false);
                tsEvent.detail = event.detail;

                if (callback) {
                    callback(tsEvent);
                }
                _this.dispatchEvent(tsEvent);
            };
        };
        SPInsightsModel.$inject = ['rpcProvider'];
        return SPInsightsModel;
    })(SPBase);
    insights.SPInsightsModel = SPInsightsModel;
})(insights || (insights = {}));

(function (_insights) {
    "use strict";

    _insights.INSIGHTS_VIEW_TYPE = {
        NOMINAL: "NOMINAL",
        PERCENTAGE: "PERCENTAGE"
    };

    _insights.INSIGHTS_TYPE = {
        CURRENT: "CURRENT",
        SNAPSHOT: "SNAPSHOT"
    };

    _insights.INSIGHTS_VIEW_BY_SELECTIONS = [
        { index: 0, name: "CONVERSION_RATE", text: "Conversion rate", description: "Overall wins" },
        { index: 1, name: "SUCCESS_RATE", text: "Success rate", description: "Win + Lost" },
        { index: 2, name: "BUSINESS_RATIO", text: "Business ratio", description: "Win + Close + Lost" }
    ];

    _insights.INSIGHTS_TIME_FRAME = {
        MONTH: "MONTH",
        HALF_YEAR: "HALF_YEAR",
        QUARTER: "QUARTER"
    };
    var SPInsightsController = (function (_super) {
        __extends(SPInsightsController, _super);
        function SPInsightsController($scope, insightsModel, settingsService, translations, biService) {
            var _this = this;
            _super.call(this);
            this.$scope = $scope;
            this.insightsModel = insightsModel;
            this.settingsService = settingsService;
            this.translations = translations;
            this.biService = biService;
            this.viewByValues = _insights.INSIGHTS_VIEW_BY_SELECTIONS;

            $scope["Ctrl"] = this;

            this.insightsData = {
                namespaces: null,
                parameters: null,
                insights: null,
                favoriteInsights: null,
                currentNamespace: null,
                currentParameter: null,
                currentTimeFrame: _insights.INSIGHTS_TIME_FRAME.HALF_YEAR,
                currentSegment: null,
                currentSegmentsSet: [],
                snapshotResponse: null
            };
            this.segmentsView = {
                SUCCESS_RATE: [],
                CONVERSION_RATE: [],
                BUSINESS_RATIO: []
            };

            this.viewByValues[0].text = translations.selection_ConversionRate;
            this.viewByValues[0].description = translations.tooltip_ConversionRate;
            this.viewByValues[1].text = translations.selection_SuccessRate;
            this.viewByValues[1].description = translations.tooltip_SuccessRate;
            this.viewByValues[2].text = translations.selection_BusinessRatio;
            this.viewByValues[2].description = translations.tooltip_BusinessRatio;

            this.view = {
                insightsViewBy: this.viewByValues[0 /* CONVERSION_RATE */],
                insightsViewType: _insights.INSIGHTS_VIEW_TYPE.PERCENTAGE,
                insightsType: settingsService.isCanvasApp ? _insights.INSIGHTS_TYPE.SNAPSHOT : _insights.INSIGHTS_TYPE.CURRENT,
                levelOfInterest: "GOOD",
                onlyInteresting: true,
                rpcInProcess: false
            };

            this.attachToModelEvents();

            this.biEvent_Error = {
                applicationId: 2 /* INSIGHTS */,
                categoryId: 1 /* JS_EVENT */,
                eventId: 0 /* DATA_ERROR */,
                eventData: {
                    code: 0,
                    description: ""
                }
            };

            this.biEvent_Selection = {
                applicationId: 2 /* INSIGHTS */,
                categoryId: 0 /* UI_EVENT */,
                eventId: 0 /* SELECTION_NAMESPACE */,
                eventData: {}
            };

            biService.setUrl(settingsService.biEventsUrl);
            biService.offlineMode = !this.settingsService.isBiActive;

            if (settingsService.isInsightsEnabled) {
                window.addEventListener("resize", function () {
                    return _this.onViewChange();
                });

                if (this.settingsService.isCanvasApp) {
                    this.generateNamespaceFromSignedRequest();
                } else {
                    this.insightsModel.retrieveNamespaces();
                }
            }
        }
        SPInsightsController.prototype.attachToModelEvents = function () {
            var _this = this;
            var createSnapshot_successEventListener = new SPEventListener(function (event) {
                return _this.onDataRetrieve_CreateSnapshot(event);
            });
            var createSnapshot_errorEventListener = new SPEventListener(function (event) {
                return _this.onDataError_CreateSnapshot(event);
            });
            var getNamespaces_successEventListener = new SPEventListener(function (event) {
                return _this.onDataRetrieve_RetrieveNamespaces(event);
            });
            var getNamespaces_errorEventListener = new SPEventListener(function (event) {
                return _this.onDataError_RetrieveNamespaces(event);
            });
            var getAllParameters_successEventListener = new SPEventListener(function (event) {
                return _this.onDataRetrieve_RetrieveParameters(event);
            });
            var getAllParameters_errorEventListener = new SPEventListener(function (event) {
                return _this.onDataError_RetrieveParameters(event);
            });
            var getSegments_successEventListener = new SPEventListener(function (event) {
                return _this.onDataRetrieve_RetrieveSegments(event);
            });
            var getSegments_errorEventListener = new SPEventListener(function (event) {
                return _this.onDataError_RetrieveSegments(event);
            });
            var updateFavoriteFlag_successEventListener = new SPEventListener(function (event) {
                return _this.onDataRetrieve_UpdateFavoriteFlag(event);
            });
            var updateFavoriteFlag_errorEventListener = new SPEventListener(function (event) {
                return _this.onDataError_UpdateFavoriteFlag(event);
            });
            var getFavoriteInsights_successEventListener = new SPEventListener(function (event) {
                return _this.onDataRetrieve_RetrieveFavoriteInsights(event);
            });
            var getFavoriteInsights_errorEventListener = new SPEventListener(function (event) {
                return _this.onDataError_RetrieveFavoriteInsights(event);
            });
            var renameParameter_successEventListener = new SPEventListener(function (event) {
                return _this.onDataRetrieve_RenameParameter(event);
            });
            var renameParameter_errorEventListener = new SPEventListener(function (event) {
                return _this.onDataError_RenameParameter(event);
            });

            this.insightsModel.addEventListener("CreateSnapshot_onDataRetrieve", createSnapshot_successEventListener, false);
            this.insightsModel.addEventListener("CreateSnapshot_onDataError", createSnapshot_errorEventListener, false);
            this.insightsModel.addEventListener("GetNamespaces_onDataRetrieve", getNamespaces_successEventListener, false);
            this.insightsModel.addEventListener("GetNamespaces_onDataError", getNamespaces_errorEventListener, false);
            this.insightsModel.addEventListener("GetAllParameters_onDataRetrieve", getAllParameters_successEventListener, false);
            this.insightsModel.addEventListener("GetAllParameters_onDataError", getAllParameters_errorEventListener, false);
            this.insightsModel.addEventListener("GetSegments_onDataRetrieve", getSegments_successEventListener, false);
            this.insightsModel.addEventListener("GetSegments_onDataError", getSegments_errorEventListener, false);
            this.insightsModel.addEventListener("UpdateFavoriteFlag_onDataRetrieve", updateFavoriteFlag_successEventListener, false);
            this.insightsModel.addEventListener("UpdateFavoriteFlag_onDataError", updateFavoriteFlag_errorEventListener, false);
            this.insightsModel.addEventListener("GetFavoriteInsights_onDataRetrieve", getFavoriteInsights_successEventListener, false);
            this.insightsModel.addEventListener("GetFavoriteInsights_onDataError", getFavoriteInsights_errorEventListener, false);
            this.insightsModel.addEventListener("RenameParameter_onDataRetrieve", renameParameter_successEventListener, false);
            this.insightsModel.addEventListener("RenameParameter_onDataError", renameParameter_errorEventListener, false);
        };

        SPInsightsController.prototype.prepareSegmentsDataFor_SuccessRate = function (segments, insights) {
            var segmentView = {};
            var segmentsView = [];
            var segment;

            for (var index = 0; index < segments.length; index++) {
                segment = segments[index];
                segmentView = segment;

                segmentView.average = insights.priorSuccessRate * 100;
                segmentView.percentage = segment.successRate * 100;
                segmentView.recallLeads = insights.totalWon + insights.totalLost;
                segmentView.recallPercentage = segment.recallOnClosed * 100;
                segmentView.recallWon = insights.totalWon;
                segmentView.numberOfLeads = segment.numberOfWon + segment.numberOfLost;
                segmentView.lostRate = (segmentView.numberOfLost / segmentView.numberOfLeads) * 100;
                segmentView.type = 1 /* SUCCESS_RATE */;

                if (!(this.settingsService.isCanvasApp && segment.blank)) {
                    segmentsView.push(segmentView);
                }
            }
            return segmentsView;
        };

        SPInsightsController.prototype.prepareSegmentsDataFor_ConversionRate = function (segments, insights) {
            var segmentView = {};
            var segmentsView = [];
            var segment;

            for (var index = 0; index < segments.length; index++) {
                segment = segments[index];
                segmentView = segment;

                segmentView.average = insights.priorConversionRate * 100;
                segmentView.percentage = segment.conversionRate * 100; //bus
                segmentView.recallLeads = insights.totalWon + insights.totalLost + insights.totalOpen;
                segmentView.recallPercentage = segment.recallOnAll * 100;
                segmentView.recallWon = insights.totalWon;
                segmentView.numberOfLeads = segment.numberOfWon + segment.numberOfLost + segment.numberOfOpen;
                segmentView.lostRate = (segmentView.numberOfLost / segmentView.numberOfLeads) * 100;
                segmentView.type = 0 /* CONVERSION_RATE */;

                if (!(this.settingsService.isCanvasApp && segment.blank)) {
                    segmentsView.push(segmentView);
                }
            }
            return segmentsView;
        };

        SPInsightsController.prototype.prepareSegmentsDataFor_BusinessRatio = function (segments, insights) {
            var segmentView = {};
            var segmentsView = [];
            var segment;

            for (var index = 0; index < segments.length; index++) {
                segment = segments[index];
                segmentView = segment;

                segmentView.average = insights.priorConversionRate * 100;
                segmentView.percentage = segment.businessRatio * 100; //conv
                segmentView.recallLeads = insights.totalWon + insights.totalLost + insights.totalOpen;
                segmentView.recallPercentage = segment.recallOnAll * 100;
                segmentView.recallWon = insights.totalWon;
                segmentView.numberOfLeads = segment.numberOfWon + segment.numberOfLost + segment.numberOfOpen;
                segmentView.lostRate = (segmentView.numberOfLost / segmentView.numberOfLeads) * 100;
                segmentView.type = 2 /* BUSINESS_RATIO */;

                if (!(this.settingsService.isCanvasApp && segment.blank)) {
                    segmentsView.push(segmentView);
                }
            }
            return segmentsView;
        };

        SPInsightsController.prototype.prepareSegmentsDataForView = function () {
            this.segmentsView.SUCCESS_RATE = [];
            this.segmentsView.CONVERSION_RATE = [];
            this.segmentsView.BUSINESS_RATIO = [];

            //var segments = this.insightsData.insights.segments;
            this.segmentsView.BUSINESS_RATIO = this.prepareSegmentsDataFor_BusinessRatio(this.insightsData.insights.segments.BUSINESS_RATIO, this.insightsData.insights);
            this.segmentsView.SUCCESS_RATE = this.prepareSegmentsDataFor_SuccessRate(this.insightsData.insights.segments.SUCCESS_RATE, this.insightsData.insights);
            this.segmentsView.CONVERSION_RATE = this.prepareSegmentsDataFor_ConversionRate(this.insightsData.insights.segments.CONVERSION_RATE, this.insightsData.insights);
        };

        SPInsightsController.prototype.prepareSegmentsSetForView = function () {
            var segmentsByView;

            switch (this.view.insightsViewBy.index) {
                case 0 /* CONVERSION_RATE */:
                    segmentsByView = this.segmentsView.CONVERSION_RATE;
                    break;
                case 1 /* SUCCESS_RATE */:
                    segmentsByView = this.segmentsView.SUCCESS_RATE;
                    break;
                case 2 /* BUSINESS_RATIO */:
                    segmentsByView = this.segmentsView.BUSINESS_RATIO;
                    break;
            }

            this.insightsData.currentSegmentsSet = [];

            for (var index = 0; index < segmentsByView.length; index++) {
                var segment = segmentsByView[index];

                if (this.view.onlyInteresting) {
                    if (segmentsByView[index].important) {
                        this.insightsData.currentSegmentsSet.push(segmentsByView[index]);
                    }
                } else {
                    this.insightsData.currentSegmentsSet.push(segmentsByView[index]);
                }
            }
        };

        SPInsightsController.prototype.prepareInsightsParameters = function (parametersFromRpc) {
            this.insightsData.parameters = [];

            var paramIndex;
            var paramExist;
            var tempParam;

            for (paramIndex = 0; paramIndex < parametersFromRpc.recommendedParameters.length; paramIndex++) {
                tempParam = parametersFromRpc.recommendedParameters[paramIndex];

                tempParam.group = "Recommended";
                this.insightsData.parameters.push(tempParam);
            }
            for (paramIndex = 0; paramIndex < parametersFromRpc.allParameters.length; paramIndex++) {
                paramExist = false;

                for (var checkIndex = 0; checkIndex < parametersFromRpc.recommendedParameters.length; checkIndex++) {
                    paramExist = parametersFromRpc.recommendedParameters[checkIndex].name === parametersFromRpc.allParameters[paramIndex].name;

                    if (paramExist)
                        break;
                }
                if (!paramExist) {
                    tempParam = parametersFromRpc.allParameters[paramIndex];

                    tempParam.group = "All Parameters";
                    this.insightsData.parameters.push(tempParam);
                }
            }
        };

        SPInsightsController.prototype.generateNamespaceFromSignedRequest = function () {
            function __generateNamespaceFromSignedRequest(signedRequest) {
                return {
                    classificationDaysLookBack: 0,
                    dbName: "",
                    description: "",
                    flowType: "Lead",
                    fullSyncCycleDays: 0,
                    isBackup: false,
                    isDeleted: false,
                    namespace: signedRequest.context.organization.organizationId,
                    onlineSyncCycleMinutes: 0,
                    oppsDownloadLookBack: 0,
                    organization: {
                        appVersion: "",
                        description: "",
                        organizationId: signedRequest.context.organization.organizationId,
                        syncSource: "" },
                    rawEntityDirty: false,
                    syncSource: "",
                    timestamp: 0,
                    trainingDaysLookBack: 0
                };
            }

            this.insightsData.namespaces = [__generateNamespaceFromSignedRequest(this.settingsService.signedRequest)];
            this.insightsData.currentNamespace = this.insightsData.namespaces[0];
            this.onNameSpaceChange();
        };

        SPInsightsController.prototype.onBarHoverEvent = function (event) {
            if (event.detail) {
                this.insightsData.currentSegment = this.insightsData.currentSegmentsSet[event.detail.seriesIndex - 1];

                if (this.$scope["$root"].$$phase != '$apply' && this.$scope["$root"].$$phase != '$digest') {
                    this.$scope.$apply();
                }
            }
        };

        SPInsightsController.prototype.onDataRetrieve_RetrieveNamespaces = function (event) {
            this.insightsData.namespaces = event.detail.result;
            this.insightsData.currentNamespace = null;

            this.view.rpcInProcess = false;

            if (this.insightsData.namespaces.length > 0) {
                this.insightsData.currentNamespace = this.insightsData.namespaces[0];
                this.onNameSpaceChange();
            }
            this.$scope.$apply();
        };

        SPInsightsController.prototype.onDataError_RetrieveNamespaces = function (event) {
            this.biEvent_Error.eventData.code = 0 /* RETRIEVE_NAMESPACES */;
            this.biEvent_Error.eventData.description = "onDataError_RetrieveNamespaces";
            this.biService.sendEvent(this.biEvent_Error);

            this.view.rpcInProcess = false;
            this.insightsData.namespaces = [];
            this.insightsData.currentNamespace = null;

            this.onViewChange();
            alert(this.translations.error_connectionError);
        };

        SPInsightsController.prototype.onDataRetrieve_RetrieveParameters = function (event) {
            this.prepareInsightsParameters(event.detail.result);

            this.insightsData.insights = null;
            this.view.rpcInProcess = false;

            if (this.insightsData.parameters.length > 0) {
                if (this.insightsData.currentParameter) {
                    var name = this.insightsData.currentParameter.name;
                    this.insightsData.currentParameter = null;
                    for (var index = 0; index < this.insightsData.parameters.length; index++) {
                        if (name === this.insightsData.parameters[index].name) {
                            this.insightsData.currentParameter = this.insightsData.parameters[index];
                            break;
                        }
                    }
                }
                if (!this.insightsData.currentParameter) {
                    this.insightsData.currentParameter = this.insightsData.parameters[0];
                }
            } else {
                this.insightsData.currentParameter = null;
            }
            this.onParameterChange();
        };

        SPInsightsController.prototype.onDataError_RetrieveParameters = function (event) {
            this.biEvent_Error.eventData.code = 1 /* RETRIEVE_PARAMETERS */;
            this.biEvent_Error.eventData.description = "onDataError_RetrieveParameters";
            this.biService.sendEvent(this.biEvent_Error);

            this.insightsData.parameters = [];
            this.insightsData.currentParameter = null;

            this.onViewChange();
            alert(this.translations.error_connectionError);
        };

        SPInsightsController.prototype.onDataRetrieve_RetrieveFavoriteInsights = function (event) {
            this.insightsData.favoriteInsights = event.detail.result;
            this.view.rpcInProcess = false;

            for (var index = 0; index < this.insightsData.favoriteInsights.length; index++) {
                var insight = this.insightsData.favoriteInsights[index];

                if (insight.segments.BUSINESS_RATIO)
                    insight.segments.BUSINESS_RATIO = this.prepareSegmentsDataFor_BusinessRatio(insight.segments.BUSINESS_RATIO, insight);
                if (insight.segments.SUCCESS_RATE)
                    insight.segments.SUCCESS_RATE = this.prepareSegmentsDataFor_SuccessRate(insight.segments.SUCCESS_RATE, insight);
                if (insight.segments.CONVERSION_RATE)
                    insight.segments.CONVERSION_RATE = this.prepareSegmentsDataFor_ConversionRate(insight.segments.CONVERSION_RATE, insight);
            }

            if (this.$scope["$root"].$$phase != '$apply' && this.$scope["$root"].$$phase != '$digest') {
                this.$scope.$apply();
            }
        };

        SPInsightsController.prototype.onDataError_RetrieveFavoriteInsights = function (event) {
            this.biEvent_Error.eventData.code = 3 /* RETRIEVE_FAVORITE_INSIGHTS */;
            this.biEvent_Error.eventData.description = "onDataError_RetrieveFavoriteInsights";
            this.biService.sendEvent(this.biEvent_Error);

            this.view.rpcInProcess = false;
            this.insightsData.favoriteInsights = [];

            this.onViewChange();
            alert(this.translations.error_connectionError);
        };

        SPInsightsController.prototype.onDataRetrieve_RetrieveSegments = function (event) {
            this.insightsData.insights = event.detail.result;

            this.view.rpcInProcess = false;

            this.prepareSegmentsDataForView();
            this.dispatchDOMEvent(window, "resize");
        };

        SPInsightsController.prototype.onDataError_RetrieveSegments = function (event) {
            this.biEvent_Error.eventData.code = 2 /* RETRIEVE_SEGMENTS */;
            this.biEvent_Error.eventData.description = "onDataError_RetrieveSegments";
            this.biService.sendEvent(this.biEvent_Error);

            this.view.rpcInProcess = false;

            this.insightsData.currentSegment = {};
            this.insightsData.currentSegmentsSet = [];
            this.segmentsView.SUCCESS_RATE = [];
            this.segmentsView.CONVERSION_RATE = [];
            this.segmentsView.BUSINESS_RATIO = [];

            this.onViewChange();
            alert(this.translations.error_connectionError);
        };

        SPInsightsController.prototype.onDataRetrieve_UpdateFavoriteFlag = function (event) {
            function isHasFavorites(segments) {
                var returnIsHasFavorites = false;

                for (var index = 0; index < segments.length; index++) {
                    returnIsHasFavorites = returnIsHasFavorites || segments[index].favorite;
                }
                return returnIsHasFavorites;
            }
            function setSegmentFavoriteFlagBySegmentId(segmentId, favorite) {
                var _this = this;

                function setSegmentsFavoriteFlagBySegmentId(segments, segmentId, favorite) {
                    for (var index = 0; index < segments.length; index++) {
                        if (segments[index].segmentId === segmentId) {
                            segments[index].favorite = favorite;
                        }
                    }
                }

                function setSegmentsViewFavoriteFlagBySegmentId(segments, segmentId, favorite) {
                    for (var index = 0; index < segments.length; index++) {
                        if (segments[index].segmentId === segmentId) {
                            segments[index].favorite = favorite;
                        }
                    }
                }
                setSegmentsFavoriteFlagBySegmentId(_this.insightsData.insights.segments.BUSINESS_RATIO, segmentId, favorite);
                setSegmentsFavoriteFlagBySegmentId(_this.insightsData.insights.segments.CONVERSION_RATE, segmentId, favorite);
                setSegmentsFavoriteFlagBySegmentId(_this.insightsData.insights.segments.SUCCESS_RATE, segmentId, favorite);

                setSegmentsViewFavoriteFlagBySegmentId(_this.segmentsView.SUCCESS_RATE, segmentId, favorite);
                setSegmentsViewFavoriteFlagBySegmentId(_this.segmentsView.BUSINESS_RATIO, segmentId, favorite);
                setSegmentsViewFavoriteFlagBySegmentId(_this.segmentsView.CONVERSION_RATE, segmentId, favorite);
            }

            this.insightsData.currentSegment.favorite = !this.insightsData.currentSegment.favorite;
            setSegmentFavoriteFlagBySegmentId.call(this, this.insightsData.currentSegment.segmentId, this.insightsData.currentSegment.favorite);

            this.insightsData.currentParameter.hasFavoriteSegments = isHasFavorites(this.segmentsView.SUCCESS_RATE) || isHasFavorites(this.segmentsView.CONVERSION_RATE) || isHasFavorites(this.segmentsView.BUSINESS_RATIO);

            this.view.rpcInProcess = false;

            this.onViewChange();
        };

        SPInsightsController.prototype.onDataError_UpdateFavoriteFlag = function (event) {
            this.biEvent_Error.eventData.code = 4 /* UPDATE_FAVORITE_FLAG */;
            this.biEvent_Error.eventData.description = "onDataError_UpdateFavoriteFlag";

            this.biService.sendEvent(this.biEvent_Error);
            this.view.rpcInProcess = false;

            alert(this.translations.error_updateDataError);
        };

        SPInsightsController.prototype.onDataRetrieve_CreateSnapshot = function (event) {
            if (event.detail.result.success) {
                this.biEvent_Selection.eventId = 6 /* BUTTON_CREATE_SNAPSHOT */;
                this.biEvent_Selection.eventData = {
                    namespace: this.insightsData.currentNamespace.organization.organizationId,
                    flowType: this.insightsData.currentNamespace.flowType
                };
                this.biService.sendEvent(this.biEvent_Selection);
            } else {
                this.biEvent_Error.eventData.code = 5 /* CREATE_SNAPSHOT */;
                this.biEvent_Error.eventData.description = "onDataError_createSnapshot";
                this.biService.sendEvent(this.biEvent_Error);
            }
            this.insightsData.snapshotResponse = event.detail.result;

            this.view.rpcInProcess = false;

            this.getAllParameters();
        };

        SPInsightsController.prototype.onDataError_CreateSnapshot = function (event) {
            this.biEvent_Error.eventData.code = 5 /* CREATE_SNAPSHOT */;
            this.biEvent_Error.eventData.description = "onDataError_createSnapshot";
            this.biService.sendEvent(this.biEvent_Error);

            this.view.rpcInProcess = false;

            alert(this.translations.error_connectionError);
        };

        SPInsightsController.prototype.onDataRetrieve_RenameParameter = function (event) {
            this.biEvent_Selection.eventId = 7 /* RENAME_PARAMETER */;
            this.biEvent_Selection.eventData = {
                namespace: this.insightsData.currentNamespace.organization.organizationId,
                parameterId: this.insightsData.currentParameter.id
            };
            this.biService.sendEvent(this.biEvent_Selection);

            this.view.rpcInProcess = false;

            if (this.$scope["$root"].$$phase != '$apply' && this.$scope["$root"].$$phase != '$digest') {
                this.$scope.$apply();
            }
        };

        SPInsightsController.prototype.onDataError_RenameParameter = function (event) {
            this.biEvent_Error.eventData.code = 6 /* RENAME_PARAMETER */;
            this.biEvent_Error.eventData.description = "onDataError_createSnapshot";
            this.biService.sendEvent(this.biEvent_Error);

            this.view.rpcInProcess = false;

            alert(this.translations.error_connectionError);
        };

        SPInsightsController.prototype.onNameSpaceChange = function () {
            if (this.settingsService.isCanvasApp) {
                this.view.rpcInProcess = true;
                this.insightsModel.retrieveFavoriteInsights(this.insightsData.currentNamespace.organization.organizationId, this.insightsData.currentNamespace.flowType, this.view.insightsType);
            } else {
                this.getAllParameters();
            }
        };

        SPInsightsController.prototype.createSnapshot = function () {
            this.view.rpcInProcess = true;
            if (this.$scope["$root"].$$phase != '$apply' && this.$scope["$root"].$$phase != '$digest') {
                this.$scope.$apply();
            }
            this.view.rpcInProcess = true;
            this.insightsModel.createSnapshot(this.insightsData.currentNamespace.organization.organizationId, this.insightsData.currentNamespace.flowType);
        };

        SPInsightsController.prototype.getFavoriteInsights = function () {
        };

        SPInsightsController.prototype.getAllParameters = function () {
            this.view.rpcInProcess = true;
            this.insightsModel.retrieveAllParameters(this.insightsData.currentNamespace.organization.organizationId, this.insightsData.currentNamespace.flowType, this.insightsData.currentTimeFrame, this.view.insightsType);
        };

        SPInsightsController.prototype.changeNameSpace = function () {
            this.biEvent_Selection.eventId = 0 /* SELECTION_NAMESPACE */;
            this.biEvent_Selection.eventData = {
                namespace: this.insightsData.currentNamespace.organization.organizationId,
                flowType: this.insightsData.currentNamespace.flowType
            };
            this.biService.sendEvent(this.biEvent_Selection);

            this.onNameSpaceChange();
        };

        SPInsightsController.prototype.changeInteresting = function () {
            this.biEvent_Selection.eventId = 2 /* SELECTION_IMPORTANT */;
            this.biEvent_Selection.eventData = {
                important: this.view.onlyInteresting
            };
            this.biService.sendEvent(this.biEvent_Selection);

            this.onViewChange();
        };

        SPInsightsController.prototype.changeParameter = function (parameter) {
            this.biEvent_Selection.eventId = 1 /* SELECTION_PARAMETER */;
            this.biEvent_Selection.eventData = { parameter: parameter };
            this.biService.sendEvent(this.biEvent_Selection);

            this.insightsData.currentParameter = parameter;
            this.onParameterChange();
        };

        SPInsightsController.prototype.changeParameterByInsight = function (insight) {
            var parameter = {};

            parameter.group = "Recommended";
            parameter.displayName = insight.parameterDisplayName;
            parameter.hasFavoriteSegments = true;
            parameter.id = insight.id;
            parameter.name = insight.parameterName;

            //insightsViewBy: this.viewByValues[INSIGHTS_VIEW_BY.CONVERSION_RATE],
            this.insightsData.currentTimeFrame = insight.timeFrame;

            if (insight.segments.BUSINESS_RATIO)
                this.view.insightsViewBy = this.viewByValues[2 /* BUSINESS_RATIO */];
            if (insight.segments.CONVERSION_RATE)
                this.view.insightsViewBy = this.viewByValues[0 /* CONVERSION_RATE */];
            if (insight.segments.SUCCESS_RATE)
                this.view.insightsViewBy = this.viewByValues[1 /* SUCCESS_RATE */];
            this.insightsData.currentParameter = parameter;

            this.onParameterChange();
        };

        SPInsightsController.prototype.changeFavorite = function () {
            this.biEvent_Selection.eventId = 5 /* UPDATE_FAVORITE_FLAG */;
            this.biEvent_Selection.eventData = {
                segmentId: this.insightsData.currentSegment.segmentId,
                favorite: !this.insightsData.currentSegment.favorite
            };
            this.biService.sendEvent(this.biEvent_Selection);
            this.view.rpcInProcess = true;
            this.insightsModel.updateFavoriteFlag(this.insightsData.currentNamespace.organization.organizationId, this.insightsData.currentNamespace.flowType, this.insightsData.currentSegment.segmentId, !this.insightsData.currentSegment.favorite);
        };

        SPInsightsController.prototype.changeViewBy = function () {
            this.biEvent_Selection.eventId = 4 /* SELECTION_VIEWTYPE */;
            this.biEvent_Selection.eventData = this.view.insightsViewBy;
            this.biService.sendEvent(this.biEvent_Selection);

            this.onViewChange();
        };

        SPInsightsController.prototype.changeTimeFrame = function (timeFrame) {
            if (!this.settingsService.isCanvasApp) {
                this.biEvent_Selection.eventId = 3 /* SELECTION_TIMEFRAME */;
                this.biEvent_Selection.eventData = { timeFrame: timeFrame };
                this.biService.sendEvent(this.biEvent_Selection);

                this.insightsData.currentTimeFrame = timeFrame;
                this.onNameSpaceChange();
            }
        };

        SPInsightsController.prototype.onParameterChange = function () {
            if (this.insightsData.currentParameter) {
                this.view.rpcInProcess = true;
                this.insightsModel.retrieveSegments(this.insightsData.currentNamespace.organization.organizationId, this.insightsData.currentNamespace.flowType, this.insightsData.currentParameter.id);
            } else {
                this.onViewChange();
            }
        };

        SPInsightsController.prototype.onViewChange = function () {
            var _this = this;
            this.prepareSegmentsSetForView();

            if (!this.plottingRenderer) {
                this.plottingRenderer = new insights.SPInsightsFlot();

                var onBarHoverEventListener = new SPEventListener(function (event) {
                    return _this.onBarHoverEvent(event);
                });

                this.plottingRenderer.addEventListener("onBarHover", onBarHoverEventListener, false);
            }

            if (this.insightsData.insights && this.segmentsView[this.view.insightsViewBy.name].length > 0) {
                if (this.$scope["$root"].$$phase != '$apply' && this.$scope["$root"].$$phase != '$digest') {
                    this.$scope.$apply();
                }
                this.plottingRenderer.doPlot(this.insightsData.currentSegmentsSet, this.view);
            }
            if (this.$scope["$root"].$$phase != '$apply' && this.$scope["$root"].$$phase != '$digest') {
                this.$scope.$apply();
            }
        };

        SPInsightsController.prototype.startParameterEdit = function (id) {
            var input = document.getElementById(id);
            input.style.display = "block";
            input.focus();
        };
        SPInsightsController.prototype.endParameterEdit = function (id) {
            document.getElementById(id).style.display = "none";
            this.view.rpcInProcess = true;
            this.insightsModel.renameParameter(this.insightsData.currentNamespace.organization.organizationId, this.insightsData.currentNamespace.flowType, this.insightsData.currentParameter.name, this.insightsData.currentParameter.displayName);
        };
        SPInsightsController.$inject = ["$scope", "insightsModel", "settingsService", "translationsService", "BIService"];
        return SPInsightsController;
    })(SPBase);
    _insights.SPInsightsController = SPInsightsController;
})(insights || (insights = {}));

(function (insights) {
    "use strict";

    var SPInsightsFlot = (function (_super) {
        __extends(SPInsightsFlot, _super);
        function SPInsightsFlot() {
            _super.call(this);

            this.flotInsights = jQuery("#flotInsights");
            this.prepareColors();
        }
        SPInsightsFlot.prototype.prepareColors = function () {
            this.insightsColors = {
                BAD: {
                    border: "rgba(223, 128, 133, 0.4)",
                    fill: "rgba(255, 0, 0, 0.5)"
                },
                BORING: {
                    border: "rgba(223, 194, 128, 0.4)",
                    fill: "rgba(0, 255, 255, 0.5)"
                },
                GOOD: {
                    border: "rgba(147, 223, 128, 0.4)",
                    fill: "rgba(0, 255, 0, 0.5)"
                },
                AVERAGE: {
                    border: "rgba(16, 42, 235, 0.5)",
                    fill: "rgba(16, 42, 235, 0.1)"
                }
            };
        };

        SPInsightsFlot.prototype.getBarWidth = function (numOfBars) {
            var barWidth = 0;
            var offsetWidth = this.flotInsights[0].parentElement.parentElement.offsetWidth;
            var factor = offsetWidth / 100;
            var constant = 0.8;

            if (numOfBars > factor) {
                this.flotInsights.css("width", (numOfBars * 100) + "px");
            } else {
                this.flotInsights.css("width", "0px");
                this.flotInsights.css("width", "inherit");
            }

            barWidth = (numOfBars / factor) * constant;

            return barWidth > constant ? constant : barWidth;
        };

        SPInsightsFlot.prototype.onBarHover = function (event, pos, item) {
            var tooltip = jQuery("#graph_tooltip");

            if (item && item.series.bars.show) {
                var tsEvent = new SPEvent();

                tsEvent.initEvent("onBarHover", true, false);
                tsEvent.detail = item;
                this.dispatchEvent(tsEvent);

                tooltip.addClass("displayTheTooltip");
            } else {
                if (spSettings.isCanvasApp) {
                    tooltip.removeClass("displayTheTooltip");
                }
            }
        };

        SPInsightsFlot.prototype.getDivisionByViewType = function (segment) {
            var value;

            if (segment.type === 2 /* BUSINESS_RATIO */) {
                value = segment.recallWon;
            } else {
                value = segment.numberOfLeads;
            }
            return value;
        };

        SPInsightsFlot.prototype.doPlot = function (segmentsDataByViewType, dataOptions) {
            var _this = this;
            var percentagesAverage;

            this.flotInsights.css("width", "1px");
            this.flotInsights.off("plothover");
            jQuery("#graph_tooltip").removeClass("displayTheTooltip");

            var theData = [];
            var ticks = [];

            percentagesAverage = segmentsDataByViewType[0].average;

            for (var index = 0; index < segmentsDataByViewType.length; index++) {
                ticks.push([index, segmentsDataByViewType[index].value]);

                theData.push({
                    data: [
                        [index, segmentsDataByViewType[index].percentage]
                    ],
                    bars: {
                        show: true,
                        barWidth: this.getBarWidth(segmentsDataByViewType.length),
                        align: "center",
                        fillColor: this.insightsColors[segmentsDataByViewType[index].levelOfInterest].fill
                    },
                    color: segmentsDataByViewType[index].favorite ? "yellow" : this.insightsColors[segmentsDataByViewType[index].levelOfInterest].border,
                    valueLabels: {
                        show: true,
                        align: 'center',
                        showAsHtml: false,
                        labelFormatter: (function (value) {
                            var theLabel = value;
                            return function (value) {
                                return theLabel;
                            };
                        })(dataOptions.insightsViewType !== insights.INSIGHTS_VIEW_TYPE.NOMINAL ? Utils.formatValue(segmentsDataByViewType[index].percentage, 1) + '%' : segmentsDataByViewType[index].numberOfWon + "/" + this.getDivisionByViewType(segmentsDataByViewType[index]))
                    }
                });
            }
            if (dataOptions.insightsViewBy.index !== 2 /* BUSINESS_RATIO */) {
                theData.unshift({
                    data: [
                        [-0.5, percentagesAverage],
                        [segmentsDataByViewType.length - 1 + 0.5, percentagesAverage]
                    ],
                    lines: {
                        show: true,
                        fill: false,
                        fillColor: this.insightsColors.AVERAGE.fill
                    },
                    color: this.insightsColors.AVERAGE.border
                });
            } else {
                theData.unshift({
                    data: [
                        [-0.5, percentagesAverage],
                        [segmentsDataByViewType.length - 1 + 0.5, percentagesAverage]
                    ],
                    lines: {
                        show: false
                    }
                });
            }

            if (segmentsDataByViewType.length > 0) {
                this.plot = jQuery.plot(this.flotInsights, theData, {
                    xaxis: {
                        tickLength: 0,
                        tickSize: 1,
                        ticks: ticks,
                        labelWidth: 80
                    },
                    grid: {
                        show: true,
                        aboveData: false,
                        color: "#B9B9B9",
                        backgroundColor: "#ffffff",
                        margin: 0,
                        labelMargin: 0,
                        axisMargin: 0,
                        borderWidth: {
                            top: 0,
                            right: 0,
                            bottom: 1,
                            left: 1
                        },
                        borderColor: "#B9B9B9",
                        clickable: true,
                        hoverable: true,
                        autoHighlight: false,
                        mouseActiveRadius: 20
                    },
                    series: {}
                });

                this.flotInsights.on("plothover", function (event, pos, item) {
                    return _this.onBarHover(event, pos, item);
                });
            }
        };
        return SPInsightsFlot;
    })(SPBase);
    insights.SPInsightsFlot = SPInsightsFlot;
})(insights || (insights = {}));

(function (insights) {
    "use strict";

    var SPStartInsights = (function () {
        function SPStartInsights() {
        }
        SPStartInsights.prototype.initInsights = function () {
            var _this = this;
            this.insightsApp = angular.module('insightsApp', ['localytics.directives', 'salespredict.directives']);

            this.insightsApp.controller("SPSettings", SPSettings);

            this.insightsApp.service("BIService", SPBIEvents);

            this.insightsApp.service("settingsService", SPSettings);

            this.insightsApp.service("rpcProvider", SPRpcRequestProvider);

            this.insightsApp.service("insightsModel", insights.SPInsightsModel);

            this.insightsApp.controller("insightsController", insights.SPInsightsController);

            this.insightsApp.service("translationsService", SPTranslation);

            this.insightsApp.controller("translationsController", SPTranslation);

            window.addEventListener("resize", function () {
                return _this.resizeWindow();
            });
        };

        SPStartInsights.prototype.resizeWindow = function () {
            function getHeight(element) {
                var bodyBottom = document.getElementsByTagName("body")[0].offsetHeight;

                var listTop = 0;

                listTop += element.offsetTop;

                while (element.parentElement) {
                    element = element.parentElement;
                    listTop += element.offsetTop;
                }
                return bodyBottom - listTop - 100;
            }

            var paramList = document.getElementsByClassName("parametersSelectionsHolder")[0];
            var theGraph = document.getElementById("flotInsights");

            paramList ? paramList.style.height = getHeight(paramList) + "px" : null;
            theGraph ? theGraph.style.height = getHeight(theGraph) + "px" : null;
        };
        return SPStartInsights;
    })();
    insights.SPStartInsights = SPStartInsights;
})(insights || (insights = {}));
var Utils;
(function (Util) {

    function formatValue(value, decimal) {
        var nVal = String(value);
        var nDec = decimal;
        var rVal;
        var arr;

        if (nDec === 0) {
            rVal = nVal.split('.')[0];
        } else {
            if (nVal.indexOf('.') === -1) {
                nVal += '.';
            }
            nVal += '0000000000';
            arr = nVal.split('.');
            rVal = arr[0] + '.' + arr[1].substr(0, nDec);
        }
        return rVal;
    }
    Util.formatValue = formatValue;
})(Utils || (Utils = {}));

var SPTranslation = (function () {
    function SPTranslation() {
        this.insights_disabled = language_text_en.insights_disabled;
        this.button_createSnapshot = language_text_en.button_createSnapshot;
        this.message_snapshot_created = language_text_en.message_snapshot_created;
        this.header_globalTitle = language_text_en.header_globalTitle;
        this.paramList_Recommended = language_text_en.paramList_Recommended;
        this.paramList_AllParameters = language_text_en.paramList_AllParameters;
        this.paramList_noParameters = language_text_en.paramList_noParameters;
        this.selections_month = language_text_en.selections_month;
        this.selections_quarter = language_text_en.selections_quarter;
        this.selections_halfYear = language_text_en.selections_halfYear;
        this.selections_last = language_text_en.selections_last;
        this.selections_interesting = language_text_en.selections_interesting;
        this.selections_allSegments = language_text_en.selections_allSegments;
        this.selection_percentSign = language_text_en.selection_percentSign;
        this.selection_numberSign = language_text_en.selection_numberSign;
        this.selection_ConversionRate = language_text_en.selection_ConversionRate;
        this.selection_SuccessRate = language_text_en.selection_SuccessRate;
        this.selection_BusinessRatio = language_text_en.selection_BusinessRatio;
        this.selection_current = language_text_en.selection_current;
        this.selection_snapshot = language_text_en.selection_snapshot;
        this.graph_noData = language_text_en.graph_noData;
        this.tooltip_means = language_text_en.tooltip_means;
        this.tooltip_converted = language_text_en.tooltip_converted;
        this.tooltip_ConversionRate = language_text_en.tooltip_ConversionRate;
        this.tooltip_SuccessRate = language_text_en.tooltip_SuccessRate;
        this.tooltip_BusinessRatio = language_text_en.tooltip_BusinessRatio;
        this.tooltip_add_remove = language_text_en.tooltip_add_remove;
        this.graph_tooltip_conversion = language_text_en.graph_tooltip_conversion;
        this.graph_tooltip_GOOD = language_text_en.graph_tooltip_GOOD;
        this.graph_tooltip_BORING = language_text_en.graph_tooltip_BORING;
        this.graph_tooltip_BAD = language_text_en.graph_tooltip_BAD;
        this.graph_tooltip_thanAverage = language_text_en.graph_tooltip_thanAverage;
        this.graph_tooltip_includes = language_text_en.graph_tooltip_includes;
        this.graph_tooltip_outOf = language_text_en.graph_tooltip_outOf;
        this.graph_tooltip_during = language_text_en.graph_tooltip_during;
        this.graph_tooltip_outThose = language_text_en.graph_tooltip_outThose;
        this.graph_tooltip_created = language_text_en.graph_tooltip_created;
        this.graph_tooltip_and = language_text_en.graph_tooltip_and;
        this.graph_tooltip_wereLost = language_text_en.graph_tooltip_wereLost;
        this.graph_tooltip_converted = language_text_en.graph_tooltip_converted;
        this.graph_tooltip_totalWon = language_text_en.graph_tooltip_totalWon;
        this.graph_tooltip_open = language_text_en.graph_tooltip_open;
        this.graph_tooltip_lost = language_text_en.graph_tooltip_lost;
        this.error_connectionError = language_text_en.error_connectionError;
        this.error_updateDataError = language_text_en.error_updateDataError;
    }
    return SPTranslation;
})();
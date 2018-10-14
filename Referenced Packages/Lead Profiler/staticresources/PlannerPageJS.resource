var counter = 0;
var $charts = [];
var s1;
var s2;
var ticks;
var i;

function rebindTableSorter() {
    "use strict";
    //debugger;

    $('table.tablesorter').each(function (i, e) {
        var mySortList = [
            [, ]
        ];
        var sortDir = (score > 50) ? 1 : 0;
        var myHeaders = {}
        var hasDisableHeaders = false;
        $(this).find('th.nosort').each(function (i, e) {
            myHeaders[$(this).index()] = {
                sorter: false
            };
            hasDisableHeaders = true;
        });
        $(this).find('th.initsort').each(function (i, e) {
            mySortList[i] = [$(this).index(), sortDir];
        });
        //debugger;
        if (hasDisableHeaders)
            $(this).tablesorter({
                widthFixed: true,
                widgets: ['zebra'],
                headers: myHeaders,
                sortList: mySortList
            });
        else
            $(this).tablesorter({
                widthFixed: true,
                widgets: ['zebra'],
                sortList: mySortList
            });
    });

    /*  if (score > 50) {
		$('.tablesorter').tablesorter({widthFixed: true, widgets: ['zebra'], sortList: [[2, 1]]});
	} else {
		$('.tablesorter').tablesorter({widthFixed: true, widgets: ['zebra'], sortList: [[2, 0]]});
	}
	*/

}

function ImgError(source, errorimg) {
    var img = $(source); // Get my img elem
    $("<img/>") // Make in memory copy of image to avoid css issues
    .attr("src", $(img).attr("src"))
        .load(function () {
            var pic_real_width = this.width; // Note: $(this).width() will not work for in memory images.
            if (pic_real_width == 0) {
                img.src = errorimg;
                img.onerror = "";
                return true;
            }
        });
}

function addOddEvenClass(classname) {
    "use strict";
    $('.' + classname).each(function (index, value) {
        var element = $(value);
        element.removeClass('odd');
        if (index % 2 === 0) {
            element.addClass('odd');
        }
        /*else {
			element.addClass('even');
		}*/
    });
}

function deselectAllRows() {
    "use strict";
    $('tr.selected').removeClass('selected');
}
$(document).ready(function () {
    //debugger;
    "use strict";
    $('#waitingPage').show();
    loadData();
});

function initPage() {
    "use strict";
    debugger;
    $('.header div').css('margin-right', '12px');
    //$('.tablesorter').append('<tfoot style="height:10px;"><tfoot style="height:10px;"><tr><td onclick="toggleRows(this)" colspan="5" style="height:10px;cursor: pointer;">Show More</td></tr></tfoot>');
    rebindTableSorter();
    $('.dataRow').each(function (index, value) {
        var element = $(value);
        var ele = element.children('.dataParent').children('div').html();
        if (ele !== null) {
            $(this).addClass('pointer');
        } else {
            $(this).attr('title', 'No data');
        }
        /*
		ele = element.children('.primary');
		if (ele.length === 0) {
			$(this).addClass('hidden');
			$(this).hide();
		} else {
			$(this).addClass('shown');
		}*/
    });
    $('#waitingPage').hide();
    $('#gridWrapper').slideDown('slow');
    $('div.labels a')[0].click();

}

function hideCharts() {
    "use strict";
    for (i = 0; i < $charts.length; i++) {
        $charts[i].slideUp('slow');
    }
    deselectAllRows();
}

function hideChartsTest() {
    "use strict";
    for (i = 0; i < $charts.length; i++) {
        $charts[i].slideUp('slow');
    }
    deselectAllRows();
}

function hideChartsDialog() {
    "use strict";
    for (i = 0; i < $charts.length; i++) {
        $charts[i].hide();
    }
    deselectAllRows();
}

function hideAllCategories() {
    var dataRows = $('tbody tr.dataRow');
    selectedInHidden = false;
    for (i = 0; i < dataRows.length; i++) {
        $(dataRows[i]).hide().removeClass('shown');
        if ($(dataRows[i]).hasClass('selected')) {
            selectedInHidden = true;
        }
    }
    if (selectedInHidden) {
        deselectAllRows();
        hideCharts();
    }
    $('div.labels .active').removeClass('active');
}

var selectedInHidden;

function showCategory(category) {

    hideAllCategories();

    var dataRows = $('tbody tr td.' + category);

    for (i = 0; i < dataRows.length; i++) {
        $(dataRows[i]).parent().show().addClass('shown');
    }
    addOddEvenClass('shown');
    $('div.labels .' + category).addClass('active');
    if (dataRows.length > 0) {
        $(dataRows[0]).parent().click();
    }

}

function toggleRows(footTd) {
    "use strict";
    if (footTd.innerHTML === 'Show More') {
        footTd.innerHTML = 'Hide Rows';
        addOddEvenClass('dataRow');
        var hidden = $('.hidden');
        for (i = 0; i < hidden.length; i++) {
            $(hidden[i]).slideDown('slow');
        }
    } else {
        footTd.innerHTML = 'Show More';
        var hidden = $('.hidden');
        var selectedInHidden = false;
        addOddEvenClass('shown');
        for (i = 0; i < hidden.length; i++) {
            $(hidden[i]).hide();
            if ($(hidden[i]).hasClass('selected')) {
                selectedInHidden = true;
            }
        }
        if (selectedInHidden) {
            deselectAllRows();
            hideCharts();
        }
    }
}

function convertToFloat(arr) {
    "use strict";
    for (i = 0; i < arr.length; i++) {
        arr[i] = parseFloat(arr[i]);
    }
    return arr;
}

var cntr = 0;
var seriesCount = 2;
$.jqplot.ColorGenerator = function (P) {
    "use strict";
    if (!this.idx) {
        this.idx = -1; // keep track of our idx
    }
    this.next = function (index) {
        //debugger;
        this.idx++;
        if (currentChart === undefined || currentChart.seriesCount > 1) {
            //		this.idx++; // get the next color
            if (this.idx === 0 && cntr === 0) {
                return 'rgba(216, 159, 60, 1)';
            } else if (this.idx === 0 && cntr !== 0) {
                return 'rgba(60, 159, 216, 1)';
            } else if (cntr === 0) {
                return 'rgba(216, 159, 60, 0.65)';
            } else {
                return 'rgba(60, 159, 216, 0.65)';
            }
        } else if (this.idx === 0) {
            return 'rgba(60, 159, 216, 1)';
        } else {
            return 'rgba(60, 159, 216, 0.65)';
        }
    }
    this.get = function (index) {
        //debugger;
        if (currentChart === undefined || currentChart.seriesCount > 1) {
            if (cntr++ === 0);
            else cntr = 0;
            this.idx++; // get the next color
            if (this.idx === 0) {
                return 'rgba(60, 159, 216, 1)';
            } else {
                return 'rgba(216, 159, 60, 1)';
            }
        } else {
            if (cntr++ === 0);
            else cntr = 0;
            return 'rgba(216, 159, 60, 1)';
            return 'rgba(60, 159, 216, 1)';
        }
    }
    this.setColors = function (colors) {
        //debugger;
        if (cntr++ == 0);
        else cntr = 0;
    }
    this.reset = function () {
        //debugger;
        this.idx = 0;
    };
    this.getIndex = function () {
        return this.idx;
    };
    this.setIndex = function (index) {
        this.idx = index;
    };
}

var grid = {
    gridLineWidth: 1.5,
    gridLineColor: 'rgb(235,235,235)',
    drawGridlines: true
};

var plot;
String.prototype.width = function (font) {
    var f = font || '12px arial',
        o = $('<div>' + this + '</div>')
            .css({
                'position': 'absolute',
                'float': 'left',
                'white-space': 'nowrap',
                'visibility': 'hidden',
                'font': f
            })
            .appendTo($('body')),
        w = o.width();

    o.remove();

    return w;
}

function showGraph(element) {
    if (element.hasClass('selected')) {
        hideCharts();
        return;
    }
    var thisCounter = element.children('.dataParent').children('div').children('.chart').html();
    if (thisCounter != null) {
        hideCharts();
        element.addClass('selected');
        $('#mycharts' + thisCounter).slideDown('slow');
        return;
    } else {
        var el = element.children('.dataCell');
        var title = '';
        if (el.length > 0) {
            title = el[0].innerHTML;
        }
        el = element.children('.dataParent').children('div').children('.s1').html();
        if (el == null) {
            hideCharts();
            return;
        }
        var s1 = convertToFloat(el.split(';'));
        el = element.children('.dataParent').children('div').children('.s2').html();
        if (el == null)
            return;
        var s2 = convertToFloat(el.split(';'));
        //el = element.children('.dataParent').children('div').children('.ticks').html();
        el = element.children('.dataParent').children('div').children('.ticks').text();
        if (el == null)
            return;

        var totalSize = el.width('10pt Hershey');
        var ticks = el.split(';');
        var angle = 0;

        var max = 0;
        var str = '';
        for (i = 0; i < ticks.length; i++) {
            if (ticks[i].length > max) {
                max = ticks[i].length;
                str = ticks[i];
            }
        }
        var maxWordSize = str.width('10pt Hershey');
        var wid = $(window).width();
        wid = wid / 2 * 0.77;
        if (totalSize >= wid || maxWordSize >= (wid / ticks.length)) angle = 30;
        //	s1 = element.children('.dataParent').children('div').children('.s1').html().split(',');
        //	s2 = element.children('.dataParent').children('div').children('.s2').html().split(',');
        // 	ticks = element.children('.dataParent').children('div').children('.ticks').html().split(',');

        element.children('.dataParent').children('div').append('<span class="chart">' + counter + '</span>')
        $('#chart').append('<div class="charts" id="mycharts' + counter + '" style="width:50%;height:420px;position:fixed;" ></div>');
        var myid = 'mycharts' + counter;

        plot = $.jqplot(myid, [s1, s2], {
            // The "seriesDefaults" option is an options object that will
            // be applied to all series in the chart.
            seriesDefaults: {
                //renderer:$.jqplot.BarRenderer, 
                shadow: false,
                useNegativeColors: false,
                rendererOptions: {
                    fillToZero: true,
                    showDataLabels: true,
                    varyBarColor: true
                }
            },
            series: [{
                renderer: $.jqplot.BarRenderer,
                label: 'Win/Lose Ratio',
                pointLabels: {
                    show: true,
                    fontSize: '10pt'
                },
                rendererOptions: {
                    fillToZero: true,
                    showDataLabels: true,
                    varyBarColor: true,
                    barPadding: 2,
                    barMargin: 10
                }
            }, {
                renderer: $.jqplot.BarRenderer,
                xaxis: 'xaxis',
                yaxis: 'yaxis',
                label: '% of Business',
                pointLabels: {
                    show: true,
                    fontSize: '10pt',
                    formatString: 'i%d%j'
                },
                rendererOptions: {
                    fillToZero: true,
                    showDataLabels: true,
                    varyBarColor: true,
                    barPadding: 2,
                    barMargin: 10
                }
            }],
            // Show the legend and put it outside the grid, but inside the
            // plot container, shrinking the grid to accomodate the legend.
            // A value of "outside" would not shrink the grid and allow
            // the legend to overflow the container.
            title: showTitle ? title + ' %' : '',
            legend: {
                show: true,
                placement: 'outside',
                location: 'ne',
                showSwatches: true
            },
            axesDefaults: {
                tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                tickOptions: {
                    angle: angle,
                    tickPadding: 1.2,
                    fontSize: '10pt'
                }
            },
            axes: {
                xaxis: {
                    renderer: $.jqplot.CategoryAxisRenderer,
                    ticks: ticks
                },
                yaxis: {
                    autoscale: true,
                    pad: 1.2,
                    //ticks: [[0,'1'],[1,'2']],
                    tickOptions: {
                        formatString: '%d%',
                        angle: 0,
                        fontSize: '10pt'
                    },
                    rendererOptions: {
                        forceTickAt0: true
                    }
                }
            },
            grid: grid,
            canvasOverlay: {
                show: true,
                objects: [{
                    horizontalLine: {
                        name: '0 mark',
                        y: 0,
                        lineWidth: 1,
                        color: 'rgb(0, 0, 0)',
                        shadow: false
                    }
                }]
            }
        });
    }
    hideCharts();
    element.addClass('selected');
    var ele = $('#mycharts' + counter);
    ele.hide();
    ele.slideDown('slow');
    $charts.push(ele);
    counter++;
}
var charts = {};
var wid = 0;
var tableWidth = '';
var tableHeight = '420px';
var position = 'fixed';
var showTitle = true;

function showGraph3(element) {
    tableWidth = '50%';
    tableHeight = '320px';
    showGraph(element.parent().parent());
}

function showGraphInDialog(element, attributeTitle) {
    debugger;
    tableWidth = '100%';
    tableHeight = '400px';
    position = 'relative';
    showTitle = false;
    initGraphDialog(attributeTitle);
    showGraph(element.parent().parent().parent());

}

function showGraph2(element) {
    tableWidth = '50%';
    showGraph(element);
}

function showGraphTest(element) {
    tableWidth = '40%';
    showGraph(element);
}

function showGraph(element) {
    //seriesCount = 1;
    if (element.hasClass('selected')) {
        hideChartsTest();
        return;
    }
    var thisCounter = element.children('.dataParent').children('div').children('.chart').html();
    if (thisCounter != null) {
        hideChartsTest();
        element.addClass('selected');
        $('#mycharts' + thisCounter).slideDown('slow');
        return;
    } else {
        var el = element.children('.dataCell');
        var title = '';
        if (showTitle && el.length > 0) {
            title = el[0].innerHTML;
        }
        el = element.children('.dataParent').children('div').children('.s1').html();
        if (el == null) {
            hideChartsTest();
            return;
        }
        var s1 = convertToFloat(el.split(';'));
        el = element.children('.dataParent').children('div').children('.s2').html();
        if (el == null)
            return;
        var s2 = convertToFloat(el.split(';'));
        //el = element.children('.dataParent').children('div').children('.ticks').html();
        el = element.children('.dataParent').children('div').children('.ticks').text();
        if (el == null)
            return;

        var totalSize = el.width('10pt Hershey');
        var ticks = el.split(';');
        var angle = 0;

        var max = 0;
        var str = '';
        for (i = 0; i < ticks.length; i++) {
            if (ticks[i].length > max) {
                max = ticks[i].length;
                str = ticks[i];
            }
        }
        var maxWordSize = str.width('10pt Hershey');
        debugger;
        if (wid === 0) {
            wid = $(window).width();

            wid = wid / 2 * 0.73;
        }
        if (totalSize > wid || maxWordSize > (wid / ticks.length)) angle = 30;
        //	s1 = element.children('.dataParent').children('div').children('.s1').html().split(',');
        //	s2 = element.children('.dataParent').children('div').children('.s2').html().split(',');
        // 	ticks = element.children('.dataParent').children('div').children('.ticks').html().split(',');

        element.children('.dataParent').children('div').append('<span class="chart">' + counter + '</span>')
        $('#chart').append('<div class="charts" id="mycharts' + counter + '" style="width:' + tableWidth + ';height:' + tableHeight + ';position:' + position + ';" ></div>');

        var myid = 'mycharts' + counter;


        charts[myid] = {};
        currentChart = charts[myid];
        charts[myid].seriesCount = 1;
        charts[myid].s1 = s1;
        charts[myid].s2 = s2;
        charts[myid].ticks = ticks;
        charts[myid].title = title;
        charts[myid].angle = angle;
        charts[myid].plot = initPlot(myid, false);

        debugger;
        var ele = $('#mycharts' + counter);
        wid = ele.find('.jqplot-series-shadowCanvas').width();
        ele.find('.jqplot-title').width(ele.find('.jqplot-series-shadowCanvas').width()).css('margin-left', '37px');
        $(ele.find('table td.jqplot-table-legend-label')[0]).html('<a style="position:relative;" href="#" onclick=\"showHidePlot(\'' + myid + '\');return false;\">Show % of Business</a>');
        //$($('\'#' + myid + ' table td.jqplot-table-legend-label')[0]).html('<a style="position:relative;" href="#" onclick=\"showHidePlot(\'' + myid  +'\');return false;\">Show % of Business</a>')
        //eval('charts.'+myid+'=\''+plot+'\'');
        hideChartsTest();
        element.addClass('selected');

        //var ele = $('#chartwrapper' + counter);
        //ele.parent().append('<a style="position:relative;" href="#" onclick=\"showHidePlot(\'' + myid  +'\');return false;\">Show % of Business</a>');
        //ele = $('#mycharts' + counter);
        ele.hide();
        ele.slideDown('slow');
        $charts.push(ele);
        counter++;
    }



}
Array.prototype.absMax = function () {
    var r = [];
    for (i = 0; i < this.length; i++) {
        r[i] = Math.abs(this[i]);
    }
    return Math.max.apply(Math, r);
};

Array.prototype.absMin = function () {
    var r = Math.abs.apply(Math, this);
    return Math.min.apply(Math, r);
};

Number.prototype.roundTo = function (to) {
    return Math.round(this * to) / to;
}

function initPlot(plotid, showSecondSeries) {

    cntr = 0;
    debugger;
    var data, series, ticks, title, angle, max;
    if (showSecondSeries) {
        data = [charts[plotid].s1, charts[plotid].s2];
        series = [{
            renderer: $.jqplot.BarRenderer,
            label: '',
            rendererOptions: {
                fillToZero: true,
                showDataLabels: true,
                varyBarColor: true,
                barPadding: 2,
                barMargin: 10
            }
        }, {
            renderer: $.jqplot.BarRenderer,
            xaxis: 'xaxis',
            show: true,
            yaxis: 'yaxis',
            label: 'Hide % of Business',
            rendererOptions: {
                fillToZero: true,
                showDataLabels: true,
                varyBarColor: true,
                barPadding: 2,
                barMargin: 10
            },
            pointLabels: {
                show: true,
                fontSize: '10pt',
                formatString: '%d%'
            }
        }];
    } else {
        data = [charts[plotid].s1];
        series = [{
            renderer: $.jqplot.BarRenderer,
            label: '',
            rendererOptions: {
                fillToZero: true,
                showDataLabels: true,
                varyBarColor: true,
                barPadding: 2,
                barMargin: 10,
            }
        }];
    }
    ticks = charts[plotid].ticks;
    title = charts[plotid].title;
    angle = charts[plotid].angle;
    max = charts[plotid].s1.absMax();
    if (showSecondSeries) {
        var max2 = charts[plotid].s2.absMax();
        max = Math.max(max, max2);
    }
    max = (max * 1.25).roundTo(5);
    var p = $.jqplot(plotid, data, {
        // The "seriesDefaults" option is an options object that will
        // be applied to all series in the chart.
        seriesDefaults: {
            //renderer:$.jqplot.BarRenderer, 
            shadow: false,
            useNegativeColors: false,
            rendererOptions: {
                fillToZero: true,
                showDataLabels: true,
                varyBarColor: true
            },
            pointLabels: {
                show: true,
                fontSize: '10pt',
                formatString: '%+d%'
            }

        },
        highlighter: {
            show: false
        },
        series: series,
        // Show the legend and put it outside the grid, but inside the
        // plot container, shrinking the grid to accomodate the legend.
        // A value of "outside" would not shrink the grid and allow
        // the legend to overflow the container.
        title: showTitle ? title + ' %' : '',
        legend: {
            show: true,
            placement: 'outsideGrid',
            location: 'ne',
            showSwatches: true,
            labels: ['Show % of Business']
        },
        axesDefaults: {
            tickRenderer: $.jqplot.CanvasAxisTickRenderer,
            tickOptions: {
                angle: angle,
                tickPadding: 1.2,
                fontSize: '10pt'
            }
        },
        axes: {
            xaxis: {
                renderer: $.jqplot.CategoryAxisRenderer,
                ticks: ticks
            },
            yaxis: {
                //autoscale: true,
                padMin: 1.3,
                padMax: 1.3,
                pad: 1.3,
                max: max,
                min: -max,
                tickOptions: {
                    formatString: '%d%',
                    angle: 0,
                    fontSize: '10pt',
                    formatter: function (format, value) {
                        return (value == "0") ? "Avg" : $.jqplot.sprintf(format, value);
                    }
                },
                rendererOptions: {
                    forceTickAt0: true
                }
            }
        },
        grid: grid,
        canvasOverlay: {
            show: true,
            objects: [{
                horizontalLine: {
                    name: '0 mark',
                    y: 0,
                    lineWidth: 1,
                    color: 'rgb(0, 0, 0)',
                    shadow: false
                }
            }]
        }
    });

    return p;
}



var currentChart;

function showHidePlot(id) {
    debugger;
    currentChart = charts[id];
    cntr = 0;
    var ele = $('#' + id);
    if (charts[id].plot !== undefined) {
        charts[id].plot.destroy();
    }
    if (charts[id].seriesCount == 1) {
        charts[id].seriesCount = 2;
        charts[id].plot = initPlot(id, true);
        $(ele.find('table tr.jqplot-table-legend')[0]).hide();
        $(ele.find('table td.jqplot-table-legend-label')[1]).html('<a style="position:relative;" href="#" onclick=\"showHidePlot(\'' + id + '\');return false;\">Hide % of Business</a>')

    } else {
        charts[id].seriesCount = 1;
        charts[id].plot = initPlot(id, false);
        $(ele.find('table td.jqplot-table-legend-label')[0]).html('<a style="position:relative;" href="#" onclick=\"showHidePlot(\'' + id + '\');return false;\">Show % of Business</a>')

    }
    //wid = ele.find('.jqplot-series-shadowCanvas').width();
    ele.find('.jqplot-title').width(ele.find('.jqplot-series-shadowCanvas').width()).css('margin-left', '37px');


    //charts[id].plot.colorGenerator.reset();
    //charts[id].redraw(); 
    //charts[id].plot.replot({ clear: true, resetAxes: true }) ; 
}
        //compatibility support for jquery
        (function($) {
            if (!$.browser) {
                $.extend({
                    browser: function() {
                        var a = {};
                        try {
                            navigator.vendor ?
                                /Chrome/.test(navigator.userAgent) ?
                                (a.browser = "Chrome", a.version = parseFloat(navigator.userAgent.split("Chrome/")[1].split("Safari")[0])) : /Safari/.test(navigator.userAgent) ? (a.browser = "Safari", a.version = parseFloat(navigator.userAgent.split("Version/")[1].split("Safari")[0])) : /Opera/.test(navigator.userAgent) && (a.Opera = "Safari", a.version = parseFloat(navigator.userAgent.split("Version/")[1])) : /Firefox/.test(navigator.userAgent) ? (a.browser = "Firefox",
                                    a.version = parseFloat(navigator.userAgent.split("Firefox/")[1])) : (a.browser = "MSIE", /MSIE/.test(navigator.userAgent) ? a.version = parseFloat(navigator.userAgent.split("MSIE")[1]) : a.version = "edge")
                        } catch (e) { a = e; }
                        return a;
                    }
                });
            }
        })(jQuery);   

        function changeToInsightsDemoSelector (evt, isInsightsDemoMode) {
    
            if (isInsightsDemoMode && (evt.srcElement.innerText === "Success Insights")) {
                changeToInsightsDemo();
            }
            if (evt.srcElement.innerText != "" && evt.srcElement && evt.srcElement.innerText.indexOf("Profile") > 0 && evt.srcElement.innerText.indexOf("Success Insights") === -1) {
            	// location.reload(true);
                // changeToLeadsProfile();
                jQuery("[id$='mainPanel']").css('opacity', "0");
                setTimeout(function() {
                	jQuery("[id$='mainPanel']").css('opacity', "1");
                }, 500);
                jQuery("[id$='ObjectList_refresh']:visible").click();
            }
        }

        function listReady(root) {
            return root.find('.x-grid3-row').length;

        } 
        
        function waitForListReady(callback1, callback2) {
           
            if (listReady(jQuery('.listViewportWrapper'))) {
            	// ie page load, takes a little bit more time so wait half a second more
            	if (jQuery.browser.msie) {
             		setTimeout(function(){callback1()}, 500);
             		setTimeout(function(){callback2()}, 500);
         		}
            	else {
	                callback1();
	                callback2();
                }
           	}
           	else
            	setTimeout(function(){waitForListReady(callback1, callback2)}, 500);
        }
        
        var tooltipTemplateHtml;

      
        // because of a SalesForce bug in the view dropdown
        // (create/edit view sometimes don't add "leadsprofiler" namespace to the retUrl prefix)
        // we hack the create / edit link to the correct url
        function fixCreateEditLink() {
        
        
        	jQuery(".filterLinks").find('a').each(function () {
	 			var href = jQuery(this).attr('href');
	 			var hrefLower = href.toLowerCase();
	 			
	 			var link_good = "leadsprofiler__vf001_profiler";
	 			var link_bad = "vf001_profiler";

				var linkStartIndex_good = hrefLower.indexOf(link_good);
				var linkStartIndex_bad = hrefLower.indexOf(link_bad);
				
	        	// if link does not contain "leadsprofiler__VF001_Leads" and do contain "VF001_Leads" - replace
	        	if (linkStartIndex_good == -1 && linkStartIndex_bad != -1) 
					jQuery(this).attr('href', href.replace(/vf001_profiler/i, link_good));
				
        	});
       	}
    
        function addToolTip() {
            // load html div
            tooltipTemplateHtml = jQuery('#tooltipTemplate').html();
            // load qTip - when the enhanced list table is available
            waitForListReady(displayQtip, fixCreateEditLink);
            //createDownloadify();
        }

        function checkExistanceOfFilter() {
                if (jQuery('.x-grid3-sort-icon').get(0) === undefined) {
                    setTimeout(checkExistanceOfFilter, 100);
                    return;
                }
                var flag = false;
                jQuery('.x-grid3-sort-icon').each(function() {
                    if (jQuery(this).is(':visible') && jQuery(this).css('display') === 'inline' && !flag) {
                        text = jQuery(this).parent().text();
                        if (text.indexOf('SalesPredict rank') != -1 || text.indexOf('Date') != -1) {
                            jQuery('.rolodex').hide();
                        }
                    }
                });
            }

        jQuery(document).ready(function() {
            addToolTip();

            jQuery("body").on('mouseenter', 'td', function() {
                addToolTip();
            });

            checkExistanceOfFilter();

            jQuery('body').on('click', "div thead .x-grid3-hd.x-grid3-cell", function() {
                var text = jQuery(this).text();
                if (text === 'SalesPredict rank' || text.indexOf('Date') != -1) {
                    jQuery('.rolodex').hide();
                }
                else {
                    jQuery('.rolodex').show();
                }
            });

        });    






        
/*       
			var isListChanged = false;
			
			// these functions do not work on IE 8
			jQuery('[idjQuery=ObjectList_wrapper]').bind("DOMSubtreeModified", function() {
        	if (!isListChanged) {
 		    	//alert("list changed");
        		isListChanged = true;
            	setTimeout(function(){displayQtip()}, 500);
        	}
        		
		});   
*/     
        // create the dynanic fields data 
        function tooltipTemplate(v) {
        
            // add arrow image if delta is more than 54 or less than -20
            var probDelta = v['ProbDelta'];
            var arrowClass = '';
            if (probDelta >= 54)
                arrowClass = 'up';
            else if (probDelta <= -20)
                arrowClass = 'down';
                
            // create the delta number formatted
            probDelta = v['ProbDelta'] + '%';
            if (probDelta.substring(0, 1) != '-' && probDelta.substring(0, 1) != '+') 
                probDelta = '+' + probDelta;
                
                
            var newHtml =  tooltipTemplateHtml
                .replace(/{{User}}/g, v['User'])
                .replace(/{{Probability Delta}}/g, probDelta)
                .replace(/{{Arrow Class}}/g, arrowClass)
                .replace(/{{Probability Range}}/g, v['ProbRange'])
                .replace(/{{Buyer Persona}}/g, v['Buyer'])
                .replace(/{{Company Profile}}/g, v['Profile'])
                .replace(/{{Vertical}}/g, v['Vertical'])
                .replace(/{{Solution Fit}}/g, v['Fit'])
                .replace(/{{Lead Id}}/g, v['Id']);
                
            // if no data in solution fit - hide all row
            if (v['Fit'] && v['Fit'] != 'N/A')
                newHtml = newHtml.replace(/{{Solution Fit Visibility}}/g, '');
            else
                newHtml = newHtml.replace(/{{Solution Fit Visibility}}/g, 'invisible');
                
            return newHtml;
        };
        
          
        // create the tooltip page
        function displayQtip() {

            // find the image (all the info is in it's alt)
            jQuery('[id*=ObjectList_wrapper]').find('img[alt]').each(function () {
                try {
                    var rank = jQuery(this);
                    var rank2 = jQuery(this);
                    
                    if (rank.data('qtip'))
                        return;

					// get the HTML with all data from json parsed into it
                    var newDiv = jQuery(tooltipTemplate(JSON.parse(rank.attr('alt'))));
                    var newDiv2 = jQuery(tooltipTemplate(JSON.parse(rank.attr('alt'))));
                    // operate the close button - to execute the "hide" qtip command 
                   	newDiv.find('.close').click(function () { rank.qtip("hide"); });
                   	newDiv2.find('.close').click(function () {jQuery(this).closest('.qtip').hide(); });
                    
                    //
                    newDiv.find('.more a').attr('href',rank.parent().attr('href'));
                    newDiv2.find('.more a').attr('href',rank.parent().attr('href'));
                    rank.unwrap();
                    
                    // load the qtip for rank1 (hover) with all properties
                   	rank.qtip({
                        content: newDiv,
                        show: { 
                            effect: true,
                            event: 'mouseenter',
                            effect: function(event) {
                               	jQuery('.qtip').hide();
                                jQuery(this).fadeIn();
                            },
                            solo: true                  // Only show one tooltip at a time
                        }, 
                        hide: {
                           	fixed: true,
                            delay: 300,
                            effect: function() { jQuery(this).fadeOut(); }
                        },
                        position: { 
                            my: 'bottom right', 
                            at: 'center left',
                            adjust: { scroll: true }
                        },
                        style: { 
                            width: 370,                 // Set the tooltip width
                            classes: 'qtip-light qtip-shadow qtip-rounded',
                            tip: { // this is the arrow into the tooltip
                                corner: 'bottom right',
                                mimic: 'bottom right',
                                border: 2,
                                width: 20,
                                height: 20
                            }
                        }
                    })
                    
                    // end qtip        
                      
                    // load the qtip for rank2 (on click) with all properties
                    .removeData('qtip')
                    .qtip({
                        content: newDiv2,
                        show: { 
                            effect: true,
                            event: 'click',
                            //effect: function(event) { jQuery(this).fadeIn(); },
                            solo: true                  // Only show one tooltip at a time
                        }, 
                         position: { 
                            my: 'bottom right', 
                            at: 'center left',
                            adjust: { scroll: true }
                        },
                        style: { 
                            width: 370,                 // Set the tooltip width
                            classes: 'qtip-light qtip-shadow qtip-rounded',
                            tip: { // this is the arrow into the tooltip
                                corner: 'bottom right',
                                mimic: 'bottom right',
                                border: 2,
                                width: 20,
                                height: 20
                            }
                        },
                        hide: {
							event: 'unfocus',
                           	fixed: true,
                            delay: 300,
                            effect: function() { jQuery(this).fadeOut(); }
                        }
                    }); // end qtip
                    
                                        
                } catch (e) {}
            }); 
            
            //isListChanged = false;
        } // displayQtip()
        
   
        var excDocStart = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
                        + '<html xmlns="http://www.w3.org/1999/xhtml">'
                        + '<head>'
                        +   '<title>Lead Profiler</title>'
                        + '</head>'
                        + '<body>';

        var excDocEnd = '</body></html>';

        
        function createDownloadify() {
            Downloadify.create('downloadify',{
                filename: 'LeadsProfiler.xls',
                data: function(){
                    return excelData();
                },
                onComplete: function(){ 
                    downloadifyDialog.dialog('close');
                    alert('Your File Has Been Saved!'); 
                },
                onCancel: function(){ 
                    downloadifyDialog.dialog('close');
                },
                onError: function(){ 
                    downloadifyDialog.dialog('close');
                    alert('An error occured!'); 
                },
                swf: "{!URLFOR($Resource.downloadify,'media/downloadify.swf')}",
                downloadImage: "{!URLFOR($Resource.downloadify,'images/excelExport.png')}",
                width: 30,
                height: 29,
                transparent: true,
                append: false
            });
        }
                        
        function excelData() {
            var ele = jQuery('<div></div>');
            
            var tHtml = jQuery('.x-grid3-viewport').clone();
            tHtml.find('img').remove();
            tHtml.find("tr td:first-child").remove();
            tHtml.find("tr td:first-child").remove();
            tHtml.find("tr td:first-child").remove();
           // debugger;
            ele.append(tHtml.html().replace(/\<\/a\>/g,"<\span>").replace(/\<a/g,"<span"));

            return  excDocStart +'<table>' + jQuery(ele).html() + '</table>' + excDocEnd;
        }
        
        var dialog;
            
        var initDialog = function (a) {
            if (typeof(dialog) !== "undefined") 
                dialog.dialog("destroy").remove();

            dialog = jQuery( "#"+a ).dialog({
                        title: 'Lead Profiler installation is incomplete',
                        height: 200 ,
                        width: 450 ,
                        modal: true,
                        closeOnEscape: false,
                        autoOpen: false,
                        draggable: true,
                        resizable: false,
                        dialogClass: 'no-close'
                    });
                   
         	dialog.dialog("open");
   		}
         
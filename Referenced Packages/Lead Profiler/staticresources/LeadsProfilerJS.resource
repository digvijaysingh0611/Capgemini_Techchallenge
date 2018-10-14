var entityRank = null;

$(document).ready(function() 
    { 
        var rankOverwrite = $('#RankOverwrite');
        var rankOverwriteSelect = $('#RankOverwrite select');

        rankOverwrite.appendTo($("#Accordion .info_section .big_title")[0]);
        rankOverwriteSelect.fancySelect();
        rankOverwriteSelect.css("display", "none");
        
        rankOverwrite.css('float', 'right').css('position', 'absolute').css('right', '14px').css('top', '7px');

        rankOverwriteSelect.change(function() {
            $('#RankOverwrite .trigger').css('background-color', $('#RankOverwrite ul li.selected').css('background-color'));
        });

        $('#rankConfirmed').on('click', function() {
            entityRank = $('#RankOverwrite select option:selected').val();
        });

        entityRank = $('#RankOverwrite select option:selected').val();

        $(".KeyFactorsTable").each(function() {
        	var lastColumn = $(this).find("th").length - 1;
            
            $(this).tablesorter({
                sortList: [[lastColumn,1]]
            });
        });
        
        $('.hiddenModals').appendTo('#Accordion');
       
        $('.backToLastModal').parent().parent().parent().parent().on('hide.bs.modal', function () {
            $('#MoreInformationModal').modal('show');
        });

        $('#changeRankReasonModal').on('hide.bs.modal', function (a) {
            undoRankChange();
        });
        
        $('#Accordion').accordion({
        	icons: {
                header: "sp-header-icon",
                activeHeader: "sp-active-header-icon"
                },
        	collapsible: false,
        	header: 'div.info_section > div.big_title',
            heightStyle: 'content'
    	});

        $('#EntityInformation').css('min-height', $('.col-md-3').height());
        
        changeToImage();
        
        $('.HideList ol').hide()
        $('.incentiveList h6').click(toggleIncentives);
    } 
);
        
function toggleIncentives() {
    var parent = $(this).parent();
    var last = parent.parent().parent().parent().find('div.ShowList');
    if (last.get(0) != parent.get(0)) {
        last.removeClass('ShowList').addClass('HideList');
        parent.removeClass('HideList').addClass('ShowList');   
        last.children('ol').slideUp(200);
        parent.children('ol').slideDown(200);
    }
}
        
function showConfirmationModal() {
    changeToImage();
    if (entityRank === $('#RankOverwrite select option:selected').val())
        return;
    
    $('#changeRankReasonModal').modal('toggle');
}

function confirm() {
    entityRank = $('#RankOverwrite select option:selected').val();
    updateRank($('#changeRankReasonString').val());
    changeToImage();
}

function undoRankChange() {
    $('#RankOverwrite select option:selected').attr("selected", false);
    $('#RankOverwrite select option[value="' + entityRank + '"]').attr("selected", true);
    $('#RankOverwrite select').trigger('update');
    $('#RankOverwrite .trigger').css('background-color', $('#RankOverwrite ul li.selected').css('background-color'));
    changeToImage();
}
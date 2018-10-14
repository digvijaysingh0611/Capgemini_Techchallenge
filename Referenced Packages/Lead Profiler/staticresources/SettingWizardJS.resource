function waitCursor (b) {
  if (b) $ ('html').addClass ('wait');
  else $ ('html').removeClass ('wait');
}

    setDataInstall = function () {
      $('#btnAllowSalesForce').prop('disabled', true);
      var webService = $('#settingsDialog .webService').val();
      $('#hiddenInputs .webService input').val(webService);
      install();
    }

    setDataSaveSettings = function () {
      saveSettings();
    }

    upgradeToUpsellSupport = function () {
      upgradeToUpsell();
    }

    setDataSaveUsers = function () {
      saveUsers();
    }

    checkBtnAllowSalesForce = function() {
      checkIfShouldTurnOnTheNextButton();
    }

    upsellUpgradeSelector = function() {
      $('#btnUpsellUpgrade').attr("disabled", "disabled").addClass( 'btnDisabled' );

      
      $("input[id$='upgradeToUpsell']").change(function() {
        if (this.checked) {
          $('#accountsUpsellFields').show();
        } else {
          $('#accountsUpsellFields').hide();
        }
      })  

      $('#accountsUpsellFields').children('select').change(function(){
        $('#accountsUpsellFields h5').css('color', 'black');
        $('#btnUpsellUpgrade').removeAttr("disabled").removeClass('btnDisabled');   
        
        if ($('#accountsUpsellFields').children('select').val() === '') {
          $('#accountsUpsellFields h5').css('color', 'red');
          $('#btnUpsellUpgrade').attr("disabled", "disabled").addClass( 'btnDisabled' );
        }
      });
    }

    contactsFieldsSelector = function() {
      $(":radio").on('click', function(){
        if ($(this).is(':checked') && $(this).val() === 'Contact')
          $('#contactsFields').show();
        else
          $('#contactsFields').hide();
        
        checkIfShouldTurnOnTheNextButton();
      });
      
      $('#contactsFields').children('select').change(function(){
        $('#contactsFields h5').css('color', 'black');
        
        if ($('#contactsFields').children('select').val() === '') {
          $('#contactsFields h5').css('color', 'red');
        }
        checkIfShouldTurnOnTheNextButton();
      });
    }

    function checkIfShouldTurnOnTheNextButton() {
      var allow = true;
      var profiling = false;
      var noMismatch = true;
      var hasCoupon = false;

      // if ($('#allowSalesforce').length > 0 && $('#allowSalesforce')[0].checked) {
      //   allow = true;
      // }       

      if ((($(":radio[value=Contact]").is(':checked') && $('#contactsFields').children('select').val() !== '')
          ||  $(":radio[value=Lead]").is(':checked') ||  $(":radio[value=Account]").is(':checked') ||  $(":radio[value=Opportunity]").is(':checked'))) {
        
        profiling = true;
      }         
    
      if (($("input[id$='leadSupport']").length > 0 && $("input[id$='leadSupport']")[0].checked) 
        && (($(":radio[value=Contact]").is(':checked') && $('#contactsFields').children('select').val() === ''))) {
        noMismatch = false;
      }

      if (($("input[id$='couponNo']").length > 0 && $("input[id$='couponNo']").val().trim().length > 0) || isAdminOrg) {
        hasCoupon = true;
      }



      if (allow && noMismatch && profiling && hasCoupon)
        $('#btnAllowSalesForce').removeAttr("disabled").removeClass('btnDisabled');  
      else
        $('#btnAllowSalesForce').attr("disabled", "disabled").addClass( 'btnDisabled' );
  }



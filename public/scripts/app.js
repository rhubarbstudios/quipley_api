$(document).ready(function () {
    $(".amount-field").hide();
    $("#total-field").hide();

    $(document).on("click", '#amount-label', function(){
      console.log("clicked amount");
      $("#amount-text").show();
      $("#percentage-text").hide();
      $("#total-field").show();
      $(".total-field-value").text("$ ")
      $("#user-amount-input").val("")
    })
    $(document).on("click", '#percentage-label', function(){
      console.log("clicked percentage");
      $("#percentage-text").show();
      $("#amount-text").hide();
      $("#total-field").show();
      $(".total-field-value").text(" %")
      $("#user-percentage-input").val("")
    })

    $(document).on("keyup", "#user-amount-input", function() {
      // console.log("testing");
      var input = $("#user-amount-input").val();
          var inputValue = parseFloat(input);
          var serviceCharge = inputValue * 0.25;
          var totalFee = inputValue + serviceCharge;
          $(".total-field-value").text("$"+totalFee);
          $(".service-charge-value").text("$"+serviceCharge);
          $(".user-input-value").text("$"+inputValue);
    })
    $(document).on("keyup", "#user-percentage-input", function() {
          var input = $("#user-percentage-input").val();
          var inputValue = parseFloat(input);
          var serviceCharge = inputValue * 0.25;
          var totalFee = inputValue + serviceCharge;
          $(".total-field-value").text(totalFee+"%");
          $(".service-charge-value").text(serviceCharge+"%");
          $(".user-input-value").text(inputValue+"%");
    })
    $(document).on("click", "#form-submit", function() {
      $(".registerModal").modal("toggle");
    })

    var getUrlParameter = function getUrlParameter(sParam) {
      var sPageURL = decodeURIComponent(window.location.search.substring(1)),
          sURLVariables = sPageURL.split('&'),
          sParameterName,
          i;
      for (i = 0; i < sURLVariables.length; i++) {
          sParameterName = sURLVariables[i].split('=');
          if (sParameterName[0] === sParam) {
              return sParameterName[1] === undefined ? true : sParameterName[1];
          }
      }
    };

    if (getUrlParameter('confirm')) {
      $(".successModal").modal("toggle");
      console.log("Peter55555555");
    }

});

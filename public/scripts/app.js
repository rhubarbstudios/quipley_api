$(document).ready(function () {
    $(".amount-field").hide();
    $("#total-field").hide();

    $(document).on("click", '#amount-label', function(){
      console.log("clicked amount");
      $("#amount-text").show();
      $("#percentage-text").hide();
      $("#total-field").show();
      $("#total-field-value").text("$ ")
      $("#user-amount-input").val("")
    })
    $(document).on("click", '#percentage-label', function(){
      console.log("clicked percentage");
      $("#percentage-text").show();
      $("#amount-text").hide();
      $("#total-field").show();
      $("#total-field-value").text(" %")
      $("#user-percentage-input").val("")
    })

    $(document).on("keyup", "#user-amount-input", function() {
      var input = $("#user-amount-input").val();
          $("#total-field-value").text("$"+input*1.25)
    })
    $(document).on("keyup", "#user-percentage-input", function() {
      var input = $("#user-percentage-input").val();
          $("#total-field-value").text(input*1.25+"%")
    })


});

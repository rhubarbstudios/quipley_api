$(document).ready(function () {
    // $(".amount-field").hide();
    $(document).on("click", '#amount-label', function(){
      console.log("clicked amount");
      $("#amount-text").show();
      $("#percentage-text").hide();
    })
    $(document).on("click", '#percentage-label', function(){
      console.log("clicked percentage");
      $("#percentage-text").show();
      $("#amount-text").hide();
    })
});
$(document).ready(function() {

var zipcodeField = $('#eventZip');
var ziptasticUrl = "https://zip.getziptastic.com/v2/"

zipcodeField.on("input", function(data){
  getCityStateCountry(data);
})

function getCityStateCountry(data){
  if (zipcodeField.val().length >= 5){
    if (zipcodeField.val().length == 6) {
      var countrySlug = "CA/";
    } else {
      var countrySlug = "US/";
    }
    var url = ziptasticUrl + countrySlug + data.target.value
    console.log(url);
    $.get(url, function(data){
      console.log("data", data);
      var returnObj = data;
      if (!returnObj.error){
        var city = capitalizeFirstLetter(returnObj.city).replace(/\(.*$/, "").trim();
        var state = returnObj.state_short;
        var country = returnObj.country;
        $('#eventCity').val(city);
        $('#eventState').val(state);
        $('#eventCountry').val(country);
      }
    })
  };
}

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
}

function abbrState(input){

    var states = [
        ['Arizona', 'AZ'],
        ['Alabama', 'AL'],
        ['Alaska', 'AK'],
        ['Arizona', 'AZ'],
        ['Arkansas', 'AR'],
        ['California', 'CA'],
        ['Colorado', 'CO'],
        ['Connecticut', 'CT'],
        ['Delaware', 'DE'],
        ['Florida', 'FL'],
        ['Georgia', 'GA'],
        ['Hawaii', 'HI'],
        ['Idaho', 'ID'],
        ['Illinois', 'IL'],
        ['Indiana', 'IN'],
        ['Iowa', 'IA'],
        ['Kansas', 'KS'],
        ['Kentucky', 'KY'],
        ['Kentucky', 'KY'],
        ['Louisiana', 'LA'],
        ['Maine', 'ME'],
        ['Maryland', 'MD'],
        ['Massachusetts', 'MA'],
        ['Michigan', 'MI'],
        ['Minnesota', 'MN'],
        ['Mississippi', 'MS'],
        ['Missouri', 'MO'],
        ['Montana', 'MT'],
        ['Nebraska', 'NE'],
        ['Nevada', 'NV'],
        ['New Hampshire', 'NH'],
        ['New Jersey', 'NJ'],
        ['New Mexico', 'NM'],
        ['New York', 'NY'],
        ['North Carolina', 'NC'],
        ['North Dakota', 'ND'],
        ['Ohio', 'OH'],
        ['Oklahoma', 'OK'],
        ['Oregon', 'OR'],
        ['Pennsylvania', 'PA'],
        ['Rhode Island', 'RI'],
        ['South Carolina', 'SC'],
        ['South Dakota', 'SD'],
        ['Tennessee', 'TN'],
        ['Texas', 'TX'],
        ['Utah', 'UT'],
        ['Vermont', 'VT'],
        ['Virginia', 'VA'],
        ['Washington', 'WA'],
        ['West Virginia', 'WV'],
        ['Wisconsin', 'WI'],
        ['Wyoming', 'WY'],
    ];

    input = input.toUpperCase();
    for(i = 0; i < states.length; i++){
        if(states[i][1] == input){
            return(states[i][0]);
        }
    }
  }

});
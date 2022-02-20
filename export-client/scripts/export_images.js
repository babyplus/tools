const YAML = require('yamljs');
var jsdom = require('jsdom');
const { JSDOM } = jsdom;
const { window } = new JSDOM();
const { document } = (new JSDOM('')).window;
global.document = document;
var $ = jQuery = require('jquery')(window);
 
console.log("---")
YAML.load('/tmp/test_latest.txt', (response) =>
{
    ping_times = []
    ping_results = []
    ping_maps = {}
    timeout_substitute = 10000
    for (r in response) {
        ping_times.push(response[r]["time"])
        ping_results.push(response[r]["results"])
    }
    for (p in ping_results){
      for (h in ping_results[p]){
            p_result = ping_results[p][h]["ping_time"].replace("None", timeout_substitute).replace(" ms", "")
            p_result = (p_result < timeout_substitute) ? p_result : timeout_substitute
          if (undefined == ping_maps[ping_results[p][h]["host"]]){
              ping_maps[ping_results[p][h]["host"]] = [p_result]
          }else{
              ping_maps[ping_results[p][h]["host"]].push(p_result)
          }
      }
    }
    echartLine_setOption = {
        "calculable": "true",
        "legend": {
          "data": [
            "Deal"
          ],
          "selectedMode": "single",
          "x": "220",
          "y": "40"
        },
        "series": [
          {
            "data": [
              "0",
              "0",
              "0",
              "0",
              "0",
              "0",
              "0"
            ],
            "itemStyle": {
              "normal": {
                "areaStyle": {
                  "type": "default"
                }
              }
            },
            "name": "Deal",
            "smooth": "true",
            "type": "line"
          }
        ],
        "title": {
          "subtext": "",
          "text": ""
        },
        "toolbox": {
          "feature": {
            "magicType": {
              "show": "true",
              "title": {
                "bar": "Bar",
                "line": "Line"
              },
              "type": [
                "line",
                "bar"
              ]
            },
            "saveAsImage": {
              "show": "true",
              "title": "Save Image"
            }
          },
          "show": "true"
        },
        "tooltip": {
          "trigger": "axis"
        },
        "xAxis": [
          {
            "boundaryGap": "false",
            "data": [
              "Mon",
              "Tue",
              "Wed",
              "Thu",
              "Fri",
              "Sat",
              "Sun"
            ],
            "type": "category"
          }
        ],
        "yAxis": [
          {
            "type": "value"
          }
        ]
      }
      series = []
      for (k in ping_maps){
        series.push(k)
      }
      echartLine_setOption["xAxis"][0]["data"] = ping_times
      // echartLine_setOption["legend"]["data"] = series
      for (n = 0 ;n < series.length; n++){
        echartLine_setOption["legend"]["data"] = [series[n]]
        // if (undefined == echartLine_setOption["series"][n]){
        //     echartLine_setOption["series"][n] = {}
        // }
        echartLine_setOption["series"][0] = {}
        echartLine_setOption["series"][0]["data"] = ping_maps[series[n]]
        echartLine_setOption["series"][0]["name"] = series[n]
        echartLine_setOption["series"][0]["type"] = "line"
        echartLine_setOption["series"][0]["smooth"] = "true"
        echartLine_setOption["series"][0]["itemStyle"] = {
            "normal": {
                "areaStyle": {
                    "type": "default"
                }
            }
        }
        $.ajax({
          type: "post",
          url:'http://172.18.0.1/pic',
          dataType:'json',
          async: false,
          crossDomain: true,
          data:JSON.stringify(echartLine_setOption),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          success:function(response){
            console.log("    " + series[n] + ": " + response["filename"])
          },
          error:function(error){
            console.log("error: "+JSON.stringify(error))
          }
        });
      }
});

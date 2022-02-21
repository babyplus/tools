const http = require("http");
const fs = require("fs");
const YAML = require('yamljs');
const jsdom = require('jsdom');
const yargs = require('yargs').option('D',{
  alias:'data',
  demand:true,
  default:'/tmp/test_latest.txt',
  describe:'The path of data file.',
  type:'string'
})
.option('U',{
  alias:'url',
  demand:true,
  default:'http://127.0.0.1/pic',
  describe:'The url of the echarts-node-export-server.',
  type:'string'
})
.option('O',{
  alias:'output',
  demand:true,
  default:'/tmp/images/',
  describe:'The directory used to store downloaded files',
  type:'string'
})
.usage('Usage: node export_images.js [options]')
.example('node export_images.js --data /tmp/test_latest.txt --url http://127.0.0.1/pic --output /tmp/images/')
.help('h')
.alias('h','help');

const argv = yargs.argv;
const { JSDOM } = jsdom;
const { window } = new JSDOM();
const { document } = (new JSDOM('')).window;
global.document = document;
const $ = jQuery = require('jquery')(window);
if (!fs.existsSync(argv["output"])) fs.mkdirSync(argv["output"], 0744);

function download(url, dest) {
  return new Promise((resolve, reject) => {
      const file = fs.createWriteStream(dest, { flags: "wx" });

      const request = http.get(url, response => {
          if (response.statusCode === 200) {
              response.pipe(file);
          } else {
              file.close();
              fs.unlink(dest, () => {}); // Delete temp file
              reject(`Server responded with ${response.statusCode}: ${response.statusMessage}`);
          }
      });

      request.on("error", err => {
          file.close();
          fs.unlink(dest, () => {}); // Delete temp file
          reject(err.message);
      });

      file.on("finish", () => {
          resolve();
      });

      file.on("error", err => {
          file.close();

          if (err.code === "EEXIST") {
              reject("File already exists");
          } else {
              fs.unlink(dest, () => {}); // Delete temp file
              reject(err.message);
          }
      });
  });
}

YAML.load(argv["data"], (response) =>
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
      for (n = 0 ;n < series.length; n++){
        echartLine_setOption["legend"]["data"] = [series[n]]
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
          url: argv["url"],
          dataType:'json',
          async: false,
          crossDomain: true,
          data:JSON.stringify(echartLine_setOption),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          success:function(response){
            download(argv["url"] + "/" + response["filename"], argv["output"] + series[n] + ".png")
          },
          error:function(error){
            console.log("error: "+JSON.stringify(error))
          }
        });
      }
});

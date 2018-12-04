var mqtt = require('./mqttCluster.js');
var fs = require('mz/fs')
var Inotify = require('inotify').Inotify;
var inotify = new Inotify();
var sensorDataPath = '/sensorsdata/';
global.zonesReadingsTopic = 'sensorReading';
global.mtqqLocalPath = process.env.MQTTLOCAL;
var piId = process.env.NODEID;


inotify.addWatch({
    path: sensorDataPath,
    watch_for: Inotify.IN_ALL_EVENTS,
    callback: onNewFileGenerated
});


function onNewFileGenerated(event) {
    var mask = event.mask;
    if (mask & Inotify.IN_CLOSE_WRITE) {
        var fileName = event.name;
        handleReadingFileGeneratedV2(fileName);
    }
}

async function handleReadingFileGeneratedV2(fileName) {
    var filePath = sensorDataPath + fileName;
    var data = await fs.readFile(filePath, 'utf8');
    var content = { data: data, fileName: fileName, piId: piId };
    (await mqtt.getClusterAsync()).publishData(global.zonesReadingsTopic, content);;
    await fs.unlink(filePath);
}


// Catch uncaught exception
process.on('uncaughtException', err => {
    console.dir(err, { depth: null });
    process.exit(1);
});
process.on('exit', code => {
    console.log('Process exit');
    process.exit(code);
});
process.on('SIGTERM', code => {
    console.log('Process SIGTERM');
    process.exit(code);
});
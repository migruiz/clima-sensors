var mqtt = require('mqtt')
var fs = require('mz/fs')
var Inotify = require('inotify').Inotify;
var inotify = new Inotify();
var sensorDataPath = '/sensordataV2/';

var piId = process.env.NODEID;

var mqttClient = mqtt.connect(process.env.MQTTServer);

client.on('connect', ()=> {
    inotify.addWatch({
        path: sensorDataPath,
        watch_for: Inotify.IN_ALL_EVENTS,
        callback: onNewFileGenerated
    });
})

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
    var msg = JSON.stringify(content);
    client.publish('sensorReading', msg);
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
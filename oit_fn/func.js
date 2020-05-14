const fdk = require('@fnproject/fdk');
const fs = require('fs');
const tmp = require('tmp');
const im = require('imagemagick');
const { exec, spawn } = require('child_process');

fdk.handle((buffer, ctx) => {
	// let name = "World";
	// if(buffer.name) {
	// 	name = buffer.name;
	// }
	// return {'message': 'Hello ' + name};
	//exec('/function/oit-fi/sdk/demo/fisimple /function/oit-fi/sdk/samplefiles/adobe-acrobat.pdf', (err, stdout, stderr) => {
	try {
		const echo = spawn('ls', {shell: true});
		echo.stdout.on('data', (data)=> {
			return { 'message': `OUTPUT: ${data}` };
		});
		// exec('echo "Hello World"', {shell: true}, (error, stdout, stderr) => {
		// 	if (error) {
		// 		console.log(`error: ${error.message}`);
		// 		return;
		// 	}
		// 	if (stderr) {
		// 		console.log(`stderr: ${stderr}`);
		// 		return;
		// 	}
		// 	return { 'message': `OUTPUT: ${stdout}` };
		// });
	}
	catch(e) {
		return { 'message': 'Some Error: ' + e };
	}
	// return { 'message': 'Nothing is working again' };
})

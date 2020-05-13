const fdk = require('@fnproject/fdk');
const fs  = require('fs');
const tmp = require('tmp');
const im  = require('imagemagick');
const { exec } = require('child_process');

fdk.handle(function() {
	      //exec('/function/oit-fi/sdk/demo/fisimple /function/oit-fi/sdk/samplefiles/adobe-acrobat.pdf', (err, stdout, stderr) => {
	      exec('echo "Hello World"', (err, stdout, stderr) => {
		      if(err) {
			      console.err('Some exec error');
			      console.err(err);
			      return "ERROR";
		      }
		      else{
			      console.log(stdout);
			      return stdout;
		      }
	      });
	return "Nothing is working";
})

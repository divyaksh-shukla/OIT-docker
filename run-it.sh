docker build --rm -t oit-sample:1 -f Dockerfile .
# docker run -it -v oit_output:/home/oit/outputs -v oit_samplefiles:/home/oit/samplefiles -v oit_fonts:/home/oit/fonts oit-sample:1 java -cp oilink.jar:oitsample.jar OITSample samplefiles/adobe-acrobat.pdf outputs/test.tif tiff fonts
docker run -it --rm -v oit_output:/home/oit/outputs -v oit_samplefiles:/home/oit/samplefiles -v oit_fonts:/home/oit/fonts oit-sample:1 java -cp oilink.jar:oitsample.jar OITSample /home/oit/samplefiles/adobe-acrobat.pdf /home/oit/outputs/test.tif tiff /home/oit/fonts
# docker run -it oit-sample:1 java -cp oilink.jar:oitsample.jar OITSample /oit_samplefiles/adobe-acrobat.pdf /oit_outputs/test.tif tiff /oit_fonts
# docker run -it --rm oit-sample:1
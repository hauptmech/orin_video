#!/bin/bash

RGB=/dev/video2
RGB_FORMAT=video/x-raw,format=YUY2,width=1280,height=720,framerate=30/1
EYE=/dev/video4
EYE_FORMAT=video/x-raw,format=GRAY16_LE,width=1024,height=512,framerate=30/1
MIC1="pulsesrc device=alsa_input.platform-sound.analog-stereo name=mic1 "
MIC1_PIPE="mic1. ! queue ! audioconvert ! voaacenc ! aacparse ! mux."
#MIC2=alsasrc device="hw:1,1" name=mic2
#MIC2_PIPE=mic1. ! queue ! audioconvert ! voaacenc ! aacparse ! mux.


echo $MIC1
export GST_DEBUG=2

gst-launch-1.0 \
	v4l2src device=$RGB name=realsense \
	v4l2src device=$EYE name=usbcam \
    $MIC1 \
    $MIC2 \
	usbcam. ! $EYE_FORMAT ! queue ! videoconvert ! nvvidconv ! nvv4l2h264enc ! h264parse ! mux. \
	realsense. ! $RGB_FORMAT ! tee name=t \
	t. ! queue ! nvvidconv ! 'video/x-raw(memory:NVMM)' ! nvegltransform ! nveglglessink sync=false \
	t. ! queue ! nvvidconv ! nvv4l2h264enc ! h264parse ! matroskamux name=mux \
	$MIC1_PIPE \
	$MIC2_PIPE \
	mux. ! filesink location=output.mkv 


#!/bin/bash

RGB=/dev/video2
RGB_FORMAT=video/x-raw,format=YUY2,width=1280,height=720,framerate=30/1
EYE=/dev/video4
EYE_FORMAT=video/x-raw,format=GRAY16_LE,width=1024,height=512,framerate=30/1

export GST_DEBUG=2

gst-launch-1.0 \
	v4l2src device=$RGB name=realsense \
	v4l2src device=$EYE name=usbcam \
	usbcam. ! $EYE_FORMAT ! queue ! videoconvert ! nvvidconv ! nvv4l2h264enc ! h264parse ! mux. \
	realsense. ! $RGB_FORMAT ! tee name=t \
	t. ! queue ! nvvidconv ! 'video/x-raw(memory:NVMM)' ! nvegltransform ! nveglglessink sync=false \
	t. ! queue ! nvvidconv ! nvv4l2h264enc ! h264parse ! matroskamux name=mux \
	mux. ! filesink location=output.mkv 


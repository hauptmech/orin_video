
# Jetson Orin GStreamer example

Using nvidia optimized plugins - 
- Record 2 video streams and 2 audio streams to file in MKV format to preserve timestamps
- Display 1 video stream


Modify `test.sh` with desired devices and formats.

Execute `test.sh`

`mkvinfo output.mkv` to see stream numbers

Execute `check_frames output.mkv 0` to check timestamps of stream 0


`gst-device-monitor-1.0 Audio`
`gst-device-monitor-1.0 Video`


Notes on Nano Encoding - https://docs.nvidia.com/jetson/archives/r35.3.1/DeveloperGuide/text/SD/Multimedia/SoftwareEncodeInOrinNano.html

Notes on accellerated gstreamer - https://docs.nvidia.com/jetson/archives/r35.4.1/DeveloperGuide/text/SD/Multimedia/AcceleratedGstreamer.html

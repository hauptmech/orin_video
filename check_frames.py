#!/usr/bin/env python3
import sys
import numpy as np
from pathlib import Path

def analyze_timestamps(timestamp_file):
    # Read timestamps (in nanoseconds)

    with open(timestamp_file) as f:
        # skip header
        f.readline()
        timestamps = [float(line.strip()) for line in f if line.strip()]
    
    if not timestamps:
        print("No timestamps found in file")
        return
    
    # Convert to milliseconds for easier reading
    timestamps = np.array(timestamps) 
    
    # Calculate frame intervals
    intervals = np.diff(timestamps)
    expected_interval = np.median(intervals)  # Use median as "normal" interval
    
    # Find dropped frames (gaps > 1.5x expected interval)
    dropped_indices = np.where(intervals > expected_interval * 1.5)[0]
    
    # Analysis results
    print(f"Total frames: {len(timestamps)}")
    print(f"Expected interval: {expected_interval:.2f}ms")
    print(f"Actual mean interval: {np.mean(intervals):.2f}ms")
    print(f"Min interval: {np.min(intervals):.2f}ms")
    print(f"Max interval: {np.max(intervals):.2f}ms")
    print(f"Standard deviation: {np.std(intervals):.2f}ms")
    print(f"\nDropped frames: {len(dropped_indices)}")
    
    if dropped_indices.size > 0:
        print("\nDetailed drops:")
        for idx in dropped_indices:
            gap = intervals[idx]
            missed_frames = round(gap / expected_interval) - 1
            timestamp = timestamps[idx]
            print(f"At {timestamp:.2f}ms: {gap:.2f}ms gap (~{missed_frames} frames)")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <timestamp_file>")
        sys.exit(1)
    
    timestamp_file = Path(sys.argv[1])
    if not timestamp_file.exists():
        print(f"Error: File {timestamp_file} not found")
        sys.exit(1)
        
    analyze_timestamps(timestamp_file)

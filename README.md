# Real-Time CUDA Color image/video filter app

A real-time image processing application that captures live video frames, processes them using CUDA on the GPU, and displays the output using OpenGL.

The project demonstrates GPU acceleration for image processing by implementing a CUDA-based color inversion filter on live camera frames.

## Overview

In a traditional CPU-based approach, every pixel of an image is processed sequentially. This project uses CUDA to perform parallel pixel processing, where multiple GPU threads process different pixels simultaneously.

The application performs:

1. Capture live frames from a camera
2. Transfer image data from CPU memory to GPU memory
3. Execute CUDA kernel for color inversion
4. Transfer processed frame to rendering pipeline
5. Display the processed output using OpenGL

## System Architecture

```
                Camera
                  |
                  v
        OpenCV / GStreamer Capture
                  |
                  v
              cv::Mat Frame
              (CPU Memory)
                  |
                  |
             cudaMemcpy()
                  |
                  v
             GPU Memory
                  |
                  v
        CUDA Color Inversion Kernel
                  |
                  v
        Processed Image Data
                  |
                  v
          OpenGL Texture/PBO
                  |
                  v
              Display Output
```

## CUDA Color Inversion

The color inversion operation is performed for every pixel:

```
New Pixel Value = 255 - Original Pixel Value
```

Example:

Input Pixel:

```
B = 100
G = 150
R = 200
```

Output Pixel:

```
B = 155
G = 105
R = 55
```

Each CUDA thread processes one pixel independently.

Example:

```
Thread 0  ---> Pixel 0
Thread 1  ---> Pixel 1
Thread 2  ---> Pixel 2
...
Thread N  ---> Pixel N
```

## Technologies Used

- C++
- CUDA
- OpenCV
- OpenGL
- Linux
- NVIDIA Jetson Platform

## CUDA Implementation

The CUDA kernel performs:

- Pixel-wise parallel processing
- GPU memory management
- Host to Device data transfer
- Device to Host data transfer
- Kernel execution synchronization

## OpenGL Rendering

OpenGL is used for displaying the processed frame.

Rendering pipeline:

```
CUDA Output
     |
     v
OpenGL Texture
     |
     v
GPU Rendering Pipeline
     |
     v
Display Window
```

## Performance Advantage

GPU acceleration allows thousands of pixels to be processed simultaneously.

Example:

For a 640x480 image:

```
Total Pixels:

640 x 480 = 307200 pixels
```

Instead of processing pixels one by one on CPU, CUDA launches many GPU threads to process pixels in parallel.

## Project Flow

```
Capture Frame
      |
      v
Convert / Prepare Image Data
      |
      v
Copy Frame to GPU
      |
      v
Launch CUDA Kernel
      |
      v
Apply Color Inversion
      |
      v
Render using OpenGL
      |
      v
Display Real-Time Output
```

## Requirements

- NVIDIA GPU / Jetson Platform
- CUDA Toolkit
- OpenCV
- OpenGL
- C++ Compiler

## Future Improvements

- Reduce CPU-GPU memory copies
- Use CUDA-OpenGL interoperability
- Use Pixel Buffer Objects (PBO)
- Add additional CUDA image filters
- Optimize memory bandwidth

## Learning Goal

This project was developed to understand real-time GPU accelerated image processing, CUDA programming, and integration of CUDA with graphics rendering pipelines.

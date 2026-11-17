#include <iostream>
#include <opencv2/opencv.hpp>
#include <cuda_runtime.h>

using namespace std;
using namespace cv;


__global__ void colorInvertKernel(unsigned char *input,unsigned char *output,int width,int height,int channels)
{
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;


    if(x < width && y < height)
    {

        int pixelIndex = (y * width + x) * channels;
        for(int c = 0; c < channels; c++)
        {
            output[pixelIndex + c] =
                    255 - input[pixelIndex + c];
        }
    }
}



int main()
{
    VideoCapture cap(0, CAP_V4L2);

    if(!cap.isOpened())
    {
        cerr << "unable to open camera" << endl;
        return -1;
    }

    Mat frame;
    Mat inverted;
    while(true)
    {

        if(!cap.read(frame))
        {
            cerr << "unable to read" << endl;
            break;
        }

        int width = frame.cols;
        int height = frame.rows;
        int channels = frame.channels();

        size_t imageSize = width * height * channels;
        unsigned char *d_input;
        unsigned char *d_output;


        cudaMalloc(&d_input, imageSize);
        cudaMalloc(&d_output, imageSize);

        cudaMemcpy(d_input,frame.data,imageSize,cudaMemcpyHostToDevice);

        dim3 block(16,16);


        dim3 grid((width + block.x - 1) / block.x,(height + block.y - 1) / block.y);
        colorInvertKernel<<<grid,block>>>(d_input,d_output,width,height,channels);

        cudaDeviceSynchronize();

        inverted.create(height,width,CV_8UC3);
        cudaMemcpy(inverted.data,d_output,imageSize,cudaMemcpyDeviceToHost);
        cudaFree(d_input);
        cudaFree(d_output);
        imshow("live capture", frame);

        imshow("CUDA colour inversion", inverted);
        int key = pollKey();

        if(key == 27 || key == 'q')
        {
            cout << "streaming stopped" << endl;
            break;
        }

    }

    cap.release();
    destroyAllWindows();

    return 0;
}

#include<opencv2/opencv.hpp>
#include<iostream>
#include<cuda_runtime.h>
using namespace std;
using namespace cv;
__global__
void grayscalar(unsigned char* input,unsigned char*output,int width,int height)
{
        int x=blockIdx.x*blockDim.x+threadIdx.x;
        int y=blockIdx.y*blockDim.y+threadIdx.y;

        if(x<width&&y<height)
        {
               int index=(y*width+x)*3;
               int grayindex=y*width+x;
               output[grayindex]=(0.114*input[index])+(0.587*input[index+1])+(0.299*input[index+2]);
        }
}
int main()
{
        VideoCapture cap(0);
        if(!cap.isOpened())
        {
                cout<<"unable to open camera"<<endl;
                return -1;
        }
        Mat frame;
        Mat gframe;
        while(true)
        {
           if(!cap.read(frame))
           {cout<<"frames are not recieved"<<endl;
                   break;
           }
           gframe.create(frame.rows,frame.cols,CV_8UC1);
           size_t  size=frame.cols*frame.rows*frame.channels();
           size_t gsize=frame.cols*frame.rows;
           unsigned char *d_input;
           cudaMalloc((void**)&d_input,size);
           cudaMemcpy(d_input,frame.data,size,cudaMemcpyHostToDevice);
           unsigned char *d_output;
           cudaMalloc((void**)&d_output,gsize);
           dim3 block(16,16);
           dim3 grid(40,30);
           grayscalar<<<grid,block>>>(d_input,d_output,frame.cols,frame.rows);
           cudaMemcpy(gframe.data,d_output,gsize,cudaMemcpyDeviceToHost);
           cudaFree(d_input);
           cudaFree(d_output);
           imshow("live image",frame);
           imshow("grayscalar",gframe);
           int key=pollKey();
           if(key==27||key=='q')
           {
                   cout<<"streaming stopped"<<endl;
                   break;
           }
        }
        cap.release();
        destroyAllWindo

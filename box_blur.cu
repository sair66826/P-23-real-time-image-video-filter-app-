#include<iostream>
#include<opencv2/opencv.hpp>
#include<cuda_runtime.h>
using namespace std;
using namespace cv;
__global__
void box_blur(unsigned char *input,unsigned char*output,int width,int height)
{
        int x=blockDim.x*blockIdx.x+threadIdx.x;
        int y=blockDim.y*blockIdx.y+threadIdx.y;
        if(x<width&&y<height)
        {
                int b=0,g=0,r=0,c=0;
                for(int idx=-1;idx<=1;idx++)
                {
                        for(int idy=-1;idy<=1;idy++)
                        {       int nx=x+idx;
                                int ny=y+idy;
                                if(nx>=0&&ny>=0&&nx<width&&ny<height)
                                {
                                int nindex=(ny*width+nx)*3;
                                b+=input[nindex];
                                g+=input[nindex+1];
                                r+=input[nindex+2];
                                c++;
                                }
                          }
                }
                        int index=(y*width+x)*3;
                        output[index]=b/c;
                        output[index+1]=g/c;
                        output[index+2]=r/c;
        }
}
int main()
{
        VideoCapture cap(0,CAP_V4L2);
        if(!cap.isOpened())
        {
          cout<<"unable to open camera"<<endl;
          return -1;
        }
        Mat frame;
        Mat bframe;
        while(true)
        {
                if(!cap.read(frame))
                {
                        cout<<"unable to read frames"<<endl;
                        break;
                }
                bframe.create(frame.rows,frame.cols,frame.type());
                int size=frame.rows*frame.cols*frame.channels();
                unsigned char*d_input;
                cudaMalloc((void**)&d_input,size);
                cudaMemcpy(d_input,frame.data,size,cudaMemcpyHostToDevice);
                unsigned char *d_output;
                cudaMalloc((void**)&d_output,size);
                dim3 block(16,16);
                dim3 grid(40,30);

                box_blur<<<grid,block>>>(d_input,d_output,frame.cols,frame.rows);
                cudaMemcpy(bframe.data,d_output,size,cudaMemcpyDeviceToHost);
                imshow("live camera",frame);
                imshow("box_blur",bframe);
                int key=pollKey();
                if(key==27||key=='q')
                {
                        cout<<"streaming stopped"<<endl;
                        break;
                }
        }
        cap.release();
        destroyAllWindows();
}

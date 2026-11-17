#include<iostream>
#include<opencv2/opencv.hpp>
using namespace std;
using namespace cv;
int main()
{
        VideoCapture cap(0,CAP_V4L2);
        if(!cap.isOpened())
        {
                cerr<<"unable to open camera"<<endl;
                return -1;
        }
        Mat frame;
        while(true)
        {
                if(!cap.read(frame))
                {
                   cerr<<"unable to read"<<endl;
                   break;
                }
                imshow("live capture",frame);
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

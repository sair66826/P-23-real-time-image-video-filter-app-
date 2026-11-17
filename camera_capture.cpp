#include <iostream>
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

int main()
{
    VideoCapture cap(0, CAP_V4L2);

    if(!cap.isOpened())
    {
        cerr << "Unable to open camera" << endl;
        return -1;
    }

    cout << "Camera opened successfully\n\n";
    double width  = cap.get(CAP_PROP_FRAME_WIDTH);
    double height = cap.get(CAP_PROP_FRAME_HEIGHT);
    double fps    = cap.get(CAP_PROP_FPS);
    double format = cap.get(CAP_PROP_FORMAT);

    cout << "Camera Properties:\n";
    cout << "Width  : " << width << endl;
    cout << "Height : " << height << endl;
    cout << "FPS    : " << fps << endl;
    cout << "Format : " << format << endl;

    Mat frame;

    if(cap.read(frame))
    {
        cout << "\nFrame Information:\n";

        cout << "Rows       : " << frame.rows << endl;
        cout << "Cols       : " << frame.cols << endl;
        cout << "Channels   : " << frame.channels() << endl;
        cout << "Type       : " << frame.type() << endl;
        cout << "Elem Size  : " << frame.elemSize() << " bytes" << endl;
        cout << "Step       : " << frame.step << " bytes" << endl;
        cout << "Data Ptr   : " << static_cast<void*>(frame.data) << endl;

        cout << "\nFrame captured successfully\n";
    }
    else
    {
        cout << "Frame capture failed\n";
    }


    cap.release();

    return 0;
}

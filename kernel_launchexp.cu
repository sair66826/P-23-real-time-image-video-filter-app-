#include <iostream>
#include <cuda_runtime.h>
using namespace std;
__global__ void addKernel(int *data)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;

    data[index] += 10;
}

int main()
{
    const int size = 10;
    int host_data[size];
    for(int i = 0; i < size; i++)
    {
        host_data[i] = i;
    }

    cout << "Before kernel:" << endl;
    for(int i = 0; i < size; i++)
    {
        cout << host_data[i] << " ";
    }
    cout << endl;
    int *d_data;
    cudaMalloc(&d_data, size * sizeof(int));
    cudaMemcpy(d_data,host_data,size * sizeof(int),cudaMemcpyHostToDevice);
    addKernel<<<1, size>>>(d_data);
    cudaDeviceSynchronize();
    cudaMemcpy(h_data,d_data,size * sizeof(int),cudaMemcpyDeviceToHost);
    cout << "After kernel:" << endl;
    for(int i = 0; i < size; i++)
    {
        cout << h_data[i] << " ";
    }

    cout << endl;
    cudaFree(d_data);
    return 0;
}

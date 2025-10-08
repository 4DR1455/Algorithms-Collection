#include <iostream>
#include <vector>
using namespace std;

//Function that selects the pivot. Goal: Doing a median-of-three that avoid selecting a pivot from three equal values.
bool med_of_three_improved(vector<int>& arr, int low, int high) {
  //Checking base cases
    if (high - low == 1) {
        if (arr[low] > arr[high]) swap(arr[low], arr[high]); 
        return true;
    }
    if (high - low == 2) { 
        if (arr[high - 1] < arr[high]) swap(arr[high - 1], arr[high]); 
        if (arr[low] > arr[high] && arr[low] < arr[high - 1]) swap(arr[low], arr[high]); 
        return false;
    }
//Selecting mid pivot candidate
    int mid = (high + low) / 2; 
    int x = mid; 
    while (x < high && arr[x] == arr[high]) x++; 
    if (x == high) return med_of_three_improved(arr, low, mid); 
    if (arr[x] < arr[high]) swap(arr[x], arr[high]);
//Selecting lower pivot candidate
    int y = low; 
    while ((y < mid) && (arr[y] == arr[high] || arr[y] == arr[x])) y++; 
    if (y == mid) return med_of_three_improved(arr, mid, high);
  //Deciding final pivot
    if (arr[y] > arr[high] && arr[y] < arr[x]) swap(arr[y], arr[high]); 
    return false;
}

int partition(vector<int>& arr, int low, int high) {
  
    if (high - low <= 1) {
        if (arr[low] > arr[high]) swap(arr[low], arr[high]);
        return low;
    }
  
    // choose the pivot
    bool done = med_of_three_improved(arr, low, high);
    if (done) return high;
    int pivot = arr[high];

    // undex of smaller element and indicates 
    // the right position of pivot found so far
    int i = low - 1;

    // Traverse arr[low..high] and move all smaller
    // elements on left side. Elements from low to 
    // i are smaller after every iteration
    for (int j = low; j <= high - 1; j++) {
        if (arr[j] < pivot) {
            i++;
            swap(arr[i], arr[j]);
        }
    }
    
    // move pivot after smaller elements and
    // return its position
    swap(arr[i + 1], arr[high]);  
    return i + 1;
}

// the QuickSort function implementation
void quickSort(vector<int>& arr, int low, int high) {
  
    if (low < high) {
      
        // pi is the partition return index of pivot
        int pi = partition(arr, low, high);

        // recursion calls for smaller elements
        // and greater or equals elements
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}
}

#include <iostream>
#include <vector>
using namespace std;


int position(double x, const vector<double>& v, int left, int right) {
    if (right < left) {
        return -1;
    }
    else if (left < right) {
        //cout << left << '<' << right << endl;
        int half = (left + right)/2;
        if (v[half] < x) return position(x, v, half + 1, right);
        else if (v[half] > x) return position(x, v, left, half - 1);
        else return half;
    }
    else if (v[left] == x) return left;
    else return -1;
}

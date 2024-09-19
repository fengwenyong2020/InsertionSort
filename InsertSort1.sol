// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.0;  
  
contract InsertSort2 {  
    // 插入排序函数，接受一个int类型的数组（长度为5）作为参数，并返回排序后的数组  
    function insertSort2(int[5] memory inputArray) public pure returns (int[5] memory) {  
        int[5] memory arr = inputArray;  
        uint n = arr.length;  
  
        for (uint i = 1; i < n; i++) {  
            int key = arr[i];  
            uint j = i - 1;  
  
            // 将key插入到已排序部分的正确位置  
            while (j >= 0 && arr[j] > key) {  
                arr[j + 1] = arr[j];  
                j--;  
            }  
            arr[j + 1] = key;  
        }  
  
        return arr;  
    }  
}

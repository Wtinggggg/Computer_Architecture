#include <stdio.h>
#include <limits.h>

int maxSubArray(int* nums, int numsSize) {
    int max_current = nums[0];
    int max_global = nums[0];

    for (int i = 1; i < numsSize; i++) {
        max_current = (nums[i] > (max_current+nums[i])) ? nums[i] : (max_current+nums[i]);
        if (max_current > max_global) {
            max_global = max_current;
        }
    }

    return max_global;
}

int main() {
    
    int nums_1[] = {-2, 1, -3, 4, -1, 2, 1, -5, 4};
    int nums_2[] = {1};
    int nums_3[] = {5,4,-1,7,8};
    int numsSize_1 = sizeof(nums_1) / sizeof(nums_1[0]);
    int numsSize_2 = sizeof(nums_2) / sizeof(nums_2[0]);
    int numsSize_3 = sizeof(nums_3) / sizeof(nums_3[0]);
    int max_sum_1 = maxSubArray(nums_1, numsSize_1);
    int max_sum_2 = maxSubArray(nums_2, numsSize_2);
    int max_sum_3 = maxSubArray(nums_3, numsSize_3);
    printf("Maximum subarray sum is %d\n", max_sum_1);
    printf("Maximum subarray sum is %d\n", max_sum_2);
    printf("Maximum subarray sum is %d\n", max_sum_3);
    return 0;
}
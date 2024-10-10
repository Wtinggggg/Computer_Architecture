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
    int nums[] = {-2, 1, -3, 4, -1, 2, 1, -5, 4};
    int numsSize = sizeof(nums) / sizeof(nums[0]);
    int max_sum = maxSubArray(nums, numsSize);
    printf("Maximum subarray sum is %d\n", max_sum);
    return 0;
}
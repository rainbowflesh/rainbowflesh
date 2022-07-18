public class runner {
    public static void main(String[] args) {
        Solution solution = new Solution();
        int[] numb = {2, 7, 11, 15};
        int target = 9;
        int[] result = Solution.twoSum(numb, target);
        assert null != result;
        System.out.println("[" + result[0] + " " + result[1] + "]");
    }
}

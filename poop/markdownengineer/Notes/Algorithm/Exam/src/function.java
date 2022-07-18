class Solution {
    static int[] twoSum(int[] numb, int target) {
        for (int i = 0; i < numb.length; i++) {
            for (int j = 0; j < numb.length; j++) {
                if (target == numb[i] + numb[j]) {
                    return new int[]{i, j};
                }
            }
        }
        return null;
    }
}
class parent {
    public void add() {
        System.out.println("parent add");
    }
    public void hello() {
        System.out.println("parent hello");
    }
}
class child extends parent {
    @Override
    public void add() {
        System.out.println("child add");
        super.add();
    }
    @Override
    public void hello() {
        System.out.println("child hello");
        super.hello();
    }
}
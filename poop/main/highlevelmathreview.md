# 高等数学复习

## 函数奇偶性

### 一元函数

+ 一次奇
+ 二次偶
+ 三次奇
+ -1次奇
+ sqrt/二分之一次无奇偶性
+ 幂函数无
+ 对数函数无

### 三角函数

+ sin奇
+ cos偶
+ tan奇
+ cot奇
+ arc sin奇
+ arc cos无
+ arc tan奇
+ arc cot无

### 计算法则

+ 奇+奇=偶
+ 偶+-偶=偶
+ 奇x奇=偶
+ 奇x偶=奇
+ 偶x偶=偶

### 定义域

> 取x存在的区间

## 函数单调性

> 若函数求一次导后y'>0, 则函数单调递增, 反之递减

---

## 导数

### 导数运算法则

+ (A+-B)' = A' +- B'
+ (A*B)' = A'*B + A*B'
+ (A/B)' = (A'*B - A*B')/B^2

### 导数公式

+ C‘ = 0, C 为常数
+ (x^a)' = ax^a-1
+ (a^x)' = a^xlna
+ (e^x)' = e^x
+ (loga x)' = 1/xlna
+ (ln x)' = 1/x
+ (sin x)' = cos x
+ (cos x)' = -sin x
+ (tan x)' = sec^2 x
+ (sec x)' = sec x + tan x
+ (cot x)' = -csc^2 x
+ (csc x)' = -csc x * cot x
+ (arc sin x)' = 1/sqrt(1-x^2) = -(arc cos x)'
+ (arc tan x)' = -1/(1+x^2) = -(arc cot x)'
+ (1/x)' = -1/x^2
+ ln(1+e^x)' = e^x/(1+e^x)
+ ln[f(x)+C]' = 1/[f(x)+C] * f'(x)
+ [e^f(x)^n]' = e^f(x)^n * [f(x)^n]'

---

## 偏导数

---

## 积分

### 不定积分

#### 不定积分公式

$
(1)\int0 \mathrm{dx} = C \\
(2)\int k\mathrm{dx}=kx + C \\
(3)\int x^\mu \mathrm{dx}=\frac1{\mu+1}x^{\mu+1}+C(\mu \ne -1) \\
(4)\int\frac1{x}\mathrm{dx}=\ln|x| + C \\
(5)\int a^x \mathrm{dx}=\frac{a^x}{\ln a} + C \\
(6)\int e^x \mathrm{dx}=e^x + C \\
(7)\int \sin x \mathrm{dx}=-\cos x + C \\
(8)\int \cos x \mathrm{dx}=\sin x + C \\
(9)\int \sec^2 x \mathrm{dx}=\int \frac1{\cos^2 x}\mathrm{dx}=\tan x + C \\
(10)\int \csc^2x\mathrm{dx}=\int \frac1{\sin^2x}\mathrm{dx}=-\cot x + C \\
(11)\int\sec x\tan x\mathrm{dx}=\sec x + C \\
(12)\int \csc x\cot x\mathrm{dx}=-\csc x + C \\
(13)\int \frac{\mathrm{dx}}{\sqrt{1-x^2}}=\arcsin x + C \\
(14)\int \frac{\mathrm{dx}}{1+x^2}=\arctan x + C \\
(15)\int \tan x\mathrm{dx}=-\ln|\cos x| + C \\
(16)\int \cot x \mathrm{dx}=\ln|\sin x| + C \\
(17)\int \sec x \mathrm{dx}=\ln|\sec x+\tan x| + C \\
(18)\int \csc x\mathrm{dx}=\ln|\csc x -\cot x| + C \\
(19)\int \frac{\mathrm{dx}}{x^2+a^2}=\frac1{a}\arctan {\frac{x}{a}} + C \\
(20)\int \frac{\mathrm{dx}}{x^2-a^2}=\frac1{2a}\ln|\frac{x-a}{x+a}| + C \\
(21)\int \frac{\mathrm{dx}}{\sqrt{a^2-x^2}}=\arcsin \frac{x}{a} + C \\
(22)\int \frac{\mathrm{dx}}{\sqrt{x^2\pm a^2}}=\ln|x+\sqrt{x^2\pm a^2}| + C \\
(23)\int \sqrt{a^2-x^2}\mathrm{dx}=\frac{x}{2}\sqrt{a^2-x^2}+\frac{a^2}{2}\arcsin \frac{x}{a} + C \\
(24)\int \sqrt{x^2\pm a^2}\mathrm{dx}=\frac{x}{2}\sqrt{x^2\pm a^2}\pm \frac{a^2}{2}\ln|x+\sqrt{x^2\pm a^2}| + C \\
(25)\int \ln x\mathrm{dx}=x\ln x-x + C \\
(26)\int \frac{e^{a\sqrt{x}}}{\sqrt{x}}{dx} = \frac{2}{a}{e^{a\sqrt{x}}} + C \\
(27)\int \frac{a}{b-{c{x}}}{dx} = \frac{-a}{c}\ln|{b}-{c}{x}| + C \\
$

### 微分

> 微分 d(f(x)) = f'(x)dx

### 微分运算法则

+ d(A+-B) = dA +- dB
+ d(A*B) = A*dB + B*dA
+ d(A/B) = (B*dA - A*dB)/B^2
+ d(C*A) = C*dA
+ d[F(g(x))] = F'(g(x)) * g'(x)

### 定积分例题

+ ∫0到1 (2x+k)dx = 2, k=1

---

## 极限

### 极限计算法则

> Limit properties − if the limit of f(x), and g(x) exists, then:

+ $\lim _{x\to a}$ (x) = a
+ $\lim _{x\to a}$ [c·f(x)] = c·$\lim_{x\to a}$ f(x)
+ $\lim _{x\to a}$ [(f(x))^c] = $\lim_{x\to a}$ f(x)^c
+ $\lim _{x\to a}$ [f(x) ± g(x)] = $\lim_{x\to a}$ f(x) ± $\lim _{x\to a}$ g(x)
+ $\lim _{x\to a}$ [f(x) · g(x)] = $\lim_{x\to a}$ f(x) · $\lim _{x\to a}$ g(x)
+ $\lim _{x\to a}$ [f(x) / g(x)] = $\lim_{x\to a}$ f(x) / $\lim _{x\to a}$ g(x) , where $\lim_{x\to a}$g(x)≠0

### 近似值

> $\lim _{x\to 0}$ 时

+ sinx = x
+ tanx = x
+ e^x = 1+x
+ e^x^a = 1+x^a
+ ln(1+x) = x
+ 1-cosx = 1/2x^2 = -(cosx -1)

#### 利用无穷小的性质求函数的极限

> 性质1: 有界函数与无穷小的乘积是无穷小
>
> 性质2: 常数与无穷小的乘积是无穷小
>
> 性质3: 有限个无穷小相加、相减及相乘仍旧无穷小

### 两个重要极限

+ limx->0 sinx/x =1
+ limx->∞ (1+1/x)^x =e

### 其他常见极限

+ limx->0 1-cosx = (x^2)/2
+ limx->0 sqrt1-x = -x/2
+ limx->0 sinx - tanx = -(x^3)/2
+ limx->0 xsin(n/x) = 0, sin为有界函数, x为无穷小量, 无穷小量×有界函数=0
+ limx->1 lnx = x-1
+ limx->∞ (1+1/ax)^x = e^(1/a)

### 极限类型

#### ∞/∞ 无穷比无穷型

#### 1^∞ 1的无穷次方型

> x^f(x) = 1^∞, 则-> e^f(x)×lnx, 同时 e^f(x)×lnx = 1^∞

### 无穷大小量

> 无穷大小量的阶数: 趋近于无穷大小时, 将原式作为极限计算, 例如:

+ $\lim _{x\to 0}\left({x^2}\right) = {x^2}$
+ $\lim _{x\to 0}\left({1-\cos{x}}\right) = \frac 1{x^2}$
+ $\lim _{x\to 0}\left(\sqrt{1-{x}}-1\right) = -\frac 1{2}{x}$
+ $\lim _{x\to 0}\left(\sin{x}-\tan{x}\right) = {x}-\frac 1{2}{x^3}$

#### 等价无穷大小

> limx->0 [f(x)/g(x)] = 1, 即为等价无穷小

### 常用解法

+ sinx -> x | sinAx -> Ax

### 抓大头

> 看最高次幂->前面的系数

### 常见的等价变换

> x->0时

+ sin(x) -> x
+ sin^2(x) -> x^2
+ ln(1+2x) -> 2x
+ xsinx -> x^2

### 泰勒展开

$
\begin{aligned}
e^{x} &=\sum_{n=0}^{\infty} \frac{1}{n !} x^{n}=1+x+\frac{1}{2 !} x^{2}+\cdots \in(-\infty,+\infty) \\
\sin x &=\sum_{n=0}^{\infty} \frac{(-1)^{n}}{(2 n+1) !} x^{2 n+1}=x-\frac{1}{3 !} x^{3}+\frac{1}{5 !} x^{5}+\cdots, x \in(-\infty,+\infty) \\
\cos x &=\sum_{n=0}^{\infty} \frac{(-1)^{n}}{(2 n) !} x^{2 n}=1-\frac{1}{2 !} x^{2}+\frac{1}{4 !} x^{4}+\cdots, x \in(-\infty,+\infty) \\
\ln(1+x) &=\sum_{n=0}^{\infty} \frac{(-1)^{n}}{n+1} x^{n+1}=x-\frac{1}{2} x^{2}+\frac{1}{3} x^{3}+\cdots, x \in(-1,1] \\
\frac{1}{1-x} &=\sum_{n=0}^{\infty} x^{n}=1+x+x^{2}+x^{3}+\cdots, x \in(-1,1) \\
\frac{1}{1+x} &=\sum_{n=0}^{\infty}(-1)^{n} x^{n}=1-x+x^{2}-x^{3}+\cdots, x \in(-1,1)\\
(1+x)^{\alpha} &=1+\sum_{n=1}^{\infty} \frac{\alpha(\alpha-1) \cdots(\alpha-n+1)}{n !} x^{n}=1+\alpha x+\frac{\alpha(\alpha-1)}{2 !} x^{2}+\cdots, x \in (-1,1)\\
\arcsin x &=\sum_{n=0}^{\infty} \frac{(2 n) !}{4^{n}(n !)^{2}(2 n+1)} x^{2 n+1}=x+\frac{1}{6} x^{3}+\frac{3}{40} x^{5}+\frac{5}{112} x^{7}+\frac{35}{1152} x^{9}+\cdots,x \in (-1,1)\\
\arctan x &=\sum_{n=0}^{\infty} \frac{(-1)^{n}}{2 n+1} x^{2 n+1}=x-\frac{1}{3} x^{3}+\frac{1}{5} x^{5}+\cdots+x \in[-1,1]\\
\tan x &= \sum_{n=1}^{\infty} \frac{B_{2 n}(-4)^{n}\left(1-4^{n}\right)}{(2 n) !} x^{2 n-1}=x+\frac{1}{3} x^{3}+\frac{2}{15} x^{5}+\frac{17}{315} x^{7}+\frac{62}{2835} x^{9}+\frac{1382}{155925} x^{11}+\frac{21844}{6081075} x^{13}+\frac{929569}{638512875} x^{15}+\cdots, x \in\left(-\frac{\pi}{2}, \frac{\pi}{2}\right)
\end{aligned}
$

#### 其他型月世界的泰勒展开

+ $\sqrt{1+x} = {1+x}^\frac{1}{2} = 1+\frac{1}{2x}+o{x}$
+ $\sqrt{1-x} = {1-x}^\frac{1}{2} = 1-\frac{1}{2x}+o{x}$

---

## 级数

### 级数的敛散性

+ 条件收敛: 若级数 ∞∑n=1 |Un| ->发散, ∞∑n=1 Un ->收敛, 则称级数为条件收敛级数
+ 绝对收敛: 若级数 ∞∑n=1 |Un| ->收敛, 则称级数为绝对收敛级数

### P级数

> 形如 ∞∑n=n 1/x^p 的级数
>
> 其中n>0时, p>1 则级数收敛, p<=1时级数发散

### 级数题

设级数∞∑n=1 Bn 为正项级数, ∞∑n=1 (An)^2 收敛, 则级数∞∑n=1 (-1)^n |An|/sqrt下n^2 + Bn
> 绝对收敛.
---

## 各类理论

### 牛顿-莱布尼兹 公式

应用条件:

> 要求被积函数在积分区间内连续

一般类型:

> 找 ∫ 区间 D 上能否存在 x

### 微分中值定理

如果 R 上的函数 f(x) 满足以下条件:(1) 在闭区间 [a,b] 上连续, 在开区间 (a,b) 内可导, 那么:

#### 罗尔定理

> 在开区间 (a,b) 内至少存在一点 ξ ,
>
> 当 f(a)=f(b) 时,
>
> 使得 f'(ξ)=0

#### 拉格朗日中值定理

> 在开区间 (a,b) 内至少存在一点 ξ ,
>
> 使得 f'(ξ)=(f(b)-f(a))/(b-a)

#### 柯西定理

> 用参数方程表示的曲线上至少有一点, 它的切线平行于两端点所在的弦.

### 间断点

定义:
> 如果函数f在点x连续, 则称x是函数f的连续点；如果函数f在点x不连续, 则称x是函数f的间断点

#### 第一类间断点

> 给定一个函数 f(x) 如果 x0 是函数 f(x) 的间断点, 并且 f(x) 在 x0 处的左极限和右极限均存在的点称为第一类间断点.

#### 可去间断点

> 若 f(x) 在 x0 处得到左、右极限均存在且相等的间断点, 称为可去间断点. 需要注意的是, 可去间断点需满足 f(x) 在 x0 处无定义, 或在 x0 处有定义但不等于函数 f(x) 在 x0 的左右极限.
>> 例如 $f\left({x}\right)={x}^{\frac{1}{x-1}}$ x=1 是f(x)的可去间断点: 取极限 $\lim _{x\to 1}{x}^{\frac{1}{x-1}}=e^{\frac {x-1}{x-1}}=e$ 得极限存在, 而 x=1 方程无定义, 故为可去间断点.

#### 跳跃间断点

> 设函数 f(x) 在 U(x0) 内有定义，x0 是函数 f(x) 的间断点 (使函数不连续的点)，那么如果左极限 f(x-) 与右极限 f(x+) 都存在，但 f(x-)≠f(x+), 则称 x0 为 f(x) 的跳跃间断点，它属于第一间断点.
---

### 图形学

#### 各类图形方程

+ 法线方程
    > 111

---

## 其他常见题型

### 变上限积分求导

> 积分上限为参数, 下限为常数, 则 d/dx∫f(t)dt = F(x)-F(a)

### 判断函数间断点

> 若 x=n 直接带入原式无定义, 则使用极限推导-> limx=n 原式

---

## 其他型月世界的计算题

+ 极限 limx->0 {[e^(x^2)]-1}/cosx -1

1. 换元法 x^2 = u
2. 等价 (e^x)-1->x
3. 变形 cosx-1 = -(1-cosx)

    > limx->0 1-cosx = (x^2)/2
4. -(1-cosx)=-(x^2)/2
5. 带入原极限求得 -2

+ 极限 limx=1 x^[1/(x-1)]

1. 原极限为1^∞型, 则-> e^{[1/(x-1)]lnx}
2.
    > limx->1 lnx -> x-1

    带入 1. 得 e^{[1/(x-1)](x-1)}=e
3. x=1无定义, x=1极限存在, 则x=1为可去间断点

---

## 证明题

---

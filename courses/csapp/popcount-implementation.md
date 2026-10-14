# `popcount` 的实现

## 朴素方法

循环，一位位计数。

- 时间复杂度：$\Theta(\log n)$。
- 空间复杂度：$\Theta(1)$。

## Brian Kernighan 算法

基本思想利用 `lowbit` 运算的性质。

```cpp
unsigned brianKernighan(uint32_t n) {
	unsigned cnt = 0;
	while (n) {
		n &= n - 1; // n -= lowbit(n)
		++cnt;
	}
	return cnt;
}
```

- 时间复杂度：$\Theta(\operatorname{popcnt}(n))$，最坏 $\Theta(\log n)$。
- 空间复杂度：$\Theta(1)$。

## SWAR 算法

采用分治思想。对于两个 bits，可以通过直接将两个位做算术加法得到答案。因此对于一个 32 位整数，可以分解为 16 个相邻的 2 bits，然后从底向上合并（做算术加法）。

```cpp
unsigned swarNaive(uint32_t n) {
	n = (n & 0x55555555) + ((n >> 1) & 0x55555555); // 2 位一组
	n = (n & 0x33333333) + ((n >> 2) & 0x33333333); // 4 位一组
	n = (n & 0x0F0F0F0F) + ((n >> 4) & 0x0F0F0F0F); // 8 位一组
	n = (n & 0x00FF00FF) + ((n >> 8) & 0x00FF00FF); // 16 位一组
	n = (n & 0x0000FFFF) + ((n >> 16) & 0x0000FFFF); // 32 位一组
	return n;
}
```

代码中 `0x55` 对应二进制 `0b01010101`，`0x33` 对应 `0b00110011`，`0x0F` 对应 `0b00001111`，等等。

- 时间复杂度：$\Theta(1)$。
- 空间复杂度：$\Theta(1)$。

### 优化

#### 第一个优化

观察两个位：

|    $n$     | $\operatorname{popcnt}(n)$ |
| :--------: | :------------------------: |
| $00_{(2)}$ |         $00_{(2)}$         |
| $01_{(2)}$ |         $01_{(2)}$         |
| $10_{(2)}$ |         $01_{(2)}$         |
| $11_{(2)}$ |         $10_{(2)}$         |

设 $n$ 的二进制分解为 $\vec{n} = (n_i)_{i = 0}^{w - 1}$。考虑第 $i$ 位和第 $i + 1$ 位，这两位的 $\operatorname{popcnt}$ 为
$$
n_i + n_{i + 1} = (2 n_{i + 1} + n_i) - n_{i + 1} ,
$$
所以如果我们要将 $\operatorname{popcnt}\left(\overline{n_{i + 1} n_i}_{(2)}\right)$ 仍然保存在这两位上，则实际上是
$$
\overline{n_{i + 1} n_i}_{(2)} \cdot 2^i \gets \overline{n_{i + 1} n_i}_{(2)} \cdot 2^i  - \left\lfloor\left(\overline{n_{i + 1} n_i}_{(2)} \cdot 2^i\right) / 2^{i + 1}\right\rfloor.
$$
对整个 $n$ 考虑，实际上就是
$$
n \gets n - \lfloor n / 2\rfloor \land \sum_{j = 0}^{w - 1} (j \bmod 2 = 1) \cdot 2^j,
$$
即 `n = n - ((n >> 1) & 0x55555555)`。

#### 第二个优化

当区间长度足够长，以至于不会放不下 $\operatorname{popcnt}$ 的结果时，就不需要先做按位与。$2^b\ \mathrm{bits}\ (b \in \mathbb{N})$ 的最大 $\operatorname{popcnt}$ 的最大结果为 $2^b$，需要 $\lceil\log 2^b\rceil + 1 = b + 1$ 位来存放。如果不超出 $2^{b - 1}$ 位就不需要先按位与，即
$$
b + 1 \leq 2^{b - 1} \iff b \geq 3
$$
时无需先按位与再相加。因此可以依次简化为
```cpp
n = ((n + (n >> 4)) & 0x0F0F0F0F)
n = ((n + (n >> 8)) & 0x00FF00FF);
n = ((n + (n >> 16)) & 0x0000FFFF);
```

#### 第三个优化

从区间长度为 $2^8 = 16$ 位开始，一半的区间长度 $8$ 位（即 $1\ \mathrm{B}$）已足以容纳整个 $32\ \mathrm{bits}$ 的最大结果了，所以可以直接加在一个字节（我们取最高位）里。因此上面的后两行可以进一步缩为
```cpp
n = (n + (n << 8) + (n << 16) + (n <<24)) >> 24;
```
这个多个移位再相加也可以表示为乘法
```cpp
n = (n * 0x01010101) >> 24;
```

---

综合以上优化，我们就得到了 SWAR（SIMD Within A Register）算法。据说这就是 GCC 的 `__builtin_popcount` 在 CPU 不支持该指令的机器上的实现。

```cpp
unsigned swar(uint32_t n) {
	n = n - ((n >>1) & 0x55555555);
	n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
	n = (n + (n >> 4)) & 0x0F0F0F0F;
	return (n * 0x01010101) >> 24;
}
```

类似地，可以写出针对 64 位整数的版本：
```cpp
unsigned swar(uint64_t n) {
	n = n - ((n >> 1) & 0x5555555555555555);
	n = (n & 0x3333333333333333) + ((n >> 2) & 0x3333333333333333);
	n = (n + (n >> 4)) & 0xF0F0F0F0F0F0F0F;
	return (n * 0x101010101010101) >> 56;
}
```

## 查表法

对一个字节的 256 种情况打标，然后逐字节加起来。有点没绷住。

据说这是某些旧版及某些罕见平台上的 GCC 的实现。

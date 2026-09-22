# Codeforces Round 1122 (Div. 3)

~~我是废物啊啊啊唉唉~~

## B. Three Piles

博弈论卡我一个多小时……

> Alice 和 Bob 初始时分别有 $a_0,b_0 \in \mathbb{N}$ 个石头，另外还有 $c_0 \in \mathbb{N}$ 个自由的石头。他们两个轮流来，从 Alice 开始。每一轮，当前玩家可以从自由石头中选择任意个（包括 $0$ 个）给自己。如果在连续两轮中，轮到的玩家都选择不拿石头（即都选择 $0$ 个）则游戏结束。设结束时 Alice 和 Bob 分别有 $A,B$ 个石头，定义分数为 $S = |B - A|$。Alice 要最大化 $S$，Bob 则要最小化 $S$，他们都按最优策略游戏。求最终的分数 $S$。
>
> 保证 $a_0,b_0,c_0 \leq 10^9$。

对于任何时刻，设 Alice 有 $a$ 个石头，Bob 有 $b$ 个石头，还有 $c$ 个自由的石头。显然我们无需关心 $a,b$ 的具体数值，而只需关注他们的差值 $d = b - a$。Alice 只能让 $d$ 减小，而 Bob 只能让 $d$ 增大。

一个显然的观察是，当 $d \leq 0$ 且轮到 Alice 时，Alice 必然拿完所有剩下的石头；当 $d \geq 0 \land d - c \leq -|d| = -d$ 且轮到 Alice 时，他也会拿完所有剩下的石头；当 $d \leq 0 \land d + c \leq 0$ 且轮到 Bob 时，Bob 必然拿完所有剩下的石头。

显然 $c = 0$ 时游戏自动结束。但有一个错误的认识是，游戏结束时必然所有石头都被拿完。~~我在想了一个小时以后才意识到这一点。~~存在一些情况，使得双方都不能拿。例如，当 $d = 3,\ c = 2$ 时，Alice 无论拿多少都会使分数变小，Bob 无论怎么拿都会使分数变大。

与以上认识同时产生的一个不那么显然的观察是，当 $d > 0 \land d - c < -|d|= -d$ 且轮到 Alice 时，Alice 不会拿石头，因为这只会使自己更劣；而当 $d > 0$ 时，Bob 也不会拿，因为他只能让 $d$ 增加，这会对他更劣。这时游戏会达到平衡而结束。

于是问题就解决了。

```cpp
inline int64_t solve(int64_t d, int64_t c) {
	if (c == 0) {
		return d;
	}
	if (d <= 0) {
		return (d - c);
	}
	assert(d > 0);
	if (d - c <= -d) {
		return solve(-d, c - 2 * d); // 剩余的石头允许 Alice 从正数跨越零点到达相反数
	}
	return d;
}
```

时间复杂度和空间复杂度都是 $\Theta(1)$。

## D. Falling Concrete

真的差一点就想出来了啊……

> 给定 $\vec{a} = (a_i)_{i = 0}^{n - 1} \in (\mathbb{N} \cap [n, 10^9])^n\ (n \in \mathbb{N}^*)$。每次操作可以选取 $l,r \in \mathbb{N}\ (0 \leq l < r < n)$，令
> $$
> (a_i)_{i = l}^r \gets \begin{bmatrix} a_r - (r - l) & (a_{l + i} + 1)_{i = 0}^{r - l - 1} \end{bmatrix}.
> $$
> 将一个子段称为*平坦的*，如果该子段内各元素相等。定义 $\vec{a}$ 的平坦长度为其最大平坦子段的长度。
>
> 可以执行任意有限次操作，求由此可以获得的 $\vec{a}$ 的最大的平坦长度。
>
> 保证 $n \leq 2 \times 10^5$。

我注意到对区间的操作可以分解为对区间内的相邻项分别进行操作，且与顺序无关。对于 $i \in \mathbb{N} \cap [0, n - 1)$，对第 $i$ 和 $i + 1$ 项进行操作是有意义的，当且仅当 $a_i + 2 \leq a_{i + 1}$。因此，暴力的做法是，每次扫描 $\vec{a}$ 中可以交换的相邻项并交换，直至没有可以交换的项。结果是唯一的。

我注意到每次交换时，相邻项的和不变，但对于问题似乎没有益处。

直觉使我想到可以对每个 $i \in \mathbb{N} \cap [0, n)$ 做 $a_i \gets a_i - i$，但我不知道这样做有甚么好处。于是我不会了。

我真的差一点就想到了啊！我甚至列出了这样的形式：
$$
\begin{matrix}
i & i + 1 \\
a_{i + 1} - 1 & a_i + 1
\end{matrix}
$$
以及
$$
\begin{matrix}
0 & 1 & 2 & 3 & 4 \\
5 & 5 & 5 & 9 & 8 \\
5 & 4 & 3 & 6 & 4
\end{matrix}
$$
偏偏没有想出那个关键点。

这里的关键点就是，做 $a_i \gets a_i - i$ 后**就可以任意交换了**，因为在每次操作中，$a_i - i$ 都是不变的，这是此题的<u>**不变量/守恒量**</u>。我们想要原数组连续一段相等，只需这一段在做 $-i$ 处理后是对形如 $\mathbb{N} \cap [b, e)$ 的集合的排列即可。例如，上面的示例中 $(5, 4, 3, 6)$ 是对 $\{3, 4, 5, 6\}$ 的排列，对应原数组操作后的 $(6, 6, 6, 6)$。

因此，只需令 $\vec{a} = (a_i - i)_{i = 0}^{n - 1}$，然后排序、去重，找出满足 $(a_{b + i})_{i = 0}^{e - b - 1} = (x + i)_{i = 0}^{e - b - 1}\ (b,e,x \in \mathbb{N},\ b < e \leq n)$ 的 $b,e$ 即可。

```cpp
inline void solve() {
	size_t n;
	std::cin >> n;
	std::vector<uint32_t> arr(n);
	for (size_t i = 0; i < n; ++i) {
		std::cin >> arr[i];
		assert(arr[i] >= n);
		arr[i] -= i;
	}
	std::sort(arr.begin(), arr.end());
	arr.erase(std::unique(arr.begin(), arr.end()), arr.end());
	size_t max = 1, cur = 1;
	for (size_t i = 1; i < arr.size(); ++i) {
		if (arr[i] == arr[i - 1] + 1) {
			++cur;
			if (cur > max) {
				max = cur;
			}
		} else {
			cur = 1;
		}
	}
	std::cout << max << '\n';
}
```

时间复杂度：$\Theta(n \log n)$。

空间复杂度：排序所需的空间 $O(\log n)$。

## E. Prime Destruction

> 给定一个由 $n \in \mathbb{N}^*$ 个不超过 $n$ 的正整数构成的多重集 $S$ 和 $m \in \mathbb{N}^*\ (m \leq n)$。每次操作中，可以选择一个整数 $x > 1$ 和 $x$ 的一个质因数 $p$，从 $S$ 中移除**一个** $x$ 再加入 $p$ 个 $\frac{x}{p}$。可以进行任意有限次操作，求使 $S$ 的所有元素都不超过 $m$ 所需的最小操作次数。
>
> 保证 $n \leq 2 \times 10^5$。

这里的子问题结构是很明显的：将任何一个 $x$ 分解直至全都不超过 $m$，可以枚举其所有质因数 $p$，此时的次数为分解 $p$ 个 $\frac{x}{p}$ 所需的次数。对所有 $p$ 取操作次数最小的作为答案。

考虑模仿埃氏筛的思路进行枚举。

```cpp
constexpr uint32_t N = 2e5;
std::vector<uint32_t> primes;

inline void solve() {
	uint32_t m, n;
	std::cin >> n >> m;
	std::vector<uint64_t> dp(n + 1);
	for (uint32_t i = m + 1; i <= n; ++i) {
		dp[i] = UINT64_MAX;
	}
	for (uint64_t i = 1; i <= n; ++i) {
		for (auto prime : primes) {
			auto val = i * prime;
			if (val > n) {
				break;
			}
			dp[val] = std::min(dp[val], dp[i] * prime + 1);
		}
	}
	uint64_t ans = 0;
	for (uint32_t i = 0; i < n; ++i) {
		uint32_t qry;
		std::cin >> qry;
		ans += dp[qry];
	}
	std::cout << ans << '\n';
}
```

可以容易计算出时间复杂度的一个上界：即使内层循环我们枚举所有 $\mathbb{N} \cap \left[1, \frac{m}{i}\right]$ 而非质数，时间复杂度也为
$$
\sum_{i = 1}^n \frac{m}{i} \leq m \log n,
$$
所以时间复杂度为 $O(m \log n)$。实际上由于质数的数量是 $o(n)$ 的，所以总的复杂度也要小得多。

总的时间复杂度还取决于选用的质数筛。

空间复杂度：$\Theta(n)$。

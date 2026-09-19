# 2026 ICPC Asia EC Preliminary Round 2

这把坐牢……

## K. K-MEX

> 给定 $\vec{a} = (a_i)_{i = 0}^{n - 1} \in \mathbb{N} ^n\ (n \in \mathbb{N}^*)$。
>
> 定义一次 $k$-变换为，对每个 $i \in \mathbb{N} \cap [0, n)$，独立地选择保持 $a_i$ 不变或替换 $a_i \gets k - a_i$，由此得到一个新的数组 $\vec{a'}$。
>
> 定义 $k\text{-}\operatorname{mex}(a)$ 为所有通过 $k$-变换得到的 $a'$ 中 $\operatorname{mex}(a')$ 的最大值。
>
>
> 进行 $q \in \mathbb{N}^*$ 次查询，每次指定一个 $k \in \mathbb{N}$，求 $k\text{-}\operatorname{mex}(a)$。
>
> 一共 $t \in \mathbb{N} \cap [1, 10^3]$ 组测试用例，保证 $a_i \leq 10^9$，$\sum n \leq 5 \times 10^3$，$\sum q \leq 5 \times 10^5$。

比赛时的想法如下，主要由我的队友提供：

几个观察：

- 过大的 $k$ （具体来说，大于 $n$）没有意义，因为下方必定出现空缺。
- 允许 $O(n^2)$ 的预处理，但查询复杂度必须是 $o(n)$（严格低于 $\Theta(n)$）。
- 出现次数为 $1$ 且小于 $k$ 的数不能往上补。

基于这几个观察，我们提出了以下思路。

1. 考虑 $\mathbb{N} \cap [0, n]$ 中的“空位”，即没有在 $\vec{a}$ 中出现的数，从小到大排序后记作 $\vec{b} = (b_i)_{i = 0}^{m - 1}$，称为“空位”。空位显然至少存在一个，因为长为 $n$ 的 $\vec{a}$ 不可能覆盖 $\mathbb{N} \cap [0, n]$ 这 $n + 1$ 个数。
1. 设立一些桶，编号为 $i$ 的桶内将要存放能够通过 $i$-变换补上的空位。编号是离散的。
1. 对于第 $i \in \mathbb{N} \cap [0, m)$ 个空位 $b_i$，如果要通过变化第 $j \in \mathbb{N} \cap [0, n)$ 个元素 $a_j$ 来补上这个空位，就需要对其进行一次 $(b_i + a_j)$-变换，因此将 $b_i$ 放入编号为 $(b_i + a_j)$ 的桶。特别地，对于出现次数为 $1$ 且小于 $b_i$ 的 $a_j$，不进行记录。
1. 对每个桶，将其与 $\vec{b}$ 比较，找出最小的未被覆盖的空位。
1. 开始查询。对每次查询，如果对应的桶不存在，就直接返回 $n$（因为没有需要利用这个数去补的空位），否则查询对应桶的答案。

按照设想，如果每个桶开一个哈希表，因为总共最多 $n$ 个空位，每个空位最多有 $n$ 个元素可以补上，所以所有哈希表最多 $O(n^2)$ 个元素。第 3 步的均摊时间复杂度为 $\Theta(m \cdot n) = O(n^2)$，第 4 步的也是 $O(n^2)$（因为桶中每个元素最多被访问一次），每次查询的时间复杂度为 $\Theta(1)$。然而，尽管我们想尽一切手段降低常数（包括用其他数据结构存储桶），我们一直都在 TLE。本地运行随机数据甚至高达 14 秒。

而事实上，即使不 TLE，以上做法也是错误的，因为对于出现次数为 $1$ 但比空位大的元素，虽然能够往下补，但会导致他本身出现空位，这是我们的思路未考虑到的。例如，对于 $\vec{a} = (1, 2, 100)$，查询 $k = 1$，答案应为 $1$ 但上面的算法输出 $3$。

---

GPT 5.6 Sol 大人轻松给出正解，而且我觉得讲得很清晰，所以我不自行改写了。

设
\[
c_x=\#\{i\mid a_i=x\}, \qquad m=\operatorname{mex}(a).
\]
关键在于：对于固定的 \(k\)，原值为 \(x\) 的元素只能在
\[
x,\quad k-x
\]
之间选择。因此，数值会按照映射 \(x\leftrightarrow k-x\) 被分成若干互不相交的组。

### 1. 如何判断一个前缀能否全部出现

若最终数组的 mex 至少为 \(r+1\)，就必须同时包含
\[
0,1,\ldots,r.
\]
依次考察当前需要覆盖的数 \(y\)，令
\[
z=k-y.
\]
能够变成 \(y\) 的元素只能来自原数组中的 \(y\) 或 \(z\)。

分三种情况。

#### 情况一：\(z<0\)

此时原数组元素不可能等于 \(z\)，所以只能使用原值为 \(y\) 的元素：
\[
c_y\ge 1.
\]

#### 情况二：\(z=y\)

也就是 \(k=2y\)。变换不会产生另一个不同的值，仍只需要：
\[
c_y\ge 1.
\]

注意这里不能写成 \(c_y+c_z\)，否则会把同一批元素计算两次。

#### 情况三：\(z\ge 0\) 且 \(z\ne y\)

数值 \(y,z\) 共用同一批
\[
c_y+c_z
\]

个元素。

- 若 \(z>y\)，当前只要求覆盖 \(y\)，因此需要
  \[
  c_y+c_z\ge 1.
  \]

- 若 \(z<y\)，由于我们按从小到大的顺序扫描，\(z\) 也已经需要被覆盖，所以现在必须同时覆盖 \(z,y\)，需要
  \[
  c_y+c_z\ge 2.
  \]

由于不同的二元组 \(\{x,k-x\}\) 之间互不共享元素，这些条件不仅必要，而且充分。

因此，从 \(0\) 开始扫描，第一个不满足条件的 \(y\)，就是答案。

不过直接对每个查询扫描 \(O(n)\) 仍然太慢，需要继续优化。

### 2. 只有很少的 \(k\) 可能改变答案

先考虑原数组的 mex：
\[
m=\operatorname{mex}(a).
\]

保留所有元素不变，就能保证答案至少为 \(m\)。

若想让答案严格大于 \(m\)，最终数组中必须出现 \(m\)。因为原数组中没有 \(m\)，某个元素必须通过变换变成 \(m\)：
\[
k-a_i=m.
\]

也就是
\[
k=m+a_i.
\]

所以：

- 如果 \(k\) 不属于集合
  \[
  \{m+a_i\mid 0\le i<n\},
  \]

  那么不可能产生 \(m\)，答案一定就是 \(m\)。

- 只有至多 \(n\) 个不同的 \(k\) 需要真正计算。

对每个这样的候选 \(k\)，用前面的判定方法扫描一次即可。

另外，任何长度为 \(n\) 的数组都不可能同时包含 \(0,1,\ldots,n\)，所以答案一定不超过 \(n\)。扫描到 \(n\) 即可结束。

### 3. 为什么可以从 \(m\) 开始扫描

所有小于 \(m\) 的值本来就都存在。

若某一组的两个值都小于 \(m\)，原数组中这两个值各至少出现一次，所以一定有至少两个元素可用。

若扫描到某个 \(y\ge m\)，而它的搭档 \(k-y<m\)，此时判定条件会要求这一组至少有两个元素，已经自动考虑了“小于 \(m\) 的搭档也需要被保留”。

因此候选 \(k\) 的扫描可以直接从 \(m\) 开始。

```cpp
inline void solve() {
	size_t n;
	std::cin >> n;
	std::vector<uint32_t> arr(n);
	std::unordered_map<uint32_t, uint32_t> cnts;
	cnts.reserve(n);
	for (auto &e : arr) {
		std::cin >> e;
		++cnts[e];
	}
	uint32_t mex = 0;
	while (cnts.contains(mex)) {
		++mex;
	}
	auto countOf = [&cnts](uint32_t key) {
		auto iter = cnts.find(key);
		return ((iter == cnts.end()) ? 0 : iter->second);
	};
	std::unordered_map<uint32_t, uint32_t> anss;
	anss.reserve(n * n);
	for (auto [val, cnt] : cnts) {
		auto sum = mex + val;
		uint32_t ans = -1;
		for (uint32_t x = mex; x <= n; ++x) {
			bool found = false;
			if (sum < x || sum == (x << 1)) {
				found = (countOf(x) >= 1);
			} else {
				auto y = sum - x;
				assert(x != y); // otherwise sum == (x << 1)
				uint32_t required = ((x < y) ? 1 : 2);
				found = (countOf(x) + countOf(y) >= required);
			}
			if (!found) {
				ans = x;
				break;
			}
		}
		assert(~ans);
		anss.emplace(sum, ans);
	}
	uint32_t q;
	std::cin >> q;
	uint32_t ans = 0;
	for (uint32_t i = 0; i < q; ++i) {
		uint32_t qry;
		std::cin >> qry;
		auto iter = anss.find(qry);
		ans ^= ((iter == anss.end()) ? mex : iter->second);
	}
	std::cout << ans << '\n';
}
```

第 20 行的 `reserve` 在 hack 数据下是必需的，尽管在不预留时也可以通过正式数据。比赛结束后这道题疯狂被 hack。

时间复杂度：\(O(n^2 + q)\)。

空间复杂度：\(O(n^2)\)。

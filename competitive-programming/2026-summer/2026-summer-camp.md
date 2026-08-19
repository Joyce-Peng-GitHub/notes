# 2026 年 ACM 暑假集训

[TOC]

## 2026 牛客暑期多校训练营 1

### F. Permutation Generation

> 给定 $n \in \mathbb{N}^*$，记 $N = \mathbb{N} \cap [0, n)$。 对于 $N$ 的一个排列 $p = (p_i)_{i = 0}^{n - 1}$，记
> $$
> f(p) = \sum_{i = 0}^{n - 1} \sum_{j = i + 1}^{n - 1}(p_j - p_i).
> $$
> 现在给出 $N$ 的一个排列 $p$ 和 $k,v \in N$，你需要求出 $N$ 的一个排列 $q = (q_i)_{i = 0}^{n - 1}$，使得以下条件都成立：
>
> - $q_k = v$。
> - $f(p) \equiv f(q) \pmod{n}$。
>
> 或报告无解。
>
> 保证 $n \leq 2 \times 10^5$。

$f$ 是容易化简的：
$$
f(p) = \sum_{i = 0}^{n - 1} p_i (i - (n - 1 - i)) = \sum_{i = 0}^{n - 1} p_i (2i - n + 1).
$$
如果再利用上 $p$ 是排列这一性质的话，还可以进一步化简为
$$
f(p) = 2 \sum_{i = 0}^{n - 1} p_i i - \dfrac{1}{2} n (n - 1)^2.
$$
我和一位队友都注意到，如果交换 $p$ 的第 $x$ 和第 $y$ 项得到 $p'$，会使其函数值变化
$$
f(p') - f(p) = -2 (y - x) (p_y - p_x).
$$
因此一直在考虑，要么从 $p$ 交换出 $q_k = v$ 后再想办法消除其影响，或直接从顺序交换出 $q_k = v$ 后再凑出 $f(q) \equiv f(p) \pmod{n}$。我甚么办法也没想出来，队友倒是搞出了一种，但没有覆盖到所有情况，导致 WA。

后来我们通过枚举小的数据，观察到都是有解的，因此猜测必定有解，但没有甚么用。

当另一位队友终于写完 J 题大模拟后再看此题时，观察枚举的数据时注意到每个 $n$ 都有答案可以通过 circular shift（循环移动？）得到，遂出正解。

这里证明一下正确性：设将 $p$ 循环左移一位得到 $p'$，有
$$
\begin{align}
f(p') & = \sum_{i = 0}^{n - 1} p_i (2(i - 1) - n + 1) + 2np_0 \\
& = \sum_{i = 0}^{n - 1} p_i (2i - n + 1) - 2 \sum_{i = 0}^{n - 1} p_i + 2 n p_0 \\
& = f(p) - n (n - 1) + 2 n p_0 \\
& \equiv f(p) \pmod{n}.
\end{align}
$$
所以只需通过循环移动使第 $k$ 位为 $v$ 即可。时间复杂度 $O(1)$。

后来 Gemini 告诉我们，在出现 $\bmod n$ 时应当优先考虑 circular shift。这是我们没有经验。

```cpp
inline void solve() {
	uint32_t n, idx, val;
	std::cin >> n >> idx >> val;
	std::vector<uint32_t> perm(n);
	uint32_t pos;
	for (uint32_t i = 0; i < n; ++i) {
		std::cin >> perm[i];
		if (perm[i] == val) pos = i;
	}
	uint32_t lsh = pos - idx + n;
	if (lsh >= n) lsh -= n;
	for (uint32_t i = lsh; i < n; ++i) {
		std::cout << perm[i] << ' ';
	}
	for (size_t i = 0; i < lsh; ++i) {
		std::cout << perm[i] << ' ';
	}
	std::cout << '\n';
}
```

### G. Precision Error?!

> 给定 $n \in \mathbb{N}^*$，需要找出一个点集 $S \subset \mathbb{R}^3$ 使得
>
> - $|S| \leq 2 n + 2$。
> - $(\forall P \in S)\ (|\{Q \in S: \Vert\vec{PQ}\Vert_2 = 1\}| = n)$。
>
> 为了允许浮点误差，取精度 $\epsilon = 0.01$， $S$ 需要满足
>
> - $(\forall P,Q \in S)\ (P = Q \lor \Vert\vec{PQ}\Vert_2 > \epsilon)$。
> - $|S| \leq 2 n + 2$。
> - $(\forall P \in S)\ (|\{Q \in S: \Vert\vec{PQ}\Vert_2 \in (1 - \epsilon, 1 + \epsilon)\}| = n)$。
>
> 保证 $n \leq 100$。有 $T \leq 100$ 组测试。

看到题解真气笑了。我就说这个 $\epsilon$ 怎么这么大，别的题都是 $10^{-5}$、$10^{-6}$，这里来个 $10^{-2}$，他妈的，果然有蹊跷。

注意到这里的 $\epsilon$ 相当大，所以我们可以通过构造两部分点，使得同一部分的点之间非常近但不比 $\epsilon$ 近，而不同部分的点之间的距离都几乎为 $1$。

对于平面 $z = 0$ 上的一个点，在平面 $z = 1$ 中有一个半径为 $r = \sqrt{(1 + \epsilon)^2 - 1^2} \approx 0.1418 > 14 \epsilon$ 的圆，这个圆内的点到该点的距离都在 $[1, 1 + \epsilon)$。这实际上是因为 $\sqrt{1 + \left(\sqrt{2 \epsilon}\right)^2} = 1 + \epsilon + o(\epsilon^2)$，即圆的半径 $r \approx \sqrt{2 \epsilon}$。我们可以在两个平面上各放 $n$ 个点。为了让两个平面的点互相在对方的容忍范围中，我们需要使它们都位于圆柱 $x^2 + y^2 \leq \left(\dfrac{1}{2} r\right)^2$ 内（当然，圆心位置实际上是任意的）。

简便起见，考虑将每个平面的点以正方形点阵排布，即用一个 $\left\lceil \sqrt{n}\right\rceil \times \left\lceil \sqrt{n}\right\rceil$ 点阵排布这 $n$ 个点。这样的正方形点阵中，设两个点的最近距离（即相邻两点的距离）为 $d$，则两个点的最远距离为 $\left(\left\lceil \sqrt{n}\right\rceil - 1\right) \cdot \sqrt{2} d$。我们希望
$$
\begin{cases}
d > \epsilon && \text{不重合} \\
\left(\left\lceil \sqrt{n}\right\rceil - 1\right) \cdot \sqrt{2} d < 2 \cdot \dfrac{1}{2} r && \text{在圆内}
\end{cases},
$$
解该不等式组得
$$
d \in \left(\epsilon, \dfrac{r}{\sqrt{2} \left(\left\lceil \sqrt{n}\right\rceil - 1\right)}\right)
$$
由 $n \leq 100$ 得上界
$$
\dfrac{r}{\sqrt{2} \left(\left\lceil \sqrt{n}\right\rceil - 1\right)} \geq \dfrac{r}{9\sqrt{2}} \approx 0.01114 > 1.1 \epsilon,
$$
所以完全是可以的。

```cpp
constexpr double D = 0.011;
constexpr size_t N = 100, S = 10; // sqrt(N)

inline void preprocess() {
	std::cout << std::fixed << std::setprecision(9);
}

inline void solve() {
	size_t n;
	std::cin >> n;
	std::cout << (n << 1) << '\n';
	for (size_t i = 0; i < n; ++i) {
		auto [x, y] = std::div(SC<long long>(i), SC<long long>(S));
		for (int z = 0; z < 2; ++z) {
			std::cout << (D * x) << ' ' << (D * y) << ' ' << z << '\n';
		}
	}
}
```

时间复杂度：$O(n)$。

空间复杂度：$O(1)$。

### C. Fish Eating

> 在一个 $m \times n$ 网格上，初始时全是障碍，没有鱼，在之后的若干次操作中会逐渐放置鱼。除了你操作的鱼可以动以外，别的鱼都是静止的。每条鱼有大小。当操作某条鱼时，要么将其移动到鱼已经被吃掉而留下的空白处，要么移动到与它相邻的（四个方向之一）、大小**不大于**它自己的鱼的位置并将其吃掉。每吃掉一条鱼，自己的大小会增加 $1$。
>
> 现在进行 $q$ 次操作，每次会选择下面的某一种操作：
>
> - 给定 $x,y,v$，表示移走 $(x, y)$ 处的障碍，并放置一条大小为 $v$ 的鱼。**保证该鱼的大小 $v$ 不小于此前放的任何一条鱼**。回答这条鱼现在最多**能**吃多少条鱼（不会真的吃）。
> - 给定 $x,y$。设将 $(x, y)$ 处的鱼的大小增大任意值**时**（不会真的增大），它**能**吃掉的鱼的数量最大为 $s$（不会真的吃）。求出**为使**该鱼**能**吃 $s$ 条鱼，其大小**要**增大的值的最小值。
>
> 保证 $m \cdot n \leq 2.5 \times 10^5,\ q \leq 5 \times 10^5$。强制在线处理。

并查集是很容易想到的，因为需要涉及到连通块合并。第一种查询可以容易地用并查集维护。

很容易注意到那个关键的性质：后来的鱼一定不小于已有的鱼。这意味着新加入的鱼的答案可以立刻确定，且对于某一条鱼，它的答案是随着加入的鱼变多不递减（不严格递增）的。比赛时想到这里就不知道怎么办了，仍然只能想出 $O(q^2)$ 做法。

还有一个关键的性质需要注意到：当两个连通块第一次被一条鱼连在一起时，来自一个连通块的鱼要想到达另一个，必须吃这一条“割边鱼”；即便后面加的鱼能使得这条鱼不再是割边，走这条鱼也不会更劣，因为后加的鱼一定不比他小。这启发我们考虑 Kruskal 重构树的思想（然而在比赛时我并不知道这个东西），维护一个带权并查集。

每条鱼都是并查集的一个顶点。对于顶点 $x$，设其父节点为 $p_x$，其权值 $ans_x$ 为“从这条鱼的位置出发，要吃完它所在连通块的所有鱼，初始时的大小的最小值”，当 $x$ 为根节点时还要维护其树大小 $s_x$。在路径压缩时需要更新 $v$ 的权值：
$$
\begin{array}{rl}
1 & \textbf{func $find(x)$:} \\
2 & \qquad \textbf{if $p_x = x$: return $x$} \\
3 & \qquad anc \gets find(p_x) \\
4 & \qquad ans_x \gets \max\{ans_x, ans_{p_x}\} \\
5 & \qquad p_x \gets anc \\
6 & \qquad \textbf{return $anc$}
\end{array}
$$
而当我们插入新的鱼时，要将与之相邻的连通块都以新鱼为根，并更新这些连通块的根的权值：
$$
\begin{array}{rl}
1 & \textbf{func $insertNewFish(i, x_0, y_0, v_i)$:} \quad \textrm{// 第 $i$ 条鱼在 $(x_0, y_0)$ 处，大小为 $v_i$} \\
2 & \qquad p_i \gets i,\ s_i \gets 1,\ ans_i \gets 0 \\
3 & \qquad \text{visit the adjacent grid $(x, y)$ in the 4 directions respectively:} \\
4 & \qquad\qquad \textbf{if \textrm{$(x, y)$ does not have fish} : continue} \\
5 & \qquad\qquad \textrm{Denote the fish at $(x, y)$ as $f$} \\
6 & \qquad\qquad r \gets find(f) \\
7 & \qquad\qquad p_r \gets i \\
8 & \qquad\qquad s_i \gets s_i + s_r \\
9 & \qquad\qquad ans_r \gets \max\{0, v_i - (s_r - 1)\}
\end{array}
$$
对于第二种查询，只需输出 $\max\{0, ans_i - v_i\}$ 即为答案，不过要先执行一次路径压缩以更新答案。

```cpp
size_t m, n, tc_num;
std::vector<std::vector<size_t>> map;
std::vector<uint32_t> vals, ans;
std::vector<size_t> prts, szs;
uint32_t last_ans;

inline void preprocess() {
	std::cin >> m >> n >> tc_num;
	map.resize(m, std::vector<size_t>(n, -1));
	auto tot = std::min(m * n, tc_num);
	vals.reserve(tot);
	ans.reserve(tot);
	prts.reserve(tot);
	szs.reserve(tot);
}

size_t find(size_t x) {
	auto prt = prts[x];
	if (prt == x) return x;
	auto anc = find(prt);
	ans[x] = std::max(ans[x], ans[prt]);
	prts[x] = anc;
	return anc;
}

inline void solve() {
	int op;
	uint32_t x, y;
	std::cin >> op >> x >> y;
	x ^= last_ans, y ^= last_ans;
	--x, --y;

	if (op == 1) {
		assert(map[x][y] == size_t(-1));
		auto id = vals.size();
		map[x][y] = id;
		prts.emplace_back(id);
		szs.emplace_back(1);
		vals.emplace_back();
		std::cin >> vals[id];
		ans.emplace_back(0);

		constexpr std::array<std::pair<int, int>, 4>
			DIRS{{{1, 0}, {0, 1}, {-1, 0}, {0, -1}}};
		for (auto [dx, dy] : DIRS) {
			ptrdiff_t cur_x = SC<ptrdiff_t>(x) + dx, cur_y = SC<ptrdiff_t>(y) + dy;

			if (cur_x < 0 || cur_x >= SC<ptrdiff_t>(m) ||
				cur_y < 0 || cur_y >= SC<ptrdiff_t>(n)) continue;

			if (map[cur_x][cur_y] == size_t(-1)) continue;

			auto rt = find(map[cur_x][cur_y]);
			if (rt == id) continue;

			prts[rt] = id;
			szs[id] += szs[rt];
			ans[rt] = std::max<int64_t>(0, SC<int64_t>(vals[id]) - (szs[rt] - 1));
		}

		last_ans = szs[id] - 1;
	} else if (op == 2) {
		auto id = map[x][y];
		assert(~id);
		find(id);
		last_ans = std::max<int64_t>(0, SC<int64_t>(ans[id]) - vals[id]);
	} else {
		assert(false);
	}
	std::cout << last_ans << '\n';
	std::cerr << last_ans << '\n';
}

inline int mainLoop() {
	for (size_t tc = 0; tc < tc_num; ++tc) {
		solve();
	}
	return 0;
}
```

时间复杂度：$O(m \cdot n + q \log(m \cdot n))$。如果使用哈希表存储地图，可以优化到 $O(q \log(m \cdot n))$。

空间复杂度：$O(m \cdot n + \min\{m \cdot n, q\})$。同样，如果用哈希表存地图，可以优化到 $O(\min\{m\cdot n, q\})$。

### H. Rock-Paper-Scissors Master

> Alice 和 Bob 要玩 $n \in \mathbb{N}$ 轮游戏。牌有石头、剪刀、布三种。两人初始时都各有三张牌，他们的牌始终都是公开的。在每一轮游戏中：
>
> 1. Alice 选择一张牌打出。Bob 知道他打出了哪一张牌。
> 2. 然后，Bob 也需要选择一张牌打出。
> 3. 按照正常的石头剪刀布规则，比较两人的牌。如果 Alice 赢，他的得分加 $3$；如果是平局，他的得分加 $1$；如果 Alice 输了，他的得分不变。
> 4. 已经打出的牌被舍弃。两个玩家各自**独立地**重新抽一张牌，每个玩家抽到每一种牌的概率都是 $\dfrac{1}{3}$。
>
> Alice 需要最大化他的得分，而 Bob 需要最小化 Alice 的得分，他们都采取最优策略。
>
> 给定初始牌组和 $n$，求 Alice 在 $n$ 轮后的期望分数。要求绝对误差和相对误差都不超过 $10^{-6}$。
>
> 保证 $n \leq 10^9$。一共有 $T \leq 10^5$ 组测试点。

Markov 决策过程是甚么？

### L. Substrings of Substrings

## 2026 “钉耙编程”中国大学生算法设计暑期联赛（1）

### 1006. 开关灯

> 给定权值序列 $(a_i)_{i = 0}^{n - 1} \in \mathbb{N}^n$，表示有 $n \in \mathbb{N}^*$ 盏灯，初始时都是熄灭的。在 $\mathbb{N} \cap [0, n)$ 的所有排列中随机选一个记作 $(p_i)_{i = 0}^{n - 1}$，按该顺序依次点亮各灯。设第 $i \in \mathbb{N} \cap [0, n)$ 步时，所有点亮的灯会形成 $c_i$ 个极大连续段，则这一步的得分为 $a_{p_i} \cdot c_i$。求总得分的期望
> $$
> \mathbb{E}\left(\sum_{i = 0}^{n - 1}a_{p_i} \cdot c_i\right),
> $$
> 答案对 $M = 998\,244\,353$ 取模。
>
> 保证 $n \leq 2 \times 10^6$，$(\forall i \in \mathbb{N} \cap [0, n))\ (a_i < M)$。

根据期望的线性性，我们可以将期望表达式转化为
$$
\sum_{i = 0}^{n - 1} a_i \cdot \mathbb{E}(c_{p^{-1}_i}),
$$
但我们并不知道这个期望怎么推。通过对 $n \in [3, 10]$ 打表，我注意到（注意力难得惊人），枚举范围内的所有 $n$ 都满足
$$
N(c_{p^{-1}_0}) = N(c_{p^{-1}_{n - 1}}) = \mathrm{P}_{n}^{n - 3} (n + 4), \\
(\forall i \in \mathbb{N} \cap [1, n - 2])\ (N(c_{p^{-1}_i}) = \mathrm{P}_{n}^{n - 3} (n + 3)),
$$
其中 $N(\cdot)$ 表示古典概型计数。

遂猜出答案。真他妈神了。

下面还是严谨地推导一遍。

j将这 $n$ 个灯从左到右摆一排，则一个极大连续段有且仅有一个左端点。我们可以将连续段计数转换为左端点计数，而一个点是左端点，当且仅当以下条件都成立：

- 该点的灯点亮。
- 该点左侧没有灯或左侧的相邻灯熄灭。

设事件 $IL_{i, j}$ 表示“灯 $i$ 被点亮时（即刚过时刻 $p^{-1}_i$时）灯 $j$ 是某个极大连续段的左端点”。于是
$$
c_{p^{-1}_i} = \sum_{j = 0}^{n - 1} IL_{i, j}.
$$
利用期望的线性性得
$$
\mathbb{E}(c_{p^{-1}_i}) = \sum_{j = 0}^{n - 1} \mathbb{P}(IL_{i, j}).
$$
分类讨论 $IL_{i, j}$：

- 若 $j = 0$：$j$ 左侧没有灯，它是左端点当且仅当它亮起。

  - 若 $i = 0$：显然 $\mathbb{P}(IL_{0, 0}) = 1$。

  - 若 $i \neq 0$：$\mathbb{P}(IL_{i, 0}) = \mathbb{P}(p^{-1}_i < p^{-1}_0)$。因为 $\vec{p}$ 是随机选取得排列，根据对称性和 $i \neq 0$，有
    $$
    \mathbb{P}(p^{-1}_i < p^{-1}_0) = \mathbb{P}(p^{-1}_0 < p^{-1}_i) = \dfrac{1}{2}.
    $$

- 若 $j \neq 0$：

### 1005. 摩卡数

> 设 $\Sigma$ 是字母表（记其中第 $i \in \mathbb{N} \cap [0, |\Sigma|)$ 个字母为 $\sigma_i$）。对于字符串 $s \in \Sigma^n$，记其前缀函数为 $\pi$，其中
> $$
> \pi_i = \max\{j \in \mathbb{N} \cap [0, i]: s_{[0, j)} = s_{[i - j + 1, i]} \}\ (i \in \mathbb{N} \cap [0, n)).
> $$
> 现在有算法
> $$
> \begin{array}{rl}
> 1 & \textbf{func $count(\Sigma, s)$:} \\
> 2 & \qquad cnt \gets 0 \\
> 3 & \qquad \textbf{for $i \in \mathbb{N} \cap [0, n - 2]$:} \\
> 4 & \qquad\qquad \textbf{for $c \in \Sigma$:} \\
> 5 & \qquad\qquad\qquad k \gets i \\
> 6 & \qquad\qquad\qquad \textbf{while $k > 0 \land s_k \neq c$:} \\
> 7 & \qquad\qquad\qquad\qquad cnt \gets cnt + 1 \\
> 8 & \qquad\qquad\qquad\qquad k \gets \pi_{k - 1} \\
> 9 & \qquad \textbf{return $cnt$}
> \end{array}
> $$
> 给定 $t \in \mathbb{N}^*$，需要选取合适的 $\Sigma$ 和 $s \in \Sigma^n\ (n \in \mathbb{N}^*)$，使得 $count(\Sigma, s) = t$。
>
> 保证 $t \leq 10^9$，要求 $|\Sigma| \leq 26$ 且其中的字母从 $\texttt{a}$ 开始按拉丁字母顺序取，要求 $n \leq 10^5$。有不超过 $50$ 组测试数据。

猜到了只需取 $\Sigma = \{\texttt{a}, \texttt{b}\}$。可惜没注意到在连续的 $\texttt{a}$ 后面放连续的 $\texttt{b}$ 是甚么效果。

$count$ 的返回值实际上就是从各个位置出发的错配次数之和，错配时会将指针 $k$ 按照前缀函数往前跳。

为了简便，先考虑只有一个字母的情况，即 $\Sigma = \{\texttt{a}\}$。此时因为都是同一个字母，所以不存在错配，即答案始终为 $0$。

那末，接下来考虑两个字母的情况，即 $\Sigma = \{\texttt{a}, \texttt{b}\}$。既然限制 $|\Sigma| \leq 26$，我猜大概率是主要靠 $s$ 做手脚，字母表取两个字母就够了（在计算理论中，两个字母也是最常用的字母表）。稍微考虑一下也容易发现，更多字母会导致计算答案时乘上因数，这会限制我们的发挥，对我们是很不利的。

在这种字母表下考虑字符串 $\texttt{a}^n$。容易发现，此时每个位置都有 $\pi_i = i + 1$，所以每次错配只会往前跳一步，从 $i$ 出发会错配 $i + 1$ 次，所以
$$
(\forall n \in \mathbb{N})\ \left(count(\Sigma, \texttt{a}^n) = \sum_{i = 0}^{n - 2} (i + 1) = \dfrac{1}{2} n (n - 1)\right).
$$
此后我考虑了能否通过交替两字母的连续段来构造，失败，因为第二次出现的 $\texttt{a}$ 段会受第一次的影响，$\texttt{b}$ 段同理。

实际上，只需要构造 $\texttt{a}^m\texttt{b}^n$ 就可以。对于 $\texttt{a}$ 段，它的贡献由上面的公式可以得到，且不会受到 $\texttt{b}$ 段影响；$\texttt{b}$ 段因为前缀函数都是 $0$（因为字符串开头没有 $\texttt{b}$），所以每个 $\texttt{b}$ 贡献都是 $1$，而且同样也不会受到前面 $\texttt{a}$ 的影响。因此，
$$
(\forall m \in \mathbb{N})\ (\forall n \in \mathbb{N})\ \left(count(\Sigma, \texttt{a}^m \texttt{b}^n = \dfrac{1}{2} m (m - 1) + n\right).
$$
取 $m = \max\left\{x \in \mathbb{N}: \dfrac{1}{2} x (x - 1) \leq t\right\} = \left\lfloor\dfrac{1 + \sqrt{8 t + 1}}{2}\right\rfloor$，$n = t - \dfrac{1}{2} m (m - 1)$ 即可，此时 $n < m \leq \left\lfloor\dfrac{1 + \sqrt{8 \times 10^9 + 1}}{2}\right\rfloor = 44721 < 5 \times 10^4$，所以 $m + n < 2m < 10^5$。

```cpp
inline uint32_t findMax(uint32_t target) {
	constexpr double EPS = 1e-6;
	return std::floor((std::sqrt(8 * SC<double>(target) + 1) + 1) / 2 + EPS);
}

inline void solve() {
	uint64_t target;
	std::cin >> target;
	size_t m = findMax(target);
	size_t n = target - ((SC<uint64_t>(m) * (m - 1)) >> 1);
	std::cout << (m + n) << " 2\n";
	for (size_t i = 0; i < m; ++i) std::cout << 'a';
	for (size_t i = 0; i < n; ++i) std::cout << 'b';
	std::cout << '\n';
}
```

时间复杂度：$\Theta(\sqrt{t})$。

空间复杂度：$\Theta(1)$。

## 2026 牛客暑期多校训练营 2

最菜的一集。

### B. Bitwise Maximization

> 给定 $(a_i) \in \mathbb{N}^n\ (n \in \mathbb{N}^*)$，记 $N = \mathbb{N} \cap [0, n)$，求
> $$
> \max_{S \subseteq N} \left(\bigoplus_{i \in S} a_i + \bigoplus_{i \in N \setminus S} a_i\right).
> $$
> 保证 $n \leq 5 \times 10^5$，$(\forall i \in N)\ (a_i < 2^{30})$。

~~三个人想了四小时也没能想出来。首 A 六分钟就过了。太绝望了。~~

记 $s = \bigoplus_{i \in S} a_i$。我们考虑过将原式化为
$$
\bigoplus_{i \in S} a_i + \left(\bigoplus_{i \in S} a_i\right) \oplus s,
$$
但然后该怎么办就不知道了。ChatGPT 在这里使用了恒等式
$$
x + y = (x \oplus y) + 2(x \land y),
$$
于是原式化为
$$
\begin{align}
& \left(\left(\bigoplus_{i \in S} a_i\right) \oplus \left(\bigoplus_{i \in S} a_i\right) \oplus s\right)+2\left(\left(\bigoplus_{i \in S} a_i\right) \land \left(\left(\bigoplus_{i \in S} a_i\right) \oplus s\right)\right) \\
= & s + 2\left(\left(\bigoplus_{i \in S} a_i\right) \land \neg s \right).
\end{align}
$$
利用与对异或的分配律
$$
(x \oplus y) \land z = (x \land z) \oplus (y \land z)
$$
可进一步化为
$$
2 \bigoplus_{i \in S} (a_i \land \neg s) + s
$$
因为 $s$ 已为定值，只需选取 $S \subseteq N$ 最大化该式即可。

> 题解从另一个角度考虑，代替了与对异或的分配律：$(s)_{(2)}$ 中的 $1$ 在结果中必然为 $1$，无需考虑；所以我们只需考虑 $(s)_{(2)}$ 中的为 $0$ 位，即
> $$
> \left(\bigoplus_{i \in S} a_i\right) \land \neg s = \bigoplus_{i \in S} (a_i \land \neg s).
> $$

最大子集异或和问题可以用**异或线性基**解决。我还给别人讲课讲过这个呢，看题解的时候还是没想到，真是废物，误人子弟。

```cpp
inline void solve() {
	constexpr unsigned B = 30;
	size_t n;
	std::cin >> n;
	std::vector<uint32_t> arr(n);
	uint32_t sum = 0;
	for (auto &e : arr) {
		std::cin >> e;
		sum ^= e;
	}

	for (auto &e : arr) e &= ~sum;

	std::array<uint32_t, B> bases{};
	for (auto e : arr) {
		for (unsigned i = B; i--;) {
			if ((e >> i) & 1) {
				if (!bases[i]) {
					bases[i] = e;
					break;
				}
				e ^= bases[i];
			}
		}
	}

	uint32_t ans = 0;
	for (unsigned i = B; i--;) {
		ans = std::max(ans, ans ^ bases[i]);
	}
	ans = (ans << 1) + sum;
	std::cout << ans << '\n';
}
```

时间复杂度：$\Theta(Bn)$，其中 $B = \log(\max \vec{a})$。

空间复杂度：$\Theta(n + B)$。

### G. GCD Graph

> 给定 $n \in \mathbb{N}^*$。构造这样一张有向图 $G = (V, E)$，其中 $V = [n]$，
> $$
> E = \{(u, v, w) \in V \times V \times \mathbb{N}: u < v \land w = \gcd(u, v)\}.
> $$
> 记 $\delta(u, v)\ (u,v \in V,\ u < v)$ 表示从 $u$ 到 $v$ 的最短路。给出 $l, r \in [n]\ (l \leq r < n)$，求
> $$
> \sum_{i = l}^r \delta(i, n).
> $$
> 保证 $n \leq 10^7$。
>
> 有不多于 $100$ 组测试数据。

我枚举几项后注意到
$$
\delta(u, v) = 1 + (u \not\perp v).
$$
遂想要通过线性筛分解质因数，然后用容斥数出不互质的数的个数。

```cpp
constexpr uint64_t N = 1e7;
std::vector<bool> not_prime(N + 1);
std::vector<uint64_t> primes;
std::vector<uint64_t> mpfs(N + 1, UINT32_MAX);

inline void preprocess() {
	primes.emplace_back(2);
	for (uint64_t i = 1; (i << 1) <= N; ++i) {
		mpfs[i << 1] = 2;
	}
	for (uint64_t i = 3; i <= N; i += 2) {
		if (!not_prime[i]) {
			primes.emplace_back(i);
			mpfs[i] = i;
		}
		for (auto j : primes) {
			if (j * i > N) break;
			not_prime[j * i] = true;
			mpfs[j * i] = j; // j is the minimum prime factor of i * j
			if (i % j == 0) break;
		}
	}
}

inline void solve() {
	uint64_t l, r, n;
	std::cin >> l >> r >> n;
	std::vector<uint64_t> factors;
	factors.reserve(7);
	for (uint64_t i = n; i > 1;) {
		auto mpf = mpfs[i];
		factors.emplace_back(mpf);
		while (i > 1 && i % mpf == 0) {
			i /= mpf;
		}
	}

	uint64_t ans = 0;
	assert(factors.size() < 32);
	for (uint64_t i = 1; i < (uint64_t(1) << factors.size()); ++i) {
		uint64_t prod = 1;
		for (unsigned j = 0; j < SC<unsigned>(factors.size()); ++j) {
			if (i & (1u << j)) {
				prod *= factors[j];
			}
		}
		uint64_t floor = (l + prod - 1) / prod, ceil = r / prod, cnt = ceil - floor + 1;
		if (std::popcount(i) & 1) {
			ans += cnt;
		} else {
			ans -= cnt;
		}
	}
	ans += r - l + 1;
	std::cout << ans << '\n';
}
```

很神秘的是，如果我开一个 $10^7$ 的数组而非 `std::vector` 的话，牛客会报“Compiler exceeded OUTPUT limit”，不知道甚么鬼。我换到牛客的编译器版本，测了也没有问题，用 Compiler Explorer 也没问题。

很不幸，这次注意力不但没能帮我解题，反而浪费了大量时间在错误的思路上。这个式子在 $2184$ 以下都没有反例，但从这个数字开始是有许多组的，在 $10^5$ 范围内有：

```
2184 2200
27830 27846
32214 32230
57860 57876
62244 62260
87890 87906
92274 92290
```

## 2026 “钉耙编程”中国大学生算法设计暑期联赛（2）

没有签到，两小时五十一分钟过的第一道题（队友过的，当时我在写大模拟），但最后居然能 4 题 280……

### 1004. 坪厕鸡

> 在一场 ACM 比赛中，共有 $n \in \mathbb{N}^*$ 支队伍参与，比赛配备了 $m \in \mathbb{N}^*$ 台完全相同的评测机。比赛期间系统共接受到了 $q \in \mathbb{N}^*$ 次提交，第 $i$ 次提交由队伍 $a_i \in \mathbb{N} \cap [0, n)$ 在第 $b_i \in \mathbb{N}^*$ 秒发起，需要花 $c_i \in \mathbb{N}^*$ 秒进行评测。**保证所有的 $b_i$ 严格单调递增**。
>
> 为了避免队伍在短时间内连续大量提交代码，从而占用过多评测资源。你决定采用如下的调度策略：
>
> - 每台评测机同一时刻只能评测一份提交。对于任意队伍，同一时刻至多只能有一份提交处于评测状态。
> - 每次提交到达后，将会进入等待队列。
> - 每当存在空闲评测机时，系统会**在等待队列中，筛选出所有满足“所属队伍当前无正在评测提交”的提交**。若存在这样的提交，则选择其中**提交时间 $b_i$ 最早的一份**开始评测。
> - 系统将会不断重复上述调度过程，直到不存在空闲评测机，或不存在符合条件的等待提交为止。
>
> 若第 $i$ 次提交从第 $t$ 秒开始评测，则它将会连续占用一台评测机 $c_i$ 秒，评测过程不可中断。该提交在第 $t + c_i$ 秒结束评测，此时该评测机立即变为空闲，同时该提交所属队伍也立即恢复空闲状态，并可能触发新的调度。
>
> 特别地，若同一时刻既有新的提交到达，又有若干评测结束，则这些事件均视为已发生后，系统再进行调度。
>
> 你需要推演出整个系统的评测过程，请你分别求出这 $q$ 次提交实际开始被评测的时间。
>
> 保证 $m,n,q \leq 2 \times 10^5$，$(\forall i \in \mathbb{N} \cap [0, n))\ (b_i,c_i \leq 10^9)$。

大模拟。

```cpp
struct Task {
	size_t src;
	uint64_t tm, dur;
};

inline void solve() {
	size_t m, n, q;
	std::cin >> n >> q >> m;
	std::vector<Task> tasks;
	tasks.reserve(q);
	std::vector<uint64_t> judge_times(q);
	std::vector<std::queue<size_t>> team_qs(n);
	std::vector<bool> team_busy(n);
	std::map<std::pair<bool, uint64_t>, size_t> team_order;
	std::vector<size_t> machine_tasks(m, -1);
	std::vector<uint64_t> machine_end_times(m, 0);
	auto cmp = [&](size_t lhs, size_t rhs) {
		return (machine_end_times[lhs] > machine_end_times[rhs]);
	};
	auto machine_pq = std::priority_queue(cmp, std::vector<size_t>());
	std::vector<size_t> free_machines(m);
	std::iota(free_machines.begin(), free_machines.end(), 0);

	auto updateTime = [&](uint64_t cur_tm) {
		while (machine_pq.size()) {
			auto machine_id = machine_pq.top();
			if (machine_end_times[machine_id] > cur_tm) {
				break;
			}
			machine_pq.pop();

			auto task_id = machine_tasks[machine_id];
			assert(~task_id);
			machine_tasks[machine_id] = -1;
			machine_end_times[machine_id] = 0;
			free_machines.emplace_back(machine_id);

			auto [src, _, __] = tasks[task_id];
			team_busy[src] = false;
			if (team_qs[src].size()) {
				auto nxt_task_id = team_qs[src].front();
				auto nxt_task_tm = tasks[nxt_task_id].tm;
				auto iter = team_order.find(std::pair(true, nxt_task_tm));
				assert(iter != team_order.end());
				team_order.erase(iter);
				team_order.emplace(std::pair(false, nxt_task_tm), src);
			}
		}

		while (machine_pq.size() < m && team_order.size()) {
			auto beg = team_order.begin();
			if (beg->first.first) {
				break;
			}

			auto src = beg->second;
			team_order.erase(beg);

			auto task_id = team_qs[src].front();
			team_qs[src].pop();

			auto dur = tasks[task_id].dur;

			auto machine_id = free_machines.back();
			free_machines.pop_back();

			machine_tasks[machine_id] = task_id;
			judge_times[task_id] = std::max(cur_tm, tasks[task_id].tm);
			machine_end_times[machine_id] = judge_times[task_id] + dur;
			machine_pq.emplace(machine_id);

			team_busy[src] = true;
			if (team_qs[src].size()) {
				auto nxt_task_id = team_qs[src].front();
				auto nxt_task_tm = tasks[nxt_task_id].tm;
				team_order.emplace(std::pair(true, nxt_task_tm), src);
			}
		}
	};

	while (true) {
		uint64_t cur_tm = UINT64_MAX;
		if (tasks.size() < q) {
			auto task_id = tasks.size();
			auto &[src, tm, dur] = tasks.emplace_back();
			std::cin >> src >> tm >> dur;
			--src;
			cur_tm = tm;
			team_qs[src].emplace(task_id);
			if (team_qs[src].size() == 1) {
				team_order.emplace(std::pair(team_busy[src], tm), src);
			}
		} else {
			if (team_order.empty()) {
				break;
			}
			assert(machine_pq.size());
		}
		while (machine_pq.size() && machine_end_times[machine_pq.top()] < cur_tm) {
			auto tm = machine_end_times[machine_pq.top()];
			updateTime(tm);
		}
		if (cur_tm == UINT64_MAX) {
			break;
		}
		updateTime(cur_tm);
	}

	for (auto ans : judge_times) {
		std::cout << ans << ' ';
	}
	std::cout << '\n';
}
```

### 1011. 键盘杀手

> 给定 $\vec{a} = (a_i)_{i = 0}^{n - 1} \in (\mathbb{N}^*)^n\ (n \in \mathbb{N}^*)$，令 $a_{-1} = a_n = 0$。你需要执行 $n$ 次下面的操作，直到 $\vec{a} = \vec{0}$：
>
> - 选择一个 $i \in \mathbb{N} \cap [0, n)$，令 $a_i \gets 0$。这次操作的代价为 $\max\{a_{i - 1}, a_{i + 1}\}$。
>
> 这 $n$ 次操作的总代价是各次操作的代价之和。
>
> 求出在所有可能的操作顺序下最小的总代价。
>
> 保证 $n \leq 10^5$，且 $(\forall i \in \mathbb{N} \cap [0, n)\ (a_i \leq 10^9)$。

队友给出了基于分治思想的 DP，我觉得是比较自然的想法。

考虑区间 $[b, e)$。因为一个区间最左的两个点和最右的两个点的消除顺序会影响外层区间的答案，所以我们要分别考虑这四种顺序，即我们的状态记为
$$
(b, e, p, q),
$$
其中 $p$ 表示“左端点先删内侧的点”（为真时取值为 $1$），$q$ 表示“右端点先删内侧的点”（同理）。设 $f(b, e, p, q)$ 表示按照 $p,q$ 规定的顺序消除 $[b, e)$ 时的最小总代价。取 $m = \left\lfloor\dfrac{1}{2} (b + e)\right\rfloor$，可以枚举 $m - 1$ 和 $m$ 的消除顺序（用 $r$ 枚举 $[b, m)$ 右端的消除顺序，用 $s$ 枚举 $[m, e)$ 左端的消除顺序）：

- 先消除 $m - 1$：$m$ 将完全由区间 $[m, e)$ 决定，但 $m - 1$ 会受到 $m - 2$ 影响。

  - $r = 0$：消除顺序为 $(m - 1) \to (m - 2),\ (m - 1) \to m$，消除 $m - 1$ 的实际代价是 $\max\{a_{m - 2}, a_m\}$，但 $(b, m, p, 0)$ 会以为是 $a_{m - 2}$，所以要减掉它，得到的总代价为
    $$
    (\max\{a_{m - 2}, a_m\} - a_{m - 2}) + f(b, m, p, 0) + \min_{s \in \{0, 1\}} f(m, e, s, q).
    $$

  - $r = 1$：消除顺序为 $(m - 2) \to (m - 1) \to m$，消除 $m - 1$ 的实际代价是 $a_m$，但 $(b, m, p, 0)$ 不知道右边外面还有元素，所以要补上，得到总代价为
    $$
    f(b, m, p, 1) + a_m + \min_{s \in \{0, 1\}} f(m, e, s, q).
    $$
    
  
- 先消除 $m$：与上面的情况完全对称。

  - $s = 0$：消除顺序为 $m \to (m - 1),\ m \to (m + 1)$，总代价为
    $$
    \min_{r \in \{0, 1\}} f(b, m, p, r) + (\max\{a_{m - 1}, a_{m + 1}\} - a_{m + 1}) + f(m, e, 0, q).
    $$

  - $s = 1$：消除顺序为 $(m + 1) \to m \to (m - 1)$，总代价为
    $$
    \min_{r \in \{0, 1\}} f(b, m, p, r) + a_{m - 1} + f(m, e, 1, q).
    $$


所以总的递归的表达式，或许可以称为状态转移方程，就是以上四种情况取最小值。

考虑递归边界：

- 若 $e - b = 2$：
  -  $p = q$ 的情况未定义，可以规定值为 $+\infty$。
  - $f(b, e, 0, 1) = a_{b + 1}$。
  - $f(b, e, 1, 0) = a_b$。
- 若 $e - b = 3$：
  - $(b, e, 0, 0)$：消除顺序为 $b \to (b + 1),\ (b + 2) \to (b + 1)$，代价为 $2 a_{b + 1}$。
  - $(b, e, 0, 1)$：消除顺序为 $b \to (b + 1) \to (b + 2)$，代价为 $a_{b + 1} + a_{b + 2}$。
  - $(b, e, 1, 0)$：消除顺序为 $(b + 2) \to (b + 1) \to b$，代价为 $a_b + a_{b + 1}$。
  - $(b, e, 1, 1)$：消除顺序为 $(b + 1) \to b,\ (b + 1) \to (b + 2)$，代价为 $\max\{a_b, a_{b + 2}\}$。

$n = 1$ 的情况要特判，但在分治过程中不会出现 $e - b = 1$ 的情况。

```cpp
inline void solve() {
	constexpr uint64_t INF = 1e15;
	size_t n;
	std::cin >> n;
	std::vector<uint64_t> arr(n);
	for (auto &e : arr) std::cin >> e;

	assert(n);
	if (n == 1) {
		std::cout << "0\n";
		return;
	}

	std::array<std::array<std::vector<uint64_t>, 2>, 2> dp;
	for (unsigned i = 0; i < 2; ++i) {
		for (unsigned j = 0; j < 2; ++j) {
			dp[i][j].resize((n << 2), -1);
		}
	}

	auto divideAndConquer = [&](auto &&self, size_t idx,
								size_t beg, size_t end,
								bool beg_inner_first, bool end_inner_first) -> uint64_t {
		assert(beg + 1 < end);

		auto &res = dp[beg_inner_first][end_inner_first][idx];
		if (~res) return res;

		if (beg + 2 == end) {
			if (beg_inner_first == end_inner_first) return (res = INF);
			return (res = arr[beg + end_inner_first]);
		}

		if (beg + 3 == end) {
			switch (SC<unsigned>(beg_inner_first) << 1 | end_inner_first) {
			case 0b00:
				return (res = (arr[beg + 1] << 1));
			case 0b01:
				return (res = (arr[beg + 1] + arr[beg + 2]));
			case 0b10:
				return (res = (arr[beg] + arr[beg + 1]));
			case 0b11:
				return (res = std::max(arr[beg], arr[beg + 2]));
			default:
				assert(false);
				return INF;
			}
		}

		size_t mid = beg + ((end - beg) >> 1);
		size_t lch = ((idx << 1) | 1), rch = ((idx + 1) << 1);
		std::array<uint64_t, 2> fst, sec;
		for (unsigned i = 0; i < 2; ++i) {
			fst[i] = self(self, lch, beg, mid, beg_inner_first, i);
			sec[i] = self(self, rch, mid, end, i, end_inner_first);
		}

		auto fst_min = std::min(fst[0], fst[1]), sec_min = std::min(sec[0], sec[1]);
		if (fst_min == INF || sec_min == INF) return (res = INF);

		std::array<uint64_t, 2> cands{sec_min + std::min(fst[0] + (std::max(arr[mid - 2], arr[mid]) - arr[mid - 2]),
														 fst[1] + arr[mid]),
									  fst_min + std::min((std::max(arr[mid - 1], arr[mid + 1]) - arr[mid + 1]) + sec[0],
														 arr[mid - 1] + sec[1])};
		return (res = std::min(cands[0], cands[1]));
	};

	uint64_t ans = INF;
	for (unsigned p = 0; p < 2; ++p) {
		for (unsigned q = 0; q < 2; ++q) {
			auto val = divideAndConquer(divideAndConquer, 0, 0, n, p, q);
			ans = std::min(ans, val);
		}
	}
	assert(ans != INF);
	std::cout << ans << '\n';
}
```

时间复杂度：分治树形成一颗 $\Theta(n)$ 个叶子节点的二叉树，所以时间复杂度为 $\Theta(n)$。

空间复杂度：记忆化整颗分治树，$\Theta(n)$。

### 1006. 合成大 hdu

> 设字符集 $\Sigma = \{\texttt{h}, \texttt{d}, \texttt{u}\}$。给定 $n \in \mathbb{N}^*$，构造 $s \in \Sigma^*$ 使得其中**子序列** $(\texttt{h}, \texttt{d}, \texttt{u})$ 的个数为 $n$。
>
> 保证 $n \leq 10^9$，要求 $|s| \leq 3001$。
>
> 有不超过 $10^3$ 组测试数据。

## 2026 “钉耙编程”中国大学生算法设计暑期联赛（3）

### 1002. The World Cup

> > 2034 年，由于中国队进了沙特世界杯，为这届世界杯带来了巨大的经济收益，主办方喜笑颜开，决定举办一场不收税的全球赌球大赛。
>
> 有 $n \in \mathbb{N}$ 支队伍打比赛，第 $i \in \mathbb{N} \cap [0, n)$ 支队伍夺冠的赔率为 $r_i$，不夺冠的赔率为 $\dfrac{r_i}{r_i - 1}$。现在你有一共下注 $tot \in \mathbb{N}$ 块钱，想要最大化最坏情况下的最大回报，求这个最大值。要求绝对误差不超过 $\varepsilon = 10^{-4}$。
>
> 保证 $2 \leq n \leq 66$，$1 \leq tot \leq 10^9$，$(\forall i \in \mathbb{N} \cap [0, n))\ (2 \leq r_i \leq 200)$。有最多 $10^4$ 组测试数据。

## 2026 牛客暑期多校训练营 4

~~你太依赖你的注意力了。~~

### D. The Game

> 对于 $[n]\ (n \in \mathbb{N}^*)$ 的排列 $\vec{p}$，设 $\vec{f}(\vec{p})$ 表示通过循环移位将 $1$ 移动到首位得到的排列。
>
> 给定 $n \in \mathbb{N}^*$。初始时 $\vec{p} = ()$（空序列）。Alice 先手，Alice 和 Bob 轮流选择 $[n]$ 中的一个尚未在 $\vec{p}$ 出现的元素追加到 $\vec{p}$ 中（因此最终会得到 $[n]$ 的一个排列）。Alice 要最小化 $\vec{f}(\vec{p})$ 的字典序，而 Bob 则要最大化 $\vec{f}(\vec{p})$ 的字典序，两人都采取最优策略，求最终得到的 $\vec{f}(\vec{p})$。
>
> 保证 $n \leq 5 \times 10^5$。

通过打表（第一行是原始排列，第二行是循环移位后的排列）
```
--
1 
1 
----
1 2 
1 2 
------
1 3 2 
1 3 2 
--------
3 2 4 1 
1 3 2 4 
----------
2 3 5 1 4 
1 4 2 3 5 
------------
4 3 5 2 6 1 
1 4 3 5 2 6 
--------------
2 4 6 3 7 1 5 
1 5 2 4 6 3 7 
----------------
5 4 6 3 7 2 8 1 
1 5 4 6 3 7 2 8 
------------------
2 5 7 4 8 3 9 1 6 
1 6 2 5 7 4 8 3 9 
--------------------
6 5 7 4 8 3 9 2 10 1 
1 6 5 7 4 8 3 9 2 10 
----------------------
2 6 8 5 9 4 10 3 11 1 7 
1 7 2 6 8 5 9 4 10 3 11 
------------------------
7 6 8 5 9 4 10 3 11 2 12 1 
1 7 6 8 5 9 4 10 3 11 2 12 

```

注意到规律为（偶数 $n$ 的规律容易看出，奇数 $n$ 的规律被队友以极其惊人的注意力发现了）
```cpp
inline std::vector<uint32_t> solve(size_t n) {
	std::vector<uint32_t> res;
	if (!(n & 1)) {
		res.reserve(n);
		res.emplace_back(1);
		for (uint32_t i = (n >> 1) + 1; i < n; ++i) {
			res.emplace_back(i);
			res.emplace_back(n + 1 - i);
		}
		res.emplace_back(n);
	} else {
		res = solve(n + 1);
		assert(res[n] == n + 1);
		res.pop_back();
		if (n > 2) {
			std::shift_right(res.begin() + 2, res.end(), 1);
			res[2] = 2;
		}
	}
	assert(res.size() == n);
	return res;
}
```

提交，AC。What can I say? *Attention is all you need.*

时间复杂度：$\Theta(n)$。

空间复杂度：$\Theta(n)$。

还是推导一下这个最优策略。

因为 $\vec{f}$ 会把 $1$ 移到最前面来，所以在博弈过程中，一旦某个玩家选了 $1$，下一个玩家就必定根据他的目标做出贪心的选择，这样直到最后一个元素都会根据双方的贪心策略确定（容易猜想：会不会双方都不敢选 $1$，直至最后呢？如果从这一猜想出发，推理将比下面的更加容易）；而在 $1$ 出现之前（假如已经知道 $1$ 何时出现；由于两人都非常聪明且答案是唯一的，所以他们确实是知道的），Alice 会尽量消耗较大的数，Bob 则会尽量消耗较小的数。

#### $n$ 为偶数

设 $h = \dfrac{1}{2}n$。如果 Alice 想使 $\vec{f}(\vec{p})_2 \leq x$，则他需要在 $[x] \setminus \{1\}$ 被 Bob 选完前选完所有 $\mathbb{N} \cap [x + 1, n]$，即需要
$$
n - x \leq x - 1 \iff x \geq \dfrac{1}{2}(n + 1) \implies x \geq h + 1,
$$
也就是说只要 $x \geq h + 1$，Alice 就能使 $\vec{f}(\vec{p})_2 \leq x$，所以 Alice 能够保证
$$
\vec{f}(\vec{p})_2 \leq h + 1;
$$
而如果 Bob 想使 $\vec{f}(\vec{p})_2 \geq x$，则需要在 Alice 选完所有 $\mathbb{N} \cap [x, n]$ 前选完所有 $[x - 1] \setminus \{1\}$，即需要
$$
x - 2 \leq n - x + 1 \iff x \leq \dfrac{1}{2}(n + 3) \implies x \leq h + 1,
$$
所以 Bob 能够保证
$$
\vec{f}(\vec{p})_2 \geq h + 1.
$$
综上有 $\vec{f}(\vec{p})_2 = h + 1$。此时在 $1$ 出现之前，设剩余元素的集合为 $S$，Alice 总会选择 $a \in A \triangleq S \cap (h + 1, +\infty)$，Bob 总会选择 $b \in B \triangleq S \cap (1, h + 1)$。一旦某个玩家在自己的集合尚有元素时选择了 $1$：

- 若 Alice 提前选 $1$，则 Bob 会立刻接最大值，使得 $\vec{f}(\vec{p})_2 = \max S > h + 1$，使 $\vec{f}(\vec{p})$ 变大。
- 若 Bob 提前选 $1$，则 Alice 会立刻接最小值，使得 $\vec{f}(\vec{p})_2 = \min S < h + 1$，使 $\vec{f}(\vec{p})$ 变小。

所以他们都不能在自己的集合消耗完之前选择 $1$，即 $1$ 一定留到最后由 Bob 不得不选，所以 Alice 的第一步就是 $\vec{f}(\vec{p})_2 = h + 1$。此时 $\vec{f}(\vec{p})$ 已经有前缀 $(1, h + 1)$，Bob 为了最大化字典序，但又只能在 $B = [h]$ 里面选，所以只能选 $\max B = h$。再接下来，同理 Alice 也只能选 $\min A = h + 2$。这样轮流，直至 Alice 选择了 $n - 1$，然后 Bob 选择 $2$，然后 Alice 选择 $n$，此时 $A = B = \varnothing$，Bob 只有 $1$ 可选。

#### $n$ 为奇数

设 $h = \dfrac{n - 1}{2}$。同理可以推出 Alice 能保证 $\vec{f}(\vec{p})_2 \leq m + 2$，Bob 能保证 $\vec{f}(\vec{p})_2 \geq m + 2$，所以 $\vec{f}(\vec{p})_2 = m+2$。因为 $n$ 为奇数，所以 Bob 将在他的最后一步（总游戏的倒数第二步）选出 $1$， $\vec{f}(\vec{p})_2$ 将由 Alice 在最后一步选出。于是 $\vec{f}(\vec{p})$ 的前缀确定为 $(1, m + 2)$，下一项就是 Alice 选的第一项。此时 Alice 会选择最小的元素 $2$，然后 Bob 从小于 $m + 2$ 的元素中选择最大的 $m + 1$，然后 Alice 从大于 $m + 2$ 的元素中选择最小的 $m + 3$，如此交替直至只剩 $1$ 和 $m + 2$，然后 Bob 选择 $1$（否则前缀会变为 $(1, 2)$），Alice 选择 $m + 2$。

###  B. Quadratic Residue

> 给定 $m \in \mathbb{N}^*$，求出一组 $x,y,n \in \mathbb{N}^*$ 满足
>
> 1. $1 \leq x < m$。
> 2. $1 \leq y < n$。
> 3. $x^2 \equiv m \pmod{n}$。
> 4. $y^2 \equiv n \pmod{m}$。
>
> 保证 $2 \leq m \leq 10^9$，要求 $n \leq 10^{12}$。如果没有满足上述条件的解则报告无解。
>
> 有最多 $10^{12}$ 组测试数据。

队友在一坤小时的时候靠传奇注意力想出了一半：假设 $y = 1$，对于 $m$ 较小的情况，有这样一组解：
$$
n = m^2 + m + 1,\ x = m + 1,\ y = 1.
$$
然而当 $n \gtrsim 10^6$ 时会使 $m > 10^{12}$。

在结束前大概 12 分钟时想到：既然 $x^2 = ?n + m,\ y^2 = ?m + n$，考虑使 $x^2 = y^2 = m + n$。可以取一个稍大于 $m$ 的完全平方数 $r^2$，令 $n = r^2 - m$，于是 $x = y = r$。唯一的问题是，能不能使前两条约束成立，即
$$
1 < r < \min\{m, n\}.
$$
然而我没时间考虑清楚细节了，遗憾 WA（其实是被自己的 `assert` 干出 RE）。

刚结束就想出正解了。因为取的 $r^2 > m$，所以 $r \gtrsim \sqrt{m}$，$r$ 离 $m$ 还有很远，$r < m$ 是容易满足的。要让 $r < n$ 也成立，就要给 $n$ 在 $r^2$ 留出足够的空间，也就是说 $r$ 要稍稍大一点，但只要保持在与 $\sqrt{m}$ 相同的数量级内，$n$ 就还会在与 $m$ 相同的数量级而远远不会达到 $10^{12}$ 的限制。严格来说要满足 $r < n = r^2 - m$，所以只需
$$
\begin{aligned}
& r^2 - r - m > 0 \\
\iff & r < \dfrac{1}{2} - \sqrt{m + \dfrac{1}{4}} \lor r > \dfrac{1}{2} + \sqrt{m + \dfrac{1}{4}}.
\end{aligned}
$$
如果取 $r_0 = \left\lfloor \sqrt{m} \right\rfloor$，则有
$$
(r_0 + 1)^2 > m,
$$
但我们难以比较
$$
(r_0 + 1)^2 \overset{?}{>} m + \sqrt{m + \dfrac{1}{4}} + \dfrac{1}{2} = \left(\dfrac{1}{2} + \sqrt{m + \dfrac{1}{4}}\right)^2,
$$
所以再放大一点，
$$
(r_0 + 2)^2 > m + 2\sqrt{m} + 1 > m + \sqrt{m + \dfrac{1}{4}} + \dfrac{1}{2}.
$$
所以取 $r = r_0 + 2$ 即可。

注意在 $m$ 较小（$m \leq 4$）时上述算法会因为 $r = r_0 + 2 \geq m$ 而失效，应该特殊处理，可以打表、采用上面注意到的解或直接暴力寻找。

```cpp
inline void solve() {
	constexpr uint64_t M = 1e9, N = 1e12;
	uint64_t m;
	std::cin >> m;
	assert(m <= M);

	uint64_t n = m * m + m + 1;
	if (n <= N) {
		uint64_t x = m + 1;
		uint64_t y = 1;
		std::cout << x << ' ' << y << ' ' << n << '\n';
		return;
	}

	uint64_t rt = std::sqrt(SC<long double>(m));
	rt += 2;
	assert(rt * rt > m);
	n = rt * rt - m;
	assert(n <= N);
	uint64_t x = rt * rt;
	assert(rt < m);
	assert(rt < n);
	assert(x % n == m % n);
	assert(x % m == n % m);
	std::cout << rt << ' ' << rt << ' ' << n << '\n';
}
```

时间复杂度：几乎为 $O(1)$，取决于 `std::sqrt` 的实现。

空间复杂度：$O(1)$。

### C. Retest Queue

> 有 $m \in \mathbb{N}^*$ 个程序需要在 $n \in \mathbb{N}^*$ 个测试点上分别重新评测，所有程序使用同一个测试点顺序。已知程序 $i \in \mathbb{N} \cap [0, m)$ 在测试点 $j \in \mathbb{N} \cap [0, n)$ 的运行时间为 $d_{i, j} \in \mathbb{N}^*$，运行结果为 $a_{i, j} \in \{0, 1\}$（拒绝/接受），某个程序一旦在某个测试点不通过就不会再评测其他测试点。你可以任意排列这 $m$ 个测试点的顺序，求完成所有程序的评测需要的最少总时间。
>
> 保证 $m \leq 2 \times 10^4$，$n \leq 20$，$(\forall i \in \mathbb{N} \cap [0, m))\ (\forall j \in \mathbb{N} \cap [0, n))\ (d_{i, j} \leq 10^9)$。

$n \leq 20$ 几乎是明示状压 DP 了。但很不幸，我们没能想出符合复杂度要求的 DP 方式。



## 2026 “钉耙编程”中国大学生算法设计暑期联赛（4）

今天突然改为用字母编号了。

### J. Rare Game

> 给定 $\vec{a} = (a_i)_{i = 0}^{n - 1} \in (\mathbb{N} \cap [0, n))^n\ (n \in \mathbb{N}^*)$。你可以将整个 $\vec{a}$ 划分为非负整数个非空连续段，要求使得对于每一段，出现在其中的元素都出现恰好 $4$ 次，求划分方案数。
>
> 保证 $n \leq 5 \times 10^5$。答案对 $M = 998244353$ 取模。

~~别人到底是怎么写那末快的？？？我想出来之后都写了起码十几分钟的代码，还要调试……~~

显然必须要求 $4 \mid n$，否则直接输出 $0$ 即可。令 $n \gets \dfrac{1}{4}n$。

如果存在合法的划分方案，那末一定有一种方案会将整个 $\vec{a}$ 划分为若干个不可再划分的**极小段**（不论再怎么划分都会使被划出来的两段无法满足约束），而其他的方案一定是将这些极小段进行一些合并而得到的。四个四个地从前往后遍历 $\vec{a}$，每一时刻 $\vec{a}$ 都有三个连续部分：已经划分的极小段，已经访问但尚未确定极小段右边界的待定段，尚未访问到的段。设待定段长度为 $4l$，用一个不可重的集合 $S$ 保存待定段的元素。分类讨论：

- 若 $|S| < l$，则待定段必定有某个元素**重复了超过 $4$ 次**（可能是 $8$ 次、$12$ 次等），也就是说当前考虑的这一段不可能划入任何一个合法的极小段，直接输出 $0$。
- 若 $|S| > l$，则说明待定段里有一些元素还没满 $4$ 次，需要继续向右延申边界来补全（如果没有元素可以加入，则说明也没办法划为合法极小段，输出 $0$）。
- 若 $|S| = l$，说明待定段刚好形成一个极小段，记录位置并清空 $S$、归零 $l$。

用 `std::unordered_set` 可以 $\Theta(n)$ 时空完成划分。

设整个序列被我们划为了 $m$ 个极小段，分别为 $[s_{i - 1}, s_i)\ (i \in \mathbb{N},\ i < m,\ s_{-1} = 0,\ s_{m - 1} = 4n)$。段内是不可能插板的，要插板只能在段与段之间插；但我们又不能简单地算 $2^{m - 1}$，因为有些段之间是必须插板隔开的。甚么样的段呢？**当且仅当两个段有相同的元素时**，他们之间**必须至少插入一个板**，否则合并出来会导致共有的元素的出现次数变为 $8$。这就好像在 $\vec{s} = (s_i)_{i = 0}^{m - 1}$ 上连了一些边（标示这两个段之间有“冲突”），凡是被边覆盖的地方都必须至少插一个隔板。但是边与边之间会有交叉覆盖，所以我们还需要简化问题。对于第 $i \in \mathbb{N} \cap [0, m)$ 段，设第 $j,k \in \mathbb{N}\ (k < j < i)$ 段都跟他有相同元素，我们只需考虑 $j$ 与 $i$ 之间必须插板就行，因为这样会使 $k$ 与 $i$ 必然已经被隔开 $j$ 与 $i$ 的隔板隔开。换言之，对于同一个极小段，我们只需要考虑他前面**最靠后的**那个与他冲突的位置即可。如果我们把这个连边的序列画下来，会容易想到用 DP 来解决这个问题（不知道容易在那，但做题的直觉就是让我和队友都想到了，attention 这一块）。

设 $p_i$ 是使得 $[x, i]$ 中没有任何冲突对的（也就是说，没有一条边完整地包含在这个区间中）最小的 $x \in \mathbb{N}$。这个 $\vec{p} = (p_i)_{i = 0}^{n - 1}$ 可以用双指针法以 $\Theta(n)$ 时空求出。设状态为 $(i, b)\ (i \in \mathbb{N},\ i < m,\ b \in \{0, 1\})$，表示只考虑区间 $[0, i]$ 及其中的边，在 $i$ 前是否要放一个隔板（当且仅当 $b = 1$ 时在此放一个隔板）。设 $f_{i, b}$ 表示该状态的合法划分方案数。对于 $(i, 0)$，因为 $p_i$ 之前必定要切一刀，但 $(p_i, i)$ 区间都是可切可不切，所以我们可以枚举 $i$ 前最后一刀切下的位置 $j \in \mathbb{N} \cap[p_i, i)$，于是有状态转移方程
$$
f_{i, 0} = \sum_{j = p_i}^{i - 1} f_{j, 1}\ (i \in \mathbb{N},\ 2 \leq i < m);
$$
而对于 $(i, 1)$，因为反正这里我都要切一刀，管他前面甚么冲突不冲突都没有问题，所以直接
$$
f_{i, 1} = f_{i - 1, 0} + f_{i - 1, 1}\ (i \in \mathbb{N},\ 2 \leq i < m).
$$
递推边界：当 $m = 1$ 时直接输出 $1$。当 $m > 1$ 时，为了递推式的统一，规定
$$
f_{0, 0} = f_{0, 1} = f_{1, 1} =1,
$$
而特殊计算
$$
f_{1, 0} = (p_1 = 0).
$$
注意代码中的两维顺序是反的，为了对内存更友好。别忘了取模，以及别忘了前缀和取模之后可能不单调。
```cpp
inline void solve() {
	constexpr uint32_t MOD = 998244353;
	size_t n;
	std::cin >> n;
	std::vector<uint32_t> arr(n);
	for (auto &e : arr) {
		std::cin >> e;
		--e;
		assert(e < n);
	}
	if (n & 0b11) {
		std::cout << "0\n";
		return;
	}
	n >>= 2;

	std::vector<size_t> segs;
	segs.reserve(n);
	{
		std::unordered_set<uint32_t> unqs;
		unqs.reserve(n << 2);
		for (size_t i = 0; i < n; ++i) {
			for (size_t j = 0; j < 4; ++j) {
				unqs.emplace(arr[(i << 2) | j]);
			}

			size_t last = (segs.empty() ? 0 : segs.back());
			size_t len = i + 1 - last;
			if (unqs.size() < len) {
				std::cout << "0\n";
				return;
			}
			if (unqs.size() > len) {
				if (i + 1 == n) {
					std::cout << "0\n";
					return;
				}
				continue;
			}

			assert(unqs.size() == len);
			segs.push_back(i + 1);
			unqs.clear();
		}
	}
	// std::cerr << "segs: ";
	// for (auto seg : segs) std::cerr << seg << ' ';
	// std::cerr << '\n';
	size_t m = segs.size();
	assert(m && segs[m - 1] == n);

	if (m == 1) {
		std::cout << "1\n";
		return;
	}
	assert(m >= 2);

	std::vector<size_t> last_conflict_pos_of(m, size_t(-1));
	{
		std::vector<std::vector<size_t>> occs(n << 2);
		std::vector<size_t> last_seg_occs(n << 2, size_t(-1));
		for (size_t i = 0; i < n; ++i) {
			for (size_t j = 0; j < 4; ++j) {
				auto idx = ((i << 2) | j);
				auto val = arr[idx];
				assert(val < (n << 2));
				occs[val].emplace_back(i);

				if (occs[val].size() == 4) {
					size_t seg_idx = std::lower_bound(segs.begin(), segs.end(), i + 1) - segs.begin();
					assert(seg_idx < m);
					assert(!seg_idx || occs[val].front() >= segs[seg_idx - 1]);
					if (~last_seg_occs[val]) {
						auto &pos = last_conflict_pos_of[seg_idx];
						if (pos == size_t(-1) || pos < last_seg_occs[val]) {
							pos = last_seg_occs[val];
						}
					}
					last_seg_occs[val] = seg_idx;
					occs[val].clear();
				}
			}
		}
	}
	// std::cerr << "last_conflict_pos_of: ";
	// for (auto pos : last_conflict_pos_of) std::cerr << pos << ' ';
	// std::cerr << '\n';

	std::vector<size_t> prevs(m);
	for (size_t i = 1, j = 0; i < m; ++i) {
		while (~last_conflict_pos_of[i] && j <= last_conflict_pos_of[i]) {
			++j;
		}
		prevs[i] = j;
	}
	// std::cerr << "prevs: ";
	// for (auto prev : prevs) std::cerr << prev << ' ';
	// std::cerr << '\n';

	std::array<std::vector<uint64_t>, 2> dp;
	dp.fill(std::vector<uint64_t>(m));
	std::vector<uint64_t> pref_sum(m + 1); // prefix sum of dp[1]
	dp[0][0] = 1;
	dp[1][0] = 1;
	dp[1][1] = 1;
	if (prevs[1]) {
		assert(prevs[1] == 1);
		dp[0][1] = 0;
	} else {
		dp[0][1] = 1;
	}
	pref_sum[1] = dp[1][0];
	pref_sum[2] = (pref_sum[1] + dp[1][1]) % MOD;
	for (size_t i = 2; i < m; ++i) {
		auto prev = prevs[i];
		dp[0][i] = (pref_sum[i] - pref_sum[prev] + MOD) % MOD; // sum of [prev, i - 1]
		dp[1][i] = (dp[0][i - 1] + dp[1][i - 1]) % MOD;
		pref_sum[i + 1] = (pref_sum[i] + dp[1][i]) % MOD;
	}
	uint64_t ans = (dp[0][m - 1] + dp[1][m - 1]) % MOD;
	std::cout << ans << '\n';
}
```

时间复杂度：$\Theta(n)$。

空间复杂度：$\Theta(n)$。

~~比赛完我怎么看见别的队有用线段树写的？那里来的线段树啊？？？~~

### G. Perfect Palindrome

## 2026 牛客暑期多校训练营 5

### C. Number

> 给定 $n \in \mathbb{N}\ (2 \leq n \leq 10^6)$，求 $\mathbb{N} \cap [0, n)$ 的排列 $\vec{p},\vec{q},\vec{r}$ 使得
>
> - $(\forall i \in \mathbb{N} \cap [0, n))\ (p_i \neq q_i \neq r_i \neq p_i)$。
> - $\sum_{i=0}^{n - 1} p_i \cdot n^i + \sum_{i = 0}^{n - 1} q_i \cdot n^i = \sum_{i = 0}^{n - 1} r_i \cdot n^i$。
>
> 如果不存在这样的一组 $\vec{p},\vec{q},\vec{r}$，输出 $-1$，否则输出这三个排列。

## 2026 “钉耙编程”中国大学生算法设计暑期联赛（5）

### 1009. 自乘

> $\vec{a} = (a_i)_{i = 0}^{n - 1} \in (\mathbb{N} \cap [0, n))^n\ (n \in \mathbb{N})$ 可以被视作映射 $\vec{a}: i \mapsto a_i\ (i \in \mathbb{N} \cap [0, n))$。记 $\vec{a}^0 = (i)_{i = 0}^{n - 1}$，$\vec{a}^{m + 1} = \vec{a} \circ \vec{a}^m\ (m \in \mathbb{N})$，其中 $\circ$ 为右复合。
>
> 现在给定 $\vec{a},\vec{b} \in (\mathbb{N} \cap [0, n))^n\ (n \in \mathbb{N} \cap [0, n))$，求最小的 $m \in \mathbb{N}$ 使得 $\vec{a}^m = \vec{b}$。如果不存在这样的 $m$，输出 $-1$。
>
> 保证 $n \leq 1000$，有最多 $1000$ 组数据。

## 2026 牛客暑期多校训练营 6

### I. Integer Function

> 用 $\operatorname{pc}(\cdot)$ 表示 `std::popcount`。给定 $n,d \in \mathbb{N}$，$M = 998244353$，求
> $$
> \left(\sum_{x = 0}^n \operatorname{pc}(x) \cdot \operatorname{pc}(x + d)\right)\bmod{M}.
> $$
> 保证 $n,d < 2^{60}$。
>
> 有不超过 $10^4$ 组测试数据。

记最大位数为 $B = 60$，二进制分解 $n = \sum_{i = 0}^{B - 1} n_i \cdot 2^i$，$d = \sum_{i = 0}^{B - 1} d_i \cdot 2^i$。

#### 思路

在比较 $x \leq n$ 时，我们需要**从高到低**逐位比较；在计算 $x + d$ 时，我们则需要**从低到高**逐位相加并判断是否进位。这是矛盾的。为了解决这个问题，可以等价转化 $x \leq n \iff n - x \geq 0$，因为计算减法 $n - x$ 时我们需要**从低到高**逐位相减并判断是否借位（当然，根据补码的原理，减法就是一种加法），这样两个过程就统一起来了。

#### 状态设计

设状态 $(i, b, c)\ (i \in \mathbb{N} \cap [0, B],\ b,c \in \{0, 1\})$ 表示：仅考虑最低 $i$ 位，计算 $\sum_{j = 0}^{i - 1} n_j \cdot 2^j - \sum_{j = 0}^{i - 1} x_j \cdot 2^j$（$n - x$ 的最低 $i$ 位）时向更高位（从低到高第 $i$ 位）借位 $b$（$b = 0$ 表示无需借位，$b = 1$ 表示借一位），计算 $\sum_{j = 0}^{i - 1} x_j \cdot 2^j + \sum_{j = 0}^{i - 1} d_j \cdot 2^j$（$x + d$ 的最低 $i$ 位）时向更高位（从低到高第 $i$ 位）进位 $c$（$c = 0$ 表示不进位，$c = 1$ 表示进一位）。设集合 $X_{i, b, c}$ 表示在仅考虑最低 $i$ 位时，所有使 $n - x$ 借位 $b$、使 $x + d$ 进位 $c$ 的**低位部分** $x \in \mathbb{N} \cap [0, 2^i)$ 组成的集合。

记 $\operatorname{pc}_i: x \mapsto \operatorname{pc}(x \bmod{2^i})$。为了计算答案，我们需要维护四个统计量：

- $|X_{i, b, c}|$。
- $s_{i,b,c} = \sum_{x \in X_{i, b, c}} \operatorname{pc}_i(x)$，即满足当前状态 $(i, b, c)$ 的所有枚举的低位部分分别求 popcount 后的总和。
- $t_{i, b, c} = \sum_{x \in X_{i, b, c}} \operatorname{pc}_i(x + d)$，即满足当前状态 $(i, b, c)$ 的所有枚举的低位部分分别与 $d$ 相加，只考虑最低 $i$ 位求 popcount 的总和。
- $p_{i, b, c} = \sum_{x \in X_{i, b, c}} \operatorname{pc}_i(x) \cdot \operatorname{pc}_i(x + d)$，如果不考虑进位的话，这就是我们最终要求的答案。

#### 状态转移

设我们已经处理好了最低 $i$ 位的结果，$n - x$ 借位 $b$，$x + d$ 进位 $c$，现在要处理第 $i$ 位。设枚举到当前位为 $x_i \in \{0, 1\}$。$x_i$ 会影响 $x$ 的 popcount，即影响 $s_{i + 1, b', c'}$。

##### 借位

$n - x$ 需要向更高位借位当且仅当 $n_i < x_i + b$，即向更高位借位 $(n_i < x_i + b) \triangleq b'$。

##### 进位

$x + d$ 的第 $k$ 位为 $(x_i + d_i + c) \bmod 2 \triangleq y_i$，进位 $\lfloor (x_i + d_i + c) / 2\rfloor \triangleq c'$。这里的第 $k$ 位的结果会影响 $x + d$ 的 popcount，即影响 $t_{i + 1, b', c'}$。

##### 状态转移方程

从 $(i, b, c)$ 向 $(i + 1, b', c')$ 转移，需要更新
$$
\begin{array}{c}
X_{i + 1, b', c'} \gets X_{i + 1, b', c'} \cup X_{i, b, c}, \\
s_{i + 1, b', c'} \gets s_{i + 1, b', c'} + (s_{i, b, c} + x_i \cdot |X_{i, b, c}|), \\
t_{i + 1, b', c'} \gets t_{i + 1, b', c'} + (t_{i, b, c} + y_i \cdot |X_{i, b, c}|), \\
p_{i + 1, b', c'} \gets p_{i + 1, b', c'} + (p_{i, b, c} + x_i \cdot t_{i, b, c} + y_i \cdot s_{i, b, c} + x_i \cdot y_i \cdot |X_{i, b, c}|).
\end{array}
$$

##### 递推边界

$$
X_{0, 0, 0} = \{0\},\ X_{0, 0, 1} = X_{0, 1, 0} = X_{0, 1, 1} = \varnothing.
$$

##### 答案

处理完全部 $B$ 位后，允许再进一位，但不许再借位了，所以最终答案是
$$
\sum_{c \in \{0, 1\}} (p_{B, 0, c} + c \cdot s_{B, 0, c}).
$$

#### 代码

```cpp
inline void solve() {
	constexpr unsigned B = 60;
	constexpr uint32_t MOD = 998'244'353;

	uint64_t n, d;
	std::cin >> n >> d;
	assert(n < (uint64_t(1) << B));
	assert(d < (uint64_t(1) << B));

	std::array<std::array<std::array<uint64_t, 2>, 2>, B + 1> cnt{}, s{}, t{}, p{};
	cnt[0][0][0] = 1;
	for (unsigned i = 0; i < B; ++i) {
		for (unsigned b = 0; b < 2; ++b) {
			for (unsigned c = 0; c < 2; ++c) {
				for (unsigned x = 0; x < 2; ++x) {
					unsigned nxt_b = (((n >> i) & 1) < x + b);
					assert(nxt_b < 2);
					unsigned nxt_c = x + ((d >> i) & 1) + c;
					assert(nxt_c < 4);
					unsigned y = (nxt_c & 1);
					nxt_c >>= 1;

					cnt[i + 1][nxt_b][nxt_c] = (cnt[i + 1][nxt_b][nxt_c] + cnt[i][b][c]) % MOD;
					s[i + 1][nxt_b][nxt_c] = (s[i + 1][nxt_b][nxt_c] + s[i][b][c] + x * cnt[i][b][c]) % MOD;
					t[i + 1][nxt_b][nxt_c] = (t[i + 1][nxt_b][nxt_c] + t[i][b][c] + y * cnt[i][b][c]) % MOD;
					p[i + 1][nxt_b][nxt_c] = (p[i + 1][nxt_b][nxt_c] + p[i][b][c] + x * t[i][b][c] + y * s[i][b][c] + x * y * cnt[i][b][c]) % MOD;
				}
			}
		}
	}

	uint64_t ans = 0;
	for (unsigned c = 0; c < 2; ++c) {
		ans = (ans + p[B][0][c] + c * s[B][0][c]) % MOD;
	}
	std::cout << ans << '\n';
}
```

#### 复杂度

时间复杂度：$\Theta(B \cdot 2 \cdot 2 \cdot 2) = \Theta(B)$。

空间复杂度：$\Theta(B \cdot 2 \cdot 2) = \Theta(B)$。

### A. A Permutation Problem

> 给定 $\mathbb{N} \cap [0, n)\ (n \in \mathbb{N}^*)$ 的排列 $\vec{p} = (p_i)_{i = 0}^{n - 1}$。你可以执行任意次以下操作：选择 $i \in \mathbb{N} \cap [1, n - 1)$ 满足 $p_{i - 1} < p_i > p_{i + 1}$，交换 $p_{i - 1},p_{i + 1}$。数出有多少种排列能从 $\vec{p}$ 出发经过任意有限次这样的操作得到，答案对 $M = 998\,244\,353$ 取模。
>
> 保证 $3 \leq n \leq 10^6$。

## 2026 “钉耙编程”中国大学生算法设计暑期联赛（6）

### I. Imperfect Permutation

> 给定一棵 $(n + 1)$ 层的满二叉树。初始时，所有叶节点从左到右依次编号为 $0$ 到 $2^n - 1$。可以进行任意有限次操作，每次选择树上的一个节点，交换其左右子树，设这样得到的叶节点从左到右的编号序列为 $\vec{a} = (a_i)_{i = 0}^{2^n - 1}$。现在给定 $\mathbb{N} \cap [0, 2^n)$ 的一个排列 $\vec{p} = (p_i)_{i = 0}^{2^n - 1}$，求 $\sum_{i = 0}^{2^n - 1} (a_i = p_i)$ 的最大值。
>
> 保证 $n \leq 22$。

## 2026 牛客暑期多校训练营 7

### H. Modulo Triples

> 给定 $n \in \mathbb{N}^*$，你需要将 $\mathbb{N} \cap [0, 3n)$ **划分**为 $n$ 个三元组 $((x_i, y_i, z_i))_{i = 0}^{n - 1}$ 使得
> $$
> (\forall i \in \mathbb{N} \cap [0, n))\ (x_i \bmod{z_i} = y_i).
> $$
> 可以证明这样的划分一定存在。求任意一组合法的划分。
>
> 保证 $n \leq 2 \times 10^5$。

## 2026 “钉耙编程”中国大学生算法设计暑期联赛（7）

今天贡献了 9 发罚时，占全队罚时次数的 $9/13$，我是罚时大王🎉

### H. 今晚吃 NPC

> 给定 $(op_{i})_{i = 0}^{n - 2} \in \{\land, \oplus, \lor\}^{n - 1}\ (n \in \mathbb{N}^*)$ 和 $y \in \mathbb{N}$ 表示关于 $\vec{x} = (x_i)_{i = 0}^{n - 1} \in \mathbb{N}^n$ 的方程 $x_0 \mathbin{op_0} x_1 \mathbin{op_1} \cdots \mathbin{op_{n - 2}} x_{n - 1} = y$，求任意一组解或报告无解。
>
> 保证 $2 \leq n \leq 10^5$ 且 $y < 2^{31}$。要求 $(\forall i \in \mathbb{N} \cap[0, n))\ (x_i < 2^{31})$。

容易想到实际上只需在 $\vec{x} \in \{0, 1\}^n$ 下分别令 $y = 0$ 和 $y = 1$，分别求出一组解 $\vec{b}_y\ (y \in \{0, 1\})$。于是对题目给定的 $y = (\overline{y_{30} \dots y_0})_{(2)}$，取
$$
(\forall i \in \mathbb{N} \cap [0, n))\ \left(x_i = \sum_{j = 0}^{30} b_{y_j, i} \cdot 2^j\right)
$$
即可，即对各位分别解该方程再将解按位拼起来。

很不幸，我将 $31$ 当成了 $32$ 处理，导致我从头到尾一直 WA。队友嫌我的代码太 modern，说看不懂（其实我平时也难以接受他的码风），自己写了一发就过了。

值得注意的是，我在比赛时因为忘记了怎么把表达式建成树，反正复杂度允许，所以选择用稀疏表乱搞如下（编号 $\mathbb{N} \cap [0, n)$ 的节点是运算数，$\mathbb{N} \cap [n, 2n - 1)$ 的是运算符）：
```cpp
inline void solve() {
	size_t n;
	uint32_t target;
	std::cin >> n >> target;
	std::string opers;
	opers.reserve(n);
	std::cin >> opers;
	assert(opers.size() + 1 == n);

	auto cmp = [&](size_t lhs, size_t rhs) -> size_t {
		auto lp = priorityOf(opers[lhs]);
		auto rp = priorityOf(opers[rhs]);
		return ((lp < rp) ? lhs : ((lp == rp) ? std::min(lhs, rhs) : rhs));
	};
	std::vector<size_t> idxs(opers.size());
	std::iota(idxs.begin(), idxs.end(), 0);
	SparseTable<size_t, decltype(cmp)> st(std::move(idxs), cmp);
	std::vector<std::array<size_t, 2>> children_of(n + opers.size(),
												   {size_t(-1), size_t(-1)});
	auto construct = [&](auto &&self, size_t beg, size_t end) -> size_t {
		assert(beg <= end && end <= opers.size());
		if (beg == end) {
			return beg;
		}
		if (beg + 1 == end) {
			children_of[n + beg] = {beg, beg + 1};
			return (n + beg);
		}
		size_t rt = st.query(beg, end - beg);
		// size_t rt = beg;
		// for (size_t i = beg + 1; i < end; ++i) {
		// 	if (priorityOf(opers[i]) < priorityOf(opers[rt])) {
		// 		rt = i;
		// 	}
		// }
		children_of[n + rt] = {self(self, beg, rt), self(self, rt + 1, end)};
		return (n + rt);
	};
	auto rt = construct(construct, 0, opers.size());

	std::array<std::vector<bool>, 2> slns;
	slns.fill(std::vector<bool>(n));
	for (unsigned tot = 0; tot < 2; ++tot) {
		auto &sln = slns[tot];
		auto solve = [&](auto &&self, size_t rt, bool val) -> void {
			assert(rt < children_of.size());
			if (rt < n) {
				assert(children_of[rt][0] == size_t(-1) && children_of[rt][1] == size_t(-1));
				sln[rt] = val;
				return;
			}
			auto [lch, rch] = children_of[rt];
			switch (opers[rt - n]) {
			case '|':
			case '&':
				self(self, lch, val);
				self(self, rch, val);
				break;
			case '^':
				self(self, lch, 1);
				self(self, rch, 1 ^ val);
				break;
			default:
				assert(0);
			}
		};
		solve(solve, rt, tot);
	}

	std::vector<uint32_t> answers(n);
	for (unsigned i = 0; i < 31; ++i) {
		bool bit = ((target >> i) & 1);
		for (size_t j = 0; j < n; ++j) {
			answers[j] |= (uint32_t(slns[bit][j]) << i);
		}
	}

	std::cout << "Yes\n";
	for (auto ans : answers) {
		std::cout << ans << ' ';
	}
	std::cout << '\n';
}
```

时间复杂度：$\Theta(n \log n + B n)$，其中 $B = 31$。

空间复杂度：$\Theta(n \log n)$。

#### 关于表达式建树

这其实是一个很基础的问题。我知道是用栈来处理，但我的确忘记了具体的细节。

一般地，我们需要开两个栈：

- 节点栈：用于存放子树节点。
- 符号栈：用来存放运算符和左括号。

顺序扫描整个表达式字符串，对每个解析出的词语的处理规则如下：

- 运算数：创建树节点，压入节点栈。
- 左括号：压入符号栈。
- 右括号：不断从符号栈中弹出运算符，直至遇到左括号。对于每次弹出的运算符，从节点栈中弹出两个节点，与弹出的运算符组合成一棵子树，重新压入符号栈。舍弃左括号。
- 运算符：不断弹出符号栈，对每次弹出的运算符，从节点栈中弹出两个元素与之构建子树并压入节点栈，直至符号栈顶部的运算符优先级**小于**当前访问到的运算符，然后将其压入符号栈。

遍历结束后，将符号栈按照遇到右括号的规则全部弹出（假想整个表达式外面还有一层括号）。这样，节点栈中最后剩下的节点就是根节点。

本题只需考虑运算符，且不需要解析字符串。只需将上面代码中建树部分改为以下代码即可：
```cpp
	std::vector<size_t> nodes_stk{0}, opers_stk;
	nodes_stk.reserve(n), opers_stk.reserve(opers.size());
	std::vector<std::array<size_t, 2>> children_of(n + opers.size(),
												   {size_t(-1), size_t(-1)});
	for (size_t i = 0; i < opers.size(); ++i) {
		while (opers_stk.size() && priorityOf(opers[opers_stk.back()]) >= priorityOf(opers[i])) {
			size_t rt = opers_stk.back();
			opers_stk.pop_back();
			assert(nodes_stk.size() >= 2);
			size_t rch = nodes_stk.back();
			nodes_stk.pop_back();
			size_t lch = nodes_stk.back();
			nodes_stk.pop_back();
			children_of[n + rt] = {lch, rch};
			nodes_stk.emplace_back(n + rt);
		}
		opers_stk.emplace_back(i);
		nodes_stk.emplace_back(i + 1);
	}
	while (opers_stk.size()) {
		size_t rt = opers_stk.back();
		opers_stk.pop_back();
		assert(nodes_stk.size() >= 2);
		size_t rch = nodes_stk.back();
		nodes_stk.pop_back();
		size_t lch = nodes_stk.back();
		nodes_stk.pop_back();
		children_of[n + rt] = {lch, rch};
		nodes_stk.emplace_back(n + rt);
	}
	assert(nodes_stk.size() == 1);
	size_t rt = nodes_stk.back();
```

时间复杂度和空间复杂度均优化到 $\Theta(n)$。

## 2026 “钉耙编程”中国大学生算法设计暑期联赛（8）

### 1008. 分数越小还是越大越好

> 给定一棵 $n \in \mathbb{N}^*$ 个点的树 $T = (V, E)$，其中 $V = \mathbb{N} \cap [0, n)$。记 $P(u, v)\ (u,v \in V)$ 为 $T$ 上以 $u,v$ 为端点的简单路径的顶点组成的集合。你需要选择一个 $\mathbb{N} \cap [0, n))$ 的排列 $\vec{p} = (p_i)_{i = 0}^{n - 1}$，定义
> $$
> f: (\vec{p}, u, v) \mapsto \operatorname{mex}\{p_x: x \in P(u, v)\}\ (u,v \in V),
> $$
> 定义
> $$
> g: \vec{p} \mapsto \sum_{u = 0}^{n - 1} \sum_{v = u}^{n - 1} f(u, v).
> $$
> 求对于所有可能的 $\vec{p}$，$g(\vec{p})$ 的最小值和最大值。
>
> 有最多 $1000$ 组测试数据，保证对每组测试数据有 $3 \leq n \leq 2000$ 且 $\sum n^2 \leq 2 \times 10^7$。

## 2026 “钉耙编程”中国大学生算法设计暑期联赛（9）

### 1007. 小乖的在益起

> 给定 $m,n \in \mathbb{N}^*\ (m < n)$ 和 $\vec{a} = (a_i)_{i = 0}^{n - 1} \in \mathbb{N}^n,\ \vec{b} = (b_i)_{i = 0}^{n - 1} \in (\mathbb{N} \cap [0, m))^n$。记 $cnt(b, e, x, y) = \sum_{i = b}^{e - 1}(a_i = x \land b_i = y)$。现在有 $q$ 次修改或询问：
>
> - 修改：指定 $p,x,y \in \mathbb{N}\ (p < n,\ y < m)$，修改 $a_p \gets x,\ b_p \gets y$。
>
> - 询问：指定 $b,e \in \mathbb{N}\ (b < e \leq n)$，查询
>   $$
>   (\forall x \in \mathbb{N})\ (\exists c \in \mathbb{N})\ (\forall y \in \mathbb{N} \cap [0, m))\ (cnt(b, e, x, y) = c)
>   $$
>   是否成立。
>
> 保证 $n,q \leq 2 \times 10^6$，$(\forall i \in \mathbb{N} \cap [0, n))\ (a_i,x < 10^9)$。本题时限 $10\ \mathrm{s}$。

容易想到必须有 $m \mid (e - b)$，但这只是一个平凡的情况。比赛时止步于此。

对于一次查询 $[b, e)$，记 $c_{x, y} = cnt(b, e, x, y)\ (x,y \in \mathbb{N},\ y < m)$。记初始的 $\vec{a}$ 和所有修改涉及的 $x$ 的集合为 $X$，显然 $|X| \leq n + q$，所以这实际上形成一个第一维稀疏的矩阵 $c = ((c_{x, y})_{y = 0}^{m - 1})_{x \in X}$。我们需要查出这个矩阵的各列是否相等，也即各行是否分别是同一值。

取 $Y = \mathbb{N} \cap [0, m)$。

题目要求单点修改、区间查询，这是典型的树状数组或线段树的特征；然而，区间查询的条件十分复杂，考虑将其转换为这些数据结构擅长的区间和形式。“一行是同一值”可以转换为“一行的差分为 $\vec{0}$”；而如果我们对整个矩阵 $c$ 考虑，问题就转换为判断“$c$ 各列的差分是否为 $0$ 矩阵”。直接维护这个差分矩阵 $d$，需要 $\Theta((n + q) \cdot m)$ 的空间，难以接受；但因为我们只需判断整个矩阵是否为 $0$，所以可以采用**随机投影**方法，选取适当的 $u,v$ 将矩阵压成一个数
$$
h(d) = \sum_{x \in X} \sum_{y \in Y} u(x) \cdot v(y) \cdot d_{x, y}.
$$
当 $d = 0$ 时，必有 $h(d) = 0$；当 $h(d) = 0$ 时，的确有可能 $d \neq 0$，但我们可以通过适当选取 $u(x),v(y)$ 来让这个概率很小，例如在很大的范围内完全随机地选取。取 $c_{x, m} = c_{x, 0}\ (x \in X)$，$v(-1) = v(m - 1)$，展开
$$
\begin{aligned}
h(d) &= \sum_{x \in X} \sum_{y \in Y} u(x) \cdot v(y) \cdot (c_{x, y + 1} - c_{x, y}) \\
&= \sum_{x \in X} u(x) \sum_{y = 0}^{m - 1} v(y) \cdot (c_{x, y + 1} - c_{x, y}) \\
&= \sum_{x \in X} u(x) \sum_{y = 0}^{m - 1} c_{x, y} (v(y - 1) - v(y)).
\end{aligned}
$$
别忘了我们的 $c_{x, y}$ 是个计数数组。第 $i \in \mathbb{N} \cap [b, e)$ 个元素能让 $c_{a_i, b_i}$ 增大 $1$，所以对 $h(d)$ 的贡献是 $u(a_i) \cdot (v(b_i - 1) - v(b_i))$。

取一个质数 $p$，记 $P = \mathbb{N} \cap [0, p)$。为每个 $x \in X$ 分配一个随机数 $u(x) \overset{\text{i.i.d.}}{\sim} U(P)$。同样，为每个 $y \in Y$ 分配随机数 $v(y) \overset{\text{i.i.d}}{\sim} U(P)$。

因为我们选取的是一个必要不充分条件代替真正的判断条件，所以我们不会将查询的命题为真误判为假（假阴性），但有可能将查询的命题为假误判为真（假阳性）。我们估算一下假阳性的概率，也就是事件“$d \neq 0$ 但 $h(d) = 0$”的概率。取 $d$ 中不全为 $0$ 的某一行，设取到第 $x^*$ 行。取这一行中不为 $0$ 的某一项，设取到第 $y^*$ 项。无论第 $x^*$ 行中，除第 $y^*$ 项以外的元素如何取值，$v(y^*)$ 都有 $\frac{1}{p}$ 的概率取到
$$
-\frac{1}{d_{x^*, y^*}}\sum_{y \in Y \setminus\{y^*\}} d_{x^*, y} \cdot v(y),
$$
从而使 $(dv)(x^*) = 0$；而这是 $dv = 0$ 的一个必要不充分条件，所以
$$
\mathbb{P}(dv = 0 \mid d \neq 0) \leq \mathbb{P}((dv)(x^*) = 0 \mid d \neq 0) = \frac{1}{p}.
$$
$dv = 0$ 是 $h(d) = 0$ 的一个充分不必要条件，所以我们还需要考虑 $dv \neq 0$ 的情况，此时
$$
h(d) = \sum_{x \in X} u(x) \cdot (dv)(x)
$$
是对各个 $u(x)$ 的线性组合，所以同样，选取某个满足 $(dv)_{x^*} \neq 0$ 的 $x^* \in X$，这一项有 $\frac{1}{p}$ 的概率取到
$$
-\frac{1}{dv(x^*)}\sum_{x \in X \setminus \{x^*\}} (dv)(x) \cdot u(x)
$$
使 $h(x) = 0$，因此
$$
\mathbb{P}(h(d) = 0 \mid d \neq 0 \land dv \neq 0) = \frac{1}{p}
$$
综上，
$$
\begin{aligned}
\mathbb{P}(h(d) = 0 \mid d \neq 0) &= \mathbb{P}(dv = 0 \mid d \neq 0) + \mathbb{P}(dv \neq 0 \mid d \neq 0) \cdot \mathbb{P}(h(d) = 0 \mid d \neq 0 \land dv \neq 0) \\
&\leq \mathbb{P}(dv = 0 \mid d \neq 0) + \mathbb{P}(h(d) = 0 \mid d \neq 0 \land dv \neq 0) \\
&\leq \frac{1}{p} + \frac{1}{p} = \frac{2}{p}.
\end{aligned}
$$
不过，我们需要保证一个非 $0$ 的整数差分项模 $p$ 后仍然非 $0$，因为 $d \in (\mathbb{Z} \cap [-n, n])^{X \times Y}$，所以只需取 $p > n$ 即可。

为简便起见，我们取了 $u,v$ 后就可以简记 $v \gets ((y \mapsto v(y - 1) - v(y)) \bmod p)_{y \in Y}$，于是
$$
h(d) \equiv \sum_{x \in X} \sum_{y \in Y} u(x) \cdot c_{x, y} \cdot v(y) \pmod{p}.
$$
确定了 $u,v$ 后，我们就只需维护 $\vec{w} = (w_i)_{i = 0}^{n - 1} = (u(a_i) \cdot v(b_i))_{i = 0}^{n - 1}$，这是各项对 $h(d)$ 的贡献。查询区间 $[b, e)$ 时，计算 $\sum_{i = b}^{e - 1} w_i$ 即可。可以用树状数组或线段树维护这个数组。

```cpp
struct ModPlus {
	uint64_t mod;

	uint64_t operator()(uint64_t lhs, uint64_t rhs) const {
		return (SC<__uint128_t>(lhs) + rhs) % mod;
	}
};

struct Modification {
	size_t p;
	uint32_t x, y;
};

struct Query {
	size_t beg, end;
};

using Oper = std::variant<Modification, Query>;

inline void preprocess() {}

inline uint64_t modMul(uint64_t lhs, uint64_t rhs, uint64_t mod) {
	return (SC<__uint128_t>(lhs) * rhs % mod);
}

inline void solve() {
	constexpr uint64_t P = (uint64_t(1) << 61) - 1;
	size_t m, n, q;
	std::cin >> n >> q >> m;

	std::vector<uint32_t> a(n), b(n);
	std::unordered_map<uint32_t, uint32_t> mp;
	mp.reserve(n + q);
	for (auto &e : a) {
		std::cin >> e;
		if (!mp.contains(e)) {
			auto sz = mp.size();
			mp.emplace(e, sz);
		}
	}
	for (auto &e : b) std::cin >> e;

	std::vector<Oper> opers(q);
	for (auto &oper : opers) {
		unsigned op;
		std::cin >> op;
		if (op == 1) {
			size_t p;
			uint32_t x, y;
			std::cin >> p >> x >> y;
			--p;

			if (!mp.contains(x)) {
				auto sz = mp.size();
				mp.emplace(x, sz);
			}

			oper.emplace<Modification>(p, x, y);
		} else if (op == 2) {
			size_t beg, end;
			std::cin >> beg >> end;
			--beg;

			oper.emplace<Query>(beg, end);
		} else {
			assert(0);
		}
	}

	std::vector<uint64_t> x_weights(mp.size()), y_weights(m);
	std::mt19937_64 mt(std::random_device{}());
	std::uniform_int_distribution<uint64_t> distrib(0, P - 1);
	for (auto &w : x_weights) w = distrib(mt);
	for (auto &w : y_weights) w = distrib(mt);
	{
		auto y_weight_back = y_weights.back();
		for (size_t i = m - 1; i; --i) {
			y_weights[i] = (y_weights[i - 1] - y_weights[i] + P) % P;
		}
		y_weights[0] = (y_weight_back - y_weights[0] + P) % P;
	}

	std::vector<uint64_t> weights(n);
	for (size_t i = 0; i < n; ++i) {
		weights[i] = modMul(x_weights[mp[a[i]]], y_weights[b[i]], P);
	}

	FenwickTree<uint64_t, ModPlus> tree(weights, ModPlus(P));
	for (const auto &oper : opers) {
		unsigned op = oper.index();
		if (op == 0) {
			auto [p, x, y] = std::get<Modification>(oper);
			assert(p < n);
			assert(mp.contains(x));
			assert(y < m);

			auto cur = tree.get(p);
			auto nxt = modMul(x_weights[mp[x]], y_weights[y], P);
			auto diff = (nxt - cur + P) % P;
			tree.modify(p, diff);
		} else if (op == 1) {
			auto [beg, end] = std::get<Query>(oper);
			assert(beg < end);

			if ((end - beg) % m) {
				std::cout << "NO\n";
				continue;
			}

			auto res = tree.query(beg, end - beg);
			std::cout << (res ? "NO\n" : "YES\n");
		} else {
			assert(0);
		}
	}
}
```

时间复杂度：$\Theta(m + n + |X| + q \log n) = O(m + n + q \log n)$。

空间复杂度：$\Theta(m + n + q + |X|) = O(m + n + q)$。

---

事实上，只要（差分后的）$v$ 满足 $\sum_{y \in Y} v(y) = 0$ 即可，所以也可以随机取 $v(y)\ (y \in Y^*)$ 然后令 $v(0) = -\sum_{y \in Y^*} v(y)$。这实际上是等价的，即 $\sum_{y = 0}^{m - 1} v(y) = 0$ 当且仅当 $v$ 由某个数组 $\tilde{v} = (\tilde{v}(y))_{y = 0}^{m - 1}$ 循环差分得到。

- 充分性：取 $\tilde{v}$，对其循环差分得到 $v$，即 $v(y) = \tilde{v}((y + 1) \bmod m) - \tilde{v}(y)\ (y \in \mathbb{N},\ y < m)$。此时有
  $$
  \sum_{y = 0}^{m - 1} v(y) = \sum_{y = 0}^{m - 1} \tilde{v}((y + 1) \bmod m) - \sum_{y = 0}^{m - 1} \tilde{v}(y) = \sum_{y = 0}^{m - 1} \tilde{v}(y) - \sum_{y = 0}^{m - 1} \tilde{v}(y) = 0.
  $$

- 必要性：取 $v$ 满足 $\sum_{y = 0}^{m - 1} v(y) = 0$，此时可以取 $\tilde{v}$ 为 $\tilde{v}(y) = \sum_{i = 0}^{y - 1} v(i)$，此时也有
  $$
  v(y) = \tilde{v}((y + 1) \bmod m) - \tilde{v}(y).
  $$

~~这神秘方法到底怎么想到的？怎么能过三百多队的？？？~~

## 2026 牛客暑期多校训练营 10

### A. 夏日影

~~神秘初中几何题以一敌三，战损 9/1。~~

> 给定 $\mathbb{R}^2$ 上的三个点 $S,A,B$，保证 $|OA| = |OB| \triangleq l$，$y_S,y_A,y_B > 0$ 且 $\det\begin{bmatrix}\overrightarrow{OA} & \overrightarrow{OB}\end{bmatrix} \geq 0$。现在有一根长为 $l$ 的硬细直棒一端固定在 $O$ 点，另一端自由，该棒可以在 $\overrightarrow{OA}$ 与 $\overrightarrow{OB}$ 间自由转动。阳光沿 $\vec{SO}$ 方向平行投射，求棒在 $x$ 轴上的影子长度的最小值和最大值。
>
> 保证给定的坐标都是整数且 $-10^5 \leq x_S,x_A,x_B \leq 10^5$，$1 < y_S,y_A,y_B \leq 10^5$。要求答案与标准答案的绝对误差和相对误差都不超过 $10^{-6}$。

这道题的思路是很显然的，于是我自信地写完提交，WA，改正后居然 RE，认为是 assertion failed，百思不得其解。后来又改了点平凡情况的错误，但还是不对，一共交了六发都不过。因思路简单，遂让队友重写，交了三发，也不过。

最后队友推测，因为我们都是用的正弦定理，用到了三角函数，误差累积，导致答案精度不足。遂直接用向量重写，一遍过。

```cpp
inline void solve() {
	Vec sun, left, right;
	std::cin >> sun.x >> sun.y >> left.x >> left.y >> right.x >> right.y;
	assert(std::abs(right.norm() - left.norm()) < EPS);
	assert(Vec::cross(left, right) > -EPS);

	auto left_proj = getProjection(sun, left);
	auto right_proj = getProjection(sun, right);

	Ld min = INFINITY, max = -INFINITY;
	if (Vec::cross(left, sun) > -EPS && Vec::cross(sun, right) > -EPS) { // left <= sun <= right
		min = 0;
	} else {
		min = std::min(std::abs(left_proj), std::abs(right_proj));
	}

	if (std::abs(sun.x) < EPS) {
		max = std::max(std::abs(left.x), std::abs(right.x));
		assert(max == std::max(std::abs(left_proj), std::abs(right_proj)));
	} else {
		auto perp = sun;
		assert(std::abs(perp.x) >= EPS);
		if (perp.x > 0) {
			perp.rotateRightAngle(1);
		} else {
			perp.rotateRightAngle(-1);
		}

		if (Vec::cross(left, perp) > -EPS && Vec::cross(perp, right) > -EPS) {
			Vec rod = perp * left.norm() / perp.norm();
			auto proj = getProjection(sun, rod);
			max = std::abs(proj);
		} else {
			max = std::max(std::abs(left_proj), std::abs(right_proj));
		}
	}

	assert(min <= max + EPS);

	std::cout << min << ' ' << max << '\n';
}
```

### B. 老虎机

> 初始时，$\vec{X} = (X_i)_{i = 0}^{n - 1} \overset{\text{i.i.d.}}{\sim} (U[0, l])^n\ (l,n \in \mathbb{N}^*)$，即各值互相独立且服从**实数**区间 $[0, m]$ 上的均匀分布。现在进行 $m$ 次操作，每次选择 $\max_{i = 0}^{n - 1} X_i$ 作为本轮分数，并重新抽取 $X_i$。求各轮分数之和的期望。
>
> 保证 $l,n \leq 300,\ m \leq 10^9$。

妈的，好久没碰过撬棍和概率论了，积分积了几个小时，思路完全正确，因为不知道结论（也许是忘了）而无法推进。

因为每次都会取走最大值然后重新抽一个，所以我们不妨提前抽好。考虑第 $i \in \mathbb{N}$ 轮，如果我们抽取 $n + i$ 个 $U[0, l]$，将结果从大到小排序，则最大的 $i + 1$ 个必然是前 $i + 1$ 轮的答案；虽然我们无法知道第 $i$ 轮的答案具体是其中哪一个，但对题目无影响。于是开始积分推式子，积了几个小时，正确的式子不多，错误的式子不少，但的确是推出来了一些，但根据估计，因为需要将一个巨大的分子（二项式系数）除上一个巨大的分母，我们认为在常规浮点数精度下不可能达到题目要求的精度，陷入困境。

事实上这是因为我不知道或忘记了一个重要结论，即次序统计量的期望性质。

#### 次序统计量的分布

设 $\vec{X} = (X_i)_{i = 0}^{n - 1}$ 各分量独立同分布，其共同的分布函数为 $F$，概率密度函数为 $f$，按不严格升序排序得到 $(X_{(i)})_{i = 0}^{n - 1}$，称为次序统计量。对每个样本做“是否小于等于 $x$”的 Bernoulli 试验，成功概率为 $F(x)$，因此
$$
F_{X_{(i)}}(x) = \mathbb{P}(X_{(i)} \leq x) = \sum_{j = i + 1}^n \binom{n}{j} (F(x))^j (1 - F(x))^{n - j},
$$
即至少 $i + 1$ 个样本的值不超过 $x$ 的概率。求导可得概率密度函数
$$
f_{X_{(i)}}(x) = \frac{n!}{i!(n - i - 1)!} (F(x))^i (1 - F(x))^{n - i - 1} f(x).
$$

#### 次序统计量的期望

若概率密度函数和期望都存在，就可以直接积分得
$$
\mathbb{E}(X_{(i)}) = \int_{-\infty}^{+\infty} f_{X_{(i)}}(x) \cdot x \mathrm{d}x.
$$
以上都在比赛时基本想到了，剩下的就不知道了。

特别地，如果 $F$ 连续，则 $F(X) \sim U(0, 1)$。

> **证明**
>
> 有空再写。

此时 $F(X_{(i)}) \sim \Beta(i + 1, n - i)$，其概率密度函数为
$$
f_{F(X_{(i)})}(y) = \frac{y^i (1 - y)^{n - i - 1}}{\Beta(i + 1, n - i)}\ (0 < y < 1),
$$
其中 Beta 函数
$$
\Beta(x, y) = \frac{\Gamma(x)\Gamma(y)}{\Gamma(x + y)} = \int_0^1 t^{x - 1} (1 - t)^{y - 1} \mathrm{d}t\ (x,y \in \mathbb{C},\ \Re(x),\Re(y) > 0).
$$
于是期望
$$
\mathbb{E}(X_{(i)}) = \frac{1}{\Beta(i + 1, n - i)} \int_0^1 y^i (1 - y)^{n - i - 1} F^{-1}(y) \mathrm{d}y.
$$

##### 均匀分布

设 $\vec{X} \overset{\text{i.i.d.}}{\sim} (U(0, 1))^n$，则 $F^{-1}(y) = y\ (0 < y < 1)$，于是
$$
\int_0^1 y^i (1 - y)^{n - i - 1} \cdot y \mathrm{d}y = \int_0^1 y^{i + 1} (1 - y)^{n - (i + 1)} \mathrm{d}y = \Beta(i + 2, n - i)
$$
代入得
$$
\mathbb{E}(X_{(i)}) = \frac{\Beta(i + 2, n - i)}{\Beta(i + 1, n - i)} = \frac{\frac{\Gamma(i + 2)\Gamma(n - i)}{\Gamma(n + 2)}}{\frac{\Gamma(i + 1)\Gamma(n - i)}{\Gamma(n + 1)}} =\frac{\frac{(i + 1)!}{(n + 1)!}}{\frac{i!}{n!}} = \frac{i + 1}{n + 1}.
$$

##### 指数分布

设 $\vec{X} \overset{\text{i.i.d.}}{\sim} (E(\lambda))^n$。根据指数分布的无记忆性，可以推出相邻次序统计量的间距相互独立，且
$$
X_{(i + 1)} - X_{(i)} \sim E((n - i - 1)\lambda),
$$
所以
$$
\mathbb{E}(X_{(i)}) = \frac{1}{\lambda} \sum_{j = 0}^{i} \frac{1}{n - j}.
$$

---

所以，采用均匀分布的情况，答案就是
$$
\sum_{i = 0}^{m - 1} \mathbb{E}(X_{(n - 1 + i)}) = \sum_{i = 0}^{m - 1} \frac{(n - 1 + i) + 1}{(n + m - 1) + 1} \cdot l = \sum_{i = 0}^{m - 1} \frac{i + n}{m + n} \cdot l = \frac{l \cdot m \cdot (2n + m- 1)}{2(m + n)}.
$$

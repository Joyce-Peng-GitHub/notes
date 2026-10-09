#import "../../typst-templates/zh.typ": *
#show: template

#align(center)[
  #text(font: (en-font, cn-font-title), size: 2em)[
    数制与位运算
  ]
]

#outline(indent: auto, title: "目录")

#pagebreak()

= 数制

== 进位制表示定理与进制分解

#theorem[进位制表示定理][
  考虑 $B in NN inter [2, +infinity)$ 进制。任何 $x in NN^*$ 都可以#strong[唯一表示]为
  $
    x = sum_(i = 0)^(w - 1) x_i dot B^i
  $
  #h(-indent) 的形式，其中
  $
    (forall i in NN inter [0, w)) space (x_i in NN inter [0, B))
  $
  #h(-indent) 且 $x_(w - 1) != 0$。向量 $arrow(x) = (x_i)_(i = 0)^(w - 1)$ 称为 $x$ #emph[在 $B$ 进制下的表示]。
]<thm:base-representation>

#algorithm[正整数的进制分解算法][
  #alg(
    title: $italic("baseRepresentationOf")$,
    parameters: ($italic("num")$, $italic("base")$),
  )[
    assert $italic("num"),italic("base") in NN^* and italic("base") >= 2$ \
    $italic("res") <- ()$ \
    while $italic("num") != 0$: #algo.i \
    $italic("res") <- vec(italic("res"), italic("num") mod italic("base"))$ \
    $italic("num") <- floor(italic("num") \/ italic("base"))$ #algo.d \
    return $italic("res")$
  ]

  该算法得到的向量就是上面的 $(x_i)_(i = 0)^(w - 1)$。
]<algo:base-representation>

#proof[@algo:base-representation][
  考虑 $B in NN inter [2, +infinity)$ 进制，$x in NN^*$。设
  $
    x div B = q space dots.c dots.c space r,
  $
  #h(-indent) 于是 $q,r in NN$，且 $0 <= r < B$。这相当于分解
  $
    x = q dot B + r,
  $
  #h(-indent) 因为要么 $q dot B = 0$（没有更高位），要么 $q dot B >= B$（不是最低位），所以 $r$ 是 $x$ 在 $B$ 进制下的表示 $(x_i)_(i = 0)^(w - 1)$ 的最低位 $x_0$，而 $q$ 就是剩下的高位部分。

  @algo:base-representation 不断对 $x$ 做上述分解后又令 $x <- q$，直到没有更高位。这样就提取出了从低到高的每一位，因此得到 $x$ 在 $B$ 进制下的一个表示。
]<prf:base-representation-algo>

#proof[@thm:base-representation][
  存在性可由 @algo:base-representation 保证。下面证明唯一性。

  假设 $x in NN^*$ 在 $B in NN inter [2, +infinity)$ 进制下有两个#strong[不同]的表示 $arrow(a) = (a_i)_(i = 0)^(m - 1)$ 和 $arrow(b) = (b_i)_(i = 0)^(n - 1)$。不妨设 $m >= n$。为了方便，将 $arrow(b)$ 补到 $m$ 位，高位补 $0$。将两种表示相减，得到
  $
    sum_(i = 0)^(m - 1) b_i dot B^i - sum_(i = 0)^(m - 1) a_i dot B^i = sum_(i = 0)^(m - 1) (b_i - a_i) dot B^i = 0 = x - x.
  $
  #h(-indent) 设 $arrow(a),arrow(b)$ 最低的不同位是第 $p in NN inter [0, m)$ 位，于是
  $
    sum_(i = p + 1)^(m - 1) (b_i - a_i) dot B^i + (b_p - a_p) = 0,
  $
  #h(-indent) 将方程整体对 $B$ 取模得
  $
    b_p - a_p equiv 0 quad (mod B),
  $
  因此 $a_p equiv b_p quad (mod B)$。然而 $a_p,b_p in NN inter [0, B)$，所以 $a_p = b_p$，与 $p$ 是 $arrow(a),arrow(b)$ 最低的不同位矛盾，故假设不成立，即 $x$ 在 $B$ 进制下不可能有两个不同的表示。
]<prf:base-representation-thm>

扩展：我们可以不用一个有限维向量，而用一个单向无穷项的数列 $(x_i)_(i = 0)^(+infinity)$ 来#strong[唯一表示]任何#strong[非负整数]
$
  x = sum_(i = 0)^(+infinity) x_i dot B^i space ((forall i in NN inter [w, +infinity)) space (x_i = 0)).
$
#h(-indent) 不同于之前的表示，此时 $0$ 也可以被唯一表示。进一步地，如果使用一个双向无穷项的数列 $(x_i)_(i in ZZ)$，我们可以（#strong[不]唯一地）表示任何#strong[实数]
$
  x = sum_(i in ZZ) x_i dot B^i space ((forall i in NN inter [w, +infinity)) space (x_i = 0)).
$
#h(-indent) 此时该表示是#strong[不唯一]的，例如 $(0.dot(9))_((10)) = (1)_((10))$。

== 整幂乘除和取模

对于本部分，考虑 $B in NN inter [2, +infinity)$ 进制。设 $x in NN$ 在 $B$ 进制的表示为数列 $arrow(x) = (x_i)_(i = 0)^(+infinity)$。

=== 乘整幂

设 $y = x dot B^p space (p in NN)$，则
$
  y = sum_(i = 0)^(+infinity) x_i dot B^(i + p),
$
#h(-indent) 因此 $y$ 的 $B$ 进制表示
$
  arrow(y) = (underbrace(0\, dots, p "0's"), x_0, x_1, x_2, dots) = vec(arrow(0)_p, arrow(x)).
$
#h(-indent) 这意味着将 $arrow(x)$ #strong[向高位移动] $p$ 位，并将空出来的低位补 $0$。

=== 除以整幂

设 $y = floor(x \/ B^p) space (p in NN)$，则
$
  y = floor(sum_(i = 0)^(+infinity) x_i dot B^(i - p)).
$
- 小数部分：因为
  $
    sum_(i = 0)^(p - 1) x_i dot B^(i - p) <= sum_(i = 0)^(p - 1) (B - 1) dot B^(i - p) = (B - 1) dot (B^p - 1) / (B - 1) dot B^(-p) = 1 - B^(-p) < 1,
  $
  #h(-indent) 所以小数部分取整后
  $
    floor(sum_(i = 0)^(p - 1) x_i dot B^(i - p)) = 0.
  $
- 整数部分：
  $
    sum_(i = p)^(+infinity) x_i dot B^(i - p) in NN.
  $
#h(-indent) 因此
$
	y = sum_(i = p)^(+infinity) x_i dot B^(i - p) = sum_(i = 0)^(+infinity) x_(i - p) dot B^i,
$
#h(-indent) 其 $B$ 进制表示
$
	arrow(y) = (x_p, x_(p + 1), x_(p + 2), dots),
$
#h(-indent) 即为将 $arrow(x)$ #strong[舍去最低 $p$ 位]。

=== 对整幂取模

设 $y = x mod B^p space (p in NN)$，则
$
y = (sum_(i = 0)^(+infinity) x_i dot B^i) mod B^p = 0 + sum_(i = 0)^(p - 1) x_i dot B^i,
$
#h(-indent) 因此其 $B$ 进制的表示为
$
	arrow(y) = (x_0, x_1, dots, x_(p - 1), 0, 0, 0, dots),
$
#h(-indent) 即只保留 $arrow(x)$ 的最低 $p$ 位，高位全抹为 $0$。

= 二进制与位运算

这一部分只讨论二进制。

== 二进制的特殊性质

二进制有且仅有 $0,1$ 两个数字，这赋予其与其他进制不同的特性。例如，我们可以定义取反运算，从而定义反码、补码，利用补码实现负数及其自然的加减乘除。

=== 位运算

将布尔代数在各位上同时分别运算，即可以得到按位取反、按位与、按位或和按位异或等运算。不同的是，多位之间还可以进行按位移动。

=== 反码、补码

考虑 $w + 1$ 位有符号整数 $x in NN inter [0, 2^w)$，设其二进制表示为 $arrow(x) = (x_i)_(i = 0)^w$。因为 $x >= 0$，所以符号位 $x_w = 0$。

$-x$ 的#emph[反码]定义为 $not arrow(x) = (not x_i)_(i = 0)^w$。在数学上，这个数相当于用 $w + 1$ 位无符号整数 $(underbrace(1 dots 1, (w + 1) "1's"))_((2)) = 2^(w + 1) - 1$ 减去 $x$ 的结果作为 $w + 1$ 位无符号整数的二进制表示。

$-x$ 的#emph[补码]定义为其反码加 $1$，于是在数学上相当于 $w + 1$ 位无符号整数
$
	2^(w + 1) - 1 - x + 1 = 2^(w + 1) - x.
$

为何实际中使用补码表示负数？因为补码具有一个极其关键的性质：
$
	2^(w + 1) - w equiv -w quad (mod 2^(w + 1)).
$
#h(-indent) 利用模意义下加、减、乘的封闭性，可以直接利用 $w + 1$ 位无符号整数的运算实现其有符号的运算而无需考虑符号问题。

== 位运算的妙用

=== 快速对 $2$ 取模

设 $x in NN$。如果想得到 $y = x mod 2^p (p in NN)$，可以令
$
	y = (x and (2^p - 1)),
$
#h(-indent) 因为 $2^p - 1$ 在二进制下是
$
	(0 dots 0 underbrace(1 dots 1, p " 0's"))_((2)).
$
#h(-indent) 对 $2^p - 1$ 做按位与就相当于只保留最低 $p$ 位上的数，而高位置 $0$，即对 $2^p$ 取模。

$w$ 位的无符号整数会对 $2^w$ #strong[自然取模]，即在进行任何运算（算术运算或位运算）时都舍弃溢出的部分，以使结果仍然为 $w$ 位无符号整数。

#strong[有符号整数的溢出是未定义的行为！]

=== 快速乘除 $2$ 的幂

利用按位移动，可以对一个数乘上或除以 $2$ 的幂。

注意，实际的位运算在上述数学意义的基础上仍会发生#strong[自然取模]。例如，当按位左移会使一些位溢出相应位长的整数的表示上界时，会舍弃溢出部分。

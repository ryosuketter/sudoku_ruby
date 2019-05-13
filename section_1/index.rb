# !/usr/bin/ruby
# -*- coding: utf-8 -*-
#
# 数独ソルバー（しらみつぶし法）
#

# gridの内部表現を作り出す
# 例 引数 string == "..53.....8......2..7..1.5..4....53...1..7...6..32...8..6.5....9..4....3......97.."
# 改行とスペース消した値が引数に来る
# .をnilに変換する
def make_grid(string)
  (0..8).collect do |i|
    string[i*9, 9].split(//).collect do |c|
      c == "." ? nil : c.to_i
    end
  end
end

# gridを表示する
def print_grid(grid, pad="\n")
  print grid.collect{ |line|
    line.collect{|v| (v || ".") }.join("")}.join(pad), "\n"
end

# 例 引数 grid == [[nil, nil, 5, 3, nil, nil, nil, nil, nil], [8, nil, nil, nil, nil, nil, nil, 2, nil], ...]
def solve(grid)
  solve_sub(grid, 0)
  grid
end

def solve_sub(grid, p)
  if p > 80
    return true
  else
    i = p / 9 # i 行
    j = p % 9 # j 列
    # 多次元配列
    if grid[i][j]            # すでに数字が入ってるセルならば
      solve_sub(grid, p + 1) # 次のセルに進む(1)
    else                     # 空のセルならば
      1.upto(9) do |v|
        grid[i][j] = v
        if no_violation?(grid, i, j)  # 制約条件に違反していなければ
          if solve_sub(grid, p + 1)   # 次のセルに進み、全てのセルが埋まったら
            return true               # trueを返す
          end
        end
      end
      grid[i][j] = nil # 全て失敗した未確定に戻す
      return false
    end
  end
end

# 制約条件のチェック(1) P10
def no_violation?(grid, i, j)
  (
    block_is_ok?(grid[i]) &&
    block_is_ok?((0..8).collect{|k| grid[k][j]}) &&
    block_is_ok?((0..8).collect{|k| grid[3*(i/3)+(k/3)][3*(j/3)+(k%3)]})
  )
end

# 制約条件のチェック(2)
# select 条件にマッチした要素を返した配列を作る 戻り値は配列
# 例 引数 block == [8, 1, 9, 2, 3, 5, 7, 6, nil] OR [5, 2, 1, 8, 3, 9, 7, 6, 1]
def block_is_ok?(block)
  unique?(block.select{|v| v})
end

# 制約条件のチェック(3)
# uniq 配列の中で重複する要素を削除した新しい配列を返す
def unique?(list)
  (list.length == list.uniq.length)
end

# あらかじめ書いてあるファイルから標準入力する（p4）
# line には ファイル（problem.txt）が入る
ARGF.each do |line|
  # chomp:文字列の末尾の改行文字を取り除いた新しい文字列を返す
  line.chomp!
  print_grid(solve(make_grid(line.gsub(/\s/, ''))))
end

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
  string.split(//).collect{ |c| c == "." ? nil : c.to_i }
end

# gridを表示する
def print_grid(grid, pad="\n")
  print (0..8).collect{|i|
    grid[9*i, 9].collect{|v| (v || ".") }.join("")}.join(pad), "\n"
end

def row(grid, p) # 行
  grid[9 * (p / 9), 9]
end

def column(grid, p) # 列
  (0..8).collect{ |k| grid[9 * k + p % 9] }
end

def square(grid, p)
  (0..8).collect{ |k| grid[9*(3*(p/9/3)+(k/3))+3*(p%9/3)+(k%3)]}
end

def empty_cells(grid)
  (0..80).select{ |p| !grid[p] }
end

def possible_numbers(grid, p)
  (1..9).to_a - fixed_numbers(grid, p)
end

def fixed_numbers(grid, p)
  ( row(grid, p).compact | column(grid, p).compact | square(grid, p).compact )
end

def solve(grid)
  pl = empty_cells(grid).collect{|p|
    [p, possible_numbers(grid, p)]}.sort_by{ |x| x[1].length }
  if pl.empty?
    grid
  else
    p, number = pl[0]
    number.each do |v|
      grid[p] = v
      if solve(grid)
        return grid
      end
    end
    grid[p] = nil # 全て失敗した未確定に戻す
    return false
  end
end

# あらかじめ書いてあるファイルから標準入力する（p4）
# line には ファイル（problem.txt）が入る
ARGF.each do |line|
  # chomp:文字列の末尾の改行文字を取り除いた新しい文字列を返す
  line.chomp!
  print_grid(solve(make_grid(line.gsub(/\s/, ''))))
end

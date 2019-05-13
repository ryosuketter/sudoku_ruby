# !/usr/bin/ruby
# -*- coding: utf-8 -*-
#
# 数独ソルバー（しらみつぶし法）
#

# gridの内部表現を作り出すメソッド
# def make_grid(string)
#   grid = 9.times.collect{ Array.new(9, nil) }
#
#   0.upto(8) do |i|
#     0.upto(8) do |j|
#       grid[i][j] = (string[i*9+j] == '.' ? nil : string[i*9+f].to_i)
#     end
#   end
# end

# gridの内部表現を作り出す
def make_grid(string)
  (0..8).collect do |i|
    string[i*9, 9].split(//).collect do |c|
      c == "." ? nil : c.to_i
    end
  end
end

# gridを表示する
def print_grid(grid, pad="\n")
  print grid.collect{|line|
    line.collect{|v| (v || ".")}.join("")}.join(pad), "\n"
end

def solve(grid)
  solve_sub(grid, 0)
  grid
end

def solve_sub(grid, p)
  if p > 80
    return true
  else
    i = p / 9
    j = p % 9
    if grid[i][j]          # すでに数字が入ってるセルならば
      solve_sub(grid, p+1) # 次のセルに進む(1)
    else                   # 空のセルならば
      1.upto(9) do |v|
        grid[i][j] = v
        if no_violation?(grid, i, j)  # 制約条件に違反していなければ
          if solve_sub(grid, p+1)      # 次のセルに進み、全てのセルが埋まったら
            return true
          end
        end
      end
      grid[i][j] = nil # 全て失敗したので、未確定に戻す
      return false
    end
  end
end

def no_violation?(grid, i, j)
  (
    block_is_ok?(grid[i]) &&
    block_is_ok?((0..8).collect{|k| grid[k][j]}) &&
    block_is_ok?((0..8).collect{|k| grid[3*(i/3)+(k/3)][3*(j/3)+(k%3)]})
  )
end

def block_is_ok?(block)
  unique?(block.select{|v| v})
end

def unique?(list)
  (list.length == list.uniq.length)
end

# def solve(grid, i, j)
#   if grid[i][j] # すでに数字が入ってるセルならば
#     solve(grid, i, j+1) # 次のセルに進む(1)
#   else
#     1.upto(9) do |v|
#       grid[i][j] = v
#       if # 制約条件に違反していなければ
#         if solve(grid, i, j+1) # 次のセルに進み、全てのセルが埋まったら
#           return true
#         end
#       end
#     end
#     grid[i][j] = nil # 全て失敗したので、未確定に戻す
#     false
#   end
# end

# あらかじめ書いてあるファイルから標準入力する（p4）
# line には ファイル（problem.txt）が入る
ARGF.each do |line|
  line.chomp!
  print_grid(solve(make_grid(line.gsub(/\s/, ''))))
end

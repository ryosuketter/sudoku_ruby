# （9×9）のgridを表示する
def print_grid(grid, pad="\n")
  print (0..8).map{ |i|
    grid[9*i, 9].map{ |v|
      (v || ".") }.join("") }.join(pad), "\n"
end

# gridの内部表現を作り出す
# 例 引数 string == "..53.....8......2..7..1.5..4....53...1..7...6..32...8..6.5....9..4....3......97.."
# 改行とスペース消した値が引数に来る
# .をnilに変換する
def convert_dot_to_nil_lists(string)
  # セル番号は、0から80
  # 各セルの値は、確定している場合は整数（1-9）、未確定の場合はnil
  string.split(//).map{ |c| c == "." ? nil : c.to_i }
end

def row(grid, cn) # 行
  grid[9 * (cn / 9), 9]
end

def column(grid, cn) # 列
  (0..8).map{ |k| grid[9 * k + cn % 9] }
end

def square(grid, cn) # 3 * 3の正方形
  (0..8).map{ |k| grid[9*(3*(cn/9/3)+(k/3))+3*(cn%9/3)+(k%3)]}
end

# 空のセルのindex番号を配列として返す
def empty_cell_numbers(grid)
  (0..80).reject{ |p| grid[p] }
end

# すでにセルに入っている数字は除外するための処理（1−9で選ばれていない数字を返す）
def possible_numbers(grid, cell_number)
  (1..9).to_a - fixed_numbers(grid, cell_number)
end

# compact : 配列からnilである要素を取り除いた新しい配列を返す
def fixed_numbers(grid, cell_number)
  (
    row(grid, cell_number).compact |
    column(grid, cell_number).compact |
    square(grid, cell_number).compact
  )
end

def solve(grid)
  empty_cell_numbers = empty_cell_numbers(grid)

  # candidates : セルに置くことができる数字の候補を配列 [index, [候補となる数字（複数も可）]]で返す
  candidates = empty_cell_numbers.map{ |cell_number|
    [cell_number, possible_numbers(grid, cell_number)]
  }

  # 候補となる数字の数が少ない順に並べる
  ordered_candidates = candidates.sort_by{ |cell| cell[1].length }

  if ordered_candidates.empty?
    print "\e[31m"  # bash出力を赤色に
    puts 'complete↓'
    print "\e[0m"   # bash出力の色を元に戻す
    grid
  else

    p ordered_candidates[0]

    cell_number, candidate_values = ordered_candidates[0]

    # puts "セルに置くことができる最初の数字"
    # p  p[0]
    # puts "任意のセルのindex番号"
    # p cell_number
    # puts "任意のセルに入る候補の数字" # => [[42, [9]], [49, [9]], [51, [4, 9]]]
    # p candidate_values

    candidate_values.each do |value|
      grid[cell_number] = value # value : 任意のセルに入る候補の数字

      print_grid(grid)
      puts "残り#{grid.count(nil)}個"
      puts '---------'

      return grid if solve(grid)
      # if solve(grid)
      #   puts "入れる数字がある"
      # else
      #   puts "入れる数字がない" # => つまり解き方は間違っている
      # end
    end

    p "grid[#{cell_number}] => #{grid[cell_number]} 取り消し"
    grid[cell_number] = nil # 全て失敗したら未確定に戻す
    return false
  end
end

# あらかじめ書いてあるファイルから標準入力する（p4）
# line には ファイル（problem.txt）が入る
ARGF.each do |line|
  remove_space_line = line.gsub(/\s/, '')
  value_or_nil_lists = convert_dot_to_nil_lists(remove_space_line)
  solved_lists = solve(value_or_nil_lists)
  print_grid(solved_lists)
end

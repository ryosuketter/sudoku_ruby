grid = [6,7,8,9,10]

def empty_cells(grid)
  # 真になった要素（index番号）を除外した配列を返す
  (0..5).reject{ |p| grid[p] }
end

p grid[0] # -> 6
p grid[1] # -> 7
p grid[2] # -> 8
p grid[3] # -> 9
p grid[4] # -> 10
p grid[5] # -> nil

p empty_cells(grid) # -> [5]
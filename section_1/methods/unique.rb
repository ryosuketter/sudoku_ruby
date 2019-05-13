# 制約条件のチェック(3)
# uniq 配列の中で重複する要素を削除した新しい配列を返す
def unique?(list)
  p list.length
  p list.uniq.length
  (list.length == list.uniq.length)
end

p unique?([2, 5, 1, 8, 7, 9, 4, 6, 3])
# p list.length -> 9
# list.uniq.length -> 9
# true

p unique?([5, 2, 1, 8, 3, 9, 7, 1])
# p list.length -> 8
# list.uniq.length -> 7
# false
class MatrixVectorHelper
  def self.column_width(rows)
    rows.map(&:to_s).map(&:length).max + 2
  end
end

class Matrix
  def inspect
    keys = BrighterPlanet::Purchase.key_map
    paddings = {}
    keys.each_with_index do |key, i|
      paddings[key] = MatrixVectorHelper.column_width(column(i).to_a + [key])
    end
    str = "Matrix: (#{row_size}x#{column_size})\n"
    str += '|' + (['X'.center(5)] + keys.map { |k| k.center(paddings[k]) }).join('|') + "|\n"
    @rows.each_with_index do |row, i|
      items = [keys[i].center(5)]
      row.each_with_index { |i, col| items << i.to_s.center(paddings[keys[col]]) }
      str += '|' + items.join('|') + "|\n"
    end
    str
  end
end
class Vector
  def inspect
    keys = BrighterPlanet::Purchase.key_map
    paddings = {}
    keys.each_with_index do |key, i|
      paddings[key] = MatrixVectorHelper.column_width([to_a[i],key])
    end
    str = "Vector: (#{size})\n"
    str += '|' + (keys.map { |k| k.center(paddings[k]) }).join('|') + "|\n"
    items = []
    to_a.each_with_index { |r, i| items << r.to_s.center(paddings[keys[i]]) }
    str += '|' + items.join('|') + "|\n"
    str
  end
end

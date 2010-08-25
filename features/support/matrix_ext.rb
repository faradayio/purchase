class Matrix
  def inspect
    str = "Matrix:\n"
    keys = BrighterPlanet::Purchase::KEY_MAP
    str += '|' + (['X'.center(5)] + keys.map { |k| k.center(5) }).join('|') + "|\n"
    @rows.each_with_index do |row, i|
      str += '|' + ([keys[i].center(5)] + row.map { |r| r.to_s.center(5) }).join('|') + "|\n"
    end
    str
  end
end
class Vector
  def inspect
    str = "Vector:\n"
    keys = BrighterPlanet::Purchase::KEY_MAP
    str += '|' + (keys.map { |k| k.center(5) }).join('|') + "|\n"
    str += '|' + (to_a.map { |r| r.to_s.center(5) }).join('|') + "|\n"
    str
  end
end

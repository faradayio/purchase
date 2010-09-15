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

RSpec::Matchers.define :have_column_values do |_expected_|
  match do |actual|
    ok = true
    BrighterPlanet::Purchase.key_map.each_with_index do |key, index|
      ok = ok && (actual[index] - _expected_[index].to_f).abs < 0.00001
    end
    ok
  end

  failure_message_for_should do |actual|
    message = nil
    BrighterPlanet::Purchase.key_map.each_with_index do |key, index|
      unless (actual[index] - _expected_[index].to_f).abs < 0.00001
        message = "expected vector at position #{key} to be #{_expected_[index]} +/- (< 0.00001), got #{actual[index]}:"
      end
    end
    message
  end

  failure_message_for_should_not do |actual|
    "expected #{_expected_} +/- (< #{_delta_}), got #{actual}"
  end

  description do
    "be close to #{_expected_} (within +- #{_delta_})"
  end
end

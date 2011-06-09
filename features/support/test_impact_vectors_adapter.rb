module BrighterPlanet
  module Purchase
    module TestImpactVectorsAdapter
      extend self

      def key_map
        @key_map ||= Sector.find(:all, :order => 'io_code').map(&:io_code)
      end

      def matrix
        Matrix[*data]
      end

      def data
        matrix_text = <<-MATRIX
|  X   |111000|3991A0|3991B0|399200|399900|4A0000|
|111000|0.81  |0     |0     |0     |0     |0     |
|3991A0|0     |0.546 |0     |0     |0     |0     |
|3991B0|0     |0     |0.358 |0     |0     |0     |
|399200|0     |0     |0     |1.2   |0     |0     |
|399900|0     |0     |0     |0     |1.08  |0     |
|4A0000|0     |0     |0     |0     |0     |0.623 |
        MATRIX
        lines = matrix_text.split(/\n/)
        lines.shift
        lines.map do |line|
          row = line.scan(/[^\s^|]+/).map(&:to_f)
          row.shift
          row
        end
      end
    end
  end
end

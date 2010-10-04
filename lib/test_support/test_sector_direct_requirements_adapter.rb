module BrighterPlanet
  module Purchase
    class TestSectorDirectRequirementsAdapter
      def self.matrix
        Matrix[*data]
      end

      def self.data
        matrix_text = <<-MATRIX
|  X   |111000 |3991A0 |3991B0 |399200 |399900 |4A0000 |
|111000|1.11660|0.25159|0.37377|0.49894|0.52683|0.50533|
|3991A0|0.12526|1.22952|0.37011|0.49405|0.52167|0.50038|
|3991B0|0.15614|0.31060|1.43230|0.61617|0.64708|0.61527|
|399200|0.15464|0.30761|0.45699|1.57178|0.64085|0.60935|
|399900|0.18444|0.36693|0.54511|0.72808|1.71418|0.72007|
|4A0000|0.18270|0.36347|0.53997|0.72121|0.75461|1.65668|
        MATRIX
        lines = matrix_text.split(/\n/)
        lines.shift
        lines.map do |line|
          row = line.scan(/[A-Z\d\.]+/)
          row.shift
          row.map(&:to_f)
        end
      end
    end
  end
end

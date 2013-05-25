class WordLoader
  class WordLoaderBase
    def read_file(filename = "JyutEnDict.u8")
      out = []
      File.open(Rails.root.to_s + "/tmp/" + filename, 'r').each_with_index do |line, index|
        #skip comments or blank lines
        if line.match(/^#/) or line.match(/^\s*$/)
          next
        end
        out << line

        break unless !(defined? self.class::TESTING_DEPTH) || self.class::TESTING_DEPTH == 0 || index <= self.class::TESTING_DEPTH
      end
      out
    end

  end
end
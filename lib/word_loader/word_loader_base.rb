class WordLoader
  class WordLoaderBase
    def read_file(filename = "JyutEnDict.u8")
      out = []
      index = 0
      File.open(Rails.root.to_s + "/tmp/" + filename, 'r').each do |line|
        #skip comments or blank lines
        if line.match(/^#/) or line.match(/^\s*$/)
          next
        end
        out << line

        index += 1

        break if !(defined? self.class::TESTING_DEPTH) || (self.class::TESTING_DEPTH != 0 and index >= self.class::TESTING_DEPTH)
      end
      out
    end

  end
end
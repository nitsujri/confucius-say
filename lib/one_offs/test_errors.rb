class OneOffs
  class TestErrors < Base

    #reload!; OneOffs::TestErrors

    w    = Word.find(37659)
    text = "[粵拼: dim1]<br>[1] [v] to estimate the weight of something by holding or weighing it with hands<br>[粵拼: dim3]<br>[粵] [2] [v] to shake; to touch<br>[粵拼: dim6]<br>[粵] [3] [adj] satisfactory; in good order; OK | Also written as '𠶧' [4] [adj] straight; vertical | Also written as '𠶧' [5] [v] to pick up with the fingers | Also written as '𠶧'"

    retries = 0
    begin
      w.update_attributes({
        english: text
      })
    rescue => e
      ap e.message

      e.message.match(/:\s'(.*?)[\s']/im){ |m|
        match = m[1].gsub("\\", '\\')
        puts match
        text.gsub!(/#{m[1]}/,"")
        puts text
      }

      retries += 1
      ap "!!!! Retrying"
      retry if retries < 5
      raise e
    end
  end
end

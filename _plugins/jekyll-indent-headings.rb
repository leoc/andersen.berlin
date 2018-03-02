module Jekyll
  module IndentHeadingsFilter
    def indent_headings(input, amount)
      str = input.clone
      addable = amount - 1
      (6 - addable).downto(1) do |i|
        str.gsub!("<h#{i}>", "<h#{i + addable}>")
        str.gsub!("</h#{i}>", "</h#{i + addable}>")
      end
      str
    end
  end
end

Liquid::Template.register_filter(Jekyll::IndentHeadingsFilter)

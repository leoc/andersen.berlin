require 'org-ruby'

module Jekyll
  class OrgConverter < Converter
    safe true
    priority :low

    # Match all files that end in .org
    def matches(ext)
      ext =~ /^\.org$/i
    end

    # Output goes to html
    def output_ext(ext)
      ".html"
    end

    def convert(content)
      Orgmode::Parser.new(content).to_html
    end
  end
end

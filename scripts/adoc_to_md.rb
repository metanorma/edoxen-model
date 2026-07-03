#!/usr/bin/env ruby
# One-shot converter: AsciiDoc → GitHub-flavored Markdown.
# Used only for the TODO.refactor/*.adoc batch conversion.
# Converts:
#   = Title         -> # Title
#   == Section      -> ## Section
#   === Subsection  -> ### Subsection
#   * item          -> - item
#   xref:foo.adoc[label] -> [label](foo.md)
#   :attribute: lists left as-is (kept as preformatted text)
# Code fences ``` already common to both.

require "fileutils"

Dir.glob("TODO.refactor/*.adoc").sort.each do |adoc|
  md = adoc.sub(/\.adoc\z/, ".md")
  text = File.read(adoc)

  lines = text.each_line.map do |raw|
    line = raw.dup
    # Headers — only convert when at start of line.
    line.gsub!(/\A= (\s*.+)/,  "# \\1")
    line.gsub!(/\A== (\s*.+)/, "## \\1")
    line.gsub!(/\A=== (\s*.+)/, "### \\1")
    line.gsub!(/\A==== (\s*.+)/, "#### \\1")
    line.gsub!(/\A===== (\s*.+)/, "##### \\1")
    # xref:filename.adoc[Label] -> [Label](filename.md)
    line.gsub!(/xref:([^\[\]]+?)\.adoc\[([^\[\]]+)\]/) do
      "[#{$2}](#{$1}.md)"
    end
    # xref:filename.adoc[] -> [filename.adoc](filename.md)
    line.gsub!(/xref:([^\[\]]+?)\.adoc\[\]/) do
      "[#{$1}.adoc](#{$1}.md)"
    end
    line
  end

  File.write(md, lines.join)
  FileUtils.rm(adoc)
  puts "  #{File.basename(adoc)} -> #{File.basename(md)}"
end

# Update MASTER index references and PROGRESS.md.
["TODO.refactor/00-MASTER.adoc", "TODO.refactor/PROGRESS.md"].each do |f|
  next unless File.exist?(f)
  text = File.read(f)
  text.gsub!(/xref:([^\[\]]+?)\.adoc\[([^\[\]]+)\]/) { "[#{$2}](#{$1}.md)" }
  text.gsub!(/xref:([^\[\]]+?)\.adoc\[\]/) { "[#{$1}.adoc](#{$1}.md)" }
  out = f.sub(/\.adoc\z/, ".md")
  File.write(out, text)
  FileUtils.rm(f) if f.end_with?(".adoc")
  puts "  updated #{File.basename(out)}"
end

puts "done."

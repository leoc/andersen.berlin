emacs_d = File.read('emacs.d.org')

if emacs_d !~ /\A---/
  File.write('emacs.d.org', "---\ntitle: My emacs.d\nlayout: page\n---\n#{emacs_d}")
end

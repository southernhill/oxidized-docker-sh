class FastIronV10 < Oxidized::Model
  using Refinements

  prompt /^([\w.@()-]+[#>]\s?)$/
  comment  '! '

  cmd :all do |cfg|
    # cfg.gsub! /\cH+\s{8}/, ''         # example how to handle pager
    # cfg.gsub! /\cH+/, ''              # example how to handle pager
    # get rid of errors for commands that don't work on some devices
    cfg.gsub! /^% Invalid input detected at '\^' marker\.$|^\s+\^$/, ''
    cfg.cut_both
  end

  cmd 'show version' do |cfg|
    comments = []
    comments << cfg.lines.first
    lines = cfg.lines
    lines.each_with_index do |line, _i|
      comments << "Version: #{Regexp.last_match(1)}" if line =~ /^\s+SW: Version (.*)$/

      if line =~ /^\s+Compressed Boot-Monitor Image size = \d+, Version:(.*)$/
        comments << "Boot-Monitor Version: #{Regexp.last_match(1)}"
      end

      comments << "Serial: #{Regexp.last_match(1)}" if line =~ /^\s+Serial  #:(.*)$/
    end
    comments << "\n"
    comment comments.join "\n"
  end

  cmd 'show module' do |cfg|
    cfg.gsub! /^$\n/, ''
    cfg.gsub! /^/, 'Modules: ' unless cfg.empty?
    comment "#{cfg}\n"
  end

  cmd 'show media | exclude EMPTY' do |cfg|
    comment cfg
  end

  cmd 'show hardware-info' do |cfg|
    comment cfg
  end

  cmd 'show stack' do |cfg|
    comment cfg
  end

  cmd 'show running-config'

  cfg :telnet do
    username /^(.* login|Username): /
    password /^Password:/
  end

  cfg :telnet, :ssh do
    post_login do
      enable_pass = vars(:enable)
      if enable_pass && enable_pass.to_s.strip.downcase != 'nil'
        cmd 'enable', /^\s*Login:/
        cmd @node.auth[:username], /^\s*Password:/
        cmd enable_pass
      else
        cmd 'enable'
      end
      cmd 'skip-page-display'
    end
    pre_logout 'exit'
    pre_logout 'exit'
  end
end
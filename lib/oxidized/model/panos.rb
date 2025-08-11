class PanOS < Oxidized::Model
  using Refinements

  # PaloAlto PAN-OS model #

  comment '! '

  prompt /^[\w.@:()-]+[>#]\s?$/m

  cmd :all do |cfg|
    cfg.each_line.to_a[2..-3].join
  end

  cmd 'show system info' do |cfg|
    cfg.gsub! /^(up)?time: .*$/, ''
    cfg.gsub! /^app-.*?: .*$/, ''
    cfg.gsub! /^av-.*?: .*$/, ''
    cfg.gsub! /^threat-.*?: .*$/, ''
    cfg.gsub! /^wildfire-.*?: .*$/, ''
    cfg.gsub! /^wf-private.*?: .*$/, ''
    cfg.gsub! /^device-dictionary-version.*?: .*$/, ''
    cfg.gsub! /^device-dictionary-release-date.*?: .*$/, ''
    cfg.gsub! /^url-filtering.*?: .*$/, ''
    cfg.gsub! /^global-.*?: .*$/, ''
    comment cfg
  end

#  cmd 'show config running' do |cfg|
#    cfg
#  end

  cmd 'set cli config-output-format set' do |cfg|
    cfg
  end

  cmd 'configure' do |cfg|
    cfg
  end

  cmd 'show' do |cfg|
    cfg
  end

  cfg :ssh do
    post_login 'set cli pager off'
    pre_logout 'quit'
    pre_logout 'quit'
  end
end

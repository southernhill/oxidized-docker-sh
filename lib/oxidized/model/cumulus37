class Cumulus37 < Oxidized::Model
  prompt /^((\w*)@(.*)):/
  comment '# '

  # add a comment in the final conf
  def add_comment(comment)
    "\n###### #{comment} ######\n"
  end

  cmd :all do |cfg|
    cfg.cut_both
  end

  # show the persistent configuration
  pre do
    # Set FRR or Quagga in config
    cfg = add_comment 'THE HOSTNAME'
    cfg += cmd 'cat /etc/hostname'

    # This command add license, show configuration and show configuration to a single file
    cfg = add_comment 'create configuration file'
    cfg += cmd '{ cl-license && net show configuration && net show configuration commands; } > config.txt'

    cfg = add_comment 'show configuration'
    cfg += cmd 'cat config.txt'

#    cfg = add_comment 'net show configuration commands'
#    cfg += cmd 'net show configuration commands'
  end

  cfg :telnet do
    username /^Username:/
    password /^Password:/
  end

  cfg :telnet, :ssh do
    post_login do
      if vars(:enable) == true
        cmd "sudo su -", /^\[sudo\] password/
        cmd @node.auth[:password]
      elsif vars(:enable)
        cmd "su -", /^Password:/
        cmd vars(:enable)
      end
    end

    pre_logout do
      cmd "exit" if vars(:enable)
    end
    pre_logout 'exit'
  end
end

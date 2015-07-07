default['authorization']['sudo']['sudoers_defaults'] = [
  'env_reset',
  # 'mailto= "root"',
  # 'shell_noargs',
  'insults',
  '!visiblepw',
  # 'requiretty',
  'exempt_group=sudo',
  'always_set_home',
  'secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"',
  # 'env_keep="COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"',
  # 'env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"',
  # 'env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"',
  # 'env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"',
  # 'env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"',
  'env_keep+="HOME"'
]

default['authorization']['sudo']['include_sudoers_d'] = true

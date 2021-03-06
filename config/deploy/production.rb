# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

# role :app, %w{root@cantodictionary.com}
# role :web, %w{root@cantodictionary.com}
# role :db,  %w{root@cantodictionary.com}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'cantodictionary.com', user: 'deploy', roles: %w{web app db}


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'cantodictionary.com',
# user: 'www-data',
# roles: %w{web app db},
# ssh_options: {
#   user: 'root', # overrides user setting above
#   keys: %w(/home/justinlouie/.ssh/git_user_jlouie),
#   forward_agent: false,
#   auth_methods: %w(publickey password)
#   # password: 'please use keys'
# }

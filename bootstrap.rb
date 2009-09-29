#!/usr/bin/env ruby

# Run this before running the bootstrap: 
#   aptitude -y update && apt-get -y install git-core

CHEF_550 = true # Until CHEF-550 is merged into master

def cmd(cmd)
  puts cmd; system(cmd)
end

puts '-' * 80
puts "Chef bootstrap"
puts

cmd "aptitude -y install irb ri rdoc libshadow-ruby1.8 ruby1.8-dev gcc g++ curl"
cmd "curl -L 'http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz' | tar xvzf -"
cmd "cd rubygems* && ruby setup.rb --no-ri --no-rdoc"
cmd "ln -sfv /usr/bin/gem1.8 /usr/bin/gem"

unless CHEF_550
  cmd "gem install rdoc chef ohai --no-ri --no-rdoc --source http://gems.opscode.com --source http://gems.rubyforge.org"
else
  cmd "gem install rake cucumber rspec merb-core merb-slices merb-assets merb-helpers merb-haml mixlib-config mixlib-log mixlib-cli stomp coderay rdoc ohai --no-ri --no-rdoc --source http://gems.opscode.com --source http://gems.rubyforge.org"
  cmd "git clone git://github.com/opscode/chef.git"
  cmd "cd chef && git remote add dawanda git://github.com/dawanda/chef.git"
  cmd "cd chef && git pull dawanda CHEF-550"
  cmd "cd chef && rake gem"
  cmd "cd chef && rake install"
end

# opscode cookbooks
cmd "git clone git://github.com/opscode/cookbooks.git"

# cmd "yes | mkfs -t ext3 /dev/sdq1"
# cmd "yes | mkfs -t ext3 /dev/sdq2"

puts
puts "Done!"
puts '-' * 80

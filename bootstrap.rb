#!/usr/bin/env ruby

CHEF_550 = true # Until CHEF-550 is merged into master

def cmd(cmd)
  puts cmd; system(cmd)
end

puts '-' * 80
puts "Chef bootstrap"
puts

# cmd "aptitude -y update && apt-get -y install git-core"

cmd "aptitude -y install irb ri rdoc libshadow-ruby1.8 ruby1.8-dev gcc g++ curl"
cmd "curl -L 'http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz' | tar xvzf -"
cmd "cd rubygems* && ruby setup.rb --no-ri --no-rdoc"
cmd "ln -sfv /usr/bin/gem1.8 /usr/bin/gem"
cmd "gem install rdoc chef ohai aws-s3 --no-ri --no-rdoc --source http://gems.opscode.com --source http://gems.rubyforge.org"

if CHEF_550
  cmd %q{sed -i 's/Chef::Config\[:file_cache_path\]/::File.expand_path(Chef::Config\[:file_cache_path\])/' /usr/lib/ruby/gems/1.8/gems/chef-0.7.10/lib/chef/provider/template.rb}
end

# opscode cookbooks
cmd "git clone git://github.com/opscode/cookbooks.git"

# disable postgresql ssl for the moment
cmd "sed -i 's/ssl = true/ssl = false/' cookbooks/postgresql/templates/default/postgresql.conf.erb"

# cmd "yes | mkfs -t ext3 /dev/sdq1"
# cmd "yes | mkfs -t ext3 /dev/sdq2"

puts
puts "Done!"
puts '-' * 80

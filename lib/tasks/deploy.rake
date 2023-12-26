namespace :deploy do
  task :check_node_version do
    node_version = `node --version`.strip
    puts "Node.js version: #{node_version}"
    raise 'Yarn requires Node.js 4.0 or higher to be installed.' unless Gem::Version.new(node_version.sub('v', '')) >= Gem::Version.new('4.0.0')
  end
end

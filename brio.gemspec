# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','brio','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'brio'
  s.version = Brio::VERSION
  s.author = 'Tanja Pislar'
  s.email = 'tanja@heroesneverpanic.com'
  s.homepage = 'http://github.com/klaut/brio'
  s.platform = Gem::Platform::RUBY
  s.description = 'Interact with app.net through your command line.'
  s.summary = 'CLI for app.net'
# Add your other files here if you make them
  s.files = %w(
bin/brio
lib/brio/version.rb
lib/brio/api.rb
lib/brio/client.rb
lib/brio/rcfile.rb
lib/brio/format/cvs.rb
lib/brio/format/pretty.rb
lib/brio/resources/user.rb
lib/brio/resources/post.rb
lib/brio.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','brio.rdoc']
  s.rdoc_options << '--title' << 'brio' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'brio'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('rspec')
  s.add_development_dependency('webmock')
  s.add_development_dependency('timecop')
  # s.add_development_dependency('simplecov')
  s.add_development_dependency('pry')
  s.add_dependency('gli')
  s.add_dependency('json')
  s.add_dependency('launchy')
  s.add_dependency('highline')
  s.add_dependency('htmlentities')
  s.add_dependency('faraday')
  s.add_dependency('faraday_middleware')
end

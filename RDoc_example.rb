gem 'sdoc'
# 注意 Ruby 2.4 用
gem 'sdoc', '1.0.0.rc1'

# then bundle install

# edit Rakefile
# Rakefile

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'public/rdoc'
  rdoc.generator = 'sdoc'
  rdoc.template = 'rails'
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include("README.md", "API.md", "lib/", "app")
end

# 然后执行 rails rerdoc 就可以生成了，文档将会到 public/rdoc 目录

访问 localhost:3000/rdoc/index.html
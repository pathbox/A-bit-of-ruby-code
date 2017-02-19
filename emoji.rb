gem 'gemoji'

# Rakefile
load 'tasks/emoji.rake'

rake emoji

# 这个命令把 emoji 表情图片从 gem 的源码中复制到 Rails 的 public 目录下smile_cat，把图片保存在一个固定的地方，这种方式是被官方推荐的sunglasses，当然你也可以手动把所有图片添加到 assets 加载的目录angry

# config/application.rb
config.assets.paths << Emoji.images_path

#然后在部署的时候把它们编译一下 worried

# config/application.rb
config.assets.precompile << "emoji/**/*.png"

#但是因为图片数量过大scream，把它们都添加到 path 中可能会降低应用程序对其它文件的查找fearful，即使 emoji 没有变化，但是在 deploy 的时候编译所有的 emoji 仍然会增加开销，遍历那么多的 emoji，所以不推荐这样做thumbsdown

module EmojiHelper
  def emojify(content)
    h(content).to_str.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias($1)
        %(<img alt="#$1" src="#{image_path("emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="20" height="20" />)
      else
        match
      end
    end.html_safe if content.present?
  end
end

Emoji.find_by_alias("cat").raw

Emoji.find_by_unicode("\u{1f431}").name
=> "cat"
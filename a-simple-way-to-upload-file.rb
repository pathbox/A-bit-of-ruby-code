# 一种非常简单的上传单个文件的方法。只是单纯的上传, 上传文件的一种原理。IO 的写和读

# view
#<%= form_tag({:action => :upload}, :multipart => true) do %>
#  <%= file_field_tag 'picture' %>
#<% end %>
  # <%= form_for @person do |f| %>
  #   <%= f.file_field :picture %>
  # <% end %>


def upload
  upload_file = params[:person][:picture]
  File.open(Rails.root.join('picture','uploads',upload_file.original_filename), 'w') do |file|
    file.write(upload_file.read)    # 将读取到的内容 写入到File.open 创建的文件。从而上传文件成功
  end
end


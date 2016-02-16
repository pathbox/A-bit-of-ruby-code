%header
  - unless current_page?(search_path) # current_page? is a function of view helper
      = render 'search_bar'
 #   end

%header
- unless current_page?(search_path) || current_page?(archive_path)
    = render 'search_bar'
#  end

%header
  = yield :search

- content_for :search do
  = render 'search_bar'
#end

#/ app/views/application/_search_bar.html.haml

= form_tag search_path, method: 'get' do
      = text_field_tag :q


# slow
<% objects.each do |object| %>
  <%= render partial: 'object', locals: { object: object } %>
<% end %>
<%= render partial: 'object', locals: { object: @objects } %>

#fast

<%= render :partial => 'object', :collection => @objects %>

<% @objects.each do |object| %>
  <%= render partial: 'object', locals: { object: object }, inline: true %>
<% end %>

# The reason rendering a collection is faster is that it initializes the template
# only once. Then it reuses the same template to render all objects from the
# collection. Rendering 10,000 partials in a loop will have to repeat the initialization 10,000 times.


# I do not have any better advice than to be careful, for two reasons. First, you
# cannot avoid using these helpers (especially in newer Rails). Second, it’s very
# hard to benchmark them. Helpers’ performance depends on too many factors,
# making any synthetic benchmark useless. For example, link_to and url_for get
# slower when the complexity of your routing increases. And img_tag performs
# worse as you add more assets. In one application it’s safe to render a thousand
# URLs in the loop, whereas in another it’s not. So…be careful.
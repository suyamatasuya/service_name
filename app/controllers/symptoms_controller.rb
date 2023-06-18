<style>
body {
  font-family: 'Noto Serif JP', serif;
  background-color: #004d00;
}

.container {
  max-width: 800px;
}

h1, h2 {
  color: #b3ffb3;
}

.card {
  background-color: #fff;
}

.btn-outline-success {
  border-color: #b3ffb3;
  color: #b3ffb3;
}

.btn-outline-success:hover {
  background-color: #b3ffb3;
  color: #004d00;
}
</style>

<div class="container py-5">
  <h1 class="mb-4 text-center text-white">Posts</h1>

  <%= form_with url: posts_path, method: :get, class: "mb-4" do %>
    <div class="form-group">
      <%= select_tag :body_part, options_for_select([['首', 'neck'], ['腰', 'waist']]), prompt: '部位を選択', class: 'form-control' %>
    </div>
    <%= submit_tag 'Filter', class: 'btn btn-outline-light' %>
  <% end %>

  <% if current_user %>
    <div class="card mb-4">
      <%= form_with model: Post.new do |form| %>
        <div class="card-header">
          <h2 class="mb-0">New Post</h2>
        </div>
        <div class="card-body">
          <%= form.hidden_field :user_id, value: current_user.id %>
          <div class="form-group">
            <%= form.text_area :content, placeholder: 'Write your post here...', class: 'form-control' %>
          </div>
          <%= form.submit 'Post', class: 'btn btn-outline-success' %>
        </div>
      <% end %>
    </div>
  <% end %>

  <% @posts.each do |post| %>
    <div class="card mb-4">
      <div class="card-header">
        <h2 class="mb-0"><%= post.user.name %></h2>
      </div>
      <div class="card-body">
        <p><%= post.content %></p>
      </div>
    </div>
  <% end %>
</div>

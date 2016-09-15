# README

* This is a todo app that allows users to create new lists, add items to those lists, check them off to signify that
they are complete, and be logged in to view/edit lists.
* Before I get started, here are some notes...

## Getting Started

### Gems
* Here are the gems that I am adding:
```ruby
#Gems I've added
gem 'haml', '~> 4.0', '>= 4.0.7'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'  # needs to be configured - DONE
gem 'simple_form', '~> 3.3', '>= 3.3.1' 	# needs to be configured - DONE
gem 'devise', '~> 4.2' 							# needs to be configured
```
* HAML is the only one that I don't need to configure

### Models, Views, Controllers

* **Models:** ToDo Lists, ToDo items, Users (via Devise, not right away)
  * TodoList: title (string), category (string)
    * belongs_to :user
    * has_many :todo_items
  * TodoItem: title (string), description (string)
  	* belongs_to :todo_list
  * Users: provided by Devise
  	* has_many :todo_lists
    * has_many :todo_items ?? <- do users need to own todo_items?
* I will list out the views as I think of them

### Groundrules
1. Note the actions as you build the app
2. Do primary styling AFTER basic functionality
3. Try to figure it out yourself BEFORE Google or referencing previous Rails Apps

## Building the App

```shell
rails g model TodoList title:string category:string
rails generate simple_form:install --bootstrap
rails db:migrate
```
* So I created the model and migrated the database but I still don't have any controllers or views...let's do that now:
```shell
rails g controller todo_lists
```
* I created a basic view (index.html.haml) in views/todo_lists/
* I added the 'resources :todo_lists' to the routes.rb file because...
> Resource routing allows you to quickly declare all of the common routes for a given resourceful controller. Instead of declaring separate routes for your index, show, new, edit, create, update and destroy actions, a resourceful route declares them in a single line of code.
  * [Rails Guides on Routing](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html)
* I added a link_to "New" and then created the "New" view.
  * Because the "new" view is largely just a form, I am going to use the simple_form_for gem for help
* Okay, so I just did several things, I'll list then explain:
  * new.html.haml file
  * show.html.haml file
  * several actions in the todo_lists_controller: show, new, create and private methods todo_list_params and
  find_todo_list
```haml
/ new.html.haml
%h1 New Todo List

= simple_form_for @todo_list do |f|
  = f.input :title
  = f.input :category
  = f.button :submit

= link_to "Back", root_path
```
  * I think I understand this pretty well.  The simple_form_for part will be moved into a partial called '_form' that
  I will then be able to call in the edit view.
  * If I am ever unclear, I can just take a look at the simple_form documentation, it's pretty self explanatory.  I may have
  to look at it again when I go to style them
  * Before this view could work, I had to create the new action which I will describe in a few minutes
```haml
/ show.html.haml
%h2= @todo_list.title
%p= @todo_list.category

= link_to "Back", root_path
```
  * This view is pretty self-explanatory as well.  Like the 'new' view, this view will not work unless I define what
  @todo_list is in the todo_lists_controller.
```ruby
def index
end

def show
	@todo_list = TodoList.find(params[:id])
end

def new
	@todo_list = TodoList.new;
end

def create
	@todo_list = TodoList.new(todo_list_params)

	if @todo_list.save
		redirect_to @todo_list
	else
		render 'new'
	end
end

def edit
end

def update
end

def destroy
end

private

	def todo_list_params
		params.require(:todo_list).permit(:title, :category)
	end

	def find_todo_list
		@todo_list = TodoList.find(params[:id])
	end
```
  * I got stuck on the private method todo_list_params and had to go back to look it up.  Here are the main parts:
    * params.require(:model_name) + 
    * permit.(:column1, :column2, etc.)
  * the entire point of the find_todo_list method is to have it completed BEFORE I show, edit, update or destroy a 
  todo_list...I must implement that now
* I added the update action in the controller and converted the simple_form_for to the partial.  Now I just need to 
add the "destroy" action
  * The destroy action is actually not very complicated at all.  In the controller, it takes just one line to destroy
  the entry and then another to redirect:
```ruby
def destroy
	@todo_list.destroy
	redirect_to root_path
end
```
  * Where it is a bit tricky is in the link itself that allows you to click 'delete'.  So if you do 'rails routes' in 
  the terminal window, you can see that the DELETE verb is allowed on the todo_list path.  That means that it uses the
  same path as show or update...this is important because what we are doing in the link is that although we are using the
  same path as the 'show' action, instead of a GET request, we are specifying the HTTP verb that we want to use.  
  In this case, it is delete.  See below:
```haml
= link_to "Delete", todo_list_path(@todo_list), method: :delete, data: { confirm: 'Are you sure?' }
```
* By this point, I have an app that can create, edit, and delete lists.  I am going to add some basic styling:
  * convert application.html.erb to HAML - DONE
  * add a basic navbar - DONE
  * configure Bootstrap - DONE

* Getting the Bootstrap into HAML was a bitch and maybe not necessary but here it is...
```haml
%nav.navbar.navbar-default{role: "navigation"}

	.navbar-header 
		%button.navbar-toggle{"data-target" => ".navbar-ex1-collapse", "data-toggle" => "collapse", type: "button"}
			%span.sr-only Toggle navigation
			%span.icon-bar
			%span.icon-bar
			%span.icon-bar
		%a.navbar-brand{href: "#"} Brand

	.collapse.navbar-collapse.navbar-ex1-collapse

		%ul.nav.navbar-nav
			%li.active
				%a{href: "#"} Link
			%li
				%a{href: "#"} Link
			%li.dropdown
				%a.dropdown-toggle{"data-toggle" => "dropdown", href: "#"}
					Dropdown
					%b.caret
				%ul.dropdown-menu
					%li
						%a{href: "#"} Action
					%li
						%a{href: "#"} Another action
					%li
						%a{href: "#"} Something else here
					%li
						%a{href: "#"} Separated link
					%li
						%a{href: "#"} One more separated link
		%form.navbar-form.navbar-left{role: "search"}
			.form-group
				%input.form-control{placeholder: "Search", type: "text"}/
			%button.btn.btn-default{type: "submit"} Submit
		%ul.nav.navbar-nav.navbar-right
			%li
				%a{href: "#"} Link
			%li.dropdown
				%a.dropdown-toggle{"data-toggle" => "dropdown", href: "#"}
					Dropdown
					%b.caret
				%ul.dropdown-menu
					%li
						%a{href: "#"} Action
					%li
						%a{href: "#"} Another action
					%li
						%a{href: "#"} Something else here
					%li
						%a{href: "#"} Separated link
```

* Add Todo Items
* Add users


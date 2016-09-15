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
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'  # needs to be configured
gem 'simple_form', '~> 3.3', '>= 3.3.1' 	# needs to be configured
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



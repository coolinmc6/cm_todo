class TodoListsController < ApplicationController

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


end

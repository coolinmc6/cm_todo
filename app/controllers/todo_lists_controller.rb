class TodoListsController < ApplicationController
	before_action :find_todo_list, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:show]

	def index
		@todo_lists = TodoList.all
	end

	def show
		
	end

	def new
		@todo_list = TodoList.new
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
		if @todo_list.update(todo_list_params)
			redirect_to @todo_list
		else
			render 'edit'
		end
	end

	def destroy
		@todo_list.destroy
		redirect_to root_path
	end

	private

		def todo_list_params
			params.require(:todo_list).permit(:title, :category)
		end

		def find_todo_list
			@todo_list = TodoList.find(params[:id])
		end


end

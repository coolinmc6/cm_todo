class TodoItemsController < ApplicationController
	before_action :find_todo_list, only: [:new, :create]

	def new
		@todo_item = @todo_list.todo_items.create(todo_item_params)
	end

	def create
		@todo_item = @todo_list.todo_items.create(todo_item_params)
		redirect_to @todo_list
	end






	private

		def find_todo_list
			@todo_list = TodoList.find(params[:todo_list_id])
		end

		def todo_item_params
			params.require(:todo_item).permit(:description, :completed)
		end
end

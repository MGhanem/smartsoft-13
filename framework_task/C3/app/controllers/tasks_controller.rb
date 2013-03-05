class TasksController < ApplicationController
	def create
    @list = List.find(params[:list_id])
    @task = @list.tasks.create(params[:task])
    redirect_to list_path(@list)
	end
	def destroy
    @list = List.find(params[:list_id])
    @task = @list.tasks.find(params[:id])
    @task.destroy
    redirect_to list_path(@list)
  end
end

class TasksController < ApplicationController
  respond_to :html, :js
  
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @tasks = Task.all
    @task = Task.create(task_params)
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @tasks = Task.all
    @task = Task.find(params[:id])
    
    @task.update_attributes(task_params)
  end

  def delete
    @task = Task.find(params[:task_id])
  end

  def destroy
    @tasks = Task.all
    @task = Task.find(params[:id])
    @task.destroy
  end

private
  def task_params
    params.require(:task).permit(:name, :price)
  end

end
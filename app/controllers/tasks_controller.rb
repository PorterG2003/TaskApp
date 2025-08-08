class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks.by_priority
    @pending_tasks = @tasks.pending
    @completed_tasks = @tasks.completed
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      redirect_to tasks_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    permitted = params.require(:task).permit(:title, :description, :priority, :due_date)
    
    # Handle the completed toggle if it's present
    if params[:task].key?(:completed)
      permitted[:status] = params[:task][:completed] == "true" ? "completed" : "pending"
    end
    
    permitted
  end
end

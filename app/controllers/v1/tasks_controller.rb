module V1
  class TasksController < ApiController
    def index
      if params[:user_id] && params[:project_id]
        user = User.find(params[:user_id])
        project = user.projects.find_by(id: params[:project_id])

        if project
          tasks = project.tasks
          render json: tasks
        else
          render json: { error: "Project not found" }, status: :not_found
        end
      else
        render json: { error: "User ID and Project ID are required" }, status: :bad_request
      end
    end

    def show
      task = Task.find(params[:id])
      render json: task
    end

    def create
      task = Task.new(task_params)

      if task.save
        render json: task, status: :created
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      task = Task.find(params[:id])
      if task.update(task_params)
        render json: task
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      task = Task.find(params[:id])
      task.destroy
      render json: {}, status: :no_content
    end

    private

    def task_params
      params.require(:task).permit(:user_id, :title, :content, :status, :start_date, :end_date, :project_id)
    end
  end
end
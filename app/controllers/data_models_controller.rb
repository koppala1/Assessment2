class DataModelsController < ApplicationController
      after_save_commit :log_user_saved_to_db

   def index
   @task = DataModel.order('"id" ASC NULLS LAST')
   render json: employee, status: :ok
   end
  
   def create
     @task = DataModel.(data_params)
    if @task.save
    render json: @task, status: :ok
  else
    render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
  end
  end

  def update
  @task = DataModel.find_by_id(params[:id])
  if @task.update(name: params[:name],data: params[:data])
  render json: @task, status: :ok
  else
  render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
  end
  end

 def destroy
  @task = DataModel.find_by_id(params[:id])
  if @task.destroy
    render json: { message: 'Data successfully destroyed' }, status: :ok
  else
    render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
  end
  end

 def show
  @task = DataModel.order('"id" ASC NULLS LAST')
  render json: @task, status: :ok
  end


 def list
  @task = DataModel.all
  end 
  def new
     @task =  DataModel.new
  end
private
  def data_params
  params.permit(:name, :data)
  end

   def log_user_saved_to_db
    puts 'User was saved Data to database'
  end

end#class End

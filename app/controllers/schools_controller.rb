class SchoolsController < ApplicationController

  before_action :set_school, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @all_schools = School.all.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def edit
  end

  def new
    @school = School.new
  end

  def show
    @school_orders = @school.orders.chronological.paginate(:page => params[:page]).per_page(10)
  end

  def create
    @school = School.new(school_params)
    if @school.save
      if can? :read, @school
        redirect_to school_path(@school), notice: "Successfully added #{@school.name} to our system."
      else
          redirect_to home_path, notice: "Successfully added #{@school.name} to our system."
      end
    else
      render action: 'new'
    end
  end

  def update
    if @school.update(school_params)
      redirect_to school_path(@school), notice: "Successfully updated #{@school.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    if !@school.is_destroyable?
      flash[:error] = "Could not remove #{@school.name}. Set as inactive."
      @school.active = false
      @school.save!
      redirect_to :back
    else
      @school.destroy
      redirect_to schools_path, notice: "Successfully removed #{@school.name} from the system."
    end
  end

  private

  def set_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit(:name, :street_1, :street_2, :city, :state, :zip, :min_grade, :max_grade, :active) 
  end

end
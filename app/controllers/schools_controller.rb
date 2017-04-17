class SchoolsController < ApplicationController

  before_action :check_login
  before_action :set_school, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @active_schools = School.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_schools = School.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def edit
  end

  def new
    @school = School.new
  end

  def show
  end

  def create
    @school = School.new(school_params)
    if @school.save
      if can? :read, @school
        redirect_to school_path(@school), notice: "Successfully added #{@school.name} to our system."
      else
        redirect_to user_path(current_user), notice: "Successfully added #{@school.name} to our system."
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
      flash[:error] = "Could not remove #{@school.name}."
      redirect_to :back
    else
      @item.destroy
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
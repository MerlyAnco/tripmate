class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :set_travels, only: %i[show]

  def index
    if current_user
      if params[:date].present?
        @plans = Plan.where(start_date: params[:date]).where.not(user_id: current_user.id)
      else
        @plans = Plan.where.not(user_id: current_user.id)
      end
    else
      if params[:date].present?
        @plans = Plan.where(start_date: params[:date])
      else
        @plans = Plan.all
      end
    end
  end

  def new
    @departaments = Plan::DEPARTAMENTS
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.user = current_user
    @plan.save!
    redirect_to my_plans_path, notice: 'success'
    # if @plan.save
    #   redirect_to my_plans_path, notice: 'Plan creado exitosamente.'
    # else
    #   respond_to do |format|
    #     format.html { render :new }
    #     format.json { render json: { errors: @plan.errors.full_messages }, status: :unprocessable_entity }
    #   end
    # end
  end

  def show
    @marker = { lat: @plan.latitude,
              lng: @plan.longitude,
              info_window_html:
              render_to_string(partial: "info_window", locals: {plan: @plan})
            }
    @ticket_available = available_tickets(@travels, @plan).positive?
    @available = available_tickets(@travels, @plan)
    @applied = applied_plan?(@plan) if current_user
  end

  def edit
    @departament = Plan::DEPARTAMENTS
  end

  def update
    @plan.update(plan_params)
    redirect_to plan_path(@plan), notice: 'Plan actualizado exitosamente.'
  end

  def destroy
    @plan.destroy
    redirect_to my_plans_path, status: :see_other
  end

  def my_plans
    @my_plans = Plan.where(user: current_user)
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :description, :travelers_quantity, :location, :start_date, :end_date, :departament, :start_point, :photo, photos: [] )
  end

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def set_travels
    @travels = Travel.where(plan_id: @plan.id)
  end

  def available_tickets(travels, plan)
    num_acepted_travels = travels.where(status: 'aceptado').count
    travelers_quantity = plan.travelers_quantity

    available = travelers_quantity - num_acepted_travels
    return available
  end

  def applied_plan?(plan)
    current_user.travels.where(plan_id: plan.id).exists?
  end
end

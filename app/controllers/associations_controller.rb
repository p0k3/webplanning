class AssociationsController < ApplicationController

  before_filter :authenticate_user!, :set_association
  layout "public"

  def index
    @associations = current_user.associations
  end

  def show
    session[:current_association_id] = params[:id]
    redirect_to association_root_url, flash:{success: 'Vous êtes maintenant connecté'}
  end

  def new
    @association = current_user.associations.build
  end

  def create

    @association = current_user.associations.build(association_params)

    if @association.save
      current_user.associations << @association
      session[:current_association_id] = @association.id
      redirect_to association_root_url, flash:{success: 'Votre association a bien été créée'}
    else
      render :new
    end
  end

  private
    def set_association
      if session[:current_association_id]
        @association = Association.find session[:current_association_id]
      end
    end

    def association_params
      params.required(:association).permit(:name, :address_1, :address_2, :zipcode, :town, :email, :phone, :president_name, :dpo_name)
    end
end
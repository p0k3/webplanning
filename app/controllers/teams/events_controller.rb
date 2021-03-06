class Teams::EventsController < ApplicationController

  before_filter :set_team

  def index
    @event = @team.events.build
    @members = @team.users.order('firstname ASC')

    respond_to do |format|
      format.html
      format.json {
        @events = @team.events.where('end_at BETWEEN ? AND ?', params[:start], params[:end])
        unless params[:user_id].blank?
          @events = Event.get_personnal_events(params[:user_id], params[:start], params[:end], @team.id)
        end
      }
    end
  end

  def new
    @event = @team.events.build(begin_at: params[:start_at], end_at: params[:end_at])
    @members = @team.users.order('firstname ASC')

    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @event = @team.events.build(event_params)
    @members = @team.users.order('firstname ASC')

    if @event.save
      redirect_to [@team, :events], notice: "Membre ajouté à l\'équipe"
    else
      render :edit
    end
  end

  def edit
    @event = Event.find(params[:id])
    @members = @team.users.order('firstname ASC')

    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    @members = @team.users.order('firstname ASC')
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to [@team, :events], notice: 'Evenement mis à jour'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])

    @event.destroy
    redirect_to [@team, :events], notice: "Evénement supprimé"
  end



  private
    def set_team
      @team = Team.find params[:team_id]
    end

    def event_params
      params.required(:event).permit(:label, :description, :begin_at, :end_at, :organizer_id, :organizer_type, :is_public,
                                      assignments_attributes: [:id, :user_id, :description, :_destroy])
    end

end

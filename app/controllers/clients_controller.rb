class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = current_user.clients.recent
  end

  def show
    @notes = @client.notes.order(created_at: :desc)
    @activity_logs = @client.activity_logs.order(created_at: :desc).limit(15)
    @note = @client.notes.new
    @document = @client.documents.new
  end

  def new
    @client = current_user.clients.new
  end

  def create
    @client = current_user.clients.new(client_params)
    if @client.save
      redirect_to @client, notice: "Client created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Client updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "Client removed."
  end

  private

  def set_client
    @client = current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:full_name, :email, :phone, :risk_profile, :lifecycle_stage, :profile_notes)
  end
end

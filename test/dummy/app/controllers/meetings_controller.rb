class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[show edit update destroy]

  # GET /meetings
  def index
    @meetings = Meeting.all
  end

  def business_week
    @meetings = Meeting.all
  end

  # GET /meetings/1
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings
  def create
    @meeting = Meeting.new(meeting_params)

    if @meeting.save
      redirect_to @meeting, notice: "Meeting was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /meetings/1
  def update
    if @meeting.update(meeting_params)
      redirect_to @meeting, notice: "Meeting was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /meetings/1
  def destroy
    @meeting.destroy
    redirect_to meetings_url, notice: "Meeting was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def meeting_params
    params.require(:meeting).permit(:name, :start_time, :end_time)
  end
end

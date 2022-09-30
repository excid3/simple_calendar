require "test_helper"

class MeetingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meeting = meetings(:one)
  end

  test "should get index" do
    get meetings_url
    assert_response :success
  end

  test "should get new" do
    get new_meeting_url
    assert_response :success
  end

  test "should create meeting" do
    assert_difference("Meeting.count") do
      post meetings_url, params: { meeting: { end_time: @meeting.end_time, name: @meeting.name, start_time: @meeting.start_time } }
    end

    assert_redirected_to meeting_url(Meeting.last)
  end

  test "should show meeting" do
    get meeting_url(@meeting)
    assert_response :success
  end

  test "should get edit" do
    get edit_meeting_url(@meeting)
    assert_response :success
  end

  test "should update meeting" do
    patch meeting_url(@meeting), params: { meeting: { end_time: @meeting.end_time, name: @meeting.name, start_time: @meeting.start_time } }
    assert_redirected_to meeting_url(@meeting)
  end

  test "should destroy meeting" do
    assert_difference("Meeting.count", -1) do
      delete meeting_url(@meeting)
    end

    assert_redirected_to meetings_url
  end
end

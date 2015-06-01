require 'test_helper'

class ScorecardsControllerTest < ActionController::TestCase
  setup do
    @scorecard = scorecards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scorecards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scorecard" do
    assert_difference('Scorecard.count') do
      post :create, scorecard: { checkin_count: @scorecard.checkin_count, journals_score: @scorecard.journals_score, last_checkin_date: @scorecard.last_checkin_date, moods_score: @scorecard.moods_score, perfect_checkin_count: @scorecard.perfect_checkin_count, self_cares_score: @scorecard.self_cares_score, sleeps_score: @scorecard.sleeps_score, streak_count: @scorecard.streak_count, streak_record: @scorecard.streak_record }
    end

    assert_redirected_to scorecard_path(assigns(:scorecard))
  end

  test "should show scorecard" do
    get :show, id: @scorecard
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scorecard
    assert_response :success
  end

  test "should update scorecard" do
    patch :update, id: @scorecard, scorecard: { checkin_count: @scorecard.checkin_count, journals_score: @scorecard.journals_score, last_checkin_date: @scorecard.last_checkin_date, moods_score: @scorecard.moods_score, perfect_checkin_count: @scorecard.perfect_checkin_count, self_cares_score: @scorecard.self_cares_score, sleeps_score: @scorecard.sleeps_score, streak_count: @scorecard.streak_count, streak_record: @scorecard.streak_record }
    assert_redirected_to scorecard_path(assigns(:scorecard))
  end

  test "should destroy scorecard" do
    assert_difference('Scorecard.count', -1) do
      delete :destroy, id: @scorecard
    end

    assert_redirected_to scorecards_path
  end
end

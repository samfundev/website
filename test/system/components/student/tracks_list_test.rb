require "application_system_test_case"

module Components
  module Student
    class TracksListTest < ApplicationSystemTestCase
      def setup
        super

        # This component uses the API, which requires authentication.
        sign_in!
      end

      test "shows tracks" do
        track = create :track, title: "Ruby"
        concept_exercises = Array.new(2).map { create :concept_exercise, track: track }
        practice_exercises = Array.new(3).map { create :practice_exercise, track: track }
        create :user_track, track: track, user: @current_user
        concept_exercises.sample(1).map { |ex| create :concept_solution, user: @current_user, exercise: ex }
        practice_exercises.sample(2).map { |ex| create :practice_solution, user: @current_user, exercise: ex }

        visit test_components_student_tracks_list_url

        assert_html '
          <a class="c-track" href="https://test.exercism.io/tracks/ruby">
            <img class="c-track-icon"
                 src="https://assets.exercism.io/tracks/ruby-hex-white.png"
                 alt="icon for Ruby track">
            <div class="info">
              <h3 class="title">Ruby</h3>
              <ul class="counts">
                <li>2 concepts</li>
                <li>3 exercises</li>
              </ul>
            </div>
          </a>
        ', within: ".student-track-list"
      end

      test "filter by track title" do
        create :user
        create :track, title: "Ruby"
        create :track, title: "Go"

        visit test_components_student_tracks_list_url
        fill_in "Search language tracks", with: "Go"

        assert_selector(".student-track-list .c-track", count: 1)
        assert_text "Go", within: ".c-track"
      end

      test "filter by status" do
        create :track, title: "Ruby"
        go = create :track, title: "Go"
        create :user_track, track: go, user: @current_user

        visit test_components_student_tracks_list_url
        select "Joined", from: "Status"

        assert_selector(".student-track-list .c-track", count: 1)
        assert_text "Go", within: ".c-track"
      end

      test "shows empty state" do
        create :user

        visit test_components_student_tracks_list_url

        assert_text "No results found"
      end

      test "shows loading state" do
        visit test_components_student_tracks_list_url
        select "Loading", from: "State"
        click_on "Submit"

        assert_text "Loading"
      end

      test "shows error state" do
        visit test_components_student_tracks_list_url
        select "Error", from: "State"
        click_on "Submit"

        assert_text "Something went wrong"
      end
    end
  end
end
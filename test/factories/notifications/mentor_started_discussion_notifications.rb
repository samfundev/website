FactoryBot.define do
  factory :mentor_started_discussion_notification, class: "Notifications::MentorStartedDiscussionNotification" do
    user
    params {{
      discussion: create(:solution_mentor_discussion)
    }}
  end
end
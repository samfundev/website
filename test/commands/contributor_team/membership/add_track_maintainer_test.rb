require "test_helper"

class ContributorTeam::Membership::AddTrackMaintainerTest < ActiveSupport::TestCase
  test "add user to track maintainers team" do
    user = create :user
    track = create :track
    team = create :contributor_team, track: track, type: :track_maintainers

    Github::Team.any_instance.stubs(:add_member)
    Github::Team.any_instance.stubs(:add_to_repository)

    # Create other track team to ensure the right team is chosen
    csharp_track = create :track, slug: 'csharp'
    create :contributor_team, :random, track: csharp_track, type: :track_maintainers
    create :contributor_team, :random, track: nil, type: :reviewers

    ContributorTeam::Membership::AddTrackMaintainer.(user, track, visible: true, seniority: :junior)

    assert_includes team.members, user
  end

  test "adds maintainer role" do
    user = create :user
    track = create :track
    create :contributor_team, track: track, type: :track_maintainers

    Github::Team.any_instance.stubs(:add_member)
    Github::Team.any_instance.stubs(:add_to_repository)

    ContributorTeam::Membership::AddTrackMaintainer.(user, track, visible: true, seniority: :junior)

    assert_includes user.roles, :maintainer
  end

  test "does not add duplicate maintainer role" do
    user = create :user, roles: [:maintainer]
    track = create :track
    create :contributor_team, track: track, type: :track_maintainers

    Github::Team.any_instance.stubs(:add_member)
    Github::Team.any_instance.stubs(:add_to_repository)

    ContributorTeam::Membership::AddTrackMaintainer.(user, track, visible: true, seniority: :junior)

    assert_equal 1, (user.roles.count { |r| r == :maintainer })
  end

  test "keeps existing roles" do
    user = create :user, roles: %i[admin reviewer]
    track = create :track
    create :contributor_team, track: track, type: :track_maintainers

    Github::Team.any_instance.stubs(:add_member)
    Github::Team.any_instance.stubs(:add_to_repository)

    ContributorTeam::Membership::AddTrackMaintainer.(user, track, visible: true, seniority: :junior)

    assert_equal 3, user.roles.size
    assert_includes user.roles, :admin
    assert_includes user.roles, :reviewer
    assert_includes user.roles, :maintainer
  end

  test "raises exception when team could not be found" do
    track = create :track
    user = create :user

    assert_raises do
      ContributorTeam::Membership::AddTrackMaintainer.(user, track)
    end
  end

  test "removes reviewer team from track repository if at least two active members in track team" do
    user = create :user
    track = create :track, slug: 'csharp'
    team = create :contributor_team, track: track, type: :track_maintainers
    create :contributor_team_membership, team: team, user: (create :user)
    create :contributor_team_membership, team: team, user: (create :user)

    # Exercism.config.stubs(:github_organization).returns('exercism')
    Github::Team.any_instance.stubs(:add_member)
    Github::Team.any_instance.expects(:remove_from_repository).with('csharp')

    ContributorTeam::Membership::AddTrackMaintainer.(user, track, visible: true, seniority: :junior)
  end

  test "adds reviewer team to track repository less than two active members in track team" do
    user = create :user
    track = create :track, slug: 'csharp'
    team = create :contributor_team, track: track, type: :track_maintainers
    create :contributor_team_membership, team: team, user: (create :user)
    create :contributor_team_membership, team: team, user: (create :user), status: :pending

    Github::Team.any_instance.stubs(:add_member)
    Github::Team.any_instance.expects(:add_to_repository).with('csharp', :push)

    ContributorTeam::Membership::AddTrackMaintainer.(user, track, visible: true, seniority: :junior)
  end
end
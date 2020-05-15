class User
  class RequestMentor
    class AlreadyRequestedError < RuntimeError
      attr_reader :request
      def initialize(request)
        @request = request
      end
    end

    include Mandate

    initialize_with :solution, :bounty, :type, :comment

    def call
      create_request
    rescue AlreadyRequestedError => e
      e.request
    end

    private
    def create_request
      request = Solution::MentorRequest.new(
        solution: solution,
        type: type, 
        bounty: bounty,
        comment: comment
      )

      ActiveRecord::Base.transaction do
        # By locking the solution before checking the amount of mentorships
        # we should avoid duplicates without having to lock the whole mentorships
        # table.
        solution.lock!
        
        # Check there's not an existing request. I'd like a unique index
        # but that would involve schema change as we allow multiple fulfilled records.
        existing_request = solution.mentor_requests.pending.first
        raise AlreadyRequestedError.new(existing_request) if existing_request

        User::SpendCredits.(solution.user, bounty)

        request.save!
      end

      request
    end
  end
end

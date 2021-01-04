ENV['RAILS_ENV'] ||= 'test'

# This must happen above the env require below
if ENV["CAPTURE_CODE_COVERAGE"]
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter %r{^/app/.+/test/}
    add_filter %r{^/app/.+/tmp/}
    add_filter "lib/solargraph-rails.rb"
    add_filter "lib/run_migrations_with_concurrent_guard.rb"
  end
end

require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require 'minitest/pride'
require 'webmock/minitest'

# Configure mocach to be safe
Mocha.configure do |c|
  # c.stubbing_method_unnecessarily = :prevent
  c.stubbing_non_existent_method = :prevent
  c.stubbing_non_public_method = :warn
  c.stubbing_method_on_nil = :prevent
end

# Require the support helper files
Dir.foreach(Rails.root / "test" / "support") do |path|
  next if path.starts_with?('.')

  require Rails.root / "test" / "support" / path
end

# TODO: Remove this as part of the git extraction
module TestHelpers
  def self.git_repo_url(slug)
    "file://#{Rails.root / 'test' / 'repos' / slug.to_s}"
  end
end

class ActiveSupport::TimeWithZone
  def ==(other)
    to_i == other.to_i
  end
end

if ENV["EXERCISM_CI"]
  WebMock.disable_net_connect!(
    allow: [
      # It would be nice not to need this but Chrome
      # uses lots of ports on localhost for thesystem tests
      "127.0.0.1",
      "chromedriver.storage.googleapis.com",
      "127.0.0.1:#{ENV['AWS_PORT']}"
    ]
  )
else
  WebMock.disable_net_connect!(
    allow: [
      # It would be nice not to need this but Chrome
      # uses lots of ports on localhost for thesystem tests
      "127.0.0.1",
      "chromedriver.storage.googleapis.com",
      "localhost:3040", "aws"
    ]
  )
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  include ActiveJob::TestHelper

  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  def setup
    RestClient.stubs(:post)
  end

  # Create a few models and return a random one.
  # Use this method to guarantee that a method isn't
  # working because it's accessing the first or last
  # object created or stored in the db
  def random_of_many(model, params = {}, num: 3)
    Array(num).map { create(model, params) }.sample
  end

  def assert_idempotent_command(&cmd)
    obj_1 = cmd.yield
    obj_2 = cmd.yield
    assert_equal obj_1, obj_2
  end

  ####################
  # DynamoDB Helpers #
  ####################
  def create_test_runner_job!(submission, execution_status: nil, results: nil)
    execution_output = results ? { "results.json" => results.to_json } : nil
    create_tooling_job!(
      submission,
      :test_runner,
      execution_status: execution_status,
      execution_output: execution_output
    )
  end

  def create_representer_job!(submission, execution_status: nil, ast: nil, mapping: nil)
    execution_output = {
      "representation.txt" => ast,
      "mapping.json" => mapping&.to_json
    }
    create_tooling_job!(
      submission,
      :representer,
      execution_status: execution_status,
      execution_output: execution_output
    )
  end

  def create_analyzer_job!(submission, execution_status: nil, data: nil)
    execution_output = {
      "analysis.json" => data&.to_json
    }
    create_tooling_job!(
      submission,
      :analyzer,
      execution_status: execution_status,
      execution_output: execution_output
    )
  end

  def create_tooling_job!(submission, type, params = {})
    id = SecureRandom.uuid
    write_to_dynamodb(
      Exercism.config.dynamodb_tooling_jobs_table,
      {
        "id" => id,
        "type" => type,
        "submission_uuid" => submission.uuid,
        "job_status" => "queued"
      }.merge(params)
    )
    ToolingJob.find(id, full: true)
  end

  def write_to_dynamodb(table_name, item)
    Exercism.dynamodb_client.put_item(
      table_name: table_name,
      item: item
    )
  end

  def read_from_dynamodb(table_name, key, attributes)
    Exercism.dynamodb_client.get_item(
      table_name: table_name,
      key: key,
      attributes_to_get: attributes,
      # Required for attribute queries to return the correct value immediately after updating
      consistent_read: true
    ).item
  end

  def upload_to_s3(bucket, key, body) # rubocop:disable Naming/VariableNumber
    Exercism.s3_client.put_object(
      bucket: bucket,
      key: key,
      body: body,
      acl: 'private'
    )
  end

  def download_s3_file(bucket, key)
    Exercism.s3_client.get_object(
      bucket: bucket,
      key: key
    ).body.read
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def sign_in!(user = nil)
    @current_user = user || create(:user)
    @current_user.auth_tokens.create! unless @current_user.auth_tokens.exists?

    @current_user.confirm
    sign_in @current_user
  end

  # As we only use #page- prefix on ids for pages
  # this is a safe way of checking we've been positioned
  # on the right page during tests
  def assert_page(page)
    assert_includes @response.body, "<div id='page-#{page}'>"
  end
end

ActionDispatch::IntegrationTest.register_encoder :js,
  param_encoder: ->(params) { params },
  response_parser: ->(body) { body }

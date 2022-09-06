# frozen_string_literal: true

require "test_helper"
require "sidekiq/testing"

class TaskLoggerJobTest < ActiveJob::TestCase
  def setup
    @task = create(:task)
  end
  test "logger runs once after creating a new task" do
    assert_enqueued_with(job: TaskLoggerJob, args: [@task])
    perform_enqueued_jobs
    assert_performed_jobs 1
  end
end

module ReviewsHelper
  class VerifyError < Exception
  end

  TYPES = %w(feat fix perf chore misc refactor style docs version revert tests ci)
  ACCESS_TOKEN = '897a587a1d31faef9c7e46a97b21ab72048e9e42' # ENV['LINTHUB_TOKEN']

  class CommitSubjectLengthCheck
    def initialize(message, options = {})
      @message = message
      @limit = options[:limit] || 50
    end

    def index
      0
    end

    def execute
      @message.length <= @limit
    end
  end

  def verify
    repo = @payload[:base][:repo][:full_name]
    hash = @payload[:head][:sha]

    @client ||= Octokit::Client.new(access_token: ACCESS_TOKEN)
    @client.create_status(repo, hash, 'pending', context: 'linthub', description: 'The LintHub check is pending ...')

    commits = @client.pull_request_commits(@payload[:base][:repo][:full_name], @payload[:number])

    @review = Review.create
    @review.github_user = @payload[:base][:repo][:owner][:login]
    @review.repo = @payload[:base][:repo][:name]

    commits.each do |commit|
      checks = [CommitSubjectLengthCheck.new(commit[:commit][:message].lines.first.chomp)]
      checks.each do |check|
        result = check.execute

        @review.checks.create(
          github_user: @review.github_user,
          repo:        @review.repo,
          sha:         commit[:sha],
          passed:      result,
          lint_id:     check.index
        )
      end
    end
    @review.save

    if @review.checks.all? { |check| check.passed }
      @client.create_status(repo, hash, 'success', context: 'linthub', description: 'The LintHub check passed')
    else
      @client.create_status(repo, hash, 'error',   context: 'linthub', description: 'The LintHub check failed', target_url: review_url(@review))
    end
  end
end

# class ChecksController < ApplicationController
#   skip_before_filter :verify_authenticity_token, only: [:create]
#
#   def create
#     @client ||= Octokit::Client.new(access_token: ACCESS_TOKEN)
#
#     @payload = JSON.parse(params[:payload], symbolize_names: true)
#
#     if request.env['HTTP_X_GITHUB_EVENT'] == 'pull_request' && %w(opened reopened synchronize).include?(@payload[:action])
#       @check = Check.create
#
#       pull_request = @payload[:pull_request]
#
#       repo = pull_request[:base][:repo][:full_name]
#       hash = pull_request[:head][:sha]
#       context = 'gittools'
#       # verify 'gittools', pull_request do
#       begin
#         @client.create_status(repo, hash, 'pending', context: context, description: 'The GitTools check is pending ...')
#         commits = @client.pull_request_commits(pull_request[:base][:repo][:full_name], pull_request[:number])
#
#         commits.each do |commit|
#           if commit[:commit][:message].length >= LIMITS[:subject]
#             @check.lints.create(sha: commit[:sha], description: 'the subject line must fit in 50 characters')
#           end
#
#           message = commit[:commit][:message]
#           match = message.match(/(?<type>[[:alpha:]]+)\((?<scope>[[:alpha:]]+)\)\:.+/) || Hash.new
#
#           unless TYPES.include? match[:type]
#             @check.lints.create(sha: commit[:sha], description: 'type requirements are not met')
#           end
#
#           unless match[:scope].length > 16
#             @check.lints.create(sha: commit[:sha], description: 'scope requirements are not met')
#           end
#         end
#
#         fail VerifyError if @check.lints.length > 0
#         @client.create_status(repo, hash, 'success', context: context, description: 'The GitTools check passed')
#       rescue Exception => err
#         puts err: err
#         @client.create_status(repo, hash, 'error', context: context, description: 'The GitTools check failed', target_url:  check_url(id: @check.id, repo: pull_request[:base][:repo][:name], user: pull_request[:base][:repo][:owner][:login]))
#       end
#
#       @check.save
#     end
#
#     render status: 200
#   end

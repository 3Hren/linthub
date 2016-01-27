class ReviewsController < ApplicationController
  include ReviewsHelper

  skip_before_filter :verify_authenticity_token, only: [:create]

  def show
    @review = Review.find(params[:id])
    @passed = @review.checks.all? { |check| check.passed }
  end

  def create
    if %w(open reopened synchronize).include? params.fetch(:pull_request, {})[:state]
      @payload = params[:pull_request]
      verify
    else
      render status: 500, body: 'invalid state'
    end
  end
end

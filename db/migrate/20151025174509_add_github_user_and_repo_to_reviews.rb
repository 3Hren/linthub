class AddGithubUserAndRepoToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :github_user, :string
    add_column :reviews, :repo, :string
  end
end

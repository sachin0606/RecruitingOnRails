class CodeSubmissionReview < ApplicationRecord
  belongs_to :code_submission
  belongs_to :user
  belongs_to :review_result
end

# frozen_string_literal: true
module ScoreHelper
  def score_class(score)
    if score > 1
      "label-success"
    elsif score > 0.5
      "label-warning"
    else
      "label-danger"
    end
  end
end

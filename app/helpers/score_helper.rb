module ScoreHelper
  def score_opacity(score)
    case score
    when 0..1
      score / 2
    when 1..10
      score / 10 + 0.5
    else
      1
    end
  end
end

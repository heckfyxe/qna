module AnswersHelper
  def the_best_answer_class(answer)
    answer.the_best? ? { tag: 'div', class: 'the-best-answer' } : { tag: 'div' }
  end
end

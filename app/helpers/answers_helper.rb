module AnswersHelper
  def the_best_answer_class(answer)
    answer.the_best? ? { tag: 'div', class: 'the-best-answer' } : { tag: 'div' }
  end

  def answer_vote_link(title, up, answer, visibility)
    html_class = visibility ? 'vote-answer' : 'vote-answer invisible'
    path = up ? answer_vote_up_path(answer) : answer_vote_down_path(answer)
    link_to title, path, method: :post, format: :json, remote: true, class: html_class, data: { id: answer.id }
  end
end

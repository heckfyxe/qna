module QuestionsHelper
  def question_vote_link(title, up, question, visibility)
    html_class = visibility ? 'vote-question' : 'vote-question invisible'
    path = up ? question_vote_up_path(question) : question_vote_down_path(question)
    link_to title, path, method: :post, format: :json, remote: true, class: html_class
  end

  def question_subscribe_link(title, subscribe, question, visibility)
    html_class = visibility ? 'subscribe-link' : 'subscribe-link d-none'
    path = subscribe ? subscribe_question_path(question) : unsubscribe_question_path(question)
    link_to title, path, method: :post, remote: true, class: html_class
  end
end

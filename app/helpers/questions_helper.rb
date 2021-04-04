module QuestionsHelper
  def question_vote_link(title, up, question, visibility)
    html_class = visibility ? 'vote-question' : 'vote-question invisible'
    path = up ? question_vote_up_path(question) : question_vote_down_path(question)
    link_to title, path, method: :post, format: :json, remote: true, class: html_class
  end
end

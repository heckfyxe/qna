import {cable} from "./application";

document.addEventListener('turbolinks:load', () => {
    var commentQuestionForm = document.querySelector('form.new-question-comment')
    if (commentQuestionForm) {
        commentQuestionForm.addEventListener('ajax:success', (e) => {
            var comment = e.detail[2].responseText

            document.querySelector('.question-comment-errors').innerHTML = ''
            document.querySelector('.question-comments').innerHTML += comment
        })

        commentQuestionForm.addEventListener('ajax:error', (e) => {
            var errors = e.detail[2].responseText

            document.querySelector('.question-comment-errors').innerHTML = errors
        })
    }

    document.querySelectorAll('form.new-answer-comment').forEach((commentAnswerForm) => {
        commentAnswerForm.addEventListener('ajax:success', (e) => {
            var comment = e.detail[2].responseText

            commentAnswerForm.parentNode.querySelector('.answer-comment-errors').innerHTML = ''
            commentAnswerForm.parentNode.querySelector('.answer-comments').innerHTML += comment
        })

        commentAnswerForm.addEventListener('ajax:error', (e) => {
            var errors = e.detail[2].responseText

            commentAnswerForm.parentNode.querySelector('.answer-comment-errors').innerHTML = errors
        })
    })

    var questionIdElement = document.querySelector('#question-id')
    if (questionIdElement) {
        var questionId = parseInt(questionIdElement.textContent)
        var questionComments = document.querySelector('.question-comments')

        cable.subscriptions.create({
            channel: "CommentsChannel",
            question_id: questionId
        }, {
            received(json) {
                var data = JSON.parse(json)
                if (data.type === 'Question') {
                    questionComments.innerHTML += data.content
                } else if (data.type === 'Answer') {
                    document.querySelector('.answer-comments[data-answer-id="' + data.id + '"]').innerHTML += data.content
                }
            }
        })
    }
})

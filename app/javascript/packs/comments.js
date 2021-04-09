import {cable} from "./application";

document.addEventListener('turbolinks:load', () => {
    var commentForm = document.querySelector('form.new-question-comment')
    if (commentForm) {
        commentForm.addEventListener('ajax:success', (e) => {
            console.log(e)
            var comment = e.detail[2].responseText

            document.querySelector('.question-comment-errors').innerHTML = ''
            document.querySelector('.question-comments').innerHTML += comment
        })

        commentForm.addEventListener('ajax:error', (e) => {
            var errors = e.detail[2].responseText

            document.querySelector('.question-comment-errors').innerHTML = errors
        })
    }

    var questionIdElement = document.querySelector('#question-id')
    if (questionIdElement) {
        var questionId = parseInt(questionIdElement.textContent)
        var questionComments = document.querySelector('.question-comments')

        cable.subscriptions.create({
            channel: "CommentsChannel",
            question_id: questionId
        }, {
            received(json) {
                console.log(json)
                var data = JSON.parse(json)
                if (data.type === 'Question') {
                    questionComments.innerHTML += data.content
                }
            }
        })
    }
})

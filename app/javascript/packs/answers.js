import {cable} from "./application";

document.addEventListener('turbolinks:load', () => {
    var answers = document.querySelector('.answers')
    if (answers) {
        answers.addEventListener('click', (e) => {
            if (!e.target.matches('.edit-answer-link'))
                return

            e.preventDefault()
            let answerId = e.target.dataset.answerId
            document.querySelector('form#edit-answer-' + answerId).classList.remove('d-none')
        })
    }

    var formNewAnswer = document.querySelector('form.new-answer')

    if (formNewAnswer) {
        formNewAnswer.addEventListener('ajax:success', (e) => {
            var answer = e.detail[0]

            document.querySelector('.answer-errors').innerHTML = ''
            document.querySelector('.answers').innerHTML += '<p>' + answer.body + '</p>'
        })

        formNewAnswer.addEventListener('ajax:error', (e) => {
            var errors = e.detail[0]
            document.querySelector('.answer-errors').innerHTML = ''
            errors.forEach((val) => {
                document.querySelector('.answer-errors').innerHTML += '<p>' + val + '</p>'
            })
        })
    }

    document.querySelectorAll('.vote-answer').forEach((element) => {
        element.addEventListener('ajax:success', (e) => {
            var response = e.detail[0]
            var resourceId = response.resource_id
            var rating = response.rating
            var my_vote = response.my_vote

            document.querySelector('#answer-rating-' + resourceId).innerHTML = 'Rating: ' + rating

            var vote_up = document.querySelectorAll('.vote-answer[data-id="' + resourceId + '"]')[0]
            var vote_down = document.querySelectorAll('.vote-answer[data-id="' + resourceId + '"]')[1]
            if (my_vote < 1) {
                vote_up.classList.remove('invisible')
            }
            if (my_vote > -1) {
                vote_down.classList.remove('invisible')
            }
            if (my_vote == 1) {
                vote_up.classList.add('invisible')
            }
            if (my_vote == -1) {
                vote_down.classList.add('invisible')
            }
        })
    })

    if (answers) {
        cable.subscriptions.create('AnswersChannel', {
            connected() {
                console.log('Connected!')
            },
            received(data) {
                console.log(data)
                answers.innerHTML += data
            }
        })
    }
})
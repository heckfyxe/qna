document.addEventListener('turbolinks:load', () => {
    var questions = document.querySelector('.questions')
    if (questions) {
        questions.addEventListener('click', (e) => {
            if (!e.target.matches('.edit-question-link'))
                return

            e.preventDefault()
            let questionId = e.target.dataset.questionId
            document.querySelector('form#edit-question-' + questionId).classList.remove('d-none')
        })
    }

    document.querySelectorAll('.vote-question').forEach((element) => {
        element.addEventListener('ajax:success', (e) => {
            var response = e.detail[0]
            var rating = response.rating
            var my_vote = response.my_vote

            document.querySelector('#question-rating').innerHTML = 'Rating: ' + rating

            vote_up = document.querySelectorAll('.vote-question')[0]
            vote_down = document.querySelectorAll('.vote-question')[1]
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
})
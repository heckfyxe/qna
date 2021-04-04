document.addEventListener('turbolinks:load', () => {
    document.querySelector('.answers').addEventListener('click', (e) => {
        if (!e.target.matches('.edit-answer-link'))
            return

        e.preventDefault()
        let answerId = e.target.dataset.answerId
        document.querySelector('form#edit-answer-' + answerId).classList.remove('d-none')
    })

    document.querySelector('form.new-answer').addEventListener('ajax:success', (e) => {
        var answer = e.detail[0]

        document.querySelector('.answer-errors').innerHTML = ''
        document.querySelector('.answers').innerHTML += '<p>' + answer.body + '</p>'
    })

    document.querySelector('form.new-answer').addEventListener('ajax:error', (e) => {
        var errors = e.detail[0]
        document.querySelector('.answer-errors').innerHTML = ''
        errors.forEach((val) => {
            document.querySelector('.answer-errors').innerHTML += '<p>' + val + '</p>'
        })
    })

    document.querySelectorAll('.vote-answer').forEach((element) => {
        element.addEventListener('ajax:success', (e) => {
            var response = e.detail[0]
            var resourceId = response.resource_id
            var rating = response.rating
            var my_vote = response.my_vote

            document.querySelector('#answer-rating-' + resourceId).innerHTML = 'Rating: ' + rating

            vote_up = document.querySelectorAll('.vote-answer[data-id="' + resourceId + '"]')[0]
            vote_down = document.querySelectorAll('.vote-answer[data-id="' + resourceId + '"]')[1]
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
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
})
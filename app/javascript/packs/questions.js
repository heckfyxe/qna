document.addEventListener('turbolinks:load', () => {
    document.querySelector('.questions').addEventListener('click', (e) => {
        if (!e.target.matches('.edit-question-link'))
            return

        e.preventDefault()
        let questionId = e.target.dataset.questionId
        document.querySelector('form#edit-question-' + questionId).classList.remove('d-none')
    })
})